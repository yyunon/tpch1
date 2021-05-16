library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.ParallelPatterns_pkg.all;
use work.Stream_pkg.all;
use work.Tpch_pkg.all;

entity ReduceOnGroupBy is
  generic (
    FIXED_LEFT_INDEX  : integer;
    FIXED_RIGHT_INDEX : integer;
    DATA_WIDTH        : integer := 64;
    INDEX_WIDTH       : integer := 32;
    TAG_WIDTH         : integer := 1;
    NUM_LANES         : integer := 1
  );
  port (
    clk           : in std_logic;
    reset         : in std_logic;

    key_in_valid  : in std_logic;
    key_in_dvalid : in std_logic := '1';
    key_in_ready  : out std_logic;
    key_in_last   : in std_logic;
    key_in_data   : in std_logic_vector(7 downto 0); -- Aggregate on single column

    in_valid      : in std_logic_vector(NUM_LANES - 1 downto 0);
    in_dvalid     : in std_logic_vector(NUM_LANES - 1 downto 0);
    in_ready      : out std_logic_vector(NUM_LANES - 1 downto 0);
    in_last       : in std_logic_vector(NUM_LANES - 1 downto 0);
    in_data       : in TUPLE_DATA_64(NUM_LANES - 1 downto 0);

    -- Start building the tables
    hash_ready    : in std_logic;
    hash_valid    : out std_logic;

    out_valid     : out std_logic;
    out_ready     : in std_logic;
    out_data      : out std_logic_vector(NUM_LANES * DATA_WIDTH - 1 downto 0)

  );
end entity;

architecture Behavioral of ReduceOnGroupBy is
  type state_t is (STATE_IDLE, STATE_WRITE, STATE_DONE);
  signal state, state_next : state_t;

  signal slice_in_data     : std_logic_vector(NUM_LANES * DATA_WIDTH + NUM_LANES * 2 - 1 downto 0);
  signal slice_out_data    : std_logic_vector(NUM_LANES * DATA_WIDTH - 1 + (NUM_LANES * 2) downto 0);
  signal hash_operation    : std_logic_vector(NUM_LANES - 1 downto 0);
  signal hash_in_data      : std_logic_vector(NUM_LANES * DATA_WIDTH - 1 downto 0);
  signal hash_in_ready     : std_logic;
  signal hash_in_valid     : std_logic;

  signal hash_in_key       : std_logic_vector(NUM_LANES * DATA_WIDTH - 1 downto 0);
  signal hash_out_data     : std_logic_vector(NUM_LANES * DATA_WIDTH - 1 downto 0);
  -- Accumulator input data stream.
  signal op_s_in_valid     : std_logic_vector(NUM_LANES - 1 downto 0);
  signal op_s_in_ready     : std_logic_vector(NUM_LANES - 1 downto 0);
  signal op_s_in_data      : std_logic_vector(NUM_LANES * DATA_WIDTH - 1 downto 0);
  -- Accumulator output stream.
  signal acc_out_valid     : std_logic_vector(NUM_LANES - 1 downto 0);
  signal acc_out_ready     : std_logic_vector(NUM_LANES - 1 downto 0);
  signal acc_out_data      : std_logic_vector(NUM_LANES * DATA_WIDTH - 1 downto 0);

  -- Accumulator input stream.
  signal acc_in_valid      : std_logic_vector(NUM_LANES - 1 downto 0);
  signal acc_in_ready      : std_logic_vector(NUM_LANES - 1 downto 0);
  signal acc_in_data       : std_logic_vector(NUM_LANES * DATA_WIDTH - 1 downto 0);
  signal acc_in_dvalid     : std_logic_vector(NUM_LANES - 1 downto 0);

  signal ops_ready         : std_logic;
  signal ops_valid         : std_logic;
  signal ops_data          : std_logic_vector(NUM_LANES * DATA_WIDTH - 1 downto 0);

  signal build_last        : std_logic_vector(NUM_LANES - 1 downto 0);
