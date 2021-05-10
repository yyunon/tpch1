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
    TAG_WIDTH         : natural;
    LEN_WIDTH         : natural;
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
    l_count_order               : out std_logic_vector(63 downto 0);

    --Status regs
    output_first_idx            : out std_logic_vector(31 downto 0);
    output_last_idx             : out std_logic_vector(31 downto 0);
    cmd_in_valid                : in std_logic;
    cmd_in_ready                : out std_logic;
    interface_in_valid          : in std_logic;
    interface_in_ready          : out std_logic

  );
end PU;

architecture Behavioral of PU is
  constant ELEMENT_WIDTH       : natural                                    := 8;
  constant ELEMENT_COUNT_MAX   : natural                                    := 64;
  constant ELEMENT_COUNT_WIDTH : natural                                    := 6;
  constant COUNT_MAX_VAL       : unsigned(ELEMENT_COUNT_WIDTH - 1 downto 0) := to_unsigned(ELEMENT_COUNT_MAX, ELEMENT_COUNT_WIDTH);
  -- State Machine
  type state_type is (STATE_IDLE,
    STATE_BUILD,
    STATE_CMD,
    STATE_INTERFACE,
    STATE_DONE);
  type len_record is record
    ready  : std_logic;
    valid  : std_logic;
    data   : std_logic_vector(LEN_WIDTH - 1 downto 0);
    last   : std_logic;
    dvalid : std_logic;
  end record;
  type cmd_in_record is record
    len : unsigned(INDEX_WIDTH - 1 downto 0);
  end record;
  type cmd_out_record is record
    ready : std_logic;
  end record;
  type regs_record is record
    state : state_type;
  end record;
  type out_record is record
    cmd : cmd_out_record;
    len : len_record;
  end record;
  --State registers
  signal r : regs_record;
  signal d : regs_record;

  type utf_record is record
    ready  : std_logic;
    valid  : std_logic;
    data   : std_logic_vector(7 downto 0);
    count  : unsigned(LEN_WIDTH - 1 downto 0);
    last   : std_logic;
    dvalid : std_logic;
  end record;
  type prim64_record is record
    ready  : std_logic;
    valid  : std_logic;
    data   : std_logic_vector(63 downto 0);
    last   : std_logic;
    dvalid : std_logic;
  end record;
  type prim32_record is record
    ready  : std_logic;
    valid  : std_logic;
    data   : std_logic_vector(31 downto 0);
    last   : std_logic;
    dvalid : std_logic;
  end record;
  type sregs_record is record
    state : state_type;
  end record;
  type buf_out_record is record
    ready : std_logic;
  end record;
  type prim64_out_record is record
    buf : buf_out_record;
    num : prim64_record;
  end record;
  type prim32_out_record is record
    buf : buf_out_record;
    num : prim32_record;
  end record;
  type chars_out_record is record
    buf : buf_out_record;
    utf : utf_record;
  end record;
  signal rs                                  : sregs_record;
  signal ds                                  : sregs_record;

  -- Constants
  -- Merger inout buffers 
  constant SUM_CHARGE_MERGER_IN_DEPTH        : integer                       := 2;
  constant SUM_CHARGE_MERGER_OUT_DEPTH       : integer                       := 2;

  constant SUM_DISC_MERGER_IN_DEPTH          : integer                       := 2;
  constant SUM_DISC_MERGER_OUT_DEPTH         : integer                       := 2;

  -- Converter inout buffers 
  constant EXTENDEDPRICE_CONVERTER_IN_DEPTH  : integer                       := 2;
  constant EXTENDEDPRICE_CONVERTER_OUT_DEPTH : integer                       := 2;
  constant DISCOUNT_CONVERTER_IN_DEPTH       : integer                       := 2;
  constant DISCOUNT_CONVERTER_OUT_DEPTH      : integer                       := 2;
  constant QUANTITY_CONVERTER_IN_DEPTH       : integer                       := 2;
  constant QUANTITY_CONVERTER_OUT_DEPTH      : integer                       := 2;
  constant TAX_CONVERTER_IN_DEPTH            : integer                       := 2;
  constant TAX_CONVERTER_OUT_DEPTH           : integer                       := 2;

  -- Filter in out buffers2
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

  signal conv_l_tax_valid                    : std_logic                     := '0';
  signal conv_l_tax_ready                    : std_logic                     := '0';
  signal conv_l_tax_dvalid                   : std_logic                     := '0';
  signal conv_l_tax_last                     : std_logic                     := '0';
  signal conv_l_tax                          : std_logic_vector(63 downto 0) := (others => '0');

  signal dly_l_shipdate_valid                : std_logic                     := '0';
  signal dly_l_shipdate_ready                : std_logic                     := '0';
  signal dly_l_shipdate_dvalid               : std_logic                     := '0';
  signal dly_l_shipdate_last                 : std_logic                     := '0';
  signal dly_l_shipdate                      : std_logic_vector(31 downto 0) := (others => '0');
  -- l_returnflag_chars_valid    : in std_logic;
  -- l_returnflag_chars_ready    : out std_logic;
  -- l_returnflag_chars_dvalid   : in std_logic;
  -- l_returnflag_chars_last     : in std_logic;
  -- l_returnflag_chars          : in std_logic_vector(7 downto 0);
  -- l_returnflag_chars_count    : in std_logic_vector(0 downto 0);

  signal dly_l_returnflag_chars_valid        : std_logic                     := '0';
  signal dly_l_returnflag_chars_ready        : std_logic                     := '0';
  signal dly_l_returnflag_chars_dvalid       : std_logic                     := '0';
  signal dly_l_returnflag_chars_last         : std_logic                     := '0';
  signal dly_l_returnflag_chars_count        : std_logic_vector(7 downto 0)  := (others => '0');
  signal dly_l_returnflag_chars              : std_logic_vector(7 downto 0)  := (others => '0');

  signal dly_l_linestatus_chars_valid        : std_logic                     := '0';
  signal dly_l_linestatus_chars_ready        : std_logic                     := '0';
  signal dly_l_linestatus_chars_dvalid       : std_logic                     := '0';
  signal dly_l_linestatus_chars_last         : std_logic                     := '0';
  signal dly_l_linestatus_chars_count        : std_logic_vector(7 downto 0)  := (others => '0');
  signal dly_l_linestatus_chars              : std_logic_vector(7 downto 0)  := (others => '0');
  --
  -- Discount synchronize signals
  signal discount_price_in_valid             : std_logic                     := '0';
  signal discount_price_in_ready             : std_logic                     := '0';
  signal charge_price_in_valid               : std_logic                     := '0';
  signal charge_price_in_ready               : std_logic                     := '0';

  signal ext_discount_price_in_valid         : std_logic                     := '0';
  signal ext_discount_price_in_ready         : std_logic                     := '0';
  signal ext_charge_price_in_valid           : std_logic                     := '0';
  signal ext_charge_price_in_ready           : std_logic                     := '0';

  signal discount_aggregate_in_valid         : std_logic                     := '0';
  signal discount_aggregate_in_ready         : std_logic                     := '0';
  signal extendedprice_aggregate_in_valid    : std_logic                     := '0';
  signal extendedprice_aggregate_in_ready    : std_logic                     := '0';
  -- Merge key streams
  signal in_key_stream_chars_valid           : std_logic                     := '0';
  signal in_key_stream_chars_dvalid          : std_logic                     := '0';
  signal in_key_stream_chars                 : std_logic_vector(15 downto 0);
  signal in_key_stream_chars_ready           : std_logic := '0';

  signal key_stream_chars_valid              : std_logic := '0';
  signal key_stream_chars_dvalid             : std_logic := '0';
  signal key_stream_chars                    : std_logic_vector(15 downto 0);
  signal key_stream_chars_ready              : std_logic := '0';

  signal l_returnflag_chars_ready_x          : std_logic := '0';
  signal l_linestatus_chars_ready_x          : std_logic := '0';
  --
  -- Merger inputs
  signal sum_charge_inputs_valid             : std_logic_vector(2 downto 0);
  signal sum_charge_inputs_ready             : std_logic_vector(2 downto 0);
  signal sum_charge_inputs_dvalid            : std_logic_vector(2 downto 0);
  signal sum_charge_inputs_last              : std_logic_vector(2 downto 0);
  signal sum_charge_inputs                   : TUPLE_DATA_64(2 downto 0);

  signal sum_disc_price_inputs_valid         : std_logic_vector(1 downto 0);
  signal sum_disc_price_inputs_ready         : std_logic_vector(1 downto 0);
  signal sum_disc_price_inputs_dvalid        : std_logic_vector(1 downto 0);
  signal sum_disc_price_inputs_last          : std_logic_vector(1 downto 0);
  signal sum_disc_price_inputs               : TUPLE_DATA_64(1 downto 0);
  --
  -- Sync inputs 
  signal sync_1_in_valid                     : std_logic := '0';
  signal sync_1_in_ready                     : std_logic := '0';
  signal sync_2_in_valid                     : std_logic := '0';
  signal sync_2_in_ready                     : std_logic := '0';
  signal sync_3_in_valid                     : std_logic := '0';
  signal sync_3_in_ready                     : std_logic := '0';
  --
  -- Multiplied vals
  signal charge_reduce_in_ready              : std_logic := '0';
  signal charge_reduce_in_valid              : std_logic := '0';
  signal charge_reduce_in_last               : std_logic;
  signal charge_reduce_in_dvalid             : std_logic;
  signal charge_reduce_in_data               : std_logic_vector(63 downto 0);

  signal disc_price_reduce_in_ready          : std_logic := '0';
  signal disc_price_reduce_in_valid          : std_logic := '0';
  signal disc_price_reduce_in_last           : std_logic;
  signal disc_price_reduce_in_dvalid         : std_logic;
  signal disc_price_reduce_in_data           : std_logic_vector(63 downto 0);
  --
  signal sum_qty_ready                       : std_logic := '0';
  signal sum_qty_valid                       : std_logic := '0';
  signal sum_qty_last                        : std_logic;
  signal sum_qty_dvalid                      : std_logic;
  signal sum_qty_data                        : std_logic_vector(63 downto 0);

  signal avg_qty_ready                       : std_logic := '0';
  signal avg_qty_valid                       : std_logic := '0';
  signal avg_qty_last                        : std_logic;
  signal avg_qty_dvalid                      : std_logic;
  signal avg_qty_data                        : std_logic_vector(63 downto 0);

  signal sum_base_price_ready                : std_logic := '0';
  signal sum_base_price_valid                : std_logic := '0';
  signal sum_base_price_last                 : std_logic;
  signal sum_base_price_dvalid               : std_logic;
  signal sum_base_price_data                 : std_logic_vector(63 downto 0);

  signal avg_price_ready                     : std_logic := '0';
  signal avg_price_valid                     : std_logic := '0';
  signal avg_price_last                      : std_logic;
  signal avg_price_dvalid                    : std_logic;
  signal avg_price_data                      : std_logic_vector(63 downto 0);

  signal sum_disc_price_ready                : std_logic := '0';
  signal sum_disc_price_valid                : std_logic := '0';
  signal sum_disc_price_last                 : std_logic;
  signal sum_disc_price_dvalid               : std_logic;
  signal sum_disc_price_data                 : std_logic_vector(63 downto 0);

  signal sum_charge_ready                    : std_logic := '0';
  signal sum_charge_valid                    : std_logic := '0';
  signal sum_charge_last                     : std_logic;
  signal sum_charge_dvalid                   : std_logic;
  signal sum_charge_data                     : std_logic_vector(63 downto 0);

  signal avg_disc_ready                      : std_logic := '0';
  signal avg_disc_valid                      : std_logic := '0';
  signal avg_disc_last                       : std_logic;
  signal avg_disc_dvalid                     : std_logic;
  signal avg_disc_data                       : std_logic_vector(63 downto 0);

  signal count_order_ready                   : std_logic := '0';
  signal count_order_valid                   : std_logic := '0';
  signal count_order_last                    : std_logic;
  signal count_order_dvalid                  : std_logic;
  signal count_order_data                    : std_logic_vector(63 downto 0);

  signal linestatus_o_chars_ready            : std_logic := '0';
  signal linestatus_o_chars_valid            : std_logic := '0';
  signal linestatus_o_chars_last             : std_logic;
  signal linestatus_o_chars_dvalid           : std_logic;
  signal linestatus_o_chars_data             : std_logic_vector(7 downto 0);
  signal linestatus_o_chars_count            : std_logic_vector(31 downto 0);

  signal len_linestatus_o_ready              : std_logic := '0';
  signal len_linestatus_o_valid              : std_logic := '0';
  signal len_linestatus_o_last               : std_logic;
  signal len_linestatus_o_dvalid             : std_logic;
  signal len_linestatus_o_data               : std_logic_vector(7 downto 0);
  signal len_linestatus_o_length             : std_logic_vector(31 downto 0);

  signal returnflag_o_chars_ready            : std_logic := '0';
  signal returnflag_o_chars_valid            : std_logic := '0';
  signal returnflag_o_chars_last             : std_logic;
  signal returnflag_o_chars_dvalid           : std_logic;
  signal returnflag_o_chars_data             : std_logic_vector(7 downto 0);
  signal returnflag_o_chars_count            : std_logic_vector(31 downto 0);

  signal len_returnflag_o_ready              : std_logic := '0';
  signal len_returnflag_o_valid              : std_logic := '0';
  signal len_returnflag_o_last               : std_logic;
  signal len_returnflag_o_dvalid             : std_logic;
  signal len_returnflag_o_data               : std_logic_vector(7 downto 0);
  signal len_returnflag_o_length             : std_logic_vector(31 downto 0);

  signal buf_in_out_data_valid_s             : std_logic;
  signal buf_in_out_data_enable_s            : std_logic;
  signal buf_in_out_data_ready_s             : std_logic;
  signal buf_in_out_data_last_s              : std_logic := '0';
  signal buf_in_out_data_s                   : std_logic_vector(16 + 9 * 64 - 1 downto 0);

  signal out_data_valid_s                    : std_logic;
  signal out_data_enable_s                   : std_logic;
  signal out_data_ready_s                    : std_logic;
  signal out_data_last_s                     : std_logic := '0';
  signal out_data_s                          : std_logic_vector(16 + 9 * 64 - 1 downto 0);
  signal reduce_in_data                      : std_logic_vector(5 * 64 - 1 downto 0);
  -- Output of filter stage
  signal filter_in_valid                     : std_logic := '0';
  signal filter_in_ready                     : std_logic := '0';
  signal filter_in_data                      : std_logic := '0';
  -- signal filter_out_strb        : std_logic;
  -- Output of filter stage buffer
  signal filter_out_valid                    : std_logic := '0';
  signal filter_out_ready                    : std_logic := '0';
  signal filter_out_last                     : std_logic;
  signal filter_out_strb                     : std_logic;
  -- signal filter_out_strb        : std_logic;
  signal probe_valid                         : std_logic;
  signal probe_ready                         : std_logic;
  signal num_entries                         : std_logic_vector(15 downto 0);
  signal enable_interface                    : std_logic;
  --
  constant ZERO                              : std_logic_vector(3 downto 0) := (others => '0');
