-- This source code is initialized by Yuksel Yonsel
-- rev 0.1 
-- Author: Yuksel Yonsel

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.std_logic_misc.ALL;

LIBRARY ieee_proposed;
USE ieee_proposed.fixed_pkg.ALL;

LIBRARY work;
USE work.Tpch_pkg.ALL;
USE work.Stream_pkg.ALL;
USE work.ParallelPatterns_pkg.ALL;
--use work.fixed_generic_pkg_mod.all;

ENTITY PriceSummary IS
  GENERIC (
    INDEX_WIDTH : INTEGER := 32;
    TAG_WIDTH : INTEGER := 1
  );
  PORT (
    kcd_clk : IN STD_LOGIC;
    kcd_reset : IN STD_LOGIC;
    l_quantity_valid : IN STD_LOGIC;
    l_quantity_ready : OUT STD_LOGIC;
    l_quantity_dvalid : IN STD_LOGIC;
    l_quantity_last : IN STD_LOGIC;
    l_quantity : IN STD_LOGIC_VECTOR(63 DOWNTO 0);
    l_extendedprice_valid : IN STD_LOGIC;
    l_extendedprice_ready : OUT STD_LOGIC;
    l_extendedprice_dvalid : IN STD_LOGIC;
    l_extendedprice_last : IN STD_LOGIC;
    l_extendedprice : IN STD_LOGIC_VECTOR(63 DOWNTO 0);
    l_discount_valid : IN STD_LOGIC;
    l_discount_ready : OUT STD_LOGIC;
    l_discount_dvalid : IN STD_LOGIC;
    l_discount_last : IN STD_LOGIC;
    l_discount : IN STD_LOGIC_VECTOR(63 DOWNTO 0);
    l_tax_valid : IN STD_LOGIC;
    l_tax_ready : OUT STD_LOGIC;
    l_tax_dvalid : IN STD_LOGIC;
    l_tax_last : IN STD_LOGIC;
    l_tax : IN STD_LOGIC_VECTOR(63 DOWNTO 0);
    l_returnflag_valid : IN STD_LOGIC;
    l_returnflag_ready : OUT STD_LOGIC;
    l_returnflag_dvalid : IN STD_LOGIC;
    l_returnflag_last : IN STD_LOGIC;
    l_returnflag_length : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    l_returnflag_count : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    l_returnflag_chars_valid : IN STD_LOGIC;
    l_returnflag_chars_ready : OUT STD_LOGIC;
    l_returnflag_chars_dvalid : IN STD_LOGIC;
    l_returnflag_chars_last : IN STD_LOGIC;
    l_returnflag_chars : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    l_returnflag_chars_count : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    l_linestatus_valid : IN STD_LOGIC;
    l_linestatus_ready : OUT STD_LOGIC;
    l_linestatus_dvalid : IN STD_LOGIC;
    l_linestatus_last : IN STD_LOGIC;
    l_linestatus_length : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    l_linestatus_count : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    l_linestatus_chars_valid : IN STD_LOGIC;
    l_linestatus_chars_ready : OUT STD_LOGIC;
    l_linestatus_chars_dvalid : IN STD_LOGIC;
    l_linestatus_chars_last : IN STD_LOGIC;
    l_linestatus_chars : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    l_linestatus_chars_count : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    l_shipdate_valid : IN STD_LOGIC;
    l_shipdate_ready : OUT STD_LOGIC;
    l_shipdate_dvalid : IN STD_LOGIC;
    l_shipdate_last : IN STD_LOGIC;
    l_shipdate : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    l_quantity_unl_valid : IN STD_LOGIC;
    l_quantity_unl_ready : OUT STD_LOGIC;
    l_quantity_unl_tag : IN STD_LOGIC_VECTOR(TAG_WIDTH - 1 DOWNTO 0);
    l_extendedprice_unl_valid : IN STD_LOGIC;
    l_extendedprice_unl_ready : OUT STD_LOGIC;
    l_extendedprice_unl_tag : IN STD_LOGIC_VECTOR(TAG_WIDTH - 1 DOWNTO 0);
    l_discount_unl_valid : IN STD_LOGIC;
    l_discount_unl_ready : OUT STD_LOGIC;
    l_discount_unl_tag : IN STD_LOGIC_VECTOR(TAG_WIDTH - 1 DOWNTO 0);
    l_tax_unl_valid : IN STD_LOGIC;
    l_tax_unl_ready : OUT STD_LOGIC;
    l_tax_unl_tag : IN STD_LOGIC_VECTOR(TAG_WIDTH - 1 DOWNTO 0);
    l_returnflag_unl_valid : IN STD_LOGIC;
    l_returnflag_unl_ready : OUT STD_LOGIC;
    l_returnflag_unl_tag : IN STD_LOGIC_VECTOR(TAG_WIDTH - 1 DOWNTO 0);
    l_linestatus_unl_valid : IN STD_LOGIC;
    l_linestatus_unl_ready : OUT STD_LOGIC;
    l_linestatus_unl_tag : IN STD_LOGIC_VECTOR(TAG_WIDTH - 1 DOWNTO 0);
    l_shipdate_unl_valid : IN STD_LOGIC;
    l_shipdate_unl_ready : OUT STD_LOGIC;
    l_shipdate_unl_tag : IN STD_LOGIC_VECTOR(TAG_WIDTH - 1 DOWNTO 0);
    l_quantity_cmd_valid : OUT STD_LOGIC;
    l_quantity_cmd_ready : IN STD_LOGIC;
    l_quantity_cmd_firstIdx : OUT STD_LOGIC_VECTOR(INDEX_WIDTH - 1 DOWNTO 0);
    l_quantity_cmd_lastIdx : OUT STD_LOGIC_VECTOR(INDEX_WIDTH - 1 DOWNTO 0);
    l_quantity_cmd_tag : OUT STD_LOGIC_VECTOR(TAG_WIDTH - 1 DOWNTO 0);
    l_extendedprice_cmd_valid : OUT STD_LOGIC;
    l_extendedprice_cmd_ready : IN STD_LOGIC;
    l_extendedprice_cmd_firstIdx : OUT STD_LOGIC_VECTOR(INDEX_WIDTH - 1 DOWNTO 0);
    l_extendedprice_cmd_lastIdx : OUT STD_LOGIC_VECTOR(INDEX_WIDTH - 1 DOWNTO 0);
    l_extendedprice_cmd_tag : OUT STD_LOGIC_VECTOR(TAG_WIDTH - 1 DOWNTO 0);
    l_discount_cmd_valid : OUT STD_LOGIC;
    l_discount_cmd_ready : IN STD_LOGIC;
    l_discount_cmd_firstIdx : OUT STD_LOGIC_VECTOR(INDEX_WIDTH - 1 DOWNTO 0);
    l_discount_cmd_lastIdx : OUT STD_LOGIC_VECTOR(INDEX_WIDTH - 1 DOWNTO 0);
    l_discount_cmd_tag : OUT STD_LOGIC_VECTOR(TAG_WIDTH - 1 DOWNTO 0);
    l_tax_cmd_valid : OUT STD_LOGIC;
    l_tax_cmd_ready : IN STD_LOGIC;
    l_tax_cmd_firstIdx : OUT STD_LOGIC_VECTOR(INDEX_WIDTH - 1 DOWNTO 0);
    l_tax_cmd_lastIdx : OUT STD_LOGIC_VECTOR(INDEX_WIDTH - 1 DOWNTO 0);
    l_tax_cmd_tag : OUT STD_LOGIC_VECTOR(TAG_WIDTH - 1 DOWNTO 0);
    l_returnflag_cmd_valid : OUT STD_LOGIC;
    l_returnflag_cmd_ready : IN STD_LOGIC;
    l_returnflag_cmd_firstIdx : OUT STD_LOGIC_VECTOR(INDEX_WIDTH - 1 DOWNTO 0);
    l_returnflag_cmd_lastIdx : OUT STD_LOGIC_VECTOR(INDEX_WIDTH - 1 DOWNTO 0);
    l_returnflag_cmd_tag : OUT STD_LOGIC_VECTOR(TAG_WIDTH - 1 DOWNTO 0);
    l_linestatus_cmd_valid : OUT STD_LOGIC;
    l_linestatus_cmd_ready : IN STD_LOGIC;
    l_linestatus_cmd_firstIdx : OUT STD_LOGIC_VECTOR(INDEX_WIDTH - 1 DOWNTO 0);
    l_linestatus_cmd_lastIdx : OUT STD_LOGIC_VECTOR(INDEX_WIDTH - 1 DOWNTO 0);
    l_linestatus_cmd_tag : OUT STD_LOGIC_VECTOR(TAG_WIDTH - 1 DOWNTO 0);
    l_shipdate_cmd_valid : OUT STD_LOGIC;
    l_shipdate_cmd_ready : IN STD_LOGIC;
    l_shipdate_cmd_firstIdx : OUT STD_LOGIC_VECTOR(INDEX_WIDTH - 1 DOWNTO 0);
    l_shipdate_cmd_lastIdx : OUT STD_LOGIC_VECTOR(INDEX_WIDTH - 1 DOWNTO 0);
    l_shipdate_cmd_tag : OUT STD_LOGIC_VECTOR(TAG_WIDTH - 1 DOWNTO 0);
    l_returnflag_o_valid : OUT STD_LOGIC;
    l_returnflag_o_ready : IN STD_LOGIC;
    l_returnflag_o_dvalid : OUT STD_LOGIC;
    l_returnflag_o_last : OUT STD_LOGIC;
    l_returnflag_o_length : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    l_returnflag_o_count : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    l_returnflag_o_chars_valid : OUT STD_LOGIC;
    l_returnflag_o_chars_ready : IN STD_LOGIC;
    l_returnflag_o_chars_dvalid : OUT STD_LOGIC;
    l_returnflag_o_chars_last : OUT STD_LOGIC;
    l_returnflag_o_chars : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    l_returnflag_o_chars_count : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    l_linestatus_o_valid : OUT STD_LOGIC;
    l_linestatus_o_ready : IN STD_LOGIC;
    l_linestatus_o_dvalid : OUT STD_LOGIC;
    l_linestatus_o_last : OUT STD_LOGIC;
    l_linestatus_o_length : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    l_linestatus_o_count : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    l_linestatus_o_chars_valid : OUT STD_LOGIC;
    l_linestatus_o_chars_ready : IN STD_LOGIC;
    l_linestatus_o_chars_dvalid : OUT STD_LOGIC;
    l_linestatus_o_chars_last : OUT STD_LOGIC;
    l_linestatus_o_chars : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    l_linestatus_o_chars_count : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    l_sum_qty_valid : OUT STD_LOGIC;
    l_sum_qty_ready : IN STD_LOGIC;
    l_sum_qty_dvalid : OUT STD_LOGIC;
    l_sum_qty_last : OUT STD_LOGIC;
    l_sum_qty : OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
    l_sum_base_price_valid : OUT STD_LOGIC;
    l_sum_base_price_ready : IN STD_LOGIC;
    l_sum_base_price_dvalid : OUT STD_LOGIC;
    l_sum_base_price_last : OUT STD_LOGIC;
    l_sum_base_price : OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
    l_sum_disc_price_valid : OUT STD_LOGIC;
    l_sum_disc_price_ready : IN STD_LOGIC;
    l_sum_disc_price_dvalid : OUT STD_LOGIC;
    l_sum_disc_price_last : OUT STD_LOGIC;
    l_sum_disc_price : OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
    l_sum_charge_valid : OUT STD_LOGIC;
    l_sum_charge_ready : IN STD_LOGIC;
    l_sum_charge_dvalid : OUT STD_LOGIC;
    l_sum_charge_last : OUT STD_LOGIC;
    l_sum_charge : OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
    l_avg_qty_valid : OUT STD_LOGIC;
    l_avg_qty_ready : IN STD_LOGIC;
    l_avg_qty_dvalid : OUT STD_LOGIC;
    l_avg_qty_last : OUT STD_LOGIC;
    l_avg_qty : OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
    l_avg_price_valid : OUT STD_LOGIC;
    l_avg_price_ready : IN STD_LOGIC;
    l_avg_price_dvalid : OUT STD_LOGIC;
    l_avg_price_last : OUT STD_LOGIC;
    l_avg_price : OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
    l_avg_disc_valid : OUT STD_LOGIC;
    l_avg_disc_ready : IN STD_LOGIC;
    l_avg_disc_dvalid : OUT STD_LOGIC;
    l_avg_disc_last : OUT STD_LOGIC;
    l_avg_disc : OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
    l_count_order_valid : OUT STD_LOGIC;
    l_count_order_ready : IN STD_LOGIC;
    l_count_order_dvalid : OUT STD_LOGIC;
    l_count_order_last : OUT STD_LOGIC;
    l_count_order : OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
    l_returnflag_o_unl_valid : IN STD_LOGIC;
    l_returnflag_o_unl_ready : OUT STD_LOGIC;
    l_returnflag_o_unl_tag : IN STD_LOGIC_VECTOR(TAG_WIDTH - 1 DOWNTO 0);
    l_linestatus_o_unl_valid : IN STD_LOGIC;
    l_linestatus_o_unl_ready : OUT STD_LOGIC;
    l_linestatus_o_unl_tag : IN STD_LOGIC_VECTOR(TAG_WIDTH - 1 DOWNTO 0);
    l_sum_qty_unl_valid : IN STD_LOGIC;
    l_sum_qty_unl_ready : OUT STD_LOGIC;
    l_sum_qty_unl_tag : IN STD_LOGIC_VECTOR(TAG_WIDTH - 1 DOWNTO 0);
    l_sum_base_price_unl_valid : IN STD_LOGIC;
    l_sum_base_price_unl_ready : OUT STD_LOGIC;
    l_sum_base_price_unl_tag : IN STD_LOGIC_VECTOR(TAG_WIDTH - 1 DOWNTO 0);
    l_sum_disc_price_unl_valid : IN STD_LOGIC;
    l_sum_disc_price_unl_ready : OUT STD_LOGIC;
    l_sum_disc_price_unl_tag : IN STD_LOGIC_VECTOR(TAG_WIDTH - 1 DOWNTO 0);
    l_sum_charge_unl_valid : IN STD_LOGIC;
    l_sum_charge_unl_ready : OUT STD_LOGIC;
    l_sum_charge_unl_tag : IN STD_LOGIC_VECTOR(TAG_WIDTH - 1 DOWNTO 0);
    l_avg_qty_unl_valid : IN STD_LOGIC;
    l_avg_qty_unl_ready : OUT STD_LOGIC;
    l_avg_qty_unl_tag : IN STD_LOGIC_VECTOR(TAG_WIDTH - 1 DOWNTO 0);
    l_avg_price_unl_valid : IN STD_LOGIC;
    l_avg_price_unl_ready : OUT STD_LOGIC;
    l_avg_price_unl_tag : IN STD_LOGIC_VECTOR(TAG_WIDTH - 1 DOWNTO 0);
    l_avg_disc_unl_valid : IN STD_LOGIC;
    l_avg_disc_unl_ready : OUT STD_LOGIC;
    l_avg_disc_unl_tag : IN STD_LOGIC_VECTOR(TAG_WIDTH - 1 DOWNTO 0);
    l_count_order_unl_valid : IN STD_LOGIC;
    l_count_order_unl_ready : OUT STD_LOGIC;
    l_count_order_unl_tag : IN STD_LOGIC_VECTOR(TAG_WIDTH - 1 DOWNTO 0);
    l_returnflag_o_cmd_valid : OUT STD_LOGIC;
    l_returnflag_o_cmd_ready : IN STD_LOGIC;
    l_returnflag_o_cmd_firstIdx : OUT STD_LOGIC_VECTOR(INDEX_WIDTH - 1 DOWNTO 0);
    l_returnflag_o_cmd_lastIdx : OUT STD_LOGIC_VECTOR(INDEX_WIDTH - 1 DOWNTO 0);
    l_returnflag_o_cmd_tag : OUT STD_LOGIC_VECTOR(TAG_WIDTH - 1 DOWNTO 0);
    l_linestatus_o_cmd_valid : OUT STD_LOGIC;
    l_linestatus_o_cmd_ready : IN STD_LOGIC;
    l_linestatus_o_cmd_firstIdx : OUT STD_LOGIC_VECTOR(INDEX_WIDTH - 1 DOWNTO 0);
    l_linestatus_o_cmd_lastIdx : OUT STD_LOGIC_VECTOR(INDEX_WIDTH - 1 DOWNTO 0);
    l_linestatus_o_cmd_tag : OUT STD_LOGIC_VECTOR(TAG_WIDTH - 1 DOWNTO 0);
    l_sum_qty_cmd_valid : OUT STD_LOGIC;
    l_sum_qty_cmd_ready : IN STD_LOGIC;
    l_sum_qty_cmd_firstIdx : OUT STD_LOGIC_VECTOR(INDEX_WIDTH - 1 DOWNTO 0);
    l_sum_qty_cmd_lastIdx : OUT STD_LOGIC_VECTOR(INDEX_WIDTH - 1 DOWNTO 0);
    l_sum_qty_cmd_tag : OUT STD_LOGIC_VECTOR(TAG_WIDTH - 1 DOWNTO 0);
    l_sum_base_price_cmd_valid : OUT STD_LOGIC;
    l_sum_base_price_cmd_ready : IN STD_LOGIC;
    l_sum_base_price_cmd_firstIdx : OUT STD_LOGIC_VECTOR(INDEX_WIDTH - 1 DOWNTO 0);
    l_sum_base_price_cmd_lastIdx : OUT STD_LOGIC_VECTOR(INDEX_WIDTH - 1 DOWNTO 0);
    l_sum_base_price_cmd_tag : OUT STD_LOGIC_VECTOR(TAG_WIDTH - 1 DOWNTO 0);
    l_sum_disc_price_cmd_valid : OUT STD_LOGIC;
    l_sum_disc_price_cmd_ready : IN STD_LOGIC;
    l_sum_disc_price_cmd_firstIdx : OUT STD_LOGIC_VECTOR(INDEX_WIDTH - 1 DOWNTO 0);
    l_sum_disc_price_cmd_lastIdx : OUT STD_LOGIC_VECTOR(INDEX_WIDTH - 1 DOWNTO 0);
    l_sum_disc_price_cmd_tag : OUT STD_LOGIC_VECTOR(TAG_WIDTH - 1 DOWNTO 0);
    l_sum_charge_cmd_valid : OUT STD_LOGIC;
    l_sum_charge_cmd_ready : IN STD_LOGIC;
    l_sum_charge_cmd_firstIdx : OUT STD_LOGIC_VECTOR(INDEX_WIDTH - 1 DOWNTO 0);
    l_sum_charge_cmd_lastIdx : OUT STD_LOGIC_VECTOR(INDEX_WIDTH - 1 DOWNTO 0);
    l_sum_charge_cmd_tag : OUT STD_LOGIC_VECTOR(TAG_WIDTH - 1 DOWNTO 0);
    l_avg_qty_cmd_valid : OUT STD_LOGIC;
    l_avg_qty_cmd_ready : IN STD_LOGIC;
    l_avg_qty_cmd_firstIdx : OUT STD_LOGIC_VECTOR(INDEX_WIDTH - 1 DOWNTO 0);
    l_avg_qty_cmd_lastIdx : OUT STD_LOGIC_VECTOR(INDEX_WIDTH - 1 DOWNTO 0);
    l_avg_qty_cmd_tag : OUT STD_LOGIC_VECTOR(TAG_WIDTH - 1 DOWNTO 0);
    l_avg_price_cmd_valid : OUT STD_LOGIC;
    l_avg_price_cmd_ready : IN STD_LOGIC;
    l_avg_price_cmd_firstIdx : OUT STD_LOGIC_VECTOR(INDEX_WIDTH - 1 DOWNTO 0);
    l_avg_price_cmd_lastIdx : OUT STD_LOGIC_VECTOR(INDEX_WIDTH - 1 DOWNTO 0);
    l_avg_price_cmd_tag : OUT STD_LOGIC_VECTOR(TAG_WIDTH - 1 DOWNTO 0);
    l_avg_disc_cmd_valid : OUT STD_LOGIC;
    l_avg_disc_cmd_ready : IN STD_LOGIC;
    l_avg_disc_cmd_firstIdx : OUT STD_LOGIC_VECTOR(INDEX_WIDTH - 1 DOWNTO 0);
    l_avg_disc_cmd_lastIdx : OUT STD_LOGIC_VECTOR(INDEX_WIDTH - 1 DOWNTO 0);
    l_avg_disc_cmd_tag : OUT STD_LOGIC_VECTOR(TAG_WIDTH - 1 DOWNTO 0);
    l_count_order_cmd_valid : OUT STD_LOGIC;
    l_count_order_cmd_ready : IN STD_LOGIC;
    l_count_order_cmd_firstIdx : OUT STD_LOGIC_VECTOR(INDEX_WIDTH - 1 DOWNTO 0);
    l_count_order_cmd_lastIdx : OUT STD_LOGIC_VECTOR(INDEX_WIDTH - 1 DOWNTO 0);
    l_count_order_cmd_tag : OUT STD_LOGIC_VECTOR(TAG_WIDTH - 1 DOWNTO 0);
    start : IN STD_LOGIC;
    stop : IN STD_LOGIC;
    reset : IN STD_LOGIC;
    idle : OUT STD_LOGIC;
    busy : OUT STD_LOGIC;
    done : OUT STD_LOGIC;
    result : OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
    l_firstidx : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    l_lastidx : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    rhigh : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    rlow : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    status_1 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    status_2 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    r1 : OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
    r2 : OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
    r3 : OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
    r4 : OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
    r5 : OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
    r6 : OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
    r7 : OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
    r8 : OUT STD_LOGIC_VECTOR(63 DOWNTO 0)
  );
