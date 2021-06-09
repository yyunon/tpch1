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

--library ieee_proposed;
--use ieee_proposed.fixed_pkg.all;

library work;
use work.Stream_pkg.all;
use work.ParallelPatterns_pkg.all;
use work.Tpch_pkg.all;
use work.fixed_generic_pkg_mod.all;

entity MergeOp is
  generic (

    -- Width of the stream data vector.
    FIXED_LEFT_INDEX  : integer;
    FIXED_RIGHT_INDEX : integer;
    DATA_WIDTH        : natural;
    NUM_INPUTS        : natural := 2;
    NUM_OUTPUTS       : natural := 1;
    INPUT_MIN_DEPTH   : natural;
    OUTPUT_MIN_DEPTH  : natural;
    OPERATOR          : string := ""

  );
  port (

    -- Rising-edge sensitive clock.
    clk           : in std_logic;

    -- Active-high synchronous reset.
    reset         : in std_logic;

    --OP1 Input stream.
    inputs_valid  : in std_logic_vector(NUM_INPUTS - 1 downto 0);
    inputs_last   : in std_logic_vector(NUM_INPUTS - 1 downto 0);
    inputs_dvalid : in std_logic_vector(NUM_INPUTS - 1 downto 0);
    inputs_ready  : out std_logic_vector(NUM_INPUTS - 1 downto 0);
    inputs_data   : in TUPLE_DATA_64(NUM_INPUTS - 1 downto 0);

    -- Output stream.
    out_valid     : out std_logic;
    out_last      : out std_logic;
    out_ready     : in std_logic;
    out_data      : out std_logic_vector(DATA_WIDTH - 1 downto 0);
    out_dvalid    : out std_logic
  );
end MergeOp;

architecture Behavioral of MergeOp is

  signal out_s_valid           : std_logic;
  signal out_s_ready           : std_logic;

  signal buf_valid             : std_logic_vector(NUM_INPUTS - 1 downto 0);
  signal buf_dvalid            : std_logic_vector(NUM_INPUTS - 1 downto 0);
  signal buf_last              : std_logic_vector(NUM_INPUTS - 1 downto 0);
  signal buf_ready             : std_logic_vector(NUM_INPUTS - 1 downto 0);
  signal buf_data              : TUPLE_DATA_64(NUM_INPUTS - 1 downto 0);

  signal buf_valid_s           : std_logic;
  signal buf_dvalid_s          : std_logic;
  signal buf_last_s            : std_logic;
  signal buf_ready_s           : std_logic;
  signal buf_data_s            : std_logic_vector(NUM_INPUTS * DATA_WIDTH - 1 downto 0);

  --OP1 Input stream.
  signal op1_valid             : std_logic;
  signal op1_last              : std_logic;
  signal op1_dvalid            : std_logic := '1';
  signal op1_data              : std_logic_vector(DATA_WIDTH - 1 downto 0);
  signal op1_ready             : std_logic;

  --OP2 Input stream.
  signal op2_valid             : std_logic;
  signal op2_last              : std_logic;
  signal op2_dvalid            : std_logic := '1';
  signal op2_ready             : std_logic;
  signal op2_data              : std_logic_vector(DATA_WIDTH - 1 downto 0);

  --OP3 Input stream.
  signal op3_valid             : std_logic;
  signal op3_last              : std_logic;
  signal op3_dvalid            : std_logic := '1';
  signal op3_ready             : std_logic;
  signal op3_data              : std_logic_vector(DATA_WIDTH - 1 downto 0);

  signal buf_op2_valid         : std_logic;
  signal buf_op2_dvalid        : std_logic;
  signal buf_op2_last          : std_logic := '0';
  signal buf_op2_ready         : std_logic;
  signal buf_op2_data          : std_logic_vector(DATA_WIDTH - 1 downto 0);

  signal ops_valid             : std_logic;
  signal ops_dvalid            : std_logic;
  signal ops_last              : std_logic := '0';
  signal ops_ready             : std_logic;
  signal ops_data              : std_logic_vector(DATA_WIDTH - 1 downto 0);
  signal result                : std_logic_vector(DATA_WIDTH - 1 downto 0);

  signal sync_streams_in_valid : std_logic_vector(NUM_INPUTS - 1 downto 0);
  signal sync_streams_in_ready : std_logic_vector(NUM_INPUTS - 1 downto 0);

