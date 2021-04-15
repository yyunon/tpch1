-- This source illustrates processing unit for each end-to-end query.
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;
use ieee.numeric_std.all;

library work;
use work.Stream_pkg.all;
use work.ParallelPatterns_pkg.all;
use work.Tpch_pkg.all;

entity PU is
  generic (
    FIXED_LEFT_INDEX  : integer;
    FIXED_RIGHT_INDEX : integer;
    DATA_WIDTH        : natural;
    INDEX_WIDTH       : integer;
    CONVERTERS        : string := "";
    ILA               : string := ""

  );
  port (
    clk                         : in std_logic;
    reset                       : in std_logic;
    l_quantity_valid            : in std_logic;
    l_quantity_ready            : out std_logic;
    l_quantity_dvalid           : in std_logic;
    l_quantity_last             : in std_logic;
    l_quantity                  : in std_logic_vector(63 downto 0);

    l_extendedprice_valid       : in std_logic;
    l_extendedprice_ready       : out std_logic;
    l_extendedprice_dvalid      : in std_logic;
    l_extendedprice_last        : in std_logic;
    l_extendedprice             : in std_logic_vector(63 downto 0);

    l_discount_valid            : in std_logic;
    l_discount_ready            : out std_logic;
    l_discount_dvalid           : in std_logic;
    l_discount_last             : in std_logic;
    l_discount                  : in std_logic_vector(63 downto 0);

    l_tax_valid                 : in std_logic;
    l_tax_ready                 : out std_logic;
    l_tax_dvalid                : in std_logic;
    l_tax_last                  : in std_logic;
    l_tax                       : in std_logic_vector(63 downto 0);

    l_returnflag_valid          : in std_logic;
    l_returnflag_ready          : out std_logic;
    l_returnflag_dvalid         : in std_logic;
    l_returnflag_last           : in std_logic;
    l_returnflag_length         : in std_logic_vector(31 downto 0);
    l_returnflag_count          : in std_logic_vector(0 downto 0);
    l_returnflag_chars_valid    : in std_logic;
    l_returnflag_chars_ready    : out std_logic;
    l_returnflag_chars_dvalid   : in std_logic;
    l_returnflag_chars_last     : in std_logic;
    l_returnflag_chars          : in std_logic_vector(7 downto 0);
    l_returnflag_chars_count    : in std_logic_vector(0 downto 0);

    l_linestatus_valid          : in std_logic;
    l_linestatus_ready          : out std_logic;
    l_linestatus_dvalid         : in std_logic;
    l_linestatus_last           : in std_logic;
    l_linestatus_length         : in std_logic_vector(31 downto 0);
    l_linestatus_count          : in std_logic_vector(0 downto 0);
    l_linestatus_chars_valid    : in std_logic;
    l_linestatus_chars_ready    : out std_logic;
    l_linestatus_chars_dvalid   : in std_logic;
    l_linestatus_chars_last     : in std_logic;
    l_linestatus_chars          : in std_logic_vector(7 downto 0);
    l_linestatus_chars_count    : in std_logic_vector(0 downto 0);

    l_shipdate_valid            : in std_logic;
    l_shipdate_ready            : out std_logic;
    l_shipdate_dvalid           : in std_logic;
    l_shipdate_last             : in std_logic;
    l_shipdate                  : in std_logic_vector(31 downto 0);
    l_returnflag_o_valid        : out std_logic;
    l_returnflag_o_ready        : in std_logic;
    l_returnflag_o_dvalid       : out std_logic;
    l_returnflag_o_last         : out std_logic;
    l_returnflag_o_length       : out std_logic_vector(31 downto 0);
    l_returnflag_o_count        : out std_logic_vector(0 downto 0);
    l_returnflag_o_chars_valid  : out std_logic;
    l_returnflag_o_chars_ready  : in std_logic;
    l_returnflag_o_chars_dvalid : out std_logic;
    l_returnflag_o_chars_last   : out std_logic;
    l_returnflag_o_chars        : out std_logic_vector(7 downto 0);
    l_returnflag_o_chars_count  : out std_logic_vector(0 downto 0);
    l_linestatus_o_valid        : out std_logic;
    l_linestatus_o_ready        : in std_logic;
    l_linestatus_o_dvalid       : out std_logic;
    l_linestatus_o_last         : out std_logic;
    l_linestatus_o_length       : out std_logic_vector(31 downto 0);
    l_linestatus_o_count        : out std_logic_vector(0 downto 0);
    l_linestatus_o_chars_valid  : out std_logic;
    l_linestatus_o_chars_ready  : in std_logic;
    l_linestatus_o_chars_dvalid : out std_logic;
    l_linestatus_o_chars_last   : out std_logic;
    l_linestatus_o_chars        : out std_logic_vector(7 downto 0);
    l_linestatus_o_chars_count  : out std_logic_vector(0 downto 0);
    l_sum_qty_valid             : out std_logic;
    l_sum_qty_ready             : in std_logic;
    l_sum_qty_dvalid            : out std_logic;
    l_sum_qty_last              : out std_logic;
    l_sum_qty                   : out std_logic_vector(63 downto 0);
    l_sum_base_price_valid      : out std_logic;
    l_sum_base_price_ready      : in std_logic;
    l_sum_base_price_dvalid     : out std_logic;
    l_sum_base_price_last       : out std_logic;
    l_sum_base_price            : out std_logic_vector(63 downto 0);
    l_sum_disc_price_valid      : out std_logic;
    l_sum_disc_price_ready      : in std_logic;
    l_sum_disc_price_dvalid     : out std_logic;
    l_sum_disc_price_last       : out std_logic;
    l_sum_disc_price            : out std_logic_vector(63 downto 0);
    l_sum_charge_valid          : out std_logic;
    l_sum_charge_ready          : in std_logic;
    l_sum_charge_dvalid         : out std_logic;
    l_sum_charge_last           : out std_logic;
    l_sum_charge                : out std_logic_vector(63 downto 0);
    l_avg_qty_valid             : out std_logic;
    l_avg_qty_ready             : in std_logic;
    l_avg_qty_dvalid            : out std_logic;
    l_avg_qty_last              : out std_logic;
    l_avg_qty                   : out std_logic_vector(63 downto 0);
    l_avg_price_valid           : out std_logic;
    l_avg_price_ready           : in std_logic;
    l_avg_price_dvalid          : out std_logic;
    l_avg_price_last            : out std_logic;
    l_avg_price                 : out std_logic_vector(63 downto 0);
    l_avg_disc_valid            : out std_logic;
    l_avg_disc_ready            : in std_logic;
    l_avg_disc_dvalid           : out std_logic;
    l_avg_disc_last             : out std_logic;
    l_avg_disc                  : out std_logic_vector(63 downto 0);
    l_count_order_valid         : out std_logic;
    l_count_order_ready         : in std_logic;
    l_count_order_dvalid        : out std_logic;
    l_count_order_last          : out std_logic;
    l_count_order               : out std_logic_vector(63 downto 0)
  );
