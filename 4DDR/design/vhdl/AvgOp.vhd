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
    clk        : in std_logic;

    -- Active-high synchronous reset.
    reset      : in std_logic;

    --OP1 Input stream.
    op1_valid  : in std_logic;
    op1_ready  : out std_logic;
    op1_dvalid : in std_logic;
    op1_data   : in std_logic_vector(DATA_WIDTH - 1 downto 0);
    op1_last   : in std_logic;

    op2_valid  : in std_logic;
    op2_ready  : out std_logic;
    op2_dvalid : in std_logic;
    op2_data   : in std_logic_vector(DATA_WIDTH - 1 downto 0);
    op2_last   : in std_logic;

    -- Output stream.
    out_valid  : out std_logic;
    out_ready  : in std_logic;
    out_last   : out std_logic;
    out_data   : out std_logic_vector(DATA_WIDTH - 1 downto 0)
  );
end AvgOp;

architecture Behavioral of AvgOp is
  component div_gen_0 is
    port (
      aclk                   : in std_logic;
      s_axis_divisor_tvalid  : in std_logic;
      s_axis_divisor_tready  : out std_logic;
      s_axis_divisor_tuser   : in std_logic_vector(0 downto 0);
      s_axis_divisor_tlast   : in std_logic;
      s_axis_divisor_tdata   : in std_logic_vector(63 downto 0);
      s_axis_dividend_tvalid : in std_logic;
      s_axis_dividend_tready : out std_logic;
      s_axis_dividend_tuser  : in std_logic_vector(0 downto 0);
      s_axis_dividend_tlast  : in std_logic;
      s_axis_dividend_tdata  : in std_logic_vector(63 downto 0);
      m_axis_dout_tvalid     : out std_logic;
      m_axis_dout_tready     : in std_logic;
      m_axis_dout_tuser      : out std_logic_vector(2 downto 0);
      m_axis_dout_tlast      : out std_logic;
      m_axis_dout_tdata      : out std_logic_vector(87 downto 0)
    );
  end component;
  constant ZERO         : sfixed(FIXED_LEFT_INDEX downto FIXED_RIGHT_INDEX) := to_sfixed(0, FIXED_LEFT_INDEX, FIXED_RIGHT_INDEX);

  signal op1_valid_s    : std_logic;
  signal op1_ready_s    : std_logic;
  signal op1_dvalid_s   : std_logic;
  signal op1_data_s     : std_logic_vector(DATA_WIDTH - 1 downto 0);
  signal op1_last_s     : std_logic;

  signal op2_valid_s    : std_logic;
  signal op2_ready_s    : std_logic;
  signal op2_dvalid_s   : std_logic;
  signal op2_data_s     : std_logic_vector(DATA_WIDTH - 1 downto 0);
  signal op2_last_s     : std_logic;

  -- Output stream.
  signal ops_valid_s    : std_logic;
  signal ops_ready_s    : std_logic;
  signal ops_valid      : std_logic;
  signal ops_user       : std_logic_vector(2 downto 0);
  signal ops_ready      : std_logic;
  signal ops_last       : std_logic;
  signal ops_data       : std_logic_vector(88 - 1 downto 0); -- 18 Fractional
  signal out_data_s     : std_logic_vector(63 downto 0);     -- 18 Fractional

  --subtype float64 is float(11 downto -52);
  --signal count_fixed_pt : sfixed(FIXED_LEFT_INDEX downto FIXED_RIGHT_INDEX) := to_sfixed(1, FIXED_LEFT_INDEX, FIXED_RIGHT_INDEX);
  signal count_fixed_pt : std_logic_vector(63 downto 0);
  signal temp_buffer    : sfixed(FIXED_LEFT_INDEX downto FIXED_RIGHT_INDEX);

  signal result         : std_logic_vector(DATA_WIDTH - 1 downto 0);

