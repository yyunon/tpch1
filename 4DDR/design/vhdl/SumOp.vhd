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
entity SumOp is
  generic (

    -- Width of the stream data vector.
    FIXED_LEFT_INDEX  : integer;
    FIXED_RIGHT_INDEX : integer;
    NUM_LANES         : integer;
    DATA_WIDTH        : natural;
    DATA_TYPE         : string := ""

  );
  port (

    -- Rising-edge sensitive clock.
    clk        : in std_logic;

    -- Active-high synchronous reset.
    reset      : in std_logic;

    --OP1 Input stream.
    op1_valid  : in std_logic;
    op1_dvalid : in std_logic := '1';
    op1_ready  : out std_logic;
    op1_data   : in std_logic_vector(NUM_LANES * DATA_WIDTH - 1 downto 0);

    --OP2 Input stream.
    op2_valid  : in std_logic;
    op2_dvalid : in std_logic := '1';
    op2_ready  : out std_logic;
    op2_data   : in std_logic_vector(NUM_LANES * DATA_WIDTH - 1 downto 0);

    -- Output stream.
    out_valid  : out std_logic;
    out_ready  : in std_logic;
    out_data   : out std_logic_vector(NUM_LANES * DATA_WIDTH - 1 downto 0);
    out_dvalid : out std_logic
  );
end SumOp;

architecture Behavioral of SumOp is

  --subtype float64 is float(11 downto -52);
  signal temp_buffer : sfixed(FIXED_LEFT_INDEX downto FIXED_RIGHT_INDEX);
  signal ops_valid   : std_logic;
  signal ops_ready   : std_logic;
  signal ops_ready_s : std_logic;

  --OP1 Input stream.
  signal op_valid    : std_logic;
  signal op_dvalid   : std_logic := '1';
  signal op_ready    : std_logic;
  signal op_data     : std_logic_vector(NUM_LANES * DATA_WIDTH - 1 downto 0);

  signal result      : std_logic_vector(NUM_LANES * DATA_WIDTH - 1 downto 0);

begin
  -- Synchronize the operand streams.
  op_in_sync : StreamSync
  generic map(
    NUM_INPUTS  => 2,
    NUM_OUTPUTS => 1
  )
  port map(
    clk          => clk,
    reset        => reset,

    in_valid(0)  => op1_valid,
    in_valid(1)  => op2_valid,
    in_ready(0)  => op1_ready,
    in_ready(1)  => op2_ready,

    out_valid(0) => ops_valid,
    out_ready(0) => ops_ready
  );
  sum_slice_gen :
  for s in 0 to NUM_LANES - 1 generate
    float_comb_process :
    if DATA_TYPE = "FIXED64" generate
      process (op1_data, op2_data) is
        variable temp_buffer_1 : sfixed(FIXED_LEFT_INDEX downto FIXED_RIGHT_INDEX);
        variable temp_buffer_2 : sfixed(FIXED_LEFT_INDEX downto FIXED_RIGHT_INDEX);
        variable temp_res      : sfixed(FIXED_LEFT_INDEX + 1 downto FIXED_RIGHT_INDEX);
      begin
        temp_buffer_1 := to_sfixed(op1_data((s + 1) * DATA_WIDTH - 1 downto s * DATA_WIDTH), temp_buffer_1'high, temp_buffer_1'low);
        temp_buffer_2 := to_sfixed(op2_data((s + 1) * DATA_WIDTH - 1 downto s * DATA_WIDTH), temp_buffer_2'high, temp_buffer_2'low);
        temp_res      := temp_buffer_1 + temp_buffer_2;
        result((s + 1) * DATA_WIDTH - 1 downto s * DATA_WIDTH) <= to_slv(resize(arg => temp_res, left_index => FIXED_LEFT_INDEX, right_index => FIXED_RIGHT_INDEX, round_style => fixed_round_style, overflow_style => fixed_overflow_style));
      end process;
    end generate;
  end generate;

  int_comb_process :
  if DATA_TYPE = "INT64" generate
    process (op1_data, op2_data) is
    begin
      result <= std_logic_vector(signed(op1_data) + signed(op2_data));
    end process;
  end generate;
  reg_proc :
  process (clk) is
  begin
    if rising_edge(clk) then
      ops_ready_s <= out_ready;
      if reset = '1' then
        ops_ready_s <= '0';
      end if;
    end if;
  end process;

  out_data   <= std_logic_vector(result);
  out_valid  <= op1_valid and op2_valid;
  out_dvalid <= op1_dvalid and op2_dvalid;
  ops_ready  <= ops_ready_s;
end Behavioral;