END ENTITY;

ARCHITECTURE Implementation OF PriceSummary IS

  CONSTANT DATA_WIDTH : INTEGER := 64;
  CONSTANT EPC : INTEGER := 8;
  CONSTANT FIXED_LEFT_INDEX : INTEGER := 45;
  CONSTANT FIXED_RIGHT_INDEX : INTEGER := FIXED_LEFT_INDEX - (DATA_WIDTH - 1);

  CONSTANT SYNC_IN_BUFFER_DEPTH : INTEGER := 0;
  CONSTANT SYNC_OUT_BUFFER_DEPTH : INTEGER := 0;

  -- If the input stream size is not divisible by EPC check this:
  SIGNAL pu_mask : STD_LOGIC_VECTOR(EPC - 1 DOWNTO 0);
  -- Enumeration type for our state machine.
  TYPE state_t IS (STATE_IDLE,
    STATE_COMMAND,
    STATE_CALCULATING,
    STATE_UNLOCK,
    STATE_DONE);

  SIGNAL state_slv : STD_LOGIC_VECTOR(2 DOWNTO 0);

  -- Current state register and next state signal.
  SIGNAL state, state_next : state_t;

  -- Buffered inputs
  SIGNAL buf_l_quantity_valid : STD_LOGIC;
  SIGNAL buf_l_quantity_ready : STD_LOGIC;
  SIGNAL buf_l_quantity_dvalid : STD_LOGIC;
  SIGNAL buf_l_quantity_last : STD_LOGIC;
  SIGNAL buf_l_quantity : STD_LOGIC_VECTOR(DATA_WIDTH * EPC - 1 DOWNTO 0);
  SIGNAL buf_l_discount_valid : STD_LOGIC;
  SIGNAL buf_l_discount_ready : STD_LOGIC;
  SIGNAL buf_l_discount_dvalid : STD_LOGIC;
  SIGNAL buf_l_discount_last : STD_LOGIC;
  SIGNAL buf_l_discount : STD_LOGIC_VECTOR(DATA_WIDTH * EPC - 1 DOWNTO 0);
  SIGNAL buf_l_extendedprice_valid : STD_LOGIC;
  SIGNAL buf_l_extendedprice_ready : STD_LOGIC;
  SIGNAL buf_l_extendedprice_dvalid : STD_LOGIC;
  SIGNAL buf_l_extendedprice_last : STD_LOGIC;
  SIGNAL buf_l_extendedprice : STD_LOGIC_VECTOR(DATA_WIDTH * EPC - 1 DOWNTO 0);
  SIGNAL buf_l_shipdate_valid : STD_LOGIC;
  SIGNAL buf_l_shipdate_ready : STD_LOGIC;
  SIGNAL buf_l_shipdate_dvalid : STD_LOGIC;
  SIGNAL buf_l_shipdate_last : STD_LOGIC;
  SIGNAL buf_l_shipdate : STD_LOGIC_VECTOR(DATA_WIDTH * EPC / 2 - 1 DOWNTO 0);

  -- Buffered and decoded inputs
  SIGNAL dec_l_quantity_valid : STD_LOGIC_VECTOR(EPC - 1 DOWNTO 0);
  SIGNAL dec_l_quantity_ready : STD_LOGIC_VECTOR(EPC - 1 DOWNTO 0);
  SIGNAL dec_l_quantity_dvalid : STD_LOGIC_VECTOR(EPC - 1 DOWNTO 0);
  SIGNAL dec_l_quantity_last : STD_LOGIC_VECTOR(EPC - 1 DOWNTO 0);
  SIGNAL dec_l_quantity : STD_LOGIC_VECTOR(DATA_WIDTH * EPC - 1 DOWNTO 0);

  SIGNAL dec_l_discount_valid : STD_LOGIC_VECTOR(EPC - 1 DOWNTO 0);
  SIGNAL dec_l_discount_ready : STD_LOGIC_VECTOR(EPC - 1 DOWNTO 0);
  SIGNAL dec_l_discount_dvalid : STD_LOGIC_VECTOR(EPC - 1 DOWNTO 0);
  SIGNAL dec_l_discount_last : STD_LOGIC_VECTOR(EPC - 1 DOWNTO 0);
  SIGNAL dec_l_discount : STD_LOGIC_VECTOR(DATA_WIDTH * EPC - 1 DOWNTO 0);

  SIGNAL dec_l_extendedprice_valid : STD_LOGIC_VECTOR(EPC - 1 DOWNTO 0);
  SIGNAL dec_l_extendedprice_ready : STD_LOGIC_VECTOR(EPC - 1 DOWNTO 0);
  SIGNAL dec_l_extendedprice_dvalid : STD_LOGIC_VECTOR(EPC - 1 DOWNTO 0);
  SIGNAL dec_l_extendedprice_last : STD_LOGIC_VECTOR(EPC - 1 DOWNTO 0);
  SIGNAL dec_l_extendedprice : STD_LOGIC_VECTOR(DATA_WIDTH * EPC - 1 DOWNTO 0);
  SIGNAL dec_l_shipdate_valid : STD_LOGIC_VECTOR(EPC - 1 DOWNTO 0);
  SIGNAL dec_l_shipdate_ready : STD_LOGIC_VECTOR(EPC - 1 DOWNTO 0);
  SIGNAL dec_l_shipdate_dvalid : STD_LOGIC_VECTOR(EPC - 1 DOWNTO 0);
  SIGNAL dec_l_shipdate_last : STD_LOGIC_VECTOR(EPC - 1 DOWNTO 0);
  SIGNAL dec_l_shipdate : STD_LOGIC_VECTOR(DATA_WIDTH * EPC / 2 - 1 DOWNTO 0);

  --Stage valid ready signals
  SIGNAL quantity_valid : STD_LOGIC_VECTOR(EPC - 1 DOWNTO 0);
  SIGNAL quantity_ready : STD_LOGIC_VECTOR(EPC - 1 DOWNTO 0);
  SIGNAL quantity_dvalid : STD_LOGIC_VECTOR(EPC - 1 DOWNTO 0);
  SIGNAL quantity_last : STD_LOGIC_VECTOR(EPC - 1 DOWNTO 0);

  SIGNAL extendedprice_valid : STD_LOGIC_VECTOR(EPC - 1 DOWNTO 0);
  SIGNAL extendedprice_ready : STD_LOGIC_VECTOR(EPC - 1 DOWNTO 0);
  SIGNAL extendedprice_dvalid : STD_LOGIC_VECTOR(EPC - 1 DOWNTO 0);
  SIGNAL extendedprice_last : STD_LOGIC_VECTOR(EPC - 1 DOWNTO 0);

  SIGNAL discount_valid : STD_LOGIC_VECTOR(EPC - 1 DOWNTO 0);
  SIGNAL discount_ready : STD_LOGIC_VECTOR(EPC - 1 DOWNTO 0);
  SIGNAL discount_dvalid : STD_LOGIC_VECTOR(EPC - 1 DOWNTO 0);
  SIGNAL discount_last : STD_LOGIC_VECTOR(EPC - 1 DOWNTO 0);

  SIGNAL shipdate_valid : STD_LOGIC_VECTOR(EPC - 1 DOWNTO 0);
  SIGNAL shipdate_ready : STD_LOGIC_VECTOR(EPC - 1 DOWNTO 0);
  SIGNAL shipdate_dvalid : STD_LOGIC_VECTOR(EPC - 1 DOWNTO 0);
  SIGNAL shipdate_last : STD_LOGIC_VECTOR(EPC - 1 DOWNTO 0);

  -- Sum output stream.
  SIGNAL sum_out_valid_stages : STD_LOGIC_VECTOR(EPC - 1 DOWNTO 0);
  SIGNAL sum_out_ready_stages : STD_LOGIC_VECTOR(EPC - 1 DOWNTO 0);
  SIGNAL sum_out_data_stages : STD_LOGIC_VECTOR(DATA_WIDTH * EPC - 1 DOWNTO 0);

  SIGNAL total_sum_out_valid : STD_LOGIC;
  SIGNAL total_sum_out_ready : STD_LOGIC;

  SIGNAL result_out_valid : STD_LOGIC;
  SIGNAL result_out_ready : STD_LOGIC;
  SIGNAL temp_inp_1 : sfixed(FIXED_LEFT_INDEX DOWNTO FIXED_RIGHT_INDEX);
  SIGNAL temp_inp_2 : sfixed(FIXED_LEFT_INDEX DOWNTO FIXED_RIGHT_INDEX);
  SIGNAL temp_inp_3 : sfixed(FIXED_LEFT_INDEX DOWNTO FIXED_RIGHT_INDEX);
  SIGNAL temp_inp_4 : sfixed(FIXED_LEFT_INDEX DOWNTO FIXED_RIGHT_INDEX);
  SIGNAL temp_inp_5 : sfixed(FIXED_LEFT_INDEX DOWNTO FIXED_RIGHT_INDEX);
  SIGNAL temp_inp_6 : sfixed(FIXED_LEFT_INDEX DOWNTO FIXED_RIGHT_INDEX);
  SIGNAL temp_inp_7 : sfixed(FIXED_LEFT_INDEX DOWNTO FIXED_RIGHT_INDEX);
  SIGNAL temp_inp_8 : sfixed(FIXED_LEFT_INDEX DOWNTO FIXED_RIGHT_INDEX);

  CONSTANT ONES : STD_LOGIC_VECTOR(EPC - 1 DOWNTO 0) := (OTHERS => '1');

