----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Ákos Hadnagy
-- 
-- Create Date: 05/29/2020 03:41:48 PM
-- Design Name: 
-- Module Name: SequenceStream - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.Tpch_pkg.all;
use work.Stream_pkg.all;

-- This unit is a simple accumulator. The data can be read any time after

entity StreamAccumulator is
  generic (

    -- Width of the stream data vector.
    DATA_WIDTH : natural;
    NUM_LANES  : natural;
    NUM_KEYS   : natural := 1
  );
  port (

    -- Rising-edge sensitive clock.
    clk               : in std_logic;

    -- Active-high synchronous reset.
    reset             : in std_logic;

    -- Init value
    -- Loaded at reset and on 'last'.
    init_value        : in std_logic_vector(DATA_WIDTH - 1 downto 0);

    -- Key stream for hash logic
    key_in_dvalid     : in std_logic := '1';
    key_in_data       : in std_logic_vector(NUM_KEYS * 8 - 1 downto 0);

    -- Input stream.
    in_valid          : in std_logic;
    in_ready          : out std_logic;
    in_data           : in std_logic_vector(NUM_LANES * DATA_WIDTH - 1 downto 0);
    in_last           : in std_logic;
    in_dvalid         : in std_logic := '1';

    -- Hash out stream
    hash_out_valid    : out std_logic;
    hash_out_last     : out std_logic;
    hash_out_ready    : in std_logic;
    hash_out_enable   : in std_logic;
    hash_out_data     : out std_logic_vector(NUM_LANES * DATA_WIDTH - 1 downto 0) := (others => '0');
    hash_key_out_data : out std_logic_vector(NUM_KEYS * 8 - 1 downto 0);
    hash_count_data   : out std_logic_vector(DATA_WIDTH - 1 downto 0);
    hash_len_data     : out std_logic_vector(15 downto 0);

    -- Output stream.
    out_valid         : out std_logic;
    out_ready         : in std_logic;
    out_data          : out std_logic_vector(NUM_LANES * DATA_WIDTH - 1 downto 0);
    key_out_data      : out std_logic_vector(NUM_KEYS * 8 - 1 downto 0);
    count_data        : out std_logic_vector(DATA_WIDTH - 1 downto 0)

  );
end StreamAccumulator;

architecture Behavioral of StreamAccumulator is

  -- Initialization status regsiter.
  signal initialized         : std_logic;

  -- Holding register for the accumulator data
  signal data                : std_logic_vector(NUM_LANES * DATA_WIDTH - 1 downto 0);

  signal count               : std_logic_vector(DATA_WIDTH - 1 downto 0);

  signal hash_out_valid_s1   : std_logic;
  signal hash_out_valid_s2   : std_logic;
  signal hash_out_valid_s0   : std_logic;

  signal out_valid_s1        : std_logic;
  signal out_valid_s2        : std_logic;
  signal out_valid_s         : std_logic;

  signal out_ready_s         : std_logic;
  signal in_ready_s          : std_logic;
  -- hash table vars
  signal hash_out_ready_s1   : std_logic;
  signal hash_out_ready_s2   : std_logic;

  signal hash_last_s1        : std_logic;
  signal hash_last_s2        : std_logic;

  signal hash_operation      : std_logic;
  signal hash_in_data        : std_logic_vector((NUM_LANES + 1) * DATA_WIDTH - 1 downto 0);

  --hash out stream in slice
  signal hash_out_valid_s    : std_logic;
  signal hash_out_ready_s    : std_logic;
  signal hash_last_s         : std_logic;
  signal hash_out_data_s     : std_logic_vector((NUM_LANES + 1) * DATA_WIDTH - 1 downto 0);
  signal hash_data_s         : std_logic_vector(NUM_LANES * DATA_WIDTH - 1 downto 0);
  signal hash_key_out_data_s : std_logic_vector(NUM_KEYS * 8 - 1 downto 0);
  signal hash_count_data_s   : std_logic_vector(DATA_WIDTH - 1 downto 0);
  --bit table vars
  signal num_entries         : std_logic_vector(15 downto 0);
  signal bit_address_in      : std_logic_vector(15 downto 0);
  signal bit_address_valid   : std_logic;
  signal bit_address_out     : std_logic_vector(15 downto 0);

  signal key_out_data_s      : std_logic_vector(NUM_KEYS * 8 - 1 downto 0);
  signal key_out_data_s1     : std_logic_vector(NUM_KEYS * 8 - 1 downto 0);
  signal key_out_data_s2     : std_logic_vector(NUM_KEYS * 8 - 1 downto 0);
  signal key_out_data_s3     : std_logic_vector(NUM_KEYS * 8 - 1 downto 0);
  signal key_in_data_s       : std_logic_vector(NUM_KEYS * 8 - 1 downto 0);

  --Debug
  signal out_counter         : unsigned(15 downto 0);

