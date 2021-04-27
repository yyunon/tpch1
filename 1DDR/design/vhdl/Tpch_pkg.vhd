----------------------------------------------------------------------------------
-- Author: Yuksel Yonsel
-- Forecast implementation
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_misc.all;

package Tpch_pkg is

  -- Array types
  type TUPLE_DATA_8 is array (integer range <>) of std_logic_vector (7 downto 0);
  type TUPLE_DATA_32 is array (integer range <>) of std_logic_vector (31 downto 0);
  type TUPLE_DATA_64 is array (integer range <>) of std_logic_vector (63 downto 0);
  -- Yer these are same :D
  type TUPLE is array (integer range <>) of std_logic;

  -- Helper functions
  function flatten_tuple_64(inp : TUPLE_DATA_64
  ) return std_logic_vector;
  function flatten_tuple_32(inp : TUPLE_DATA_32
  ) return std_logic_vector;
  function flatten_tuple_8(inp : TUPLE_DATA_8
  ) return std_logic_vector;
  function flatten_tuple(inp : TUPLE
  ) return std_logic_vector;

  component StringWriterInterface is
    generic (
      DATA_WIDTH  : natural;
      TAG_WIDTH   : natural;
      LEN_WIDTH   : natural;
      INDEX_WIDTH : integer
    );
    port (

      input_valid         : in std_logic;
      input_ready         : out std_logic;
      input_dvalid        : in std_logic;
      input_last          : in std_logic;
      input_length        : in std_logic_vector(31 downto 0);
      input_count         : in std_logic_vector(0 downto 0);

      input_chars_valid   : in std_logic;
      input_chars_ready   : out std_logic;
      input_chars_dvalid  : in std_logic;
      input_chars_last    : in std_logic;
      input_chars         : in std_logic_vector(7 downto 0);
      input_chars_count   : in std_logic_vector(0 downto 0);

      output_valid        : out std_logic;
      output_ready        : in std_logic;
      output_dvalid       : out std_logic;
      output_last         : out std_logic;
      output_length       : out std_logic_vector(31 downto 0);
      output_count        : out std_logic_vector(0 downto 0);

      output_chars_valid  : out std_logic;
      output_chars_ready  : in std_logic;
      output_chars_dvalid : out std_logic;
      output_chars_last   : out std_logic;
      output_chars        : out std_logic_vector(7 downto 0);
      output_chars_count  : out std_logic_vector(0 downto 0)
    );
  end component;

  component HashTable is
    generic (

      -- Width of the stream data vector.
      HASH_FUNCTION : string  := "";
      NUM_KEYS      : natural := 1;
      DATA_WIDTH    : natural := 64;
      ADDRESS_WIDTH : natural := 8
    );
    port (

      -- Rising-edge sensitive clock.
      clk                    : in std_logic;

      -- Active-high synchronous reset.
      reset                  : in std_logic;

      -- Operation
      operation              : in std_logic;

      --Key stream.
      key_in_data            : in std_logic_vector(NUM_KEYS * ADDRESS_WIDTH - 1 downto 0);

      --Input data stream.
      in_data                : in std_logic_vector(DATA_WIDTH - 1 downto 0);

      -- Output stream.
      out_data               : out std_logic_vector(DATA_WIDTH - 1 downto 0);

      -- Num. of entries
      num_entries            : out std_logic_vector(NUM_KEYS * ADDRESS_WIDTH - 1 downto 0);

      -- Stream key output
      stream_key_out_address : in std_logic_vector(NUM_KEYS * ADDRESS_WIDTH - 1 downto 0);
      stream_key_out_data    : out std_logic_vector(NUM_KEYS * ADDRESS_WIDTH - 1 downto 0)

    );
  end component;
  component PU is
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
  end component;
  component Float_to_Fixed is
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
  end component;

  component FILTER is
    generic (

      -- Width of a data word.
      FIXED_LEFT_INDEX  : integer;
      FIXED_RIGHT_INDEX : integer;
      DATA_WIDTH        : natural;
      INPUT_MIN_DEPTH   : integer;
      OUTPUT_MIN_DEPTH  : integer;
      FILTERTYPE        : string := ""

    );
    port (
      clk       : in std_logic;
      reset     : in std_logic;

      in_valid  : in std_logic;
      in_dvalid : in std_logic := '1';
      in_ready  : out std_logic;
      in_last   : in std_logic;
      in_data   : in std_logic_vector(DATA_WIDTH - 1 downto 0);

      out_valid : out std_logic;
      out_ready : in std_logic;
      out_data  : out std_logic

    );
  end component;

  component MergeOp is
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
      inputs_valid  : in TUPLE(NUM_INPUTS - 1 downto 0);
      inputs_last   : in TUPLE(NUM_INPUTS - 1 downto 0);
      inputs_dvalid : in TUPLE(NUM_INPUTS - 1 downto 0);
      inputs_data   : in TUPLE_DATA_64(NUM_INPUTS - 1 downto 0);
      inputs_ready  : out TUPLE(NUM_INPUTS - 1 downto 0);
      -- Output stream.
      out_valid     : out std_logic;
      out_last      : out std_logic;
      out_ready     : in std_logic;
      out_data      : out std_logic_vector(DATA_WIDTH - 1 downto 0);
      out_dvalid    : out std_logic
    );
  end component;

  component SumOp is
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
  end component;

  component ReduceStage is
    generic (
      FIXED_LEFT_INDEX  : integer;
      FIXED_RIGHT_INDEX : integer;
      NUM_KEYS          : integer;
      NUM_SUMS          : natural := 1;
      NUM_AVGS          : natural := 1;
      INDEX_WIDTH       : integer := 32;
      TAG_WIDTH         : integer := 1
    );
    port (
      clk           : in std_logic;
      reset         : in std_logic;

      -- Key stream for accumulator logic
      key_in_dvalid : in std_logic := '1';
      key_in_data   : in std_logic_vector(NUM_KEYS * 8 - 1 downto 0);

      in_valid      : in std_logic;
      in_dvalid     : in std_logic := '1';
      in_ready      : out std_logic;
      in_last       : in std_logic;
      in_data       : in std_logic_vector(NUM_SUMS * 64 - 1 downto 0);

      probe_valid   : out std_logic;
      probe_ready   : in std_logic;

      out_valid     : out std_logic;
      out_ready     : in std_logic;
      key_out_data  : out std_logic_vector(NUM_KEYS * 8 - 1 downto 0);
      out_data      : out std_logic_vector((NUM_SUMS + NUM_AVGS + 1) * 64 - 1 downto 0)
      --avg_out_data   : out std_logic_vector(NUM_LANES * 64 - 1 downto 0);
      --count_out_data : out std_logic_vector(NUM_LANES * 64 - 1 downto 0)

    );
  end component;

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

