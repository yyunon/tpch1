
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--library ieee_proposed;
--use ieee_proposed.fixed_pkg.all;

library work;
use work.ParallelPatterns_pkg.all;
use work.Stream_pkg.all;
use work.Tpch_pkg.all;
use work.fixed_generic_pkg_mod.all;

entity ReduceStage is
  generic (
    FIXED_LEFT_INDEX  : integer;
    FIXED_RIGHT_INDEX : integer;
    DATA_WIDTH        : integer := 64;
    INDEX_WIDTH       : integer := 32;
    NUM_KEYS          : natural := 1;
    NUM_SUMS          : natural := 1;
    NUM_AVGS          : natural := 1;
    TAG_WIDTH         : integer := 1
  );
  port (
    clk           : in std_logic;
    reset         : in std_logic;

    key_in_dvalid : in std_logic;
    key_in_data   : in std_logic_vector(NUM_KEYS * 8 - 1 downto 0);

    in_valid      : in std_logic;
    in_dvalid     : in std_logic;
    in_ready      : out std_logic;
    in_last       : in std_logic;
    in_data       : in std_logic_vector(NUM_SUMS * DATA_WIDTH - 1 downto 0);

    probe_valid   : out std_logic;
    hash_len      : out std_logic_vector(15 downto 0);
    probe_ready   : in std_logic;

    out_valid     : out std_logic;
    out_enable    : in std_logic;
    out_ready     : in std_logic := '0';
    out_last      : out std_logic;
    out_data      : out std_logic_vector(16 + (NUM_SUMS + NUM_AVGS + 1) * DATA_WIDTH - 1 downto 0)
    --avg_out_data   : out std_logic_vector(NUM_AVGS * DATA_WIDTH - 1 downto 0);
    --count_out_data : out std_logic_vector(DATA_WIDTH - 1 downto 0)

  );
end entity;

architecture Behavioral of ReduceStage is

  -- Accumulator output stream.
  signal acc_out_valid                 : std_logic;
  signal acc_out_ready                 : std_logic;
  signal acc_out_data                  : std_logic_vector(NUM_SUMS * DATA_WIDTH - 1 downto 0);

  -- Accumulator input stream.
  signal key_in_data_s                 : std_logic_vector(NUM_KEYS * 8 - 1 downto 0);
  signal acc_in_valid                  : std_logic;
  signal acc_in_ready                  : std_logic;
  signal acc_in_data                   : std_logic_vector(NUM_SUMS * DATA_WIDTH - 1 downto 0);
  signal acc_in_dvalid                 : std_logic;

  -- CNTRL input stream.
  signal cntrl_s_in_valid              : std_logic;
  signal cntrl_s_in_ready              : std_logic;

  -- Operator input stream.
  signal op_s_in_valid                 : std_logic;
  signal op_s_in_ready                 : std_logic;
  signal op_s_in_data                  : std_logic_vector(NUM_SUMS * DATA_WIDTH + NUM_KEYS * 8 downto 0);
  -- Compensate counter -> sequencer path if the operation is low-latency.
  signal dly_in_valid                  : std_logic;
  signal dly_in_ready                  : std_logic;
  signal dly_in_data                   : std_logic_vector(NUM_SUMS * DATA_WIDTH + NUM_KEYS * 8 downto 0);

  signal dly_out_valid                 : std_logic;
  signal dly_out_ready                 : std_logic;
  signal dly_out_data                  : std_logic_vector(NUM_SUMS * DATA_WIDTH + NUM_KEYS * 8 downto 0);

  -- hash controller output slice
  signal hash_out_valid                : std_logic := '0';
  signal hash_out_ready                : std_logic := '0';
  signal hash_out_enable               : std_logic := '0';
  signal hash_out_last                 : std_logic;
  signal hash_out_data                 : std_logic_vector(NUM_SUMS * DATA_WIDTH - 1 downto 0);
  signal hash_out_count                : std_logic_vector(DATA_WIDTH - 1 downto 0);
  signal hash_out_key                  : std_logic_vector(15 downto 0);
  -- controller output slice
  signal cntrl_out_slice_in_valid      : std_logic;
  signal cntrl_out_slice_in_ready      : std_logic;
  signal cntrl_out_slice_in_last       : std_logic;
  signal cntrl_out_slice_in_data       : std_logic_vector(NUM_SUMS * DATA_WIDTH - 1 downto 0);
  signal cntrl_out_slice_in_count_data : std_logic_vector(DATA_WIDTH - 1 downto 0);
  signal cntrl_out_slice_in_key_data   : std_logic_vector(15 downto 0);

  -- avg. count and agg. output
  signal out_valid_s                   : std_logic;
  signal out_ready_s                   : std_logic := '0';
  signal out_last_s                    : std_logic;
  signal key_out_data_s                : std_logic_vector(15 downto 0);
  signal count_out_data_s              : std_logic_vector(DATA_WIDTH - 1 downto 0);
  constant ZERO                        : std_logic_vector(DATA_WIDTH - 1 downto 0) := (others => '0');
  signal out_data_s                    : std_logic_vector(NUM_SUMS * DATA_WIDTH - 1 downto 0);
  signal avg_out_data_s                : std_logic_vector(NUM_AVGS * DATA_WIDTH - 1 downto 0);

