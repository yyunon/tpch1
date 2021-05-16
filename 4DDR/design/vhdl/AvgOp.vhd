----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/12/2020 02:15:37 PM
-- Design Name: 
-- Module Name: AvgOp - Behavioral
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
use work.Stream_pkg.all;
use work.Tpch_pkg.all;
use work.fixed_generic_pkg_mod.all;

--library ieee_proposed;
--use ieee_proposed.fixed_pkg.all;
entity AvgOp is
  generic (

    -- Width of the stream data vector.
    FIXED_LEFT_INDEX  : integer;
    FIXED_RIGHT_INDEX : integer;
    LENGTH_WIDTH      : integer;
    DATA_WIDTH        : natural;
    DATA_TYPE         : string := ""

  );
  port (

    -- Rising-edge sensitive clock.
    clk        : in std_logic;

    -- Active-high synchronous reset.
    reset      : in std_logic;

    --Aggregate Input stream.
    agg_valid  : in std_logic;
    agg_dvalid : in std_logic := '1';
    agg_ready  : out std_logic;
    agg_data   : in std_logic_vector(DATA_WIDTH - 1 downto 0);
    agg_last   : in std_logic := '1';

    --OP1 Input stream.
    ops_valid  : in std_logic;
    ops_dvalid : in std_logic := '1';
    ops_ready  : out std_logic;
    ops_data   : in std_logic_vector(DATA_WIDTH - 1 downto 0);
    ops_last   : in std_logic := '1';

    -- Output stream.
    out_valid  : out std_logic;
    out_ready  : in std_logic;
    out_data   : out std_logic_vector(DATA_WIDTH - 1 downto 0);
    out_dvalid : out std_logic
  );
end AvgOp;

architecture Behavioral of AvgOp is

  --subtype float64 is float(11 downto -52);
  signal data        : sfixed(FIXED_LEFT_INDEX downto FIXED_RIGHT_INDEX);

  signal count_valid : std_logic;
  signal count_ready : std_logic;
  signal count_last  : std_logic;
  signal count       : std_logic_vector(DATA_WIDTH - 1 downto 0);

  signal result      : std_logic_vector(DATA_WIDTH - 1 downto 0);

begin
  input_element_counter : StreamElementCounter
  generic map(
    IN_COUNT_WIDTH  => 1,
    IN_COUNT_MAX    => 1,
    OUT_COUNT_WIDTH => LENGTH_WIDTH,
    OUT_COUNT_MAX   => 2 ** LENGTH_WIDTH - 1
  )
  port map(
    clk       => clk,
    reset     => reset,
    in_valid  => ops_valid,
    in_ready  => ops_ready,
    in_last   => ops_last,
    in_count  => "1",
    in_dvalid => ops_dvalid,
    out_valid => count_valid,
    out_ready => '1',
    out_count => count,
    out_last  => count_last
  );
  agg_ready <= not agg_valid and out_ready;
  comb_proc :
  process (agg_data, agg_valid, out_ready)
  begin
    if (out_ready = '1') and (agg_valid = '1') then
      data <= to_sfixed(agg_data, FIXED_LEFT_INDEX, FIXED_RIGHT_INDEX);
    end if;
  end process;

  reg_process :
  process (clk)
  begin
    if rising_edge(clk) then
      result <= (others => '0');
      if (count_last = '1') and (count_valid = '1') then
        result <= to_slv(resize(arg => data / count, left_index => FIXED_LEFT_INDEX, right_index => FIXED_RIGHT_INDEX, round_style => fixed_round_style, overflow_style => fixed_overflow_style));
      end if;
      if reset = '1' then
        data <= (others => '0');
      end if;
    end if;
  end process;

end Behavioral;