begin
  output_first_idx <= (others       => '0');
  output_last_idx  <= (31 downto 16 => '0') & num_entries;
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
  l_returnflag_ready       <= l_returnflag_chars_ready_x;
  l_linestatus_ready       <= l_linestatus_chars_ready_x;

  l_returnflag_chars_ready <= l_returnflag_chars_ready_x;
  l_linestatus_chars_ready <= l_linestatus_chars_ready_x;

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
  tax_converter : Float_to_Fixed
  generic map(
    FIXED_LEFT_INDEX  => FIXED_LEFT_INDEX,
    FIXED_RIGHT_INDEX => FIXED_RIGHT_INDEX,
    DATA_WIDTH        => DATA_WIDTH,
    INPUT_MIN_DEPTH   => TAX_CONVERTER_IN_DEPTH,
    OUTPUT_MIN_DEPTH  => TAX_CONVERTER_OUT_DEPTH,
    CONVERTER_TYPE    => "xilinx"

  )
  port map(
    clk        => clk,
    reset      => reset,

    in_valid   => l_tax_valid,
    in_dvalid  => l_tax_dvalid,
    in_ready   => l_tax_ready,
    in_last    => l_tax_last,
    in_data    => l_tax,

    out_valid  => conv_l_tax_valid,
    out_dvalid => conv_l_tax_dvalid,
    out_ready  => conv_l_tax_ready,
    out_last   => conv_l_tax_last,
    out_data   => conv_l_tax
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

  dly_shipdate : StreamBuffer
  generic map(
    DATA_WIDTH => DATA_WIDTH/2 + 2,
    MIN_DEPTH  => 1
  )
  port map(
    clk                   => clk,
    reset                 => reset,

    in_valid              => l_shipdate_valid,
    in_ready              => l_shipdate_ready,
    in_data(33)           => l_shipdate_last,
    in_data(32)           => l_shipdate_dvalid,
    in_data(31 downto 0)  => l_shipdate,

    out_valid             => dly_l_shipdate_valid,
    out_ready             => dly_l_shipdate_ready,
    out_data(33)          => dly_l_shipdate_last,
    out_data(32)          => dly_l_shipdate_dvalid,
    out_data(31 downto 0) => dly_l_shipdate

  );

  dly_returnflag : StreamBuffer
  generic map(
    DATA_WIDTH => 8 + 2,
    MIN_DEPTH  => 2
  )
  port map(
    clk                  => clk,
    reset                => reset,

    in_valid             => l_returnflag_chars_valid,
    in_ready             => l_returnflag_chars_ready_x,
    in_data(9)           => l_returnflag_chars_last,
    in_data(8)           => l_returnflag_chars_dvalid,
    in_data(7 downto 0)  => l_returnflag_chars,

    out_valid            => dly_l_returnflag_chars_valid,
    out_ready            => dly_l_returnflag_chars_ready,
    out_data(9)          => dly_l_returnflag_chars_last,
    out_data(8)          => dly_l_returnflag_chars_dvalid,
    out_data(7 downto 0) => dly_l_returnflag_chars

  );

  dly_linestatus : StreamBuffer
  generic map(
    DATA_WIDTH => 8 + 2,
    MIN_DEPTH  => 4
  )
  port map(
    clk                  => clk,
    reset                => reset,

    in_valid             => l_linestatus_chars_valid,
    in_ready             => l_linestatus_chars_ready_x,
    in_data(9)           => l_linestatus_chars_last,
    in_data(8)           => l_linestatus_chars_dvalid,
    in_data(7 downto 0)  => l_linestatus_chars,

    out_valid            => dly_l_linestatus_chars_valid,
    out_ready            => dly_l_linestatus_chars_ready,
    out_data(9)          => dly_l_linestatus_chars_last,
    out_data(8)          => dly_l_linestatus_chars_dvalid,
    out_data(7 downto 0) => dly_l_linestatus_chars

  );
  key_stream_sync : StreamSync
  generic map(
    NUM_INPUTS  => 2,
    NUM_OUTPUTS => 1
  )
  port map(
    clk          => clk,
    reset        => reset,
    in_valid(0)  => dly_l_linestatus_chars_valid,
    in_valid(1)  => dly_l_returnflag_chars_valid,
    in_ready(0)  => dly_l_linestatus_chars_ready,
    in_ready(1)  => dly_l_returnflag_chars_ready,

    out_valid(0) => in_key_stream_chars_valid,
    out_ready(0) => in_key_stream_chars_ready
  );
  in_key_stream_chars <= dly_l_returnflag_chars & dly_l_linestatus_chars when dly_l_linestatus_chars_valid = '1' and dly_l_returnflag_chars_ready = '1' else
    (others => '0');
  merge_two_key_streams : StreamBuffer
  generic map(
    MIN_DEPTH  => 2,
    DATA_WIDTH => 17
  )
  port map(
    clk                   => clk,
    reset                 => reset,
    in_valid              => in_key_stream_chars_valid,
    in_ready              => in_key_stream_chars_ready,
    in_data(16)           => dly_l_returnflag_chars_dvalid and dly_l_linestatus_chars_dvalid,
    in_data(15 downto 0)  => in_key_stream_chars,

    out_valid             => key_stream_chars_valid,
    out_ready             => key_stream_chars_ready,
    out_data(16)          => key_stream_chars_dvalid,
    out_data(15 downto 0) => key_stream_chars
  );

  -----------------------------------------------------------------------------
  -- Break discount stream in 3 different streams:
  -- sum_disc_price, sum_charge_price, sum_discount, 
  discount_sync : StreamSync
  generic map(
    NUM_INPUTS  => 1,
    NUM_OUTPUTS => 3
  )
  port map(
    clk          => clk,
    reset        => reset,

    in_valid(0)  => conv_l_discount_valid,
    in_ready(0)  => conv_l_discount_ready,

    out_valid(0) => discount_price_in_valid,
    out_valid(1) => charge_price_in_valid,
    out_valid(2) => discount_aggregate_in_valid,
    out_ready(0) => discount_price_in_ready,
    out_ready(1) => charge_price_in_ready,
    out_ready(2) => discount_aggregate_in_ready
  );

  -----------------------------------------------------------------------------
  -- Break extendedprice stream in 3 different streams:
  -- sum_disc_price, sum_charge_price, sum_discount, 
  -----------------------------------------------------------------------------
  extendedprice_sync : StreamSync
  generic map(
    NUM_INPUTS  => 1,
    NUM_OUTPUTS => 3
  )
  port map(
    clk          => clk,
    reset        => reset,

    in_valid(0)  => conv_l_extendedprice_valid,
    in_ready(0)  => conv_l_extendedprice_ready,

    out_valid(0) => ext_discount_price_in_valid,
    out_valid(1) => ext_charge_price_in_valid,
    out_valid(2) => extendedprice_aggregate_in_valid,
    out_ready(0) => ext_discount_price_in_ready,
    out_ready(1) => ext_charge_price_in_ready,
    out_ready(2) => extendedprice_aggregate_in_ready
  );

  -----------------------------------------------------------------------------
  -- Filter stream on shipdate 
  -----------------------------------------------------------------------------
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

    in_valid  => dly_l_shipdate_valid,
    in_dvalid => dly_l_shipdate_dvalid,
    in_ready  => dly_l_shipdate_ready,
    in_last   => dly_l_shipdate_last,
    in_data   => dly_l_shipdate,

    out_valid => filter_in_valid,
    out_ready => filter_in_ready,
    out_data  => filter_in_data
  );
  -----------------------------------------------------------------------------
  -- This module merges the predicate stream with another stream
  -- The MIN_DEPTH is specified for both input and output buffer. There exists
  -- a StreamSync operation for op1,op2..opn inside this module.
  -----------------------------------------------------------------------------
  sum_charge_inputs_valid(0)  <= conv_l_tax_valid;
  sum_charge_inputs_valid(1)  <= charge_price_in_valid;
  sum_charge_inputs_valid(2)  <= ext_charge_price_in_valid;

  conv_l_tax_ready            <= sum_charge_inputs_ready(0);
  charge_price_in_ready       <= sum_charge_inputs_ready(1);
  ext_charge_price_in_ready   <= sum_charge_inputs_ready(2);

  sum_charge_inputs_dvalid(0) <= conv_l_tax_dvalid;
  sum_charge_inputs_dvalid(1) <= conv_l_discount_dvalid;
  sum_charge_inputs_dvalid(2) <= conv_l_extendedprice_dvalid;

  sum_charge_inputs_last(0)   <= conv_l_tax_last;
  sum_charge_inputs_last(1)   <= conv_l_discount_last;
  sum_charge_inputs_last(2)   <= conv_l_extendedprice_last;

  sum_charge_inputs(0)        <= conv_l_tax;
  sum_charge_inputs(1)        <= conv_l_discount;
  sum_charge_inputs(2)        <= conv_l_extendedprice;
  sum_charge_merger : MergeOp
  generic map(
    FIXED_LEFT_INDEX  => FIXED_LEFT_INDEX,
    FIXED_RIGHT_INDEX => FIXED_RIGHT_INDEX,
    DATA_WIDTH        => 64,
    NUM_INPUTS        => 3,
    NUM_OUTPUTS       => 1,
    INPUT_MIN_DEPTH   => SUM_CHARGE_MERGER_IN_DEPTH,  -- For output buffer.
    OUTPUT_MIN_DEPTH  => SUM_CHARGE_MERGER_OUT_DEPTH, -- For output buffer.
    OPERATOR          => "CHARGE"
  )
  port map(
    clk           => clk,
    reset         => reset,

    inputs_valid  => sum_charge_inputs_valid,
    inputs_last   => sum_charge_inputs_last,
    inputs_ready  => sum_charge_inputs_ready,
    inputs_dvalid => sum_charge_inputs_dvalid,
    inputs_data   => sum_charge_inputs,

    out_valid     => charge_reduce_in_valid,
    out_last      => charge_reduce_in_last,
    out_ready     => charge_reduce_in_ready,
    out_data      => charge_reduce_in_data,
    out_dvalid    => charge_reduce_in_dvalid
  );
  -----------------------------------------------------------------------------
  -- This module merges the predicate stream with another stream
  -- The MIN_DEPTH is specified for both input and output buffer. There exists
  -- a StreamSync operation for op1,op2..opn inside this module.
  -----------------------------------------------------------------------------
  discount_price_in_ready         <= sum_disc_price_inputs_ready(0);
  ext_discount_price_in_ready     <= sum_disc_price_inputs_ready(1);

  sum_disc_price_inputs_valid(0)  <= discount_price_in_valid;
  sum_disc_price_inputs_valid(1)  <= ext_discount_price_in_valid;

  sum_disc_price_inputs_dvalid(0) <= conv_l_discount_dvalid;
  sum_disc_price_inputs_dvalid(1) <= conv_l_extendedprice_dvalid;

  sum_disc_price_inputs_last(0)   <= conv_l_discount_last;
  sum_disc_price_inputs_last(1)   <= conv_l_extendedprice_last;

  sum_disc_price_inputs(0)        <= conv_l_discount;
  sum_disc_price_inputs(1)        <= conv_l_extendedprice;
  sum_disc_price_merger : MergeOp
  generic map(
    FIXED_LEFT_INDEX  => FIXED_LEFT_INDEX,
    FIXED_RIGHT_INDEX => FIXED_RIGHT_INDEX,
    DATA_WIDTH        => 64,
    NUM_INPUTS        => 2,
    NUM_OUTPUTS       => 1,
    INPUT_MIN_DEPTH   => SUM_DISC_MERGER_IN_DEPTH,  -- For output buffer.
    OUTPUT_MIN_DEPTH  => SUM_DISC_MERGER_OUT_DEPTH, -- For output buffer.
    OPERATOR          => "DISCOUNT"
  )
  port map(
    clk           => clk,
    reset         => reset,

    inputs_valid  => sum_disc_price_inputs_valid,
    inputs_last   => sum_disc_price_inputs_last,
    inputs_ready  => sum_disc_price_inputs_ready,
    inputs_dvalid => sum_disc_price_inputs_dvalid,
    inputs_data   => sum_disc_price_inputs,

    out_valid     => disc_price_reduce_in_valid,
    out_last      => disc_price_reduce_in_last,
    out_ready     => disc_price_reduce_in_ready,
    out_data      => disc_price_reduce_in_data,
    out_dvalid    => disc_price_reduce_in_dvalid
  );

  -----------------------------------------------------------------------------
  -- Sync. all streams for reduction
  -----------------------------------------------------------------------------
  filter_out_sync : StreamSync
  generic map(
    NUM_INPUTS  => 7,
    NUM_OUTPUTS => 1
  )
  port map(
    clk          => clk,
    reset        => reset,

    in_valid(0)  => filter_in_valid,
    in_valid(1)  => charge_reduce_in_valid,
    in_valid(2)  => disc_price_reduce_in_valid,
    in_valid(3)  => extendedprice_aggregate_in_valid,
    in_valid(4)  => discount_aggregate_in_valid,
    in_valid(5)  => conv_l_quantity_valid,
    in_valid(6)  => key_stream_chars_valid,

    in_ready(0)  => filter_in_ready,
    in_ready(1)  => charge_reduce_in_ready,
    in_ready(2)  => disc_price_reduce_in_ready,
    in_ready(3)  => extendedprice_aggregate_in_ready,
    in_ready(4)  => discount_aggregate_in_ready,
    in_ready(5)  => conv_l_quantity_ready,
    in_ready(6)  => key_stream_chars_ready,

    out_valid(0) => filter_out_valid,
    out_ready(0) => filter_out_ready
  );
  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------
  -- REDUCE
  -- Reduce on all of the output streams
  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------
  reduce_in_data  <= disc_price_reduce_in_data & charge_reduce_in_data & conv_l_quantity & conv_l_extendedprice & conv_l_discount;
  filter_out_strb <= filter_in_data;
  filter_out_last <= conv_l_quantity_last and conv_l_discount_last and conv_l_extendedprice_last and disc_price_reduce_in_last and charge_reduce_in_last;

  avg_discount_reduce_stage : ReduceStage
  generic map(
    FIXED_LEFT_INDEX  => FIXED_LEFT_INDEX,
    FIXED_RIGHT_INDEX => FIXED_RIGHT_INDEX,
    DATA_WIDTH        => 64,
    NUM_KEYS          => 2,
    NUM_SUMS          => 5,
    NUM_AVGS          => 3,
    INDEX_WIDTH       => INDEX_WIDTH - 1
  )
  port map(
    clk           => clk,
    reset         => reset,
    key_in_dvalid => key_stream_chars_dvalid,
    key_in_data   => key_stream_chars,
    in_valid      => filter_out_valid,
    in_ready      => filter_out_ready,
    in_dvalid     => filter_out_strb,
    in_last       => filter_out_last,
    in_data       => reduce_in_data,
    out_valid     => buf_in_out_data_valid_s,
    out_enable    => out_data_enable_s,
    out_ready     => buf_in_out_data_ready_s,
    out_last      => buf_in_out_data_last_s,
    out_data      => buf_in_out_data_s, -- This holds them all
    probe_ready   => probe_ready,
    hash_len      => num_entries,
    probe_valid   => probe_valid
  );
  --Reduce output slice
  reduce_out_slice : StreamBuffer
  generic map(
    MIN_DEPTH  => 2,
    DATA_WIDTH => 16 + 9 * 64 + 1 -- last bit
  )
  port map(
    clk                                => clk,
    reset                              => reset,
    in_valid                           => buf_in_out_data_valid_s,
    in_ready                           => buf_in_out_data_ready_s,
    in_data(16 + 9 * 64)               => buf_in_out_data_last_s,
    in_data(16 + 9 * 64 - 1 downto 0)  => buf_in_out_data_s,
    out_valid                          => out_data_valid_s,
    out_ready                          => out_data_ready_s,
    out_data(16 + 9 * 64)              => out_data_last_s,
    out_data(16 + 9 * 64 - 1 downto 0) => out_data_s
  );
  sync_output_streams : StreamSync
  generic map(
    NUM_INPUTS  => 1,
    NUM_OUTPUTS => 10
  )
  port map(
    clk          => clk,
    reset        => reset,
    in_valid(0)  => out_data_valid_s,
    in_ready(0)  => out_data_ready_s,

    out_valid(0) => sum_qty_valid,
    out_valid(1) => avg_qty_valid,
    out_valid(2) => sum_base_price_valid,
    out_valid(3) => avg_price_valid,
    out_valid(4) => sum_disc_price_valid,
    out_valid(5) => sum_charge_valid,
    out_valid(6) => avg_disc_valid,
    out_valid(7) => count_order_valid,
    out_valid(8) => returnflag_o_chars_valid,
    out_valid(9) => linestatus_o_chars_valid,

    out_ready(0) => sum_qty_ready,
    out_ready(1) => avg_qty_ready,
    out_ready(2) => sum_base_price_ready,
    out_ready(3) => avg_price_ready,
    out_ready(4) => sum_disc_price_ready,
    out_ready(5) => sum_charge_ready,
    out_ready(6) => avg_disc_ready,
    out_ready(7) => count_order_ready,
    out_ready(8) => returnflag_o_chars_ready,
    out_ready(9) => linestatus_o_chars_ready
  );
  -- Well, this does not look good!!
  --reduce_in_data  <= disc_price_reduce_in_data & charge_reduce_in_data & conv_l_quantity & conv_l_extendedprice & conv_l_discount;
  count_order_data        <= out_data_s(63 downto 0);
  avg_qty_data            <= out_data_s(127 downto 64);
  avg_price_data          <= out_data_s(191 downto 128);
  avg_disc_data           <= out_data_s(255 downto 192);
  sum_disc_price_data     <= out_data_s(319 downto 256);
  sum_charge_data         <= out_data_s(383 downto 320);
  sum_qty_data            <= out_data_s(447 downto 384);
  sum_base_price_data     <= out_data_s(511 downto 448);
  --sum_dsc <= out_data_s(575 downto 512);
  linestatus_o_chars_data <= out_data_s(583 downto 576);
  returnflag_o_chars_data <= out_data_s(591 downto 584);

  len_linestatus_o_valid  <= linestatus_o_chars_valid;
  len_returnflag_o_valid  <= returnflag_o_chars_valid;

  --Number output streams
  l_sum_qty_valid         <= sum_qty_valid;
  sum_qty_ready           <= l_sum_qty_ready;
  l_sum_qty_dvalid        <= '1';
  l_sum_qty_last          <= sum_qty_last;
  l_sum_qty               <= sum_qty_data;

  l_sum_base_price_valid  <= sum_base_price_valid;
  sum_base_price_ready    <= l_sum_base_price_ready;
  l_sum_base_price_dvalid <= '1';
  l_sum_base_price_last   <= out_data_last_s;
  l_sum_base_price        <= sum_base_price_data;

  l_sum_disc_price_valid  <= sum_disc_price_valid;
  sum_disc_price_ready    <= l_sum_disc_price_ready;
  l_sum_disc_price_dvalid <= '1';
  l_sum_disc_price_last   <= out_data_last_s;
  l_sum_disc_price        <= sum_disc_price_data;

  l_sum_charge_valid      <= sum_charge_valid;
  sum_charge_ready        <= l_sum_charge_ready;
  l_sum_charge_dvalid     <= '1';
  l_sum_charge_last       <= out_data_last_s;
  l_sum_charge            <= sum_charge_data;

  l_avg_qty_valid         <= avg_qty_valid;
  avg_qty_ready           <= l_avg_qty_ready;
  l_avg_qty_dvalid        <= '1';
  l_avg_qty_last          <= out_data_last_s;
  l_avg_qty               <= avg_qty_data;

  l_avg_price_valid       <= avg_price_valid;
  avg_price_ready         <= l_avg_price_ready;
  l_avg_price_dvalid      <= '1';
  l_avg_price_last        <= out_data_last_s;
  l_avg_price             <= avg_price_data;

  l_avg_disc_valid        <= avg_disc_valid;
  avg_disc_ready          <= l_avg_disc_ready;
  l_avg_disc_dvalid       <= '1';
  l_avg_disc_last         <= out_data_last_s;
  l_avg_disc              <= avg_disc_data;

  l_count_order_valid     <= count_order_valid;
  count_order_ready       <= l_count_order_ready;
  l_count_order_dvalid    <= '1';
  l_count_order_last      <= out_data_last_s;
  l_count_order           <= count_order_data;

  len_linestatus_o_length <= std_logic_vector(to_unsigned(1, 32));
  -- Output interface logic
  linestatus_interface :
  StringWriterInterface
  generic map(
    DATA_WIDTH  => DATA_WIDTH,
    TAG_WIDTH   => TAG_WIDTH,
    LEN_WIDTH   => LEN_WIDTH,
    INDEX_WIDTH => INDEX_WIDTH
  )
  port map(
    clk                 => clk,
    reset               => reset,
    enable              => enable_interface,
    input_valid         => len_linestatus_o_valid,
    input_ready         => len_linestatus_o_ready,
    input_dvalid        => len_linestatus_o_dvalid,
    input_last          => len_linestatus_o_last,
    input_length        => len_linestatus_o_length,
    input_count         => "1",
    input_chars_valid   => linestatus_o_chars_valid,
    input_chars_ready   => linestatus_o_chars_ready,
    input_chars_dvalid  => '1',
    input_chars_last    => out_data_last_s,
    input_chars         => linestatus_o_chars_data,
    input_chars_count   => "1",
    output_valid        => l_linestatus_o_valid,
    output_ready        => l_linestatus_o_ready,
    output_dvalid       => l_linestatus_o_dvalid,
    output_last         => l_linestatus_o_last,
    output_length       => l_linestatus_o_length,
    output_count        => l_linestatus_o_count,
    output_chars_valid  => l_linestatus_o_chars_valid,
    output_chars_ready  => l_linestatus_o_chars_ready,
    output_chars_dvalid => l_linestatus_o_chars_dvalid,
    output_chars_last   => l_linestatus_o_chars_last,
    output_chars        => l_linestatus_o_chars,
    output_chars_count  => l_linestatus_o_chars_count
  );

  -- Output interface logic
  len_returnflag_o_length <= std_logic_vector(to_unsigned(1, 32));
  returnflag_interface :
  StringWriterInterface
  generic map(
    DATA_WIDTH  => DATA_WIDTH,
    TAG_WIDTH   => TAG_WIDTH,
    LEN_WIDTH   => LEN_WIDTH,
    INDEX_WIDTH => INDEX_WIDTH
  )
  port map(
    clk                 => clk,
    reset               => reset,
    enable              => enable_interface,
    input_valid         => len_returnflag_o_valid,
    input_ready         => len_returnflag_o_ready,
    input_dvalid        => len_returnflag_o_dvalid,
    input_last          => len_returnflag_o_last,
    input_length        => len_returnflag_o_length,
    input_count         => "1",
    input_chars_valid   => returnflag_o_chars_valid,
    input_chars_ready   => returnflag_o_chars_ready,
    input_chars_dvalid  => '1',
    input_chars_last    => out_data_last_s,
    input_chars         => returnflag_o_chars_data,
    input_chars_count   => "1",
    output_valid        => l_returnflag_o_valid,
    output_ready        => l_returnflag_o_ready,
    output_dvalid       => l_returnflag_o_dvalid,
    output_last         => l_returnflag_o_last,
    output_length       => l_returnflag_o_length,
    output_count        => l_returnflag_o_count,
    output_chars_valid  => l_returnflag_o_chars_valid,
    output_chars_ready  => l_returnflag_o_chars_ready,
    output_chars_dvalid => l_returnflag_o_chars_dvalid,
    output_chars_last   => l_returnflag_o_chars_last,
    output_chars        => l_returnflag_o_chars,
    output_chars_count  => l_returnflag_o_chars_count
  );

  -- Holds the interfacing logic.
  chars_proc :
  process (rs,
    --l_returnflag_o_chars_ready,
    --l_returnflag_chars_count,
    --l_linestatus_o_chars_ready,
    --l_linestatus_chars_count,
    --l_avg_price_ready,
    --l_avg_qty_ready,
    --l_avg_disc_ready,
    --l_sum_qty_ready,
    --l_sum_base_price_ready,
    --l_sum_disc_price_ready,
    --l_sum_charge_ready,
    --l_count_order_ready,
    --returnflag_o_chars_data,
    --linestatus_o_chars_data,
    --sum_qty_data,
    --sum_disc_price_data,
    --sum_charge_data,
    --avg_qty_data,
    --avg_disc_data,
    --avg_price_data,
    --count_order_data,
    --sum_base_price_data,
    probe_valid,
    num_entries,
    out_data_last_s,

    cmd_in_valid,
    interface_in_valid
    ) is
    variable vs : sregs_record;
    --variable l_returnflag_o     : chars_out_record;
    --variable l_linestatus_o     : chars_out_record;
    --variable l_sum_qty_o        : prim64_record;
    --variable l_sum_base_price_o : prim64_record;
    --variable l_sum_disc_price_o : prim64_record;
    --variable l_sum_charge_o     : prim64_record;
    --variable l_avg_qty_o        : prim64_record;
    --variable l_avg_price_o      : prim64_record;
    --variable l_avg_disc_o       : prim64_record;
    --variable l_count_order_o    : prim64_record;
  begin

    vs := rs;

    probe_ready        <= '0';
    cmd_in_ready       <= '0';
    interface_in_ready <= '0';
    enable_interface   <= '0';
    out_data_enable_s  <= '0';

    case vs.state is
      when STATE_IDLE =>
        if cmd_in_valid = '1' then
          vs.state := STATE_BUILD;
        end if;
      when STATE_BUILD =>
        probe_ready <= '1';
        if probe_valid = '1' then --Build phase is done.
          vs.state := STATE_CMD;
        end if;
      when STATE_CMD => --Wait for cmd stream on writer logic
        cmd_in_ready <= '1';
        if interface_in_valid = '1' then
          vs.state := STATE_INTERFACE;
        end if;
      when STATE_INTERFACE =>
        -- There are 10 different Array writers.
        enable_interface  <= '1';
        out_data_enable_s <= '1';
        if out_data_last_s = '1' then
          interface_in_ready <= '1';
          vs.state := STATE_DONE;
        end if;

      when STATE_DONE =>
        interface_in_ready <= '1';
        vs.state := STATE_IDLE;
    end case;

    ds <= vs;

  end process;

  reg_proc : process (clk)
  begin
    if rising_edge(clk) then
      -- Register new state
      rs <= ds;

      -- Reset
      if reset = '1' then
        rs.state <= STATE_IDLE;
      end if;
    end if;
  end process;
end Behavioral;