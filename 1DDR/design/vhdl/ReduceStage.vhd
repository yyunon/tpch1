
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

LIBRARY work;
USE work.ParallelPatterns_pkg.ALL;
USE work.Stream_pkg.ALL;
USE work.Tpch_pkg.ALL;

ENTITY ReduceStage IS
  GENERIC (
    FIXED_LEFT_INDEX : INTEGER;
    FIXED_RIGHT_INDEX : INTEGER;
    INDEX_WIDTH : INTEGER := 32;
    TAG_WIDTH : INTEGER := 1
  );
  PORT (
    clk : IN STD_LOGIC;
    reset : IN STD_LOGIC;

    in_valid : IN STD_LOGIC;
    in_dvalid : IN STD_LOGIC := '1';
    in_ready : OUT STD_LOGIC;
    in_last : IN STD_LOGIC;
    in_data : IN STD_LOGIC_VECTOR(63 DOWNTO 0);

    out_valid : OUT STD_LOGIC;
    out_ready : IN STD_LOGIC;
    out_data : OUT STD_LOGIC_VECTOR(63 DOWNTO 0)

  );
END ENTITY;

ARCHITECTURE Behavioral OF ReduceStage IS

  -- Accumulator output stream.
  SIGNAL acc_out_valid : STD_LOGIC;
  SIGNAL acc_out_ready : STD_LOGIC;
  SIGNAL acc_out_data : STD_LOGIC_VECTOR(63 DOWNTO 0);

  -- Accumulator input stream.
  SIGNAL acc_in_valid : STD_LOGIC;
  SIGNAL acc_in_ready : STD_LOGIC;
  SIGNAL acc_in_data : STD_LOGIC_VECTOR(63 DOWNTO 0);
  SIGNAL acc_in_dvalid : STD_LOGIC;

  -- CNTRL input stream.
  SIGNAL cntrl_s_in_valid : STD_LOGIC;
  SIGNAL cntrl_s_in_ready : STD_LOGIC;

  -- Operator input stream.
  SIGNAL op_s_in_valid : STD_LOGIC;
  SIGNAL op_s_in_ready : STD_LOGIC;
  -- Compensate counter -> sequencer path if the operation is low-latency.
  SIGNAL dly_in_valid : STD_LOGIC;
  SIGNAL dly_in_ready : STD_LOGIC;
  SIGNAL dly_in_data : STD_LOGIC_VECTOR(64 DOWNTO 0);

  SIGNAL dly_out_valid : STD_LOGIC;
  SIGNAL dly_out_ready : STD_LOGIC;
  SIGNAL dly_out_data : STD_LOGIC_VECTOR(64 DOWNTO 0);

  -- controller output slice
  SIGNAL cntrl_out_slice_in_valid : STD_LOGIC;
  SIGNAL cntrl_out_slice_in_ready : STD_LOGIC;
  SIGNAL cntrl_out_slice_in_data : STD_LOGIC_VECTOR(63 DOWNTO 0);

BEGIN

  reduce_cntrl : ReduceStream
  GENERIC MAP(
    DATA_WIDTH => 64,
    IN_DIMENSIONALITY => 1,
    LENGTH_WIDTH => INDEX_WIDTH
  )
  PORT MAP(
    clk => clk,
    reset => reset,
    in_valid => cntrl_s_in_valid,
    in_ready => cntrl_s_in_ready,
    in_last(0) => in_last,

    acc_init_value => (OTHERS => '0'),

    acc_out_valid => acc_out_valid,
    acc_out_ready => acc_out_ready,
    acc_out_data => acc_out_data,

    acc_in_valid => acc_in_valid,
    acc_in_ready => acc_in_ready,
    acc_in_data => acc_in_data,
    acc_in_dvalid => acc_in_dvalid,

    out_valid => cntrl_out_slice_in_valid,
    out_ready => cntrl_out_slice_in_ready,
    out_data => cntrl_out_slice_in_data
  );

  in_sync : StreamSync
  GENERIC MAP(
    NUM_INPUTS => 1,
    NUM_OUTPUTS => 2
  )
  PORT MAP(
    clk => clk,
    reset => reset,

    in_valid(0) => in_valid,
    in_ready(0) => in_ready,
    out_valid(0) => cntrl_s_in_valid,
    out_valid(1) => dly_in_valid,
    out_ready(0) => cntrl_s_in_ready,
    out_ready(1) => dly_in_ready

  );

  dly_in_data <= in_dvalid & in_data;

  dly : StreamSliceArray
  GENERIC MAP(
    DATA_WIDTH => 65,
    DEPTH => 10
  )
  PORT MAP(
    clk => clk,
    reset => reset,

    in_valid => dly_in_valid,
    in_ready => dly_in_ready,
    in_data => dly_in_data,

    out_valid => op_s_in_valid,
    out_ready => op_s_in_ready,
    out_data => dly_out_data

  );
  operator : SumOp
  GENERIC MAP(
    FIXED_LEFT_INDEX => FIXED_LEFT_INDEX,
    FIXED_RIGHT_INDEX => FIXED_RIGHT_INDEX,
    DATA_WIDTH => 64,
    DATA_TYPE => "FLOAT64"
  )
  PORT MAP(
    clk => clk,
    reset => reset,

    op1_valid => op_s_in_valid,
    op1_ready => op_s_in_ready,
    op1_dvalid => dly_out_data(64),
    op1_data => dly_out_data(63 DOWNTO 0),

    op2_valid => acc_out_valid,
    op2_ready => acc_out_ready,
    op2_data => acc_out_data,

    out_valid => acc_in_valid,
    out_ready => acc_in_ready,
    out_data => acc_in_data,
    out_dvalid => acc_in_dvalid

  );
  cntrl_out_slice : StreamSlice
  GENERIC MAP(
    DATA_WIDTH => 64
  )
  PORT MAP(
    clk => clk,
    reset => reset,
    in_valid => cntrl_out_slice_in_valid,
    in_ready => cntrl_out_slice_in_ready,
    in_data => cntrl_out_slice_in_data,
    out_valid => out_valid,
    out_ready => out_ready,
    out_data => out_data
  );

END Behavioral;