end PU;

architecture Behavioral of PU is
  -- Constants
  -- Filter out buffers, goes in after sync.
  constant FILTER_OUT_DEPTH                  : integer                       := 0;

  -- Merger inout buffers 
  constant MERGER_IN_DEPTH                   : integer                       := 8;
  constant MERGER_OUT_DEPTH                  : integer                       := 0;

  -- Converter inout buffers 
  constant EXTENDEDPRICE_CONVERTER_IN_DEPTH  : integer                       := 2;
  constant EXTENDEDPRICE_CONVERTER_OUT_DEPTH : integer                       := 2;
  constant DISCOUNT_CONVERTER_IN_DEPTH       : integer                       := 2;
  constant DISCOUNT_CONVERTER_OUT_DEPTH      : integer                       := 2;
  constant QUANTITY_CONVERTER_IN_DEPTH       : integer                       := 2;
  constant QUANTITY_CONVERTER_OUT_DEPTH      : integer                       := 2;

  -- Filter in out buffers2
  constant BETWEEN_FILTER_IN_DEPTH           : integer                       := 0;
  constant BETWEEN_FILTER_OUT_DEPTH          : integer                       := 2;
  constant LESSTHAN_FILTER_IN_DEPTH          : integer                       := 0;
  constant LESSTHAN_FILTER_OUT_DEPTH         : integer                       := 2;
  constant COMPARE_FILTER_IN_DEPTH           : integer                       := 2; --DATE
  constant COMPARE_FILTER_OUT_DEPTH          : integer                       := 2; --DATE

  -- Outputs of converters
  signal conv_l_discount_valid               : std_logic                     := '0';
  signal conv_l_discount_ready               : std_logic                     := '0';
  signal conv_l_discount_dvalid              : std_logic                     := '0';
  signal conv_l_discount_last                : std_logic                     := '0';
  signal conv_l_discount                     : std_logic_vector(63 downto 0) := (others => '0');

  signal conv_l_extendedprice_valid          : std_logic                     := '0';
  signal conv_l_extendedprice_ready          : std_logic                     := '0';
  signal conv_l_extendedprice_dvalid         : std_logic                     := '0';
  signal conv_l_extendedprice_last           : std_logic                     := '0';
  signal conv_l_extendedprice                : std_logic_vector(63 downto 0) := (others => '0');

  signal conv_l_quantity_valid               : std_logic                     := '0';
  signal conv_l_quantity_ready               : std_logic                     := '0';
  signal conv_l_quantity_dvalid              : std_logic                     := '0';
  signal conv_l_quantity_last                : std_logic                     := '0';
  signal conv_l_quantity                     : std_logic_vector(63 downto 0) := (others => '0');

  signal dly_l_shipdate_valid                : std_logic                     := '0';
  signal dly_l_shipdate_ready                : std_logic                     := '0';
  signal dly_l_shipdate_dvalid               : std_logic                     := '0';
  signal dly_l_shipdate_last                 : std_logic                     := '0';
  signal dly_l_shipdate                      : std_logic_vector(31 downto 0) := (others => '0');
  --
  -- Discount synchronize signals
  signal between_in_valid                    : std_logic                     := '0';
  signal between_in_ready                    : std_logic                     := '0';

  signal merge_discount_in_valid             : std_logic                     := '0';
  signal merge_discount_in_ready             : std_logic                     := '0';
  --
  -- Sync inputs 
  signal sync_1_in_valid                     : std_logic                     := '0';
  signal sync_1_in_ready                     : std_logic                     := '0';
  signal sync_2_in_valid                     : std_logic                     := '0';
  signal sync_2_in_ready                     : std_logic                     := '0';
  signal sync_3_in_valid                     : std_logic                     := '0';
  signal sync_3_in_ready                     : std_logic                     := '0';
  --
  -- Sync inputs 
  signal sync_1_valid                        : std_logic                     := '0';
  signal sync_1_ready                        : std_logic                     := '0';
  signal sync_1_data                         : std_logic;
  signal sync_2_valid                        : std_logic := '0';
  signal sync_2_ready                        : std_logic := '0';
  signal sync_2_data                         : std_logic;
  signal sync_3_valid                        : std_logic := '0';
  signal sync_3_ready                        : std_logic := '0';
  signal sync_3_data                         : std_logic;
  --
  -- Multiplied vals
  signal reduce_in_ready                     : std_logic := '0';
  signal reduce_in_valid                     : std_logic := '0';
  signal reduce_in_last                      : std_logic;
  signal reduce_in_dvalid                    : std_logic;
  signal reduce_in_data                      : std_logic_vector(63 downto 0);
  --
  -- Output of filter stage
  signal filter_out_valid                    : std_logic := '0';
  signal filter_out_ready                    : std_logic := '0';
  signal filter_out_last                     : std_logic;
  signal filter_out_strb                     : std_logic;
  -- signal filter_out_strb        : std_logic;
  -- Output of filter stage buffer
  signal buf_filter_out_valid                : std_logic := '0';
  signal buf_filter_out_ready                : std_logic := '0';
  signal buf_filter_out_last                 : std_logic;
  signal buf_filter_out_strb                 : std_logic;
  -- signal filter_out_strb        : std_logic;
  --
  constant ZERO                              : std_logic_vector(3 downto 0) := (others => '0');
  component ila_1
    port (
      clk     : in std_logic;
      probe0  : in std_logic_vector(0 downto 0);
      probe1  : in std_logic_vector(63 downto 0);
      probe2  : in std_logic_vector(1 downto 0);
      probe3  : in std_logic_vector(0 downto 0);
      probe4  : in std_logic_vector(0 downto 0);
      probe5  : in std_logic_vector(63 downto 0);
      probe6  : in std_logic_vector(0 downto 0);
      probe7  : in std_logic_vector(0 downto 0);
      probe8  : in std_logic_vector(0 downto 0);
      probe9  : in std_logic_vector(0 downto 0);
      probe10 : in std_logic_vector(511 downto 0);
      probe11 : in std_logic_vector(0 downto 0);
      probe12 : in std_logic_vector(0 downto 0);
      probe13 : in std_logic_vector(1 downto 0);
      probe14 : in std_logic_vector(511 downto 0);
      probe15 : in std_logic_vector(63 downto 0);
      probe16 : in std_logic_vector(0 downto 0);
      probe17 : in std_logic_vector(2 downto 0);
      probe18 : in std_logic_vector(2 downto 0);
      probe19 : in std_logic_vector(4 downto 0);
      probe20 : in std_logic_vector(4 downto 0);
      probe21 : in std_logic_vector(7 downto 0);
      probe22 : in std_logic_vector(0 downto 0);
      probe23 : in std_logic_vector(2 downto 0);
      probe24 : in std_logic_vector(1 downto 0);
      probe25 : in std_logic_vector(4 downto 0);
      probe26 : in std_logic_vector(0 downto 0);
      probe27 : in std_logic_vector(7 downto 0);
      probe28 : in std_logic_vector(2 downto 0);
      probe29 : in std_logic_vector(1 downto 0);
      probe30 : in std_logic_vector(0 downto 0);
      probe31 : in std_logic_vector(3 downto 0);
      probe32 : in std_logic_vector(3 downto 0);
      probe33 : in std_logic_vector(3 downto 0);
      probe34 : in std_logic_vector(3 downto 0);
      probe35 : in std_logic_vector(0 downto 0);
      probe36 : in std_logic_vector(3 downto 0);
      probe37 : in std_logic_vector(3 downto 0);
      probe38 : in std_logic_vector(4 downto 0);
      probe39 : in std_logic_vector(0 downto 0);
      probe40 : in std_logic_vector(0 downto 0);
      probe41 : in std_logic_vector(0 downto 0);
      probe42 : in std_logic_vector(0 downto 0);
      probe43 : in std_logic_vector(0 downto 0)
    );
  end component;