begin

  hash_out_enable <= out_enable;
  reduce_cntrl : ReduceStream
  generic map(
    DATA_WIDTH        => DATA_WIDTH,
    IN_DIMENSIONALITY => 1,
    NUM_KEYS          => NUM_KEYS,
    NUM_LANES         => NUM_SUMS,
    LENGTH_WIDTH      => INDEX_WIDTH
  )
  port map(
    clk            => clk,
    reset          => reset,
    in_valid       => cntrl_s_in_valid,
    in_ready       => cntrl_s_in_ready,
    in_last(0)     => in_last,

    acc_init_value => (others => '0'),

    key_in_data    => key_in_data,
    key_in_dvalid  => key_in_dvalid,

    acc_out_valid  => acc_out_valid,
    acc_out_ready  => acc_out_ready,
    acc_out_data   => acc_out_data,

    -- Hash stream. After build stage is done.
    hash_ready     => hash_out_ready,
    hash_enable    => hash_out_enable,
    hash_valid     => hash_out_valid,
    hash_last      => hash_out_last,
    hash_data      => hash_out_data,
    hash_key       => hash_out_key,
    hash_count     => hash_out_count,
    hash_len       => hash_len,

    acc_in_valid   => acc_in_valid,
    acc_in_ready   => acc_in_ready,
    acc_in_data    => acc_in_data,
    acc_in_dvalid  => acc_in_dvalid,

    out_valid      => cntrl_out_slice_in_valid,
    out_ready      => cntrl_out_slice_in_ready,
    out_data       => cntrl_out_slice_in_data,
    key_out_data   => cntrl_out_slice_in_key_data,
    count_out_data => cntrl_out_slice_in_count_data
  );

  in_sync : StreamSync
  generic map(
    NUM_INPUTS  => 1,
    NUM_OUTPUTS => 2
  )
  port map(
    clk          => clk,
    reset        => reset,

    in_valid(0)  => in_valid,
    in_ready(0)  => in_ready,
    out_valid(0) => cntrl_s_in_valid,
    out_valid(1) => dly_in_valid,
    out_ready(0) => cntrl_s_in_ready,
    out_ready(1) => dly_in_ready

  );

  dly_in_data <= in_dvalid & in_data & key_in_data;

  dly : StreamSliceArray
  generic map(
    DATA_WIDTH => NUM_KEYS * 8 + NUM_SUMS * 64 + 1,
    DEPTH      => 2
  )
  port map(
    clk       => clk,
    reset     => reset,

    in_valid  => dly_in_valid,
    in_ready  => dly_in_ready,
    in_data   => dly_in_data,

    out_valid => op_s_in_valid,
    out_ready => op_s_in_ready,
    out_data  => op_s_in_data

  );
  key_in_data_s <= op_s_in_data(NUM_KEYS * 8 - 1 downto 0);

  operator : SumOp
  generic map(
    FIXED_LEFT_INDEX  => FIXED_LEFT_INDEX,
    FIXED_RIGHT_INDEX => FIXED_RIGHT_INDEX,
    NUM_LANES         => NUM_SUMS,
    DATA_WIDTH        => 64,
    DATA_TYPE         => "FIXED64"
  )
  port map(
    clk        => clk,
    reset      => reset,

    op1_valid  => op_s_in_valid,
    op1_ready  => op_s_in_ready,
    op1_dvalid => op_s_in_data(NUM_SUMS * DATA_WIDTH + NUM_KEYS * 8),
    op1_data   => op_s_in_data(NUM_SUMS * DATA_WIDTH + NUM_KEYS * 8 - 1 downto NUM_KEYS * 8),

    op2_valid  => acc_out_valid,
    op2_ready  => acc_out_ready,
    op2_data   => acc_out_data,

    out_valid  => acc_in_valid,
    out_ready  => acc_in_ready,
    out_data   => acc_in_data,
    out_dvalid => acc_in_dvalid

  );

  -- We hash the inputs.
  probe_valid              <= cntrl_out_slice_in_valid;
  cntrl_out_slice_in_ready <= probe_ready;

  cntrl_out_slice : StreamSlice
  generic map(
    DATA_WIDTH => (NUM_SUMS + 1) * 64 + 16 + 1
  )
  port map(
    clk                                                         => clk,
    reset                                                       => reset,
    in_valid                                                    => hash_out_valid,
    in_ready                                                    => hash_out_ready,
    in_data(NUM_SUMS * 64 + 16 + 64)                            => hash_out_last,
    in_data(NUM_SUMS * 64 + 15 + 64 downto NUM_SUMS * 64 + 64)  => hash_out_key,
    in_data(NUM_SUMS * 64 + 63 downto 64)                       => hash_out_data,
    in_data(63 downto 0)                                        => hash_out_count,

    out_valid                                                   => out_valid_s,
    out_ready                                                   => out_ready_s,
    out_data(NUM_SUMS * 64 + 16 + 64)                           => out_last_s,
    out_data(NUM_SUMS * 64 + 15 + 64 downto NUM_SUMS * 64 + 64) => key_out_data_s,
    out_data(NUM_SUMS * 64 + 63 downto 64)                      => out_data_s,
    out_data(63 downto 0)                                       => count_out_data_s
  );

  out_ready_s <= out_ready;
  out_valid   <= out_valid_s;
  out_last    <= out_last_s;
  out_data    <= key_out_data_s & out_data_s & avg_out_data_s & count_out_data_s;
  --count_out_data <= count_out_data_s;

  avg_proc :
  process (out_valid_s, out_data_s, count_out_data_s) is
    variable temp_buffer_1             : sfixed(FIXED_LEFT_INDEX downto FIXED_RIGHT_INDEX);
    variable temp_buffer_quantity      : sfixed(FIXED_LEFT_INDEX downto FIXED_RIGHT_INDEX);
    variable temp_buffer_extendedprice : sfixed(FIXED_LEFT_INDEX downto FIXED_RIGHT_INDEX);
    variable temp_buffer_discount      : sfixed(FIXED_LEFT_INDEX downto FIXED_RIGHT_INDEX);
    variable temp_buffer_2             : sfixed(FIXED_LEFT_INDEX downto FIXED_RIGHT_INDEX) := to_sfixed(1, FIXED_LEFT_INDEX, FIXED_RIGHT_INDEX);
    variable divide_out_quantity       : sfixed(FIXED_LEFT_INDEX - FIXED_RIGHT_INDEX downto FIXED_RIGHT_INDEX - FIXED_LEFT_INDEX - 1);
    variable divide_out_extendedprice  : sfixed(FIXED_LEFT_INDEX - FIXED_RIGHT_INDEX downto FIXED_RIGHT_INDEX - FIXED_LEFT_INDEX - 1);
    variable divide_out_discount       : sfixed(FIXED_LEFT_INDEX - FIXED_RIGHT_INDEX downto FIXED_RIGHT_INDEX - FIXED_LEFT_INDEX - 1);
    variable avg_vec                   : std_logic_vector(NUM_AVGS * DATA_WIDTH - 1 downto 0);
    variable count_var                 : integer;
  begin
    if out_valid_s = '1' and (count_out_data_s /= ZERO) then
      count_var                 := to_integer(unsigned(count_out_data_s));
      temp_buffer_quantity      := to_sfixed(out_data_s(191 downto 128), temp_buffer_1'high, temp_buffer_1'low);
      temp_buffer_extendedprice := to_sfixed(out_data_s(127 downto 64), temp_buffer_1'high, temp_buffer_1'low);
      temp_buffer_discount      := to_sfixed(out_data_s(63 downto 0), temp_buffer_1'high, temp_buffer_1'low);
      temp_buffer_2             := to_sfixed(count_var, temp_buffer_2'high, temp_buffer_2'low);
      if count_var /= 0 then
        divide_out_quantity      := temp_buffer_quantity / temp_buffer_2;
        divide_out_extendedprice := temp_buffer_extendedprice / temp_buffer_2;
        divide_out_discount      := temp_buffer_discount / temp_buffer_2;
        avg_vec(191 downto 128)  := to_slv(resize(arg => divide_out_quantity, left_index => FIXED_LEFT_INDEX, right_index => FIXED_RIGHT_INDEX, round_style => fixed_round_style, overflow_style => fixed_overflow_style));
        avg_vec(127 downto 64)   := to_slv(resize(arg => divide_out_extendedprice, left_index => FIXED_LEFT_INDEX, right_index => FIXED_RIGHT_INDEX, round_style => fixed_round_style, overflow_style => fixed_overflow_style));
        avg_vec(63 downto 0)     := to_slv(resize(arg => divide_out_discount, left_index => FIXED_LEFT_INDEX, right_index => FIXED_RIGHT_INDEX, round_style => fixed_round_style, overflow_style => fixed_overflow_style));
      else
        avg_vec(191 downto 128) := to_slv(temp_buffer_quantity);
        avg_vec(127 downto 64)  := to_slv(temp_buffer_extendedprice);
        avg_vec(63 downto 0)    := to_slv(temp_buffer_discount);
      end if;
      avg_out_data_s <= avg_vec;

    end if;

  end process;

end Behavioral;