begin

  StreamSync_inst : StreamSync
  generic map(
    NUM_INPUTS  => NUM_LANES,
    NUM_OUTPUTS => 1
  )
  port map(
    clk          => clk,
    reset        => reset,
    in_valid     => in_valid,
    in_ready     => in_ready,
    out_valid(0) => hash_in_valid,
    out_ready(0) => hash_in_ready
  );

  parse_input_data :
  process (in_last, in_dvalid, in_data) is
    variable in_data_vec : std_logic_vector((in_data'length * 64) - 1 downto 0);
  begin
    in_data_vec := flatten_tuple_64(in_data);
    slice_in_data <= in_last & in_dvalid & in_data_vec;
  end process;

  input_slice : StreamSlice
  generic map(
    DATA_WIDTH => DATA_WIDTH * NUM_LANES + 2 * NUM_LANES
  )
  port map(
    clk       => clk,
    reset     => reset,
    in_valid  => hash_in_valid,
    in_ready  => hash_in_ready,
    in_data   => slice_in_data,
    out_valid => hash_in_valid,
    out_ready => hash_in_ready,
    out_data  => slice_out_data
  );
  hash_in_ready <= not hash_in_valid or hash_ready;
  hash_in_data  <= slice_out_data(NUM_LANES * DATA_WIDTH - 1 downto 0) when (hash_in_valid = '1' and hash_ready = '1') else
    (others => '0');

  key_gen_process :
  process (key_in_valid, key_in_data) is
  begin
    if key_in_valid = '1' then
      for i in 0 to NUM_LANES - 1 loop
        hash_in_key((i + 1) * 8 - 1 downto i * 8) <= key_in_data;
      end loop;
    else
      hash_in_key <= (others => '0');
    end if;
  end process;
  gen_slices :
  for h in 0 to NUM_LANES - 1 generate
    -----------------------------------------------------------------------------
    table : HashTable
    generic map(
      HASH_FUNCTION => "DIRECT",
      DATA_WIDTH    => DATA_WIDTH,
      ADDRESS_WIDTH => 8
    )
    port map(
      clk         => clk,
      reset       => reset,
      key_in_data => hash_in_key((h + 1) * 8 downto h * 8),
      operation   => hash_operation(h),
      in_data     => hash_in_data((h + 1) * DATA_WIDTH downto h * DATA_WIDTH),
      out_data    => hash_out_data((h + 1) * DATA_WIDTH downto h * DATA_WIDTH)
    );
    -----------------------------------------------------------------------------

    -----------------------------------------------------------------------------
    operator : SumOp
    generic map(
      FIXED_LEFT_INDEX  => FIXED_LEFT_INDEX,
      FIXED_RIGHT_INDEX => FIXED_RIGHT_INDEX,
      DATA_WIDTH        => 64,
      DATA_TYPE         => "FIXED64"
    )
    port map(
      clk        => clk,
      reset      => reset,

      op1_valid  => op_s_in_valid(h),
      op1_ready  => op_s_in_ready(h),
      op1_data   => op_s_in_data((h + 1) * DATA_WIDTH downto h * DATA_WIDTH),

      op2_valid  => acc_out_valid(h),
      op2_ready  => acc_out_ready(h),
      op2_data   => acc_out_data((h + 1) * DATA_WIDTH downto h * DATA_WIDTH),

      out_valid  => acc_in_valid(h),
      out_ready  => acc_in_ready(h),
      out_data   => acc_in_data((h + 1) * DATA_WIDTH downto h * DATA_WIDTH),
      out_dvalid => acc_in_dvalid(h)

    );
    acc_in_ready(h) <= hash_in_ready or not hash_in_valid;
    hash_control_proc :
    process (in_valid(h), in_last(h), acc_out_ready(h), acc_in_valid(h), acc_in_data((h + 1) * DATA_WIDTH downto h * DATA_WIDTH), op_s_in_ready(h), hash_out_data((h + 1) * DATA_WIDTH downto h * DATA_WIDTH)) is
    begin
      hash_operation(h)                                        <= '0';
      hash_in_data((h + 1) * DATA_WIDTH downto h * DATA_WIDTH) <= ((others => '0'));
      if acc_in_valid(h) = '1' then
        hash_operation(h)                                        <= '1'; -- Write the output of summation.
        hash_in_data((h + 1) * DATA_WIDTH downto h * DATA_WIDTH) <= acc_in_data((h + 1) * DATA_WIDTH downto h * DATA_WIDTH);
      end if;

      acc_out_valid(h)                                         <= '0';
      acc_out_data((h + 1) * DATA_WIDTH downto h * DATA_WIDTH) <= (others => '0');
      if acc_out_ready(h) = '1' then
        acc_out_valid(h)                                         <= '1';
        acc_out_data((h + 1) * DATA_WIDTH downto h * DATA_WIDTH) <= hash_out_data((h + 1) * DATA_WIDTH downto h * DATA_WIDTH);
      end if;

      op_s_in_valid(h)                                         <= '0';
      op_s_in_data((h + 1) * DATA_WIDTH downto h * DATA_WIDTH) <= (others => '0');

      if op_s_in_ready(h) = '1' then
        op_s_in_valid(h)                                         <= '1';
        op_s_in_data((h + 1) * DATA_WIDTH downto h * DATA_WIDTH) <= hash_out_data((h + 1) * DATA_WIDTH downto h * DATA_WIDTH);
      end if;

      if in_last(h) = '1' and in_valid(h) = '1' then
        build_last(h) <= '1';
      end if;

    end process;

    -----------------------------------------------------------------------------
    -----------------------------------------------------------------------------
  end generate;

  hash_valid <= and_reduce(build_last);

  output_process :
  process (ops_ready, hash_out_data) is
  begin
    --Output process
    ops_valid <= '0';
    if ops_ready = '1' then
      ops_valid <= '1';
      ops_data  <= hash_out_data;
    end if;
  end process;
  --Output slice
  out_StreamSlice_inst : StreamSlice
  generic map(
    DATA_WIDTH => DATA_WIDTH
  )
  port map(
    clk       => clk,
    reset     => reset,
    in_valid  => ops_valid,
    in_ready  => ops_ready,
    in_data   => ops_data,
    out_valid => out_valid,
    out_ready => out_ready,
    out_data  => out_data
  );

  reg_process :
  process (clk) is
  begin
    if rising_edge(clk) then
      if reset = '1' then
        hash_in_data  <= (others => '0');
        hash_in_key   <= (others => '0');
        hash_out_data <= (others => '0');
      end if;
    end if;
  end process;

end Behavioral;