begin

  hash_out_buffer : StreamBuffer
  generic map(
    MIN_DEPTH  => 2,
    DATA_WIDTH => (NUM_LANES + 1) * DATA_WIDTH + NUM_KEYS * 8 + 1
  )
  port map(
    clk                                                                                           => clk,
    reset                                                                                         => reset,
    in_valid                                                                                      => hash_out_valid_s,
    in_ready                                                                                      => hash_out_ready_s,
    in_data((NUM_LANES + 1) * DATA_WIDTH + NUM_KEYS * 8)                                          => hash_last_s,
    in_data((NUM_LANES + 1) * DATA_WIDTH + NUM_KEYS * 8 - 1 downto (NUM_LANES + 1) * DATA_WIDTH)  => hash_key_out_data_s,
    in_data((NUM_LANES + 1) * DATA_WIDTH - 1 downto NUM_LANES * DATA_WIDTH)                       => hash_count_data_s,
    in_data(NUM_LANES * DATA_WIDTH - 1 downto 0)                                                  => hash_data_s,
    out_valid                                                                                     => hash_out_valid,
    out_ready                                                                                     => hash_out_ready,
    out_data((NUM_LANES + 1) * DATA_WIDTH + NUM_KEYS * 8)                                         => hash_out_last,
    out_data((NUM_LANES + 1) * DATA_WIDTH + NUM_KEYS * 8 - 1 downto (NUM_LANES + 1) * DATA_WIDTH) => hash_key_out_data,
    out_data((NUM_LANES + 1) * DATA_WIDTH - 1 downto NUM_LANES * DATA_WIDTH)                      => hash_count_data,
    out_data(NUM_LANES * DATA_WIDTH - 1 downto 0)                                                 => hash_out_data
  );
  -- Input is always ready.
  in_ready      <= '1';

  hash_len_data <= num_entries;
  -- Output data vector is always the accumulator register.
  --out_data <= data;
  out_data      <= hash_out_data_s((NUM_LANES + 1) * DATA_WIDTH - 1 downto 64); -- Read port always enabled.
  count_data    <= hash_out_data_s(63 downto 0);                                -- First 64 bits for count data..
  key_out_data  <= key_out_data_s;

  HashTable_inst : HashTable
  generic map(
    HASH_FUNCTION       => "MODULO32",
    NUM_KEYS            => NUM_KEYS,
    DATA_WIDTH          => DATA_WIDTH * (NUM_LANES + 1), -- Use count too
    GROUP_ADDRESS_WIDTH => 4,                            --This is for the size of key list
    ADDRESS_WIDTH       => 8
  )
  port map(
    clk                    => clk,
    reset                  => reset,
    key_in_data            => key_in_data_s,
    operation              => hash_operation,
    in_data                => hash_in_data,
    out_data               => hash_out_data_s,
    num_entries            => num_entries,
    stream_key_out_valid   => bit_address_valid,
    stream_key_out_address => bit_address_in,
    stream_key_out_data    => bit_address_out
  );

  -- HashTable input logic
  hash_in_data  <= data & count;
  key_in_data_s <= bit_address_out when hash_out_ready_s = '1' and hash_out_enable = '1' else
    key_in_data;
  --key_in_data_s <= key_in_data when in_valid = '1' and hash_out_enable = '1' else
  --  bit_address_out;

  reg_proc :
  process (clk) is
    variable count_reg     : unsigned(63 downto 0);
    variable count_reg_out : unsigned(15 downto 0);
  begin
    if rising_edge(clk) then

      out_valid         <= initialized;
      --out_valid_s       <= '0';
      hash_operation    <= '0';
      --Output logic, will stream the hash and bit table 
      hash_out_valid_s0 <= '0';
      hash_last_s       <= '0';
      bit_address_valid <= '0';
      --key_in_data_s     <= (others => '0'); -- to input key for reading data from hash table

      if in_valid = '1' and in_dvalid = '1' then
        hash_operation <= '1';                               --Update hash table
        --out_valid_s    <= '1';
        --key_in_data_s  <= key_in_data;
        count_reg := unsigned(hash_out_data_s(63 downto 0)); -- Always least significant bits hold the count.
        count       <= std_logic_vector(count_reg + 1);
        data        <= in_data;
        initialized <= '1';
        if in_last = '1' then
          initialized <= '0';
          --out_valid_s <= '0';
          --data        <= (others => '0');
        end if;
      elsif hash_out_ready_s = '1' and hash_out_enable = '1' then
        if count_reg_out < unsigned(num_entries) then
          -- It takes 1 clk cycles to read the hash key and 1 clk cycles to read data.
          hash_out_valid_s0 <= '1';

          bit_address_valid <= '1';
          bit_address_in    <= std_logic_vector(count_reg_out); -- Read the key list
          --key_in_data_s     <= bit_address_out;                 -- to input key for reading data from hash table
          count_reg_out := count_reg_out + 1;
        elsif count_reg_out = unsigned(num_entries) then
          hash_last_s <= '1';
        end if;
      end if;

      -- Debug purposes
      out_counter <= count_reg_out;

      if reset = '1' then
        initialized <= '1';
        --out_valid_s <= '1';
        count_reg     := to_unsigned(0, 64);
        count_reg_out := to_unsigned(0, 16);
        data              <= (others => '0');
        hash_out_ready_s1 <= '0';
        hash_out_ready_s2 <= '0';
      end if;

      -- Aggreagate out registers--------------
      --out_valid           <= out_valid_s; -- Table read op. takes 1 cyc. Therefore, delay the valid signal. 
      --out_ready_s         <= out_ready;
      -------------------------------------------

      -- Hash out registers---------------------
      --key_out_data_s2     <= key_out_data_s;
      hash_key_out_data_s <= bit_address_out; -- to output hash key
      --hash_key_out_data_s <= key_out_data_s;

      hash_out_valid_s1   <= hash_out_valid_s0;
      hash_out_valid_s    <= hash_out_valid_s1;

      --hash_last_s1        <= hash_last_s2;
      --hash_last_s         <= hash_last_s1;
      -------------------------------------------
    end if;

  end process;
  -- This is for backwards reading.
  -- Output data vector is always the accumulator register.
  hash_data_s <= hash_out_data_s((NUM_LANES + 1) * DATA_WIDTH - 1 downto 64) when hash_out_enable = '1' else
    (others => '0'); -- Read port always enabled.
  hash_count_data_s <= std_logic_vector(unsigned(hash_out_data_s(63 downto 0)) + 1) when hash_out_enable = '1' else
    (others => '0'); -- First 64 bits for count data..

end Behavioral;