begin
  --Integrated Logic Analyzers (ILA): This module works 
  --for only one of the instances. 
  logic_analyzer_gen :
  if ILA = "TRUE" generate
    --CL_ILA_0 : ila_1
    --PORT MAP (
    --      clk                   => clk,
    --      probe0(0)             => sum_out_valid,
    --      probe1                => sum_out_data,
    --      probe2                => (others => '0'),
    --      probe3(0)             => buf_filter_out_strb,
    --      probe4(0)             => reduce_in_valid,
    --      probe5                => reduce_in_data,
    --      probe6(0)             => l_discount_ready,
    --      probe7(0)             => l_extendedprice_ready,
    --      probe8(0)             => l_quantity_ready,
    --      probe9(0)             => l_shipdate_ready,
    --      probe10(511 downto 0) => (511 downto 256 => '0') & l_discount & l_extendedprice & l_quantity & l_shipdate,
    --      probe11(0)            => sync_1_data,
    --      probe12(0)            => sync_2_data,
    --      probe13               => (others => '0'),
    --      probe14               => (511 downto 192 => '0') & conv_l_discount & conv_l_extendedprice & conv_l_quantity,
    --      probe15               => (others => '0'),
    --      probe16(0)            => sync_3_data,
    --      probe17               => (others => '0'),
    --      probe18               => (others => '0'),
    --      probe19               => (others => '0'),
    --      probe20               => (others => '0'),
    --      probe21               => (others => '0'),
    --      probe22(0)            => buf_filter_out_ready,
    --      probe23               => (others => '0'),
    --      probe24               => (others => '0'),
    --      probe25               => (others => '0'),
    --      probe26(0)            => buf_filter_out_valid,
    --      probe27               => (others => '0'),
    --      probe28               => (others => '0'),
    --      probe29               => '0' & l_discount_last,
    --      probe30(0)            => l_extendedprice_last,
    --      probe31               => ZERO(3 downto 1) & l_quantity_last,
    --      probe32               => ZERO(3 downto 1)& l_shipdate_last,
    --      probe33               => ZERO(3 downto 1)& l_discount_valid,
    --      probe34               => ZERO(3 downto 1)& l_extendedprice_valid,
    --      probe35(0)            => l_quantity_valid,
    --      probe36               => ZERO(3 downto 1) & l_shipdate_valid,
    --      probe37               => (others => '0'),
    --      probe38               => (others => '0'),
    --      probe39               => (others => '0'),
    --      probe40               => (others => '0'),
    --      probe41               => (others => '0'),
    --      probe42               => (others => '0'),
    --      probe43(0)            => reduce_in_valid
    --);
  end generate;

  -- CONVERTERS
  discount_converter : Float_to_Fixed
  generic map(
    FIXED_LEFT_INDEX  => FIXED_LEFT_INDEX,
    FIXED_RIGHT_INDEX => FIXED_RIGHT_INDEX,
    DATA_WIDTH        => DATA_WIDTH,
    INPUT_MIN_DEPTH   => DISCOUNT_CONVERTER_IN_DEPTH,
    OUTPUT_MIN_DEPTH  => DISCOUNT_CONVERTER_OUT_DEPTH,
    CONVERTER_TYPE    => "xilinx"

  )
  port map(
    clk        => clk,
    reset      => reset,

    in_valid   => l_discount_valid,
    in_dvalid  => l_discount_dvalid,
    in_ready   => l_discount_ready,
    in_last    => l_discount_last,
    in_data    => l_discount,

    out_valid  => conv_l_discount_valid,
    out_dvalid => conv_l_discount_dvalid,
    out_ready  => conv_l_discount_ready,
    out_last   => conv_l_discount_last,
    out_data   => conv_l_discount
  );
  quantity_converter : Float_to_Fixed
  generic map(
    FIXED_LEFT_INDEX  => FIXED_LEFT_INDEX,
    FIXED_RIGHT_INDEX => FIXED_RIGHT_INDEX,
    DATA_WIDTH        => DATA_WIDTH,
    INPUT_MIN_DEPTH   => QUANTITY_CONVERTER_IN_DEPTH,
    OUTPUT_MIN_DEPTH  => QUANTITY_CONVERTER_OUT_DEPTH,
    CONVERTER_TYPE    => "xilinx"

  )
  port map(
    clk        => clk,
    reset      => reset,

    in_valid   => l_quantity_valid,
    in_dvalid  => l_quantity_dvalid,
    in_ready   => l_quantity_ready,
    in_last    => l_quantity_last,
    in_data    => l_quantity,

    out_valid  => conv_l_quantity_valid,
    out_dvalid => conv_l_quantity_dvalid,
    out_ready  => conv_l_quantity_ready,
    out_last   => conv_l_quantity_last,
    out_data   => conv_l_quantity
  );
  extendedprice_converter : Float_to_Fixed
  generic map(
    FIXED_LEFT_INDEX  => FIXED_LEFT_INDEX,
    FIXED_RIGHT_INDEX => FIXED_RIGHT_INDEX,
    DATA_WIDTH        => DATA_WIDTH,
    INPUT_MIN_DEPTH   => EXTENDEDPRICE_CONVERTER_IN_DEPTH,
    OUTPUT_MIN_DEPTH  => EXTENDEDPRICE_CONVERTER_OUT_DEPTH,
    CONVERTER_TYPE    => "xilinx"

  )
  port map(
    clk        => clk,
    reset      => reset,

    in_valid   => l_extendedprice_valid,
    in_dvalid  => l_extendedprice_dvalid,
    in_ready   => l_extendedprice_ready,
    in_last    => l_extendedprice_last,
    in_data    => l_extendedprice,

    out_valid  => conv_l_extendedprice_valid,
    out_dvalid => conv_l_extendedprice_dvalid,
    out_ready  => conv_l_extendedprice_ready,
    out_last   => conv_l_extendedprice_last,
    out_data   => conv_l_extendedprice
  );

  dly_shipdate : StreamSliceArray
  generic map(
    DATA_WIDTH => DATA_WIDTH/2 + 2,
    DEPTH      => 9
  )
  port map(
    clk                                 => clk,
    reset                               => reset,

    in_valid                            => l_shipdate_valid,
    in_ready                            => l_shipdate_ready,
    in_data(DATA_WIDTH /2 + 1)          => l_shipdate_last,
    in_data(DATA_WIDTH /2)              => l_shipdate_dvalid,
    in_data(DATA_WIDTH /2 - 1 downto 0) => l_shipdate,

    out_valid                           => dly_l_shipdate_valid,
    out_ready                           => dly_l_shipdate_ready,
    out_data(DATA_WIDTH/2 + 1)          => dly_l_shipdate_last,
    out_data(DATA_WIDTH/2)              => dly_l_shipdate_dvalid,
    out_data(DATA_WIDTH/2 - 1 downto 0) => dly_l_shipdate

  );

  discount_sync : StreamSync
  generic map(
    NUM_INPUTS  => 1,
    NUM_OUTPUTS => 2
  )
  port map(
    clk          => clk,
    reset        => reset,

    in_valid(0)  => conv_l_discount_valid,
    in_ready(0)  => conv_l_discount_ready,
    out_valid(0) => between_in_valid,
    out_valid(1) => merge_discount_in_valid,
    out_ready(0) => between_in_ready,
    out_ready(1) => merge_discount_in_ready
  );

  filter_in_sync : StreamSync
  generic map(
    NUM_INPUTS  => 3,
    NUM_OUTPUTS => 3
  )
  port map(
    clk          => clk,
    reset        => reset,

    in_valid(0)  => conv_l_quantity_valid,
    in_valid(1)  => dly_l_shipdate_valid,
    in_valid(2)  => between_in_valid,
    in_ready(0)  => conv_l_quantity_ready,
    in_ready(1)  => dly_l_shipdate_ready,
    in_ready(2)  => between_in_ready,

    out_valid(0) => sync_1_in_valid,
    out_valid(1) => sync_2_in_valid,
    out_valid(2) => sync_3_in_valid,
    out_ready(0) => sync_1_in_ready,
    out_ready(1) => sync_2_in_ready,
    out_ready(2) => sync_3_in_ready
  );
  compare : FILTER
  generic map(
    FIXED_LEFT_INDEX  => FIXED_LEFT_INDEX,
    FIXED_RIGHT_INDEX => FIXED_RIGHT_INDEX,
    INPUT_MIN_DEPTH   => COMPARE_FILTER_IN_DEPTH,
    OUTPUT_MIN_DEPTH  => COMPARE_FILTER_OUT_DEPTH,
    DATA_WIDTH        => DATA_WIDTH/2,
    FILTERTYPE        => "DATE"
  )
  port map(
    clk       => clk,
    reset     => reset,

    in_valid  => sync_3_in_valid,
    in_dvalid => dly_l_shipdate_dvalid,
    in_ready  => sync_3_in_ready,
    in_last   => dly_l_shipdate_last,
    in_data   => dly_l_shipdate,

    out_valid => sync_3_valid,
    out_ready => sync_3_ready,
    out_data  => sync_3_data
  );

  ---------
  -- This module merges the predicate stream with another stream
  -- The MIN_DEPTH is specified for both input and output buffer. There exists
  -- a StreamSync operation for op1 and op2 inside this module.
  merge_predicate : MergeOp
  generic map(
    FIXED_LEFT_INDEX  => FIXED_LEFT_INDEX,
    FIXED_RIGHT_INDEX => FIXED_RIGHT_INDEX,
    DATA_WIDTH        => 64,
    INPUT_MIN_DEPTH   => MERGER_IN_DEPTH,  -- For output buffer.
    OUTPUT_MIN_DEPTH  => MERGER_OUT_DEPTH, -- For output buffer.
    OPERATOR          => "MULT_FIXED"
  )
  port map(
    clk        => clk,
    reset      => reset,

    op1_valid  => merge_discount_in_valid,
    op1_last   => conv_l_discount_last,
    op1_ready  => merge_discount_in_ready,
    op1_dvalid => conv_l_discount_dvalid,
    op1_data   => conv_l_discount,

    op2_valid  => conv_l_extendedprice_valid,
    op2_last   => conv_l_extendedprice_last,
    op2_ready  => conv_l_extendedprice_ready,
    op2_dvalid => conv_l_extendedprice_dvalid,
    op2_data   => conv_l_extendedprice,

    out_valid  => reduce_in_valid,
    out_last   => reduce_in_last,
    out_ready  => reduce_in_ready,
    out_data   => reduce_in_data,
    out_dvalid => reduce_in_dvalid
  );
  filter_out_sync : StreamSync
  generic map(
    NUM_INPUTS  => 4,
    NUM_OUTPUTS => 1
  )
  port map(
    clk          => clk,
    reset        => reset,

    in_valid(0)  => sync_1_valid,
    in_valid(1)  => sync_2_valid,
    in_valid(2)  => sync_3_valid,
    in_valid(3)  => reduce_in_valid,
    in_ready(0)  => sync_1_ready,
    in_ready(1)  => sync_2_ready,
    in_ready(2)  => sync_3_ready,
    in_ready(3)  => reduce_in_ready,
    out_valid(0) => filter_out_valid,
    out_ready(0) => filter_out_ready
  );

  filter_out_buf : StreamBuffer
  generic map(
    DATA_WIDTH => 2,
    MIN_DEPTH  => FILTER_OUT_DEPTH
  )
  port map(
    clk         => clk,
    reset       => reset,
    in_valid    => filter_out_valid,
    in_ready    => filter_out_ready,
    in_data(1)  => sync_1_data and sync_2_data and sync_3_data,
    in_data(0)  => reduce_in_last,
    out_valid   => buf_filter_out_valid,
    out_ready   => buf_filter_out_ready,
    out_data(1) => buf_filter_out_strb,
    out_data(0) => buf_filter_out_last
  );

  reduce_stage : ReduceStage
  generic map(
    FIXED_LEFT_INDEX  => FIXED_LEFT_INDEX,
    FIXED_RIGHT_INDEX => FIXED_RIGHT_INDEX,
    INDEX_WIDTH       => INDEX_WIDTH - 1
  )
  port map(
    clk       => clk,
    reset     => reset,
    in_valid  => buf_filter_out_valid,
    in_ready  => buf_filter_out_ready,
    in_dvalid => buf_filter_out_strb,
    in_last   => buf_filter_out_last,
    in_data   => reduce_in_data,
    out_valid => sum_out_valid,
    out_ready => sum_out_ready,
    out_data  => sum_out_data
  );

end Behavioral;