end Tpch_pkg;

package body Tpch_pkg is

  function flatten_tuple_64(inp : TUPLE_DATA_64) return std_logic_vector is
    variable output               : std_logic_vector((inp'length * 64) - 1 downto 0);
  begin
    for i in inp'range loop
      output((i * 64) + 63 downto (i * 64)) := inp(i);
    end loop;
    return output;
  end function;
  function flatten_tuple_32(inp : TUPLE_DATA_32) return std_logic_vector is
    variable output               : std_logic_vector((inp'length * 32) - 1 downto 0);
  begin
    for i in inp'range loop
      output((i * 32) + 31 downto (i * 32)) := inp(i);
    end loop;
    return output;
  end function;
  function flatten_tuple_8(inp : TUPLE_DATA_8) return std_logic_vector is
    variable output              : std_logic_vector((inp'length * 8) - 1 downto 0);
  begin
    for i in inp'range loop
      output((i * 8) + 7 downto (i * 8)) := inp(i);
    end loop;
    return output;
  end function;
  function flatten_tuple(inp : TUPLE) return std_logic_vector is
    variable output            : std_logic_vector((inp'length) - 1 downto 0);
  begin
    for i in inp'range loop
      output(i) := inp(i);
    end loop;
    return output;
  end function;
end Tpch_pkg;