begin

  input_buffer_generator :
  for g in 0 to NUM_INPUTS - 1 generate
    in_buf : StreamBuffer
    generic map(
      DATA_WIDTH => DATA_WIDTH + 2,
      MIN_DEPTH  => INPUT_MIN_DEPTH
    )
    port map(
      clk                   => clk,
      reset                 => reset,
      in_valid              => inputs_valid(g),
      in_ready              => inputs_ready(g),
      in_data(65)           => inputs_last(g),
      in_data(64)           => inputs_dvalid(g),
      in_data(63 downto 0)  => inputs_data(g),
      out_valid             => buf_valid(g),
      out_ready             => buf_ready(g),
      out_data(65)          => buf_last(g),
      out_data(64)          => buf_dvalid(g),
      out_data(63 downto 0) => buf_data(g)
    );
  end generate;

  out_buf : StreamBuffer
  generic map(
    DATA_WIDTH => DATA_WIDTH + 2,
    MIN_DEPTH  => OUTPUT_MIN_DEPTH
  )
  port map(
    clk                   => clk,
    reset                 => reset,
    in_valid              => out_s_valid,
    in_ready              => out_s_ready,
    in_data(65)           => ops_last,
    in_data(64)           => ops_dvalid,
    in_data(63 downto 0)  => ops_data,
    out_valid             => out_valid,
    out_ready             => out_ready,
    out_data(65)          => out_last,
    out_data(64)          => out_dvalid,
    out_data(63 downto 0) => out_data
  );

  sync_streams : StreamSync
  generic map(
    NUM_INPUTS  => NUM_INPUTS,
    NUM_OUTPUTS => 1
  )
  port map(
    clk          => clk,
    reset        => reset,

    in_valid     => buf_valid,
    in_ready     => buf_ready,

    out_valid(0) => ops_valid,
    out_ready(0) => ops_ready
  );
  buf_ready_s <= not buf_valid_s or out_s_ready;

  discount_fixed_process :
  if OPERATOR = "DISCOUNT" generate
    sync_out_buf : StreamBuffer
    generic map(
      MIN_DEPTH  => 4,
      DATA_WIDTH => NUM_INPUTS * DATA_WIDTH + 2
    )
    port map(
      clk                                            => clk,
      reset                                          => reset,
      in_valid                                       => ops_valid,
      in_ready                                       => ops_ready,
      in_data(NUM_INPUTS * DATA_WIDTH + 1)           => buf_last(1) and buf_last(0),
      in_data(NUM_INPUTS * DATA_WIDTH)               => buf_dvalid(1) and buf_dvalid(0),
      in_data(NUM_INPUTS * DATA_WIDTH - 1 downto 0)  => buf_data(1) & buf_data(0),
      out_valid                                      => buf_valid_s,
      out_ready                                      => buf_ready_s,
      out_data(NUM_INPUTS * DATA_WIDTH + 1)          => buf_last_s,
      out_data(NUM_INPUTS * DATA_WIDTH)              => buf_dvalid_s,
      out_data(NUM_INPUTS * DATA_WIDTH - 1 downto 0) => buf_data_s
    );
    op1_data <= buf_data_s(DATA_WIDTH - 1 downto 0);
    op2_data <= buf_data_s(2 * DATA_WIDTH - 1 downto DATA_WIDTH);
    mult_process :
    process (op1_data, op2_data, ops_valid, out_s_ready) is
      variable temp_buffer_1 : sfixed(fixed_left_index downto fixed_right_index);
      variable temp_buffer_2 : sfixed(fixed_left_index downto fixed_right_index);
      variable temp_buffer_3 : sfixed(fixed_left_index downto fixed_right_index);
      variable temp_res      : sfixed(2 * fixed_left_index + 1 downto 2 * fixed_right_index);
    begin
      temp_buffer_1 := to_sfixed(op1_data, temp_buffer_1'high, temp_buffer_1'low);
      temp_buffer_2 := to_sfixed(op2_data, temp_buffer_2'high, temp_buffer_2'low);
      temp_res      := resize(arg => (to_sfixed(1, 64) - temp_buffer_1), left_index => fixed_left_index, right_index => fixed_right_index, round_style => fixed_round_style, overflow_style => fixed_overflow_style) * temp_buffer_2;
      ops_data <= to_slv(resize(arg => temp_res, left_index => fixed_left_index, right_index => fixed_right_index, round_style => fixed_round_style, overflow_style => fixed_overflow_style));
    end process;
    ops_dvalid  <= buf_dvalid_s;
    ops_last    <= buf_last_s;
    out_s_valid <= buf_valid_s;
  end generate;

  charge_fixed_process :
  if OPERATOR = "CHARGE" generate
    sync_out_buf : StreamBuffer
    generic map(
      MIN_DEPTH  => 4,
      DATA_WIDTH => NUM_INPUTS * DATA_WIDTH + 2
    )
    port map(
      clk                                            => clk,
      reset                                          => reset,
      in_valid                                       => ops_valid,
      in_ready                                       => ops_ready,
      in_data(NUM_INPUTS * DATA_WIDTH + 1)           => buf_last(2) and buf_last(1) and buf_last(0),
      in_data(NUM_INPUTS * DATA_WIDTH)               => buf_dvalid(2) and buf_dvalid(1) and buf_dvalid(0),
      in_data(NUM_INPUTS * DATA_WIDTH - 1 downto 0)  => buf_data(2) & buf_data(1) & buf_data(0),
      out_valid                                      => buf_valid_s,
      out_ready                                      => buf_ready_s,
      out_data(NUM_INPUTS * DATA_WIDTH + 1)          => buf_last_s,
      out_data(NUM_INPUTS * DATA_WIDTH)              => buf_dvalid_s,
      out_data(NUM_INPUTS * DATA_WIDTH - 1 downto 0) => buf_data_s
    );
    op1_data <= buf_data_s(DATA_WIDTH - 1 downto 0);
    op2_data <= buf_data_s(2 * DATA_WIDTH - 1 downto DATA_WIDTH);
    op3_data <= buf_data_s(3 * DATA_WIDTH - 1 downto 2 * DATA_WIDTH);

    mult_process :
    process (op1_data, op2_data, op3_data, ops_valid, out_s_ready) is
      variable temp_buffer_1 : sfixed(fixed_left_index downto fixed_right_index);
      variable temp_buffer_2 : sfixed(fixed_left_index downto fixed_right_index);
      variable temp_buffer_3 : sfixed(fixed_left_index downto fixed_right_index);
      variable temp_buffer_4 : sfixed(fixed_left_index downto fixed_right_index);
      variable temp_res      : sfixed(2 * fixed_left_index + 1 downto 2 * fixed_right_index);
      variable temp_res_2    : sfixed(2 * fixed_left_index + 1 downto 2 * fixed_right_index);
    begin
      temp_buffer_1 := to_sfixed(op1_data, temp_buffer_1'high, temp_buffer_1'low);
      temp_buffer_2 := to_sfixed(op2_data, temp_buffer_2'high, temp_buffer_2'low);
      temp_buffer_3 := to_sfixed(op3_data, temp_buffer_3'high, temp_buffer_3'low);
      temp_res      := resize(arg => (to_sfixed(1, 64) + temp_buffer_1), left_index => fixed_left_index, right_index => fixed_right_index, round_style => fixed_round_style, overflow_style => fixed_overflow_style) * resize(arg => (to_sfixed(1, 64) - temp_buffer_2), left_index => fixed_left_index, right_index => fixed_right_index, round_style => fixed_round_style, overflow_style => fixed_overflow_style);
      temp_buffer_4 := resize(arg => temp_res, left_index => fixed_left_index, right_index => fixed_right_index, round_style => fixed_round_style, overflow_style => fixed_overflow_style);
      temp_res_2    := temp_buffer_4 * temp_buffer_3;
      ops_data <= to_slv(resize(arg => temp_res_2, left_index => fixed_left_index, right_index => fixed_right_index, round_style => fixed_round_style, overflow_style => fixed_overflow_style));
    end process;
    ops_dvalid  <= buf_dvalid_s;
    ops_last    <= buf_last_s;
    out_s_valid <= buf_valid_s;

  end generate;

  revenue_fixed_process :
  if OPERATOR = "REVENUE" generate
    mult_process :
    process (op1_data, op2_data, ops_valid, out_s_ready) is
      variable temp_buffer_1 : sfixed(FIXED_LEFT_INDEX downto FIXED_RIGHT_INDEX);
      variable temp_buffer_2 : sfixed(FIXED_LEFT_INDEX downto FIXED_RIGHT_INDEX);
      variable temp_res      : sfixed(2 * FIXED_LEFT_INDEX + 1 downto 2 * FIXED_RIGHT_INDEX);
    begin
      out_s_valid <= '0';
      --ops_ready   <= '0';
      ops_dvalid  <= '0';
      --ops_last_s <= '0';
      if ops_valid = '1' and out_s_ready = '1' then
        out_s_valid <= '1';
        --ops_ready   <= '1';
        temp_buffer_1 := to_sfixed(op1_data, temp_buffer_1'high, temp_buffer_1'low);
        temp_buffer_2 := to_sfixed(op2_data, temp_buffer_2'high, temp_buffer_2'low);
        temp_res      := temp_buffer_1 * temp_buffer_2;
        ops_data <= to_slv(resize(arg => temp_res, left_index => FIXED_LEFT_INDEX, right_index => FIXED_RIGHT_INDEX, round_style => fixed_round_style, overflow_style => fixed_overflow_style));
      end if;
    end process;
    ops_dvalid <= op1_dvalid and op2_dvalid;
    ops_last   <= op1_last and op2_last;
  end generate;

end Behavioral;