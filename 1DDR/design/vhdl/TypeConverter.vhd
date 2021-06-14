-- This code is directly taken from vhlib but async read is implemented
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;
use ieee.numeric_std.all;

library work;
use work.Stream_pkg.all;
use work.ParallelPatterns_pkg.all;
entity TypeConverter is
  generic (

    FIXED_LEFT_INDEX  : integer;
    FIXED_RIGHT_INDEX : integer;
    DATA_WIDTH        : natural;
    INPUT_MIN_DEPTH   : natural;
    OUTPUT_MIN_DEPTH  : natural;
    CONVERTER_IP      : string; -- := "flopoco" := "xilinx_ip";
    CONVERTER_TYPE    : string  -- := "Float2Fix" := "Fix2Float";

  );
  port (
    clk        : in std_logic;
    enable     : in std_logic;
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
end TypeConverter;

architecture Behavioral of TypeConverter is
  -- Floating  point IP used by xilinx
  component floating_point_1
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
  component floating_point_0_2
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
  --component InputIEEE_11_52_to_11_52 is
  --  port (
  --    clk, rst : in std_logic;
  --    X        : in std_logic_vector(63 downto 0);
  --    R        : out std_logic_vector(11 + 52 + 2 downto 0));
  --end component;
  --component FP2Fix_11_52M_32_31_S_NT_F400_uid2 is
  --  port (
  --    clk, rst : in std_logic;
  --    I        : in std_logic_vector(11 + 52 + 2 downto 0);
  --    O        : out std_logic_vector(63 downto 0));
  --end component;
  --
  signal conv_data_valid  : std_logic                     := '0';
  signal conv_data_ready  : std_logic                     := '0';
  signal conv_data_dvalid : std_logic                     := '0';
  signal conv_data_last   : std_logic                     := '0';
  signal conv_data        : std_logic_vector(63 downto 0) := (others => '0');

  signal ops_valid        : std_logic;
  signal ops_dvalid       : std_logic;
  signal ops_ready        : std_logic;
  signal ops_last         : std_logic;
  signal ops_data         : std_logic_vector(DATA_WIDTH - 1 downto 0);

  signal fixtofloat_valid : std_logic;
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

  xilinx_converterfpfx :
  if CONVERTER_TYPE = "Float2Fix" and CONVERTER_IP = "xilinx" generate
    data_converter : floating_point_0_2
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
  xilinx_converterfxfp :
  if CONVERTER_TYPE = "Fix2Float" and CONVERTER_IP = "xilinx" generate
    data_converter : floating_point_1
    port map(
      aclk                   => clk,
      s_axis_a_tvalid        => ops_valid,
      s_axis_a_tready        => ops_ready,
      s_axis_a_tdata         => ops_data,
      s_axis_a_tuser(0)      => ops_dvalid,
      s_axis_a_tlast         => ops_last,
      m_axis_result_tvalid   => fixtofloat_valid,
      m_axis_result_tready   => conv_data_ready,
      m_axis_result_tdata    => conv_data,
      m_axis_result_tuser(0) => conv_data_dvalid,
      m_axis_result_tlast    => conv_data_last
    );
    conv_data_valid <= fixtofloat_valid and enable;-- The converter will return valid on even though it is not. To solve this we also wait for enable signal
  end generate;

end Behavioral;