begin
  op1_buf : StreamBuffer
  generic map(
    DATA_WIDTH => DATA_WIDTH + 2,
    MIN_DEPTH  => 2
  )
  port map(
    clk                   => clk,
    reset                 => reset,
    in_valid              => op1_valid,
    in_ready              => op1_ready,
    in_data(65)           => op1_last,
    in_data(64)           => op1_last,
    in_data(63 downto 0)  => op1_data,

    out_valid             => op1_valid_s,
    out_ready             => op1_ready_s,
    out_data(65)          => op1_last_s,
    out_data(64)          => op1_dvalid_s,
    out_data(63 downto 0) => op1_data_s
  );
  op2_buf : StreamBuffer
  generic map(
    DATA_WIDTH => DATA_WIDTH + 2,
    MIN_DEPTH  => 2
  )
  port map(
    clk                   => clk,
    reset                 => reset,
    in_valid              => op2_valid,
    in_ready              => op2_ready,
    in_data(65)           => op2_last,
    in_data(64)           => op2_last,
    in_data(63 downto 0)  => op2_data,

    out_valid             => op2_valid_s,
    out_ready             => op2_ready_s,
    out_data(65)          => op2_last_s,
    out_data(64)          => op2_dvalid_s,
    out_data(63 downto 0) => op2_data_s
  );
  out_buf : StreamBuffer
  generic map(
    DATA_WIDTH => DATA_WIDTH + 1,
    MIN_DEPTH  => 2
  )
  port map(
    clk                   => clk,
    reset                 => reset,
    in_valid              => ops_valid_s,
    in_ready              => ops_ready_s,
    in_data(64)           => ops_last,
    in_data(63 downto 0)  => out_data_s,

    out_valid             => out_valid,
    out_ready             => out_ready,
    out_data(64)          => out_last,
    out_data(63 downto 0) => out_data
  );
  count_fixed_pt <= to_slv(to_sfixed(to_integer(signed(op2_data_s)), FIXED_LEFT_INDEX, FIXED_RIGHT_INDEX));
  avg_proc : div_gen_0
  port map(
    aclk                     => clk,
    s_axis_divisor_tvalid    => op2_valid_s,
    s_axis_divisor_tready    => op2_ready_s,
    s_axis_divisor_tuser(0)  => op2_dvalid_s,
    s_axis_divisor_tlast     => op2_last_s,
    s_axis_divisor_tdata     => count_fixed_pt,
    s_axis_dividend_tvalid   => op1_valid_s,
    s_axis_dividend_tready   => op1_ready_s,
    s_axis_dividend_tuser(0) => op1_dvalid_s,
    s_axis_dividend_tlast    => op1_last_s,
    s_axis_dividend_tdata    => op1_data_s,
    m_axis_dout_tvalid       => ops_valid,
    m_axis_dout_tready       => ops_ready,
    m_axis_dout_tuser        => ops_user,
    m_axis_dout_tlast        => ops_last,
    m_axis_dout_tdata        => ops_data
  );
  ops_ready <= not ops_valid or ops_ready_s;
  out_parse :
  process (ops_data, ops_user, ops_valid) is
    variable temp_res : sfixed(87 + FIXED_RIGHT_INDEX downto FIXED_RIGHT_INDEX);
  begin
    temp_res := to_sfixed(ops_data, temp_res'high, temp_res'low);
    ops_valid_s <= '0';
    out_data_s  <= (others => '0');
    if ops_valid = '1' and ops_user(0) = '0' then
      out_data_s  <= to_slv(resize(arg => temp_res, left_index => fixed_left_index, right_index => fixed_right_index, round_style => fixed_round_style, overflow_style => fixed_overflow_style));
      ops_valid_s <= '1';
    end if;
  end process;
  --process (ops_valid, op1_data, count_fixed_pt) is
  --  variable temp_buffer   : sfixed(FIXED_LEFT_INDEX downto FIXED_RIGHT_INDEX);
  --  variable temp_buffer_2 : sfixed(FIXED_LEFT_INDEX downto FIXED_RIGHT_INDEX) := to_sfixed(1, FIXED_LEFT_INDEX, FIXED_RIGHT_INDEX);
  --  variable divide_out    : sfixed(FIXED_LEFT_INDEX + 2 downto FIXED_RIGHT_INDEX - 30);
  --  variable avg_vec       : std_logic_vector(DATA_WIDTH - 1 downto 0);
  --begin
  --  temp_buffer := to_sfixed(op1_data, temp_buffer'high, temp_buffer'low);
  --  out_valid <= '0';
  --  --avg_vec     := to_slv(temp_buffer);
  --  out_data  <= (others => '0');
  --  if ops_valid = '1' and (count_fixed_pt /= ZERO) then
  --    out_valid <= '1';
  --    divide_out := temp_buffer / count_fixed_pt;
  --    --divide_out := divide(l => temp_buffer, r => count_fixed_pt, round_style => fixed_round_style, guard_bits => fixed_guard_bits);
  --    avg_vec    := to_slv(resize(arg => divide_out, left_index => FIXED_LEFT_INDEX, right_index => FIXED_RIGHT_INDEX, round_style => fixed_round_style, overflow_style => fixed_overflow_style));
  --    out_data <= avg_vec;
  --  end if;
  --end process;
  --out_last  <= ops_last;
  --ops_ready <= not ops_valid or out_ready;
end Behavioral;