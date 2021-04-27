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
    hash_out_ready    : in std_logic;
    hash_out_data     : out std_logic_vector(NUM_LANES * DATA_WIDTH - 1 downto 0);
    hash_key_out_data : out std_logic_vector(NUM_KEYS * 8 - 1 downto 0);
    hash_count_data   : out std_logic_vector(NUM_LANES * DATA_WIDTH - 1 downto 0);

    -- Output stream.
    out_valid         : out std_logic;
    out_ready         : in std_logic;
    out_data          : out std_logic_vector(NUM_LANES * DATA_WIDTH - 1 downto 0);
    key_out_data      : out std_logic_vector(NUM_KEYS * 8 - 1 downto 0);
    count_data        : out std_logic_vector(NUM_LANES * DATA_WIDTH - 1 downto 0)

  );
end StreamAccumulator;

architecture Behavioral of StreamAccumulator is

  -- Initialization status regsiter.
  signal initialized     : std_logic;

  -- Holding register for the accumulator data
  signal data            : std_logic_vector(NUM_LANES * DATA_WIDTH - 1 downto 0);

  signal count           : std_logic_vector(NUM_LANES * DATA_WIDTH - 1 downto 0);

  signal out_valid_s     : std_logic;
  -- hash table vars
  signal hash_operation  : std_logic;
  signal hash_in_data    : std_logic_vector((NUM_LANES + 1) * DATA_WIDTH - 1 downto 0);
  signal hash_out_data_s : std_logic_vector((NUM_LANES + 1) * DATA_WIDTH - 1 downto 0);
  --bit table vars
  signal num_entries     : std_logic_vector(15 downto 0);
  signal bit_address_in  : std_logic_vector(15 downto 0);
  signal bit_address_out : std_logic_vector(15 downto 0);

  signal key_out_data_s  : std_logic_vector(NUM_KEYS * 8 - 1 downto 0);
  signal key_in_data_s   : std_logic_vector(NUM_KEYS * 8 - 1 downto 0);

begin

  -- Input is always ready.
  in_ready          <= '1';

  -- Output data vector is always the accumulator register.
  --out_data <= data;
  out_data          <= hash_out_data_s((NUM_LANES + 1) * DATA_WIDTH - 1 downto 64); -- Read port always enabled.
  count_data        <= hash_out_data_s(63 downto 0);                                -- First 64 bits for count data..
  key_out_data      <= key_out_data_s;
  -- This is for backwards reading. what a shitty comment
  -- Output data vector is always the accumulator register.
  hash_out_data     <= hash_out_data_s((NUM_LANES + 1) * DATA_WIDTH - 1 downto 64); -- Read port always enabled.
  hash_count_data   <= hash_out_data_s(63 downto 0);                                -- First 64 bits for count data..
  hash_key_out_data <= key_out_data_s;

  HashTable_inst : HashTable
  generic map(
    HASH_FUNCTION => "DIRECT",
    NUM_KEYS      => NUM_KEYS,
    DATA_WIDTH    => DATA_WIDTH * (NUM_LANES + 1), -- Use count too
    ADDRESS_WIDTH => 8
  )
  port map(
    clk                    => clk,
    reset                  => reset,
    key_in_data            => key_in_data_s,
    operation              => hash_operation,
    in_data                => hash_in_data,
    out_data               => hash_out_data_s,
    num_entries            => num_entries,
    stream_key_out_address => bit_address_in,
    stream_key_out_data    => bit_address_out
  );

  hash_in_data <= data & count;

  reg_proc :
  process (clk) is
    variable count_reg : unsigned(63 downto 0);
  begin
    if rising_edge(clk) then

      out_valid      <= initialized;
      hash_operation <= '0';
      key_in_data_s  <= (others => '0');

      if in_valid = '1' and in_dvalid = '1' then
        hash_operation <= '1'; --Update hash table
        key_in_data_s  <= key_in_data;
        count_reg := unsigned(hash_out_data_s(63 downto 0)); -- Always least significant bits hold the count.
        count       <= std_logic_vector(count_reg + 1);
        data        <= in_data;
        initialized <= '1';
        if in_last = '1' then
          initialized <= '0';
          data        <= init_value;
        end if;
      end if;
      if reset = '1' then
        initialized <= '1';
        data        <= init_value;
      end if;
    end if;
  end process;

  reg_process_out :
  process (clk) is
    variable count_reg : unsigned(15 downto 0);
  begin
    if rising_edge(clk) then
      --O-utput logic, will stream the hash and bit table 
      out_valid_s    <= '0';
      hash_operation <= '0'; -- We only do reads in this process.
      key_in_data_s  <= (others => '0');
      if hash_out_ready = '1' then
        if count_reg < 15 then
          out_valid_s    <= '1';
          bit_address_in <= std_logic_vector(count_reg);
          count_reg := count_reg + 1;
          -- 2 clk cyc.
          key_out_data_s <= bit_address_out;
          key_in_data_s  <= key_out_data_s;
        end if;
      end if;
      hash_out_valid <= out_valid_s;
      if reset = '1' then
        count_reg := to_unsigned(0, 16);
      end if;
    end if;
  end process;

end Behavioral;