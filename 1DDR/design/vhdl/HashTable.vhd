library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.Tpch_pkg.all;
use work.Stream_pkg.all;
use work.UtilRam_pkg.all;

-- This table implements a hash table implementation for 
-- group by aggregation. It also synt. a CAM counter implementataion
-- for hit/miss for the key. 
entity HashTable is
  generic (

    -- Width of the stream data vector.
    HASH_FUNCTION       : string  := "";
    NUM_KEYS            : natural := 1;
    DATA_WIDTH          : natural := 64;
    GROUP_ADDRESS_WIDTH : natural := 5;
    ADDRESS_WIDTH       : natural := 8
  );
  port (

    -- Rising-edge sensitive clock.
    clk                    : in std_logic;

    -- Active-high synchronous reset.
    reset                  : in std_logic;

    --Key stream.
    key_in_data            : in std_logic_vector(NUM_KEYS * ADDRESS_WIDTH - 1 downto 0);

    -- Operation
    operation              : in std_logic;

    --Input data stream.
    in_data                : in std_logic_vector(DATA_WIDTH - 1 downto 0);

    -- Output stream.
    out_data               : out std_logic_vector(DATA_WIDTH - 1 downto 0);

    -- Num. of entries
    num_entries            : out std_logic_vector(NUM_KEYS * ADDRESS_WIDTH - 1 downto 0);

    -- Stream key output
    stream_key_out_valid   : in std_logic;
    stream_key_out_address : in std_logic_vector(NUM_KEYS * ADDRESS_WIDTH - 1 downto 0);
    stream_key_out_data    : out std_logic_vector(NUM_KEYS * ADDRESS_WIDTH - 1 downto 0)

  );
end HashTable;

architecture Behavioral of HashTable is
  type state_t is (STATE_IDLE, STATE_UPDATE);
  constant DIGEST_SIZE           : integer := 10;

  signal state, state_next       : state_t;

  signal key_in_data_s           : std_logic_vector(NUM_KEYS * ADDRESS_WIDTH - 1 downto 0);

  signal operation_s             : std_logic;
  signal write_enable            : std_logic;
  signal write_address           : std_logic_vector(DIGEST_SIZE - 1 downto 0);
  signal write_data              : std_logic_vector(DATA_WIDTH downto 0);

  signal read_enable             : std_logic;
  signal read_address            : std_logic_vector(DIGEST_SIZE - 1 downto 0);
  signal read_data               : std_logic_vector(DATA_WIDTH downto 0);

  signal bit_table_write_enable  : std_logic;
  signal bit_table_write_address : std_logic_vector(NUM_KEYS * ADDRESS_WIDTH - 1 downto 0);
  signal bit_table_write_data    : std_logic_vector(NUM_KEYS * ADDRESS_WIDTH - 1 downto 0);

  signal bit_table_read_enable   : std_logic;
  signal bit_table_read_address  : std_logic_vector(NUM_KEYS * ADDRESS_WIDTH - 1 downto 0);
  signal bit_table_read_data     : std_logic_vector(NUM_KEYS * ADDRESS_WIDTH - 1 downto 0);

  signal hash_pointer            : unsigned(NUM_KEYS * ADDRESS_WIDTH - 1 downto 0);
  signal hash_pointer_next       : unsigned(NUM_KEYS * ADDRESS_WIDTH - 1 downto 0);

begin
  read_enable            <= '1';
  bit_table_read_enable  <= '1';
  -- This is for array writer.
  num_entries            <= std_logic_vector(hash_pointer + 1);
  bit_table_read_address <= stream_key_out_address when stream_key_out_valid = '1' else
    std_logic_vector(hash_pointer);
  stream_key_out_data <= bit_table_read_data(NUM_KEYS * ADDRESS_WIDTH - 1 downto 0);

  key_in_data_s       <= key_in_data;

  hash_function_gen_direct :
  if HASH_FUNCTION = "DIRECT" generate
    --bit_table_read_address <= key_in_data;
    read_address <= key_in_data;
  end generate;

  hash_function_gen_alias :
  if HASH_FUNCTION = "MODULO32" generate
    --bit_table_read_address <= key_in_data;
    read_address <= key_in_data(12 downto 8) & key_in_data(4 downto 0);
  end generate;

  bit_table : UtilRam1R1W -- This will hold the keys.
  generic map(
    WIDTH      => NUM_KEYS * ADDRESS_WIDTH,
    DEPTH_LOG2 => GROUP_ADDRESS_WIDTH
  )
  port map(
    w_clk  => clk,
    w_ena  => bit_table_write_enable,
    w_addr => bit_table_write_address(GROUP_ADDRESS_WIDTH - 1 downto 0),
    w_data => bit_table_write_data,
    r_clk  => clk,
    r_ena  => bit_table_read_enable,
    r_addr => bit_table_read_address(GROUP_ADDRESS_WIDTH - 1 downto 0),
    r_data => bit_table_read_data
  );

  hash_table : UtilRam1R1W
  generic map(
    WIDTH      => DATA_WIDTH + 1,
    DEPTH_LOG2 => DIGEST_SIZE
  )
  port map(
    w_clk  => clk,
    w_ena  => write_enable,
    w_addr => write_address,
    w_data => write_data,
    r_clk  => clk,
    r_ena  => read_enable,
    r_addr => read_address,
    r_data => read_data
  );

  -- Process to hash the input
  hash_proc :
  process (state, in_data, read_data, read_address, operation, hash_pointer) is
    variable hash_counter : unsigned(NUM_KEYS * ADDRESS_WIDTH - 1 downto 0);
  begin
    state_next             <= state;
    bit_table_write_enable <= '0';
    write_enable           <= '0';
    hash_counter := hash_pointer;
    case state is
      when STATE_IDLE =>
        if operation = '1' then
          state_next <= STATE_UPDATE;
        else
          state_next <= STATE_IDLE;
        end if;
      when STATE_UPDATE =>
        -- update hash table
        if read_data(DATA_WIDTH) = '1' then
          state_next <= STATE_IDLE;
        else
          -- update bit table
          bit_table_write_enable  <= '1';
          bit_table_write_address <= std_logic_vector(hash_pointer);
          bit_table_write_data    <= key_in_data_s;
          state_next              <= STATE_IDLE;
          hash_counter := hash_counter + to_unsigned(1, NUM_KEYS * ADDRESS_WIDTH); -- Increment the hash pointer to the next address
          --hash_counter := hash_counter + 1;
        end if;
        write_enable  <= '1';
        write_data    <= '1' & in_data;
        write_address <= read_address;
    end case;
    hash_pointer_next <= hash_counter;
  end process;

  out_data <= read_data(DATA_WIDTH - 1 downto 0);

  -- Seq process
  seq_proc :
  process (clk) is
  begin
    if rising_edge(clk) then
      --operation_s  <= operation;
      state        <= state_next;
      hash_pointer <= hash_pointer_next;
      if reset = '1' then
        state        <= STATE_IDLE;
        hash_pointer <= to_unsigned(0, NUM_KEYS * ADDRESS_WIDTH);
      end if;
    end if;
  end process;
end Behavioral;