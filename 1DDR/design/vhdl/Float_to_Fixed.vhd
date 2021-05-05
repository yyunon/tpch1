-- This code is directly taken from vhlib but async read is implemented
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;
use ieee.numeric_std.all;

--library ieee_proposed;
--use ieee_proposed.fixed_pkg.all;

library work;
use work.Stream_pkg.all;
use work.ParallelPatterns_pkg.all;
--use work.fixed_generic_pkg_mod.all;
entity Float_to_Fixed is
  generic (

    FIXED_LEFT_INDEX  : integer;
    FIXED_RIGHT_INDEX : integer;
    DATA_WIDTH        : natural;
    INPUT_MIN_DEPTH   : natural;
    OUTPUT_MIN_DEPTH  : natural;
    CONVERTER_TYPE    : string -- := "flopoco" := "xilinx_ip";

  );
  port (
    clk        : in std_logic;
    reset      : in std_logic;

    in_valid   : in std_logic;
    in_dvalid  : in std_logic := '1';
    in_ready   : out std_logic;
    in_last    : in std_logic;
    in_data    : in std_logic_vector(DATA_WIDTH - 1 downto 0);

    out_valid  : out std_logic;
    out_dvalid : out std_logic := '1';
    out_ready  : in std_logic;
    out_last   : out std_logic;
    out_data   : out std_logic_vector(DATA_WIDTH - 1 downto 0)

  );
end Float_to_Fixed;

architecture Behavioral of Float_to_Fixed is
  -- Floating  point IP used by xilinx
  component floating_point_0
    port (
      aclk                 : in std_logic;
      s_axis_a_tvalid      : in std_logic;
      s_axis_a_tready      : out std_logic;
      s_axis_a_tdata       : in std_logic_vector(63 downto 0);
      s_axis_a_tuser       : in std_logic_vector(0 downto 0);
      s_axis_a_tlast       : in std_logic;
      m_axis_result_tvalid : out std_logic;
      m_axis_result_tready : in std_logic;
      m_axis_result_tdata  : out std_logic_vector(63 downto 0);
      m_axis_result_tuser  : out std_logic_vector(0 downto 0);
      m_axis_result_tlast  : out std_logic
    );
  end component;
  --
  -- Flopoco functions 
  component InputIEEE_11_52_to_11_52 is
    port (
      clk, rst : in std_logic;
      X        : in std_logic_vector(63 downto 0);
      R        : out std_logic_vector(11 + 52 + 2 downto 0));
  end component;
  component FP2Fix_11_52M_32_31_S_NT_F400_uid2 is
    port (
      clk, rst : in std_logic;
      I        : in std_logic_vector(11 + 52 + 2 downto 0);
      O        : out std_logic_vector(63 downto 0));
  end component;
  --
  signal conv_data_valid                                                                     : std_logic                     := '0';
  signal conv_data_ready                                                                     : std_logic                     := '0';
  signal conv_data_dvalid                                                                    : std_logic                     := '0';
  signal conv_data_last                                                                      : std_logic                     := '0';
  signal conv_data                                                                           : std_logic_vector(63 downto 0) := (others => '0');
  signal result_data                                                                         : std_logic_vector(63 downto 0) := (others => '0'); --MUX to the output of converter.
  signal float_type                                                                          : std_logic_vector(1 downto 0);--MUX to the output of converter.

  signal ops_valid                                                                           : std_logic;
  signal ops_dvalid                                                                          : std_logic;
  signal ops_ready                                                                           : std_logic;
  signal ops_last                                                                            : std_logic;
  signal ops_data                                                                            : std_logic_vector(DATA_WIDTH - 1 downto 0);

  -- Pipeline signals
  signal data, data_d1, data_d2, data_d3, data_d4, data_d5, data_d6, data_d7                 : std_logic_vector(11 + 52 + 2 downto 0);
  signal ready, ready_d1, ready_d2, ready_d3, ready_d4, ready_d5, ready_d6, ready_d7         : std_logic;
  signal last, last_d1, last_d2, last_d3, last_d4, last_d5, last_d6, last_d7                 : std_logic;
  signal dvalid, dvalid_d1, dvalid_d2, dvalid_d3, dvalid_d4, dvalid_d5, dvalid_d6, dvalid_d7 : std_logic;
  signal valid, valid_d1, valid_d2, valid_d3, valid_d4, valid_d5, valid_d6, valid_d7         : std_logic;

  constant ZERO                                                                              : std_logic_vector(DATA_WIDTH - 1 downto 0) := (others => '0');

begin

  op_in_sync : StreamBuffer
  generic map(
    DATA_WIDTH => DATA_WIDTH + 2,
    MIN_DEPTH  => INPUT_MIN_DEPTH
  )
  port map(
    clk                   => clk,
    reset                 => reset,

    in_valid              => in_valid,
    in_ready              => in_ready,
    in_data(65)           => in_last,
    in_data(64)           => in_dvalid,
    in_data(63 downto 0)  => in_data,

    out_valid             => ops_valid,
    out_ready             => ops_ready,
    out_data(65)          => ops_last,
    out_data(64)          => ops_dvalid,
    out_data(63 downto 0) => ops_data
  );

  out_buf : StreamBuffer
  generic map(
    DATA_WIDTH => DATA_WIDTH + 2,
    MIN_DEPTH  => OUTPUT_MIN_DEPTH
  )
  port map(
    clk                   => clk,
    reset                 => reset,
    in_valid              => conv_data_valid,
    in_ready              => conv_data_ready,
    in_data(65)           => conv_data_last,
    in_data(64)           => conv_data_dvalid,
    in_data(63 downto 0)  => conv_data,

    out_valid             => out_valid,
    out_ready             => out_ready,
    out_data(65)          => out_last,
    out_data(64)          => out_dvalid,
    out_data(63 downto 0) => out_data
  );

  none_converter :
  if CONVERTER_TYPE = "none" generate
    conv_data        <= ops_data;
    conv_data_last   <= ops_last;
    conv_data_dvalid <= ops_dvalid;
    conv_data_valid  <= ops_valid;
    ops_ready        <= conv_data_ready;
  end generate;

  xilinx_converter :
  if CONVERTER_TYPE = "xilinx" generate
    data_converter : floating_point_0
    port map(
      aclk                   => clk,
      s_axis_a_tvalid        => ops_valid,
      s_axis_a_tready        => ops_ready,
      s_axis_a_tdata         => ops_data,
      s_axis_a_tuser(0)      => ops_dvalid,
      s_axis_a_tlast         => ops_last,
      m_axis_result_tvalid   => conv_data_valid,
      m_axis_result_tready   => conv_data_ready,
      m_axis_result_tdata    => conv_data,
      m_axis_result_tuser(0) => conv_data_dvalid,
      m_axis_result_tlast    => conv_data_last
    );
  end generate;

end Behavioral;