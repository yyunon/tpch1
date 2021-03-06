-- This source code is initialized by Yuksel Yonsel
-- rev 0.1 
-- Author: Yuksel Yonsel

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_misc.all;

library work;
use work.Tpch_pkg.all;
use work.Stream_pkg.all;
use work.ParallelPatterns_pkg.all;

entity PriceSummary is
  generic (
    INDEX_WIDTH : integer := 32;
    TAG_WIDTH   : integer := 1
  );
  port (
    kcd_clk                       : in std_logic;
    kcd_reset                     : in std_logic;
    l_quantity_valid              : in std_logic;
    l_quantity_ready              : out std_logic;
    l_quantity_dvalid             : in std_logic;
    l_quantity_last               : in std_logic;
    l_quantity                    : in std_logic_vector(63 downto 0);
    l_extendedprice_valid         : in std_logic;
    l_extendedprice_ready         : out std_logic;
    l_extendedprice_dvalid        : in std_logic;
    l_extendedprice_last          : in std_logic;
    l_extendedprice               : in std_logic_vector(63 downto 0);
    l_discount_valid              : in std_logic;
    l_discount_ready              : out std_logic;
    l_discount_dvalid             : in std_logic;
    l_discount_last               : in std_logic;
    l_discount                    : in std_logic_vector(63 downto 0);
    l_tax_valid                   : in std_logic;
    l_tax_ready                   : out std_logic;
    l_tax_dvalid                  : in std_logic;
    l_tax_last                    : in std_logic;
    l_tax                         : in std_logic_vector(63 downto 0);
    l_returnflag_valid            : in std_logic;
    l_returnflag_ready            : out std_logic;
    l_returnflag_dvalid           : in std_logic;
    l_returnflag_last             : in std_logic;
    l_returnflag_length           : in std_logic_vector(31 downto 0);
    l_returnflag_count            : in std_logic_vector(0 downto 0);
    l_returnflag_chars_valid      : in std_logic;
    l_returnflag_chars_ready      : out std_logic;
    l_returnflag_chars_dvalid     : in std_logic;
    l_returnflag_chars_last       : in std_logic;
    l_returnflag_chars            : in std_logic_vector(7 downto 0);
    l_returnflag_chars_count      : in std_logic_vector(0 downto 0);
    l_linestatus_valid            : in std_logic;
    l_linestatus_ready            : out std_logic;
    l_linestatus_dvalid           : in std_logic;
    l_linestatus_last             : in std_logic;
    l_linestatus_length           : in std_logic_vector(31 downto 0);
    l_linestatus_count            : in std_logic_vector(0 downto 0);
    l_linestatus_chars_valid      : in std_logic;
    l_linestatus_chars_ready      : out std_logic;
    l_linestatus_chars_dvalid     : in std_logic;
    l_linestatus_chars_last       : in std_logic;
    l_linestatus_chars            : in std_logic_vector(7 downto 0);
    l_linestatus_chars_count      : in std_logic_vector(0 downto 0);
    l_shipdate_valid              : in std_logic;
    l_shipdate_ready              : out std_logic;
    l_shipdate_dvalid             : in std_logic;
    l_shipdate_last               : in std_logic;
    l_shipdate                    : in std_logic_vector(31 downto 0);
    l_quantity_unl_valid          : in std_logic;
    l_quantity_unl_ready          : out std_logic;
    l_quantity_unl_tag            : in std_logic_vector(TAG_WIDTH - 1 downto 0);
    l_extendedprice_unl_valid     : in std_logic;
    l_extendedprice_unl_ready     : out std_logic;
    l_extendedprice_unl_tag       : in std_logic_vector(TAG_WIDTH - 1 downto 0);
    l_discount_unl_valid          : in std_logic;
    l_discount_unl_ready          : out std_logic;
    l_discount_unl_tag            : in std_logic_vector(TAG_WIDTH - 1 downto 0);
    l_tax_unl_valid               : in std_logic;
    l_tax_unl_ready               : out std_logic;
    l_tax_unl_tag                 : in std_logic_vector(TAG_WIDTH - 1 downto 0);
    l_returnflag_unl_valid        : in std_logic;
    l_returnflag_unl_ready        : out std_logic;
    l_returnflag_unl_tag          : in std_logic_vector(TAG_WIDTH - 1 downto 0);
    l_linestatus_unl_valid        : in std_logic;
    l_linestatus_unl_ready        : out std_logic;
    l_linestatus_unl_tag          : in std_logic_vector(TAG_WIDTH - 1 downto 0);
    l_shipdate_unl_valid          : in std_logic;
    l_shipdate_unl_ready          : out std_logic;
    l_shipdate_unl_tag            : in std_logic_vector(TAG_WIDTH - 1 downto 0);
    l_quantity_cmd_valid          : out std_logic;
    l_quantity_cmd_ready          : in std_logic;
    l_quantity_cmd_firstIdx       : out std_logic_vector(INDEX_WIDTH - 1 downto 0);
    l_quantity_cmd_lastIdx        : out std_logic_vector(INDEX_WIDTH - 1 downto 0);
    l_quantity_cmd_tag            : out std_logic_vector(TAG_WIDTH - 1 downto 0);
    l_extendedprice_cmd_valid     : out std_logic;
    l_extendedprice_cmd_ready     : in std_logic;
    l_extendedprice_cmd_firstIdx  : out std_logic_vector(INDEX_WIDTH - 1 downto 0);
    l_extendedprice_cmd_lastIdx   : out std_logic_vector(INDEX_WIDTH - 1 downto 0);
    l_extendedprice_cmd_tag       : out std_logic_vector(TAG_WIDTH - 1 downto 0);
    l_discount_cmd_valid          : out std_logic;
    l_discount_cmd_ready          : in std_logic;
    l_discount_cmd_firstIdx       : out std_logic_vector(INDEX_WIDTH - 1 downto 0);
    l_discount_cmd_lastIdx        : out std_logic_vector(INDEX_WIDTH - 1 downto 0);
    l_discount_cmd_tag            : out std_logic_vector(TAG_WIDTH - 1 downto 0);
    l_tax_cmd_valid               : out std_logic;
    l_tax_cmd_ready               : in std_logic;
    l_tax_cmd_firstIdx            : out std_logic_vector(INDEX_WIDTH - 1 downto 0);
    l_tax_cmd_lastIdx             : out std_logic_vector(INDEX_WIDTH - 1 downto 0);
    l_tax_cmd_tag                 : out std_logic_vector(TAG_WIDTH - 1 downto 0);
    l_returnflag_cmd_valid        : out std_logic;
    l_returnflag_cmd_ready        : in std_logic;
    l_returnflag_cmd_firstIdx     : out std_logic_vector(INDEX_WIDTH - 1 downto 0);
    l_returnflag_cmd_lastIdx      : out std_logic_vector(INDEX_WIDTH - 1 downto 0);
    l_returnflag_cmd_tag          : out std_logic_vector(TAG_WIDTH - 1 downto 0);
    l_linestatus_cmd_valid        : out std_logic;
    l_linestatus_cmd_ready        : in std_logic;
    l_linestatus_cmd_firstIdx     : out std_logic_vector(INDEX_WIDTH - 1 downto 0);
    l_linestatus_cmd_lastIdx      : out std_logic_vector(INDEX_WIDTH - 1 downto 0);
    l_linestatus_cmd_tag          : out std_logic_vector(TAG_WIDTH - 1 downto 0);
    l_shipdate_cmd_valid          : out std_logic;
    l_shipdate_cmd_ready          : in std_logic;
    l_shipdate_cmd_firstIdx       : out std_logic_vector(INDEX_WIDTH - 1 downto 0);
    l_shipdate_cmd_lastIdx        : out std_logic_vector(INDEX_WIDTH - 1 downto 0);
    l_shipdate_cmd_tag            : out std_logic_vector(TAG_WIDTH - 1 downto 0);

    l_returnflag_o_valid          : out std_logic;
    l_returnflag_o_ready          : in std_logic;
    l_returnflag_o_dvalid         : out std_logic;
    l_returnflag_o_last           : out std_logic;
    l_returnflag_o_length         : out std_logic_vector(31 downto 0);
    l_returnflag_o_count          : out std_logic_vector(0 downto 0);
    l_returnflag_o_chars_valid    : out std_logic;
    l_returnflag_o_chars_ready    : in std_logic;
    l_returnflag_o_chars_dvalid   : out std_logic;
    l_returnflag_o_chars_last     : out std_logic;
    l_returnflag_o_chars          : out std_logic_vector(7 downto 0);
    l_returnflag_o_chars_count    : out std_logic_vector(0 downto 0);
    l_linestatus_o_valid          : out std_logic;
    l_linestatus_o_ready          : in std_logic;
    l_linestatus_o_dvalid         : out std_logic;
    l_linestatus_o_last           : out std_logic;
    l_linestatus_o_length         : out std_logic_vector(31 downto 0);
    l_linestatus_o_count          : out std_logic_vector(0 downto 0);
    l_linestatus_o_chars_valid    : out std_logic;
    l_linestatus_o_chars_ready    : in std_logic;
    l_linestatus_o_chars_dvalid   : out std_logic;
    l_linestatus_o_chars_last     : out std_logic;
    l_linestatus_o_chars          : out std_logic_vector(7 downto 0);
    l_linestatus_o_chars_count    : out std_logic_vector(0 downto 0);
    l_sum_qty_valid               : out std_logic;
    l_sum_qty_ready               : in std_logic;
    l_sum_qty_dvalid              : out std_logic;
    l_sum_qty_last                : out std_logic;
    l_sum_qty                     : out std_logic_vector(63 downto 0);
    l_sum_base_price_valid        : out std_logic;
    l_sum_base_price_ready        : in std_logic;
    l_sum_base_price_dvalid       : out std_logic;
    l_sum_base_price_last         : out std_logic;
    l_sum_base_price              : out std_logic_vector(63 downto 0);
    l_sum_disc_price_valid        : out std_logic;
    l_sum_disc_price_ready        : in std_logic;
    l_sum_disc_price_dvalid       : out std_logic;
    l_sum_disc_price_last         : out std_logic;
    l_sum_disc_price              : out std_logic_vector(63 downto 0);
    l_sum_charge_valid            : out std_logic;
    l_sum_charge_ready            : in std_logic;
    l_sum_charge_dvalid           : out std_logic;
    l_sum_charge_last             : out std_logic;
    l_sum_charge                  : out std_logic_vector(63 downto 0);
    l_avg_qty_valid               : out std_logic;
    l_avg_qty_ready               : in std_logic;
    l_avg_qty_dvalid              : out std_logic;
    l_avg_qty_last                : out std_logic;
    l_avg_qty                     : out std_logic_vector(63 downto 0);
    l_avg_price_valid             : out std_logic;
    l_avg_price_ready             : in std_logic;
    l_avg_price_dvalid            : out std_logic;
    l_avg_price_last              : out std_logic;
    l_avg_price                   : out std_logic_vector(63 downto 0);
    l_avg_disc_valid              : out std_logic;
    l_avg_disc_ready              : in std_logic;
    l_avg_disc_dvalid             : out std_logic;
    l_avg_disc_last               : out std_logic;
    l_avg_disc                    : out std_logic_vector(63 downto 0);
    l_count_order_valid           : out std_logic;
    l_count_order_ready           : in std_logic;
    l_count_order_dvalid          : out std_logic;
    l_count_order_last            : out std_logic;
    l_count_order                 : out std_logic_vector(63 downto 0);
    l_returnflag_o_unl_valid      : in std_logic;
    l_returnflag_o_unl_ready      : out std_logic;
    l_returnflag_o_unl_tag        : in std_logic_vector(TAG_WIDTH - 1 downto 0);
    l_linestatus_o_unl_valid      : in std_logic;
    l_linestatus_o_unl_ready      : out std_logic;
    l_linestatus_o_unl_tag        : in std_logic_vector(TAG_WIDTH - 1 downto 0);
    l_sum_qty_unl_valid           : in std_logic;
    l_sum_qty_unl_ready           : out std_logic;
    l_sum_qty_unl_tag             : in std_logic_vector(TAG_WIDTH - 1 downto 0);
    l_sum_base_price_unl_valid    : in std_logic;
    l_sum_base_price_unl_ready    : out std_logic;
    l_sum_base_price_unl_tag      : in std_logic_vector(TAG_WIDTH - 1 downto 0);
    l_sum_disc_price_unl_valid    : in std_logic;
    l_sum_disc_price_unl_ready    : out std_logic;
    l_sum_disc_price_unl_tag      : in std_logic_vector(TAG_WIDTH - 1 downto 0);
    l_sum_charge_unl_valid        : in std_logic;
    l_sum_charge_unl_ready        : out std_logic;
    l_sum_charge_unl_tag          : in std_logic_vector(TAG_WIDTH - 1 downto 0);
    l_avg_qty_unl_valid           : in std_logic;
    l_avg_qty_unl_ready           : out std_logic;
    l_avg_qty_unl_tag             : in std_logic_vector(TAG_WIDTH - 1 downto 0);
    l_avg_price_unl_valid         : in std_logic;
    l_avg_price_unl_ready         : out std_logic;
    l_avg_price_unl_tag           : in std_logic_vector(TAG_WIDTH - 1 downto 0);
    l_avg_disc_unl_valid          : in std_logic;
    l_avg_disc_unl_ready          : out std_logic;
    l_avg_disc_unl_tag            : in std_logic_vector(TAG_WIDTH - 1 downto 0);
    l_count_order_unl_valid       : in std_logic;
    l_count_order_unl_ready       : out std_logic;
    l_count_order_unl_tag         : in std_logic_vector(TAG_WIDTH - 1 downto 0);
    l_returnflag_o_cmd_valid      : out std_logic;
    l_returnflag_o_cmd_ready      : in std_logic;
    l_returnflag_o_cmd_firstIdx   : out std_logic_vector(INDEX_WIDTH - 1 downto 0);
    l_returnflag_o_cmd_lastIdx    : out std_logic_vector(INDEX_WIDTH - 1 downto 0);
    l_returnflag_o_cmd_tag        : out std_logic_vector(TAG_WIDTH - 1 downto 0);
    l_linestatus_o_cmd_valid      : out std_logic;
    l_linestatus_o_cmd_ready      : in std_logic;
    l_linestatus_o_cmd_firstIdx   : out std_logic_vector(INDEX_WIDTH - 1 downto 0);
    l_linestatus_o_cmd_lastIdx    : out std_logic_vector(INDEX_WIDTH - 1 downto 0);
    l_linestatus_o_cmd_tag        : out std_logic_vector(TAG_WIDTH - 1 downto 0);
    l_sum_qty_cmd_valid           : out std_logic;
    l_sum_qty_cmd_ready           : in std_logic;
    l_sum_qty_cmd_firstIdx        : out std_logic_vector(INDEX_WIDTH - 1 downto 0);
    l_sum_qty_cmd_lastIdx         : out std_logic_vector(INDEX_WIDTH - 1 downto 0);
    l_sum_qty_cmd_tag             : out std_logic_vector(TAG_WIDTH - 1 downto 0);
    l_sum_base_price_cmd_valid    : out std_logic;
    l_sum_base_price_cmd_ready    : in std_logic;
    l_sum_base_price_cmd_firstIdx : out std_logic_vector(INDEX_WIDTH - 1 downto 0);
    l_sum_base_price_cmd_lastIdx  : out std_logic_vector(INDEX_WIDTH - 1 downto 0);
    l_sum_base_price_cmd_tag      : out std_logic_vector(TAG_WIDTH - 1 downto 0);
    l_sum_disc_price_cmd_valid    : out std_logic;
    l_sum_disc_price_cmd_ready    : in std_logic;
    l_sum_disc_price_cmd_firstIdx : out std_logic_vector(INDEX_WIDTH - 1 downto 0);
    l_sum_disc_price_cmd_lastIdx  : out std_logic_vector(INDEX_WIDTH - 1 downto 0);
    l_sum_disc_price_cmd_tag      : out std_logic_vector(TAG_WIDTH - 1 downto 0);
    l_sum_charge_cmd_valid        : out std_logic;
    l_sum_charge_cmd_ready        : in std_logic;
    l_sum_charge_cmd_firstIdx     : out std_logic_vector(INDEX_WIDTH - 1 downto 0);
    l_sum_charge_cmd_lastIdx      : out std_logic_vector(INDEX_WIDTH - 1 downto 0);
    l_sum_charge_cmd_tag          : out std_logic_vector(TAG_WIDTH - 1 downto 0);
    l_avg_qty_cmd_valid           : out std_logic;
    l_avg_qty_cmd_ready           : in std_logic;
    l_avg_qty_cmd_firstIdx        : out std_logic_vector(INDEX_WIDTH - 1 downto 0);
    l_avg_qty_cmd_lastIdx         : out std_logic_vector(INDEX_WIDTH - 1 downto 0);
    l_avg_qty_cmd_tag             : out std_logic_vector(TAG_WIDTH - 1 downto 0);
    l_avg_price_cmd_valid         : out std_logic;
    l_avg_price_cmd_ready         : in std_logic;
    l_avg_price_cmd_firstIdx      : out std_logic_vector(INDEX_WIDTH - 1 downto 0);
    l_avg_price_cmd_lastIdx       : out std_logic_vector(INDEX_WIDTH - 1 downto 0);
    l_avg_price_cmd_tag           : out std_logic_vector(TAG_WIDTH - 1 downto 0);
    l_avg_disc_cmd_valid          : out std_logic;
    l_avg_disc_cmd_ready          : in std_logic;
    l_avg_disc_cmd_firstIdx       : out std_logic_vector(INDEX_WIDTH - 1 downto 0);
    l_avg_disc_cmd_lastIdx        : out std_logic_vector(INDEX_WIDTH - 1 downto 0);
    l_avg_disc_cmd_tag            : out std_logic_vector(TAG_WIDTH - 1 downto 0);
    l_count_order_cmd_valid       : out std_logic;
    l_count_order_cmd_ready       : in std_logic;
    l_count_order_cmd_firstIdx    : out std_logic_vector(INDEX_WIDTH - 1 downto 0);
    l_count_order_cmd_lastIdx     : out std_logic_vector(INDEX_WIDTH - 1 downto 0);
    l_count_order_cmd_tag         : out std_logic_vector(TAG_WIDTH - 1 downto 0);
    start                         : in std_logic;
    stop                          : in std_logic;
    reset                         : in std_logic;
    idle                          : out std_logic;
    busy                          : out std_logic;
    done                          : out std_logic;
    result                        : out std_logic_vector(63 downto 0);
    l_firstidx                    : in std_logic_vector(31 downto 0);
    l_lastidx                     : in std_logic_vector(31 downto 0);
    l_o_firstidx                  : in std_logic_vector(31 downto 0);
    l_o_lastidx                   : in std_logic_vector(31 downto 0);
    rhigh                         : out std_logic_vector(31 downto 0);
    rlow                          : out std_logic_vector(31 downto 0);
    status_1                      : out std_logic_vector(31 downto 0);
    status_2                      : out std_logic_vector(31 downto 0);
    r1                            : out std_logic_vector(63 downto 0);
    r2                            : out std_logic_vector(63 downto 0);
    r3                            : out std_logic_vector(63 downto 0);
    r4                            : out std_logic_vector(63 downto 0);
    r5                            : out std_logic_vector(63 downto 0);
    r6                            : out std_logic_vector(63 downto 0);
    r7                            : out std_logic_vector(63 downto 0);
    r8                            : out std_logic_vector(63 downto 0)
  );
