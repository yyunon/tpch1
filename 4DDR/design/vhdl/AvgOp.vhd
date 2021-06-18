----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/12/2020 02:15:37 PM
-- Design Name: 
-- Module Name: SumOp - Behavioral
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
    DATA_WIDTH        : natural

  );
  port (

    -- Rising-edge sensitive clock.
    clk       : in std_logic;

    -- Active-high synchronous reset.
    reset     : in std_logic;

    --OP1 Input stream.
    ops_valid : in std_logic;
    ops_ready : out std_logic;
    ops_last  : in std_logic;

    op1_data  : in std_logic_vector(DATA_WIDTH - 1 downto 0);
    op2_data  : in std_logic_vector(DATA_WIDTH - 1 downto 0);

    -- Output stream.
    out_valid : out std_logic;
    out_ready : in std_logic;
    out_last  : out std_logic;
    out_data  : out std_logic_vector(DATA_WIDTH - 1 downto 0)
  );
end AvgOp;

architecture Behavioral of AvgOp is
  constant ZERO         : sfixed(30 downto -1) := to_sfixed(0, 30, -1);

  --subtype float64 is float(11 downto -52);
  signal count_fixed_pt : sfixed(30 downto -1) := to_sfixed(1, 30, -1);
  signal temp_buffer    : sfixed(FIXED_LEFT_INDEX downto FIXED_RIGHT_INDEX);
  signal ops_ready_s    : std_logic;

  signal result         : std_logic_vector(DATA_WIDTH - 1 downto 0);

begin

  count_fixed_pt <= to_sfixed(to_integer(signed(op2_data)), count_fixed_pt'high, count_fixed_pt'low);
  avg_proc :
  process (ops_valid, op1_data, count_fixed_pt) is
    variable temp_buffer   : sfixed(FIXED_LEFT_INDEX downto FIXED_RIGHT_INDEX);
    variable temp_buffer_2 : sfixed(FIXED_LEFT_INDEX downto FIXED_RIGHT_INDEX) := to_sfixed(1, FIXED_LEFT_INDEX, FIXED_RIGHT_INDEX);
    variable divide_out    : sfixed(FIXED_LEFT_INDEX + 2 downto FIXED_RIGHT_INDEX - 30);
    variable avg_vec       : std_logic_vector(DATA_WIDTH - 1 downto 0);
  begin
    temp_buffer := to_sfixed(op1_data, temp_buffer'high, temp_buffer'low);
    out_valid <= '0';
    --avg_vec     := to_slv(temp_buffer);
    out_data  <= (others => '0');
    if ops_valid = '1' and (count_fixed_pt /= ZERO) then
      out_valid <= '1';
      divide_out := temp_buffer / count_fixed_pt;
      --divide_out := divide(l => temp_buffer, r => count_fixed_pt, round_style => fixed_round_style, guard_bits => fixed_guard_bits);
      avg_vec    := to_slv(resize(arg => divide_out, left_index => FIXED_LEFT_INDEX, right_index => FIXED_RIGHT_INDEX, round_style => fixed_round_style, overflow_style => fixed_overflow_style));
      out_data <= avg_vec;
    end if;
  end process;
  out_last  <= ops_last;
  ops_ready <= not ops_valid or out_ready;
end Behavioral;