BEGIN
  WITH state SELECT state_slv <=
    "000" WHEN STATE_COMMAND,
    "011" WHEN STATE_CALCULATING,
    "100" WHEN STATE_UNLOCK,
    "101" WHEN OTHERS;

  combinatorial_proc : PROCESS (
    l_firstIdx,
    l_lastIdx,

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

    copy_done_valid,

    state,
    start,
    reset,
    kcd_reset
    ) IS
  BEGIN

    l_quantity_cmd_valid <= '0';
    l_quantity_cmd_firstIdx <= (OTHERS => '0');
    l_quantity_cmd_lastIdx <= (OTHERS => '0');
    l_quantity_cmd_tag <= (OTHERS => '0');

    l_discount_cmd_valid <= '0';
    l_discount_cmd_firstIdx <= (OTHERS => '0');
    l_discount_cmd_lastIdx <= (OTHERS => '0');
    l_discount_cmd_tag <= (OTHERS => '0');

    l_shipdate_cmd_valid <= '0';
    l_shipdate_cmd_firstIdx <= (OTHERS => '0');
    l_shipdate_cmd_lastIdx <= (OTHERS => '0');
    l_shipdate_cmd_tag <= (OTHERS => '0');

    l_returnflag_cmd_valid <= '0';
    l_returnflag_cmd_firstIdx <= (OTHERS => '0');
    l_returnflag_cmd_lastIdx <= (OTHERS => '0');
    l_returnflag_cmd_tag <= (OTHERS => '0');

    l_tax_cmd_valid <= '0';
    l_tax_cmd_firstIdx <= (OTHERS => '0');
    l_tax_cmd_lastIdx <= (OTHERS => '0');
    l_tax_cmd_tag <= (OTHERS => '0');

    l_extendedprice_cmd_valid <= '0';
    l_extendedprice_cmd_firstIdx <= (OTHERS => '0');
    l_extendedprice_cmd_lastIdx <= (OTHERS => '0');
    l_extendedprice_cmd_tag <= (OTHERS => '0');

    l_linestatus_cmd_valid <= '0';
    l_linestatus_cmd_firstIdx <= (OTHERS => '0');
    l_linestatus_cmd_lastIdx <= (OTHERS => '0');
    l_linestatus_cmd_tag <= (OTHERS => '0');

    state_next <= state; -- Retain current state.

    l_quantity_unl_ready <= '0';
    l_extendedprice_unl_ready <= '0';
    l_discount_unl_ready <= '0';
    l_tax_unl_ready <= '0';
    l_returnflag_unl_ready <= '0';
    l_linestatus_unl_ready <= '0';
    l_shipdate_unl_ready <= '0';

    CASE state IS
      WHEN STATE_IDLE =>
        -- Idle: We just wait for the start bit to come up.
        done <= '0';
        busy <= '0';
        idle <= '1';

        -- Wait for the start signal (typically controlled by the host-side 
        -- software).
        IF start = '1' THEN
          state_next <= STATE_COMMAND;
        END IF;

      WHEN STATE_COMMAND =>
        -- Command: we send a command to the generated interface.
        done <= '0';
        busy <= '1';
        idle <= '0';
        l_quantity_cmd_valid <= '1';
        l_quantity_cmd_firstIdx <= l_firstIdx;
        l_quantity_cmd_lastIdx <= l_lastIdx;
        l_quantity_cmd_tag <= (OTHERS => '0');

        l_extendedprice_cmd_valid <= '1';
        l_extendedprice_cmd_firstIdx <= l_firstIdx;
        l_extendedprice_cmd_lastIdx <= l_lastIdx;
        l_extendedprice_cmd_tag <= (OTHERS => '0');

        l_shipdate_cmd_valid <= '1';
        l_shipdate_cmd_firstIdx <= l_firstIdx;
        l_shipdate_cmd_lastIdx <= l_lastIdx;
        l_shipdate_cmd_tag <= (OTHERS => '0');

        l_discount_cmd_valid <= '1';
        l_discount_cmd_firstIdx <= l_firstIdx;
        l_discount_cmd_lastIdx <= l_lastIdx;
        l_discount_cmd_tag <= (OTHERS => '0');

        l_tax_cmd_valid <= '1';
        l_tax_cmd_firstIdx <= l_firstIdx;
        l_tax_cmd_lastIdx <= l_lastIdx;
        l_tax_cmd_tag <= (OTHERS => '0');

        l_shipdate_cmd_valid <= '1';
        l_shipdate_cmd_firstIdx <= l_firstIdx;
        l_shipdate_cmd_lastIdx <= l_lastIdx;
        l_shipdate_cmd_tag <= (OTHERS => '0');

        l_linestatus_cmd_valid <= '1';
        l_linestatus_cmd_firstIdx <= l_firstIdx;
        l_linestatus_cmd_lastIdx <= l_lastIdx;
        l_linestatus_cmd_tag <= (OTHERS => '0');

        IF l_quantity_cmd_ready = '1' AND l_extendedprice_cmd_ready = '1' AND l_shipdate_cmd_ready = '1' AND l_discount_cmd_ready = '1' AND l_linestatus_cmd_ready = '1' AND l_tax_cmd_ready = '1' AND l_returnflag = '1' THEN
          state_next <= STATE_CALCULATING;
        END IF;

      WHEN STATE_CALCULATING =>
        -- Calculating: we stream in and accumulate the numbers one by one. PROBE Phase is here!
        done <= '0';
        busy <= '1';
        idle <= '0';

        copy_done <= (OTHERS => '1');

        IF copy_done_valid = ONES THEN
          state_next <= STATE_UNLOCK;
        END IF;

      WHEN STATE_UNLOCK =>
        -- Unlock: the generated interface delivered all items in the stream.
        -- The unlock stream is supplied to make sure all bus transfers of the
        -- corresponding command are completed.
        done <= '1';
        busy <= '0';
        idle <= '1';

        -- Ready to handshake the unlock stream:
        l_quantity_unl_ready <= '1';
        l_discount_unl_ready <= '1';
        l_shipdate_unl_ready <= '1';
        l_extendedprice_unl_ready <= '1';
        l_tax_unl_ready <= '1';
        l_linestatus_unl_ready <= '1';
        l_returnflag_unl_ready <= '1';
        -- Handshake when it is valid and go to the done state.
        -- if s_store_sk_unl_valid = '1' then
        IF l_discount_unl_valid = '1' AND l_quantity_unl_valid = '1' AND l_shipdate_unl_valid = '1' AND l_extendedprice_unl_valid = '1' AND l_linestatus_unl_valid = '1' AND l_tax_unl_valid = '1' AND l_returnflag_unl_valid = '1' THEN
          state_next <= STATE_DONE;
        END IF;

      WHEN STATE_DONE =>
        -- Done: the kernel is done with its job.
        done <= '1';
        busy <= '0';
        idle <= '1';

        -- Wait for the reset signal (typically controlled by the host-side 
        -- software), so we can go to idle again. This reset is not to be
        -- confused with the system-wide reset that travels into the kernel
        -- alongside the clock (kcd_reset).        
    END CASE;
  END PROCESS;

  -- Sequential part:
  sequential_proc : PROCESS (kcd_clk)
    VARIABLE result_out_data : STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0);
    VARIABLE temp_acc : sfixed(FIXED_LEFT_INDEX + (EPC - 1) DOWNTO FIXED_RIGHT_INDEX);
  BEGIN
    -- On the rising edge of the kernel clock:
    IF rising_edge(kcd_clk) THEN
      -- Register the next state.
      state <= state_next;
      status_1 <= (31 DOWNTO EPC => '0') & sum_out_valid_stages;
      result_out_data := (OTHERS => '0');
      temp_acc := (OTHERS => '0');

      IF kcd_reset = '1' OR reset = '1' THEN
        state <= STATE_IDLE;
        status_1 <= (OTHERS => '0');
        status_2 <= (OTHERS => '0');
        result <= (OTHERS => '0');
        rhigh <= (OTHERS => '0');
        rlow <= (OTHERS => '0');
        r1 <= (OTHERS => '0');
        r2 <= (OTHERS => '0');
        r3 <= (OTHERS => '0');
        r4 <= (OTHERS => '0');
        r5 <= (OTHERS => '0');
        r6 <= (OTHERS => '0');
        r7 <= (OTHERS => '0');
        r8 <= (OTHERS => '0');
      END IF;
    END IF;
  END PROCESS;

END ARCHITECTURE;