end entity;

architecture Implementation of PriceSummary is

  constant DATA_WIDTH            : integer := 64;
  constant LEN_WIDTH             : integer := 8;
  constant EPC                   : integer := 8;
  constant FIXED_LEFT_INDEX      : integer := 45;
  constant FIXED_RIGHT_INDEX     : integer := FIXED_LEFT_INDEX - (DATA_WIDTH - 1);

  constant SYNC_IN_BUFFER_DEPTH  : integer := 0;
  constant SYNC_OUT_BUFFER_DEPTH : integer := 0;

  -- If the input stream size is not divisible by EPC check this:
  signal pu_mask                 : std_logic_vector(EPC - 1 downto 0);
  -- Enumeration type for our state machine.
  -- Fletcher command stream
  type cmd_record is record
    valid    : std_logic;
    firstIdx : std_logic_vector(INDEX_WIDTH - 1 downto 0);
    lastIdx  : std_logic_vector(INDEX_WIDTH - 1 downto 0);
    tag      : std_logic_vector(TAG_WIDTH - 1 downto 0);
  end record;

  -- UTF8 string gen command stream
  type str_record is record
    valid : std_logic;
    len   : std_logic_vector(INDEX_WIDTH - 1 downto 0);
    min   : std_logic_vector(LEN_WIDTH - 1 downto 0);
    mask  : std_logic_vector(LEN_WIDTH - 1 downto 0);
  end record;

  -- Unlock ready signal
  type unl_record is record
    ready : std_logic;
  end record;

  -- Outputs
  type out_record is record
    cmd : cmd_record;
    str : str_record;
    unl : unl_record;
  end record;
  type state_t is (STATE_IDLE,
    STATE_COMMAND,
    STATE_BUILD,
    STATE_BUILD_UNLOCK,
    STATE_INTERFACE_CMD,
    STATE_INTERFACE,
    STATE_UNLOCK,
    STATE_DONE);
  signal state_slv             : std_logic_vector(2 downto 0);
  -- Current state register and next state signal.
  signal state, state_next     : state_t;

  signal pu_cmd_in_valid       : std_logic;
  signal pu_cmd_in_ready       : std_logic;
  signal pu_interface_in_valid : std_logic;
  signal pu_interface_in_ready : std_logic;
  signal output_first_idx      : std_logic_vector(32 - 1 downto 0);
  signal output_last_idx       : std_logic_vector(32 - 1 downto 0);

  --unlock stream signals
  signal pricesummary_valid    : std_logic;
  signal pricesummary_ready    : std_logic;

begin
  processing_unit_0 : PU
  generic map(
    FIXED_LEFT_INDEX  => FIXED_LEFT_INDEX,
    FIXED_RIGHT_INDEX => FIXED_RIGHT_INDEX,
    DATA_WIDTH        => 64,
    TAG_WIDTH         => TAG_WIDTH,
    LEN_WIDTH         => LEN_WIDTH,
    INDEX_WIDTH       => INDEX_WIDTH,
    CONVERTERS        => "FLOAT_TO_FIXED", -- TODO: Implement this
    ILA               => "TRUE"
  )
  port map(
    clk                         => kcd_clk,
    reset                       => kcd_reset or reset,

    l_quantity_valid            => l_quantity_valid,
    l_quantity_ready            => l_quantity_ready,
    l_quantity_dvalid           => l_quantity_dvalid,
    l_quantity_last             => l_quantity_last,
    l_quantity                  => l_quantity,
    l_extendedprice_valid       => l_extendedprice_valid,
    l_extendedprice_ready       => l_extendedprice_ready,
    l_extendedprice_dvalid      => l_extendedprice_dvalid,
    l_extendedprice_last        => l_extendedprice_last,
    l_extendedprice             => l_extendedprice,
    l_discount_valid            => l_discount_valid,
    l_discount_ready            => l_discount_ready,
    l_discount_dvalid           => l_discount_dvalid,
    l_discount_last             => l_discount_last,
    l_discount                  => l_discount,
    l_tax_valid                 => l_tax_valid,
    l_tax_ready                 => l_tax_ready,
    l_tax_dvalid                => l_tax_dvalid,
    l_tax_last                  => l_tax_last,
    l_tax                       => l_tax,
    l_returnflag_valid          => l_returnflag_valid,
    l_returnflag_ready          => l_returnflag_ready,
    l_returnflag_dvalid         => l_returnflag_dvalid,
    l_returnflag_last           => l_returnflag_last,
    l_returnflag_length         => l_returnflag_length,
    l_returnflag_count          => l_returnflag_count,
    l_returnflag_chars_valid    => l_returnflag_chars_valid,
    l_returnflag_chars_ready    => l_returnflag_chars_ready,
    l_returnflag_chars_dvalid   => l_returnflag_chars_dvalid,
    l_returnflag_chars_last     => l_returnflag_chars_last,
    l_returnflag_chars          => l_returnflag_chars,
    l_returnflag_chars_count    => l_returnflag_chars_count,
    l_linestatus_valid          => l_linestatus_valid,
    l_linestatus_ready          => l_linestatus_ready,
    l_linestatus_dvalid         => l_linestatus_dvalid,
    l_linestatus_last           => l_linestatus_last,
    l_linestatus_length         => l_linestatus_length,
    l_linestatus_count          => l_linestatus_count,
    l_linestatus_chars_valid    => l_linestatus_chars_valid,
    l_linestatus_chars_ready    => l_linestatus_chars_ready,
    l_linestatus_chars_dvalid   => l_linestatus_chars_dvalid,
    l_linestatus_chars_last     => l_linestatus_chars_last,
    l_linestatus_chars          => l_linestatus_chars,
    l_linestatus_chars_count    => l_linestatus_chars_count,
    l_shipdate_valid            => l_shipdate_valid,
    l_shipdate_ready            => l_shipdate_ready,
    l_shipdate_dvalid           => l_shipdate_dvalid,
    l_shipdate_last             => l_shipdate_last,
    l_shipdate                  => l_shipdate,
    l_returnflag_o_valid        => l_returnflag_o_valid,
    l_returnflag_o_ready        => l_returnflag_o_ready,
    l_returnflag_o_dvalid       => l_returnflag_o_dvalid,
    l_returnflag_o_last         => l_returnflag_o_last,
    l_returnflag_o_length       => l_returnflag_o_length,
    l_returnflag_o_count        => l_returnflag_o_count,
    l_returnflag_o_chars_valid  => l_returnflag_o_chars_valid,
    l_returnflag_o_chars_ready  => l_returnflag_o_chars_ready,
    l_returnflag_o_chars_dvalid => l_returnflag_o_chars_dvalid,
    l_returnflag_o_chars_last   => l_returnflag_o_chars_last,
    l_returnflag_o_chars        => l_returnflag_o_chars,
    l_returnflag_o_chars_count  => l_returnflag_o_chars_count,
    l_linestatus_o_valid        => l_linestatus_o_valid,
    l_linestatus_o_ready        => l_linestatus_o_ready,
    l_linestatus_o_dvalid       => l_linestatus_o_dvalid,
    l_linestatus_o_last         => l_linestatus_o_last,
    l_linestatus_o_length       => l_linestatus_o_length,
    l_linestatus_o_count        => l_linestatus_o_count,
    l_linestatus_o_chars_valid  => l_linestatus_o_chars_valid,
    l_linestatus_o_chars_ready  => l_linestatus_o_chars_ready,
    l_linestatus_o_chars_dvalid => l_linestatus_o_chars_dvalid,
    l_linestatus_o_chars_last   => l_linestatus_o_chars_last,
    l_linestatus_o_chars        => l_linestatus_o_chars,
    l_linestatus_o_chars_count  => l_linestatus_o_chars_count,
    l_sum_qty_valid             => l_sum_qty_valid,
    l_sum_qty_ready             => l_sum_qty_ready,
    l_sum_qty_dvalid            => l_sum_qty_dvalid,
    l_sum_qty_last              => l_sum_qty_last,
    l_sum_qty                   => l_sum_qty,
    l_sum_base_price_valid      => l_sum_base_price_valid,
    l_sum_base_price_ready      => l_sum_base_price_ready,
    l_sum_base_price_dvalid     => l_sum_base_price_dvalid,
    l_sum_base_price_last       => l_sum_base_price_last,
    l_sum_base_price            => l_sum_base_price,
    l_sum_disc_price_valid      => l_sum_disc_price_valid,
    l_sum_disc_price_ready      => l_sum_disc_price_ready,
    l_sum_disc_price_dvalid     => l_sum_disc_price_dvalid,
    l_sum_disc_price_last       => l_sum_disc_price_last,
    l_sum_disc_price            => l_sum_disc_price,
    l_sum_charge_valid          => l_sum_charge_valid,
    l_sum_charge_ready          => l_sum_charge_ready,
    l_sum_charge_dvalid         => l_sum_charge_dvalid,
    l_sum_charge_last           => l_sum_charge_last,
    l_sum_charge                => l_sum_charge,
    l_avg_qty_valid             => l_avg_qty_valid,
    l_avg_qty_ready             => l_avg_qty_ready,
    l_avg_qty_dvalid            => l_avg_qty_dvalid,
    l_avg_qty_last              => l_avg_qty_last,
    l_avg_qty                   => l_avg_qty,
    l_avg_price_valid           => l_avg_price_valid,
    l_avg_price_ready           => l_avg_price_ready,
    l_avg_price_dvalid          => l_avg_price_dvalid,
    l_avg_price_last            => l_avg_price_last,
    l_avg_price                 => l_avg_price,
    l_avg_disc_valid            => l_avg_disc_valid,
    l_avg_disc_ready            => l_avg_disc_ready,
    l_avg_disc_dvalid           => l_avg_disc_dvalid,
    l_avg_disc_last             => l_avg_disc_last,
    l_avg_disc                  => l_avg_disc,
    l_count_order_valid         => l_count_order_valid,
    l_count_order_ready         => l_count_order_ready,
    l_count_order_dvalid        => l_count_order_dvalid,
    l_count_order_last          => l_count_order_last,
    l_count_order               => l_count_order,
    --Status regs
    result                      => result,
    output_first_idx            => output_first_idx,
    output_last_idx             => output_last_idx,
    cmd_in_valid                => pu_cmd_in_valid,
    cmd_in_ready                => pu_cmd_in_ready,
    interface_in_valid          => pu_interface_in_valid,
    interface_in_ready          => pu_interface_in_ready

  );

  with state select state_slv <=
    "000" when STATE_IDLE,
    "001" when STATE_COMMAND,
    "010" when STATE_BUILD,
    "011" when STATE_INTERFACE,
    "100" when STATE_UNLOCK,
    "101" when others;

  combinatorial_proc : process (
    l_firstIdx,
    l_lastIdx,
    l_o_firstIdx,
    l_o_lastIdx,

    l_quantity_unl_valid,
    l_extendedprice_unl_valid,
    l_discount_unl_valid,
    l_tax_unl_valid,
    l_returnflag_unl_valid,
    l_linestatus_unl_valid,
    l_shipdate_unl_valid,
    l_quantity_cmd_ready,
    l_extendedprice_cmd_ready,
    l_discount_cmd_ready,
    l_tax_cmd_ready,
    l_returnflag_cmd_ready,
    l_linestatus_cmd_ready,
    l_shipdate_cmd_ready,

    pricesummary_valid,
    --l_count_order_unl_valid,
    --l_avg_disc_unl_valid,
    --l_avg_price_unl_valid,
    --l_avg_qty_unl_valid,
    --l_sum_charge_unl_valid,
    --l_sum_disc_price_unl_valid,
    --l_sum_base_price_unl_valid,
    --l_linestatus_o_unl_valid,
    --l_sum_qty_unl_valid,
    --l_returnflag_o_unl_valid,

    l_count_order_cmd_ready,
    l_avg_disc_cmd_ready,
    l_avg_price_cmd_ready,
    l_avg_qty_cmd_ready,
    l_sum_charge_cmd_ready,
    l_sum_disc_price_cmd_ready,
    l_sum_base_price_cmd_ready,
    l_linestatus_o_cmd_ready,
    l_sum_qty_cmd_ready,
    l_returnflag_o_cmd_ready,

    pu_cmd_in_ready,
    pu_interface_in_ready,

    state,
    start,
    reset,
    kcd_reset
    ) is
    variable l_returnflag_o   : out_record;
    variable l_linestatus_o   : out_record;
    variable l_sum_qty        : out_record;
    variable l_sum_base       : out_record;
    variable l_sum_disc_price : out_record;
    variable l_sum_charge     : out_record;
    variable l_avg_qty        : out_record;
    variable l_avg_price      : out_record;
    variable l_avg_disc       : out_record;
    variable l_count_order    : out_record;
  begin
    done                         <= '0';
    busy                         <= '0';
    idle                         <= '1';

    --Input stream
    l_quantity_cmd_valid         <= '0';
    l_quantity_cmd_firstIdx      <= (others => '0');
    l_quantity_cmd_lastIdx       <= (others => '0');
    l_quantity_cmd_tag           <= (others => '0');

    l_discount_cmd_valid         <= '0';
    l_discount_cmd_firstIdx      <= (others => '0');
    l_discount_cmd_lastIdx       <= (others => '0');
    l_discount_cmd_tag           <= (others => '0');

    l_shipdate_cmd_valid         <= '0';
    l_shipdate_cmd_firstIdx      <= (others => '0');
    l_shipdate_cmd_lastIdx       <= (others => '0');
    l_shipdate_cmd_tag           <= (others => '0');

    l_returnflag_cmd_valid       <= '0';
    l_returnflag_cmd_firstIdx    <= (others => '0');
    l_returnflag_cmd_lastIdx     <= (others => '0');
    l_returnflag_cmd_tag         <= (others => '0');

    l_tax_cmd_valid              <= '0';
    l_tax_cmd_firstIdx           <= (others => '0');
    l_tax_cmd_lastIdx            <= (others => '0');
    l_tax_cmd_tag                <= (others => '0');

    l_extendedprice_cmd_valid    <= '0';
    l_extendedprice_cmd_firstIdx <= (others => '0');
    l_extendedprice_cmd_lastIdx  <= (others => '0');
    l_extendedprice_cmd_tag      <= (others => '0');

    l_linestatus_cmd_valid       <= '0';
    l_linestatus_cmd_firstIdx    <= (others => '0');
    l_linestatus_cmd_lastIdx     <= (others => '0');
    l_linestatus_cmd_tag         <= (others => '0');
    --Output stream
    -- Disable command streams by default
    l_returnflag_o.str.valid      := '0';
    l_returnflag_o.unl.ready      := '0';
    l_returnflag_o.cmd.valid      := '0';
    l_returnflag_o.cmd.firstIdx   := (others => '0');
    l_returnflag_o.cmd.lastIdx    := (others => '0');
    l_returnflag_o.cmd.tag        := (others => '0');

    l_linestatus_o.str.valid      := '0';
    l_linestatus_o.unl.ready      := '0';
    l_linestatus_o.cmd.valid      := '0';
    l_linestatus_o.cmd.firstIdx   := (others => '0');
    l_linestatus_o.cmd.lastIdx    := (others => '0');
    l_linestatus_o.cmd.tag        := (others => '0');

    l_sum_qty.str.valid           := '0';
    l_sum_qty.unl.ready           := '0';
    l_sum_qty.cmd.valid           := '0';
    l_sum_qty.cmd.firstIdx        := (others => '0');
    l_sum_qty.cmd.lastIdx         := (others => '0');
    l_sum_qty.cmd.tag             := (others => '0');

    l_sum_base.str.valid          := '0';
    l_sum_base.unl.ready          := '0';
    l_sum_base.cmd.valid          := '0';
    l_sum_base.cmd.firstIdx       := (others => '0');
    l_sum_base.cmd.lastIdx        := (others => '0');
    l_sum_base.cmd.tag            := (others => '0');

    l_sum_disc_price.str.valid    := '0';
    l_sum_disc_price.unl.ready    := '0';
    l_sum_disc_price.cmd.valid    := '0';
    l_sum_disc_price.cmd.firstIdx := (others => '0');
    l_sum_disc_price.cmd.lastIdx  := (others => '0');
    l_sum_disc_price.cmd.tag      := (others => '0');

    l_sum_charge.str.valid        := '0';
    l_sum_charge.unl.ready        := '0';
    l_sum_charge.cmd.valid        := '0';
    l_sum_charge.cmd.firstIdx     := (others => '0');
    l_sum_charge.cmd.lastIdx      := (others => '0');
    l_sum_charge.cmd.tag          := (others => '0');

    l_avg_qty.str.valid           := '0';
    l_avg_qty.unl.ready           := '0';
    l_avg_qty.cmd.valid           := '0';
    l_avg_qty.cmd.firstIdx        := (others => '0');
    l_avg_qty.cmd.lastIdx         := (others => '0');
    l_avg_qty.cmd.tag             := (others => '0');

    l_avg_price.str.valid         := '0';
    l_avg_price.unl.ready         := '0';
    l_avg_price.cmd.valid         := '0';
    l_avg_price.cmd.firstIdx      := (others => '0');
    l_avg_price.cmd.lastIdx       := (others => '0');
    l_avg_price.cmd.tag           := (others => '0');

    l_avg_disc.str.valid          := '0';
    l_avg_disc.unl.ready          := '0';
    l_avg_disc.cmd.valid          := '0';
    l_avg_disc.cmd.firstIdx       := (others => '0');
    l_avg_disc.cmd.lastIdx        := (others => '0');
    l_avg_disc.cmd.tag            := (others => '0');

    l_count_order.str.valid       := '0';
    l_count_order.unl.ready       := '0';
    l_count_order.cmd.valid       := '0';
    l_count_order.cmd.firstIdx    := (others => '0');
    l_count_order.cmd.lastIdx     := (others => '0');
    l_count_order.cmd.tag         := (others => '0');

    state_next                <= state; -- Retain current state.

    l_quantity_unl_ready      <= '0';
    l_extendedprice_unl_ready <= '0';
    l_discount_unl_ready      <= '0';
    l_tax_unl_ready           <= '0';
    l_returnflag_unl_ready    <= '0';
    l_linestatus_unl_ready    <= '0';
    l_shipdate_unl_ready      <= '0';

    pu_cmd_in_valid           <= '0';
    pu_interface_in_valid     <= '0';
    pricesummary_ready        <= '1';

    case state is
      when STATE_IDLE =>
        -- Idle: We just wait for the start bit to come up.
        done <= '0';
        busy <= '0';
        idle <= '1';

        -- Wait for the start signal (typically controlled by the host-side 
        -- software).
        if start = '1' then
          state_next <= STATE_COMMAND;
        end if;

      when STATE_COMMAND =>
        -- Command: we send a command to the generated interface.
        done                         <= '0';
        busy                         <= '1';
        idle                         <= '0';
        l_quantity_cmd_valid         <= '1';
        l_quantity_cmd_firstIdx      <= l_firstIdx;
        l_quantity_cmd_lastIdx       <= l_lastIdx;
        l_quantity_cmd_tag           <= (others => '0');

        l_extendedprice_cmd_valid    <= '1';
        l_extendedprice_cmd_firstIdx <= l_firstIdx;
        l_extendedprice_cmd_lastIdx  <= l_lastIdx;
        l_extendedprice_cmd_tag      <= (others => '0');

        l_returnflag_cmd_valid       <= '1';
        l_returnflag_cmd_firstIdx    <= l_firstIdx;
        l_returnflag_cmd_lastIdx     <= l_lastIdx;
        l_returnflag_cmd_tag         <= (others => '0');

        l_discount_cmd_valid         <= '1';
        l_discount_cmd_firstIdx      <= l_firstIdx;
        l_discount_cmd_lastIdx       <= l_lastIdx;
        l_discount_cmd_tag           <= (others => '0');

        l_tax_cmd_valid              <= '1';
        l_tax_cmd_firstIdx           <= l_firstIdx;
        l_tax_cmd_lastIdx            <= l_lastIdx;
        l_tax_cmd_tag                <= (others => '0');

        l_shipdate_cmd_valid         <= '1';
        l_shipdate_cmd_firstIdx      <= l_firstIdx;
        l_shipdate_cmd_lastIdx       <= l_lastIdx;
        l_shipdate_cmd_tag           <= (others => '0');

        l_linestatus_cmd_valid       <= '1';
        l_linestatus_cmd_firstIdx    <= l_firstIdx;
        l_linestatus_cmd_lastIdx     <= l_lastIdx;
        l_linestatus_cmd_tag         <= (others => '0');

        if l_quantity_cmd_ready = '1' and l_extendedprice_cmd_ready = '1' and l_shipdate_cmd_ready = '1' and l_discount_cmd_ready = '1' and l_linestatus_cmd_ready = '1' and l_tax_cmd_ready = '1' and l_returnflag_cmd_ready = '1' then
          state_next <= STATE_BUILD;
        end if;

      when STATE_BUILD =>
        -- Calculating: we stream in and accumulate the numbers one by one. PROBE Phase is here!
        done            <= '0';
        busy            <= '1';
        idle            <= '0';

        pu_cmd_in_valid <= '1';
        if pu_cmd_in_ready = '1' then
          state_next <= STATE_BUILD_UNLOCK;
        end if;

      when STATE_BUILD_UNLOCK => -- We unlock the build stream
        done                      <= '0';
        busy                      <= '1';
        idle                      <= '0';
        -- Ready to handshake the unlock stream:
        l_quantity_unl_ready      <= '1';
        l_discount_unl_ready      <= '1';
        l_shipdate_unl_ready      <= '1';
        l_extendedprice_unl_ready <= '1';
        l_tax_unl_ready           <= '1';
        l_linestatus_unl_ready    <= '1';
        l_returnflag_unl_ready    <= '1';
        if l_discount_unl_valid = '1' and l_quantity_unl_valid = '1' and l_shipdate_unl_valid = '1' and l_extendedprice_unl_valid = '1' and l_linestatus_unl_valid = '1' and l_tax_unl_valid = '1' and l_returnflag_unl_valid = '1' then
          state_next <= STATE_INTERFACE_CMD;
        end if;

      when STATE_INTERFACE_CMD =>
        l_returnflag_o.cmd.valid      := '1';
        l_returnflag_o.cmd.firstIdx   := l_o_firstidx;
        l_returnflag_o.cmd.lastIdx    := l_o_lastidx;
        l_returnflag_o.cmd.tag        := (others => '0');

        l_linestatus_o.cmd.valid      := '1';
        l_linestatus_o.cmd.firstIdx   := l_o_firstidx;
        l_linestatus_o.cmd.lastIdx    := l_o_lastidx;
        l_linestatus_o.cmd.tag        := (others => '0');

        l_sum_qty.cmd.valid           := '1';
        l_sum_qty.cmd.firstIdx        := l_o_firstidx;
        l_sum_qty.cmd.lastIdx         := l_o_lastidx;
        l_sum_qty.cmd.tag             := (others => '0');

        l_sum_base.cmd.valid          := '1';
        l_sum_base.cmd.firstIdx       := l_o_firstidx;
        l_sum_base.cmd.lastIdx        := l_o_lastidx;
        l_sum_base.cmd.tag            := (others => '0');

        l_sum_disc_price.cmd.valid    := '1';
        l_sum_disc_price.cmd.firstIdx := l_o_firstidx;
        l_sum_disc_price.cmd.lastIdx  := l_o_lastidx;
        l_sum_disc_price.cmd.tag      := (others => '0');

        l_sum_charge.cmd.valid        := '1';
        l_sum_charge.cmd.firstIdx     := l_o_firstidx;
        l_sum_charge.cmd.lastIdx      := l_o_lastidx;
        l_sum_charge.cmd.tag          := (others => '0');

        l_avg_qty.cmd.valid           := '1';
        l_avg_qty.cmd.firstIdx        := l_o_firstidx;
        l_avg_qty.cmd.lastIdx         := l_o_lastidx;
        l_avg_qty.cmd.tag             := (others => '0');

        l_avg_price.cmd.valid         := '1';
        l_avg_price.cmd.firstIdx      := l_o_firstidx;
        l_avg_price.cmd.lastIdx       := l_o_lastidx;
        l_avg_price.cmd.tag           := (others => '0');

        l_avg_disc.cmd.valid          := '1';
        l_avg_disc.cmd.firstIdx       := l_o_firstidx;
        l_avg_disc.cmd.lastIdx        := l_o_lastidx;
        l_avg_disc.cmd.tag            := (others => '0');

        l_count_order.cmd.valid       := '1';
        l_count_order.cmd.firstIdx    := l_o_firstidx;
        l_count_order.cmd.lastIdx     := l_o_lastidx;
        l_count_order.cmd.tag         := (others => '0');

        if l_count_order_cmd_ready = '1' and l_avg_disc_cmd_ready = '1' and l_avg_price_cmd_ready = '1' and l_avg_qty_cmd_ready = '1' and l_sum_charge_cmd_ready = '1' and l_sum_disc_price_cmd_ready = '1' and l_sum_base_price_cmd_ready = '1' and l_linestatus_o_cmd_ready = '1' and l_sum_qty_cmd_ready = '1' and l_returnflag_o_cmd_ready = '1' then
          state_next <= STATE_INTERFACE;
        end if;
      when STATE_INTERFACE =>
        pu_interface_in_valid <= '1';
        if pu_interface_in_ready = '1' then
          state_next <= STATE_UNLOCK;
        end if;
      when STATE_UNLOCK =>
        -- Unlock: the generated interface delivered all items in the stream.
        -- The unlock stream is supplied to make sure all bus transfers of the
        -- corresponding command are completed.
        done               <= '0';
        busy               <= '0';
        idle               <= '1';

        -- Unlock the output stream too
        pricesummary_ready <= '1';
        -- Handshake when it is valid and go to the done state.
        --if l_count_order_unl_valid = '1' and l_avg_disc_unl_valid = '1' and l_avg_price_unl_valid = '1' and l_avg_qty_unl_valid = '1' and l_sum_charge_unl_valid = '1' and l_sum_disc_price_unl_valid = '1' and l_sum_base_price_unl_valid = '1' and l_sum_qty_unl_valid = '1' and l_returnflag_o_unl_valid = '1' and l_linestatus_o_unl_valid = '1' then
        if pricesummary_valid = '1' then
          state_next <= STATE_DONE;
        end if;

      when STATE_DONE =>
        -- Done: the kernel is done with its job.
        done <= '1';
        busy <= '0';
        idle <= '1';
        if reset = '1' then
          state_next <= STATE_IDLE;
        end if;
        -- Wait for the reset signal (typically controlled by the host-side 
        -- software), so we can go to idle again. This reset is not to be
        -- confused with the system-wide reset that travels into the kernel
        -- alongside the clock (kcd_reset).        
    end case;

    l_returnflag_o_cmd_valid      <= l_returnflag_o.cmd.valid;
    l_returnflag_o_cmd_firstIdx   <= l_returnflag_o.cmd.firstIdx;
    l_returnflag_o_cmd_lastIdx    <= l_returnflag_o.cmd.lastIdx;
    l_returnflag_o_cmd_tag        <= l_returnflag_o.cmd.tag;

    l_linestatus_o_cmd_valid      <= l_linestatus_o.cmd.valid;
    l_linestatus_o_cmd_firstIdx   <= l_linestatus_o.cmd.firstIdx;
    l_linestatus_o_cmd_lastIdx    <= l_linestatus_o.cmd.lastIdx;
    l_linestatus_o_cmd_tag        <= l_linestatus_o.cmd.tag;

    l_sum_qty_cmd_valid           <= l_sum_qty.cmd.valid;
    l_sum_qty_cmd_firstIdx        <= l_sum_qty.cmd.firstIdx;
    l_sum_qty_cmd_lastIdx         <= l_sum_qty.cmd.lastIdx;
    l_sum_qty_cmd_tag             <= l_sum_qty.cmd.tag;

    l_sum_base_price_cmd_valid    <= l_sum_base.cmd.valid;
    l_sum_base_price_cmd_firstIdx <= l_sum_base.cmd.firstIdx;
    l_sum_base_price_cmd_lastIdx  <= l_sum_base.cmd.lastIdx;
    l_sum_base_price_cmd_tag      <= l_sum_base.cmd.tag;

    l_sum_disc_price_cmd_valid    <= l_sum_disc_price.cmd.valid;
    l_sum_disc_price_cmd_firstIdx <= l_sum_disc_price.cmd.firstIdx;
    l_sum_disc_price_cmd_lastIdx  <= l_sum_disc_price.cmd.lastIdx;
    l_sum_disc_price_cmd_tag      <= l_sum_disc_price.cmd.tag;

    l_sum_charge_cmd_valid        <= l_sum_charge.cmd.valid;
    l_sum_charge_cmd_firstIdx     <= l_sum_charge.cmd.firstIdx;
    l_sum_charge_cmd_lastIdx      <= l_sum_charge.cmd.lastIdx;
    l_sum_charge_cmd_tag          <= l_sum_charge.cmd.tag;

    l_avg_qty_cmd_valid           <= l_avg_qty.cmd.valid;
    l_avg_qty_cmd_firstIdx        <= l_avg_qty.cmd.firstIdx;
    l_avg_qty_cmd_lastIdx         <= l_avg_qty.cmd.lastIdx;
    l_avg_qty_cmd_tag             <= l_avg_qty.cmd.tag;

    l_avg_price_cmd_valid         <= l_avg_price.cmd.valid;
    l_avg_price_cmd_firstIdx      <= l_avg_price.cmd.firstIdx;
    l_avg_price_cmd_lastIdx       <= l_avg_price.cmd.lastIdx;
    l_avg_price_cmd_tag           <= l_avg_price.cmd.tag;

    l_avg_disc_cmd_valid          <= l_avg_disc.cmd.valid;
    l_avg_disc_cmd_firstIdx       <= l_avg_disc.cmd.firstIdx;
    l_avg_disc_cmd_lastIdx        <= l_avg_disc.cmd.lastIdx;
    l_avg_disc_cmd_tag            <= l_avg_disc.cmd.tag;

    l_count_order_cmd_valid       <= l_count_order.cmd.valid;
    l_count_order_cmd_firstIdx    <= l_count_order.cmd.firstIdx;
    l_count_order_cmd_lastIdx     <= l_count_order.cmd.lastIdx;
    l_count_order_cmd_tag         <= l_count_order.cmd.tag;

    --l_returnflag_o_unl_ready      <= l_returnflag_o.unl.ready;
    --l_linestatus_o_unl_ready      <= l_linestatus_o.unl.ready;
    --l_sum_qty_unl_ready           <= l_sum_qty.unl.ready;
    --l_sum_base_price_unl_ready    <= l_sum_base.unl.ready;
    --l_sum_disc_price_unl_ready    <= l_sum_disc_price.unl.ready;
    --l_sum_charge_unl_ready        <= l_sum_charge.unl.ready;
    --l_avg_qty_unl_ready           <= l_avg_qty.unl.ready;
    --l_avg_price_unl_ready         <= l_avg_price.unl.ready;
    --l_avg_disc_unl_ready          <= l_avg_disc.unl.ready;
    --l_count_order_unl_ready       <= l_count_order.unl.ready;
  end process;

  unl_sync : StreamSync
  generic map(
    NUM_INPUTS  => 10,
    NUM_OUTPUTS => 1
  )
  port map(
    clk          => kcd_clk,
    reset        => kcd_reset,
    out_valid(0) => pricesummary_valid,
    out_ready(0) => pricesummary_ready,

    in_valid(0)  => l_count_order_unl_valid,
    in_valid(1)  => l_avg_disc_unl_valid,
    in_valid(2)  => l_avg_price_unl_valid,
    in_valid(3)  => l_avg_qty_unl_valid,
    in_valid(4)  => l_sum_charge_unl_valid,
    in_valid(5)  => l_sum_disc_price_unl_valid,
    in_valid(6)  => l_sum_base_price_unl_valid,
    in_valid(7)  => l_sum_qty_unl_valid,
    in_valid(8)  => l_returnflag_o_unl_valid,
    in_valid(9)  => l_linestatus_o_unl_valid,

    in_ready(0)  => l_count_order_unl_ready,
    in_ready(1)  => l_avg_disc_unl_ready,
    in_ready(2)  => l_avg_price_unl_ready,
    in_ready(3)  => l_avg_qty_unl_ready,
    in_ready(4)  => l_sum_charge_unl_ready,
    in_ready(5)  => l_sum_disc_price_unl_ready,
    in_ready(6)  => l_sum_base_price_unl_ready,
    in_ready(7)  => l_sum_qty_unl_ready,
    in_ready(8)  => l_returnflag_o_unl_ready,
    in_ready(9)  => l_linestatus_o_unl_ready
  );

  -- Sequential part:
  sequential_proc : process (kcd_clk)
    variable result_out_data : std_logic_vector(DATA_WIDTH - 1 downto 0);
    --variable temp_acc        : sfixed(FIXED_LEFT_INDEX + (EPC - 1) downto FIXED_RIGHT_INDEX);
  begin
    -- On the rising edge of the kernel clock:
    if rising_edge(kcd_clk) then
      -- Register the next state.
      state <= state_next;
      result_out_data := (others => '0');
      --temp_acc        := (others => '0');

      if kcd_reset = '1' or reset = '1' then
        state    <= STATE_IDLE;
        status_1 <= (others => '0');
        status_2 <= (others => '0');
        --result   <= (others => '0');
        rhigh    <= (others => '0');
        rlow     <= (others => '0');
        r1       <= (others => '0');
        r2       <= (others => '0');
        r3       <= (others => '0');
        r4       <= (others => '0');
        r5       <= (others => '0');
        r6       <= (others => '0');
        r7       <= (others => '0');
        r8       <= (others => '0');
      end if;
    end if;
  end process;

end architecture;