-- Generated using vhdMMIO 0.0.3 (https://github.com/abs-tudelft/vhdmmio)

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;
use ieee.numeric_std.all;

library work;
use work.vhdmmio_pkg.all;

package mmio_pkg is

  -- Component declaration for mmio.
  component mmio is
    port (

      -- Clock sensitive to the rising edge and synchronous, active-high reset.
      kcd_clk : in std_logic;
      kcd_reset : in std_logic := '0';

      -- Interface for field start: start.
      f_start_data : out std_logic := '0';

      -- Interface for field stop: stop.
      f_stop_data : out std_logic := '0';

      -- Interface for field reset: reset.
      f_reset_data : out std_logic := '0';

      -- Interface for field idle: idle.
      f_idle_write_data : in std_logic := '0';

      -- Interface for field busy: busy.
      f_busy_write_data : in std_logic := '0';

      -- Interface for field done: done.
      f_done_write_data : in std_logic := '0';

      -- Interface for field result: result.
      f_result_write_data : in std_logic_vector(63 downto 0) := (others => '0');

      -- Interface for field l_firstidx: l_firstidx.
      f_l_firstidx_data : out std_logic_vector(31 downto 0) := (others => '0');

      -- Interface for field l_lastidx: l_lastidx.
      f_l_lastidx_data : out std_logic_vector(31 downto 0) := (others => '0');

      -- Interface for field l_returnflag_o_offsets: l_returnflag_o_offsets.
      f_l_returnflag_o_offsets_data : out std_logic_vector(63 downto 0)
          := (others => '0');

      -- Interface for field l_returnflag_o_values: l_returnflag_o_values.
      f_l_returnflag_o_values_data : out std_logic_vector(63 downto 0)
          := (others => '0');

      -- Interface for field l_linestatus_o_offsets: l_linestatus_o_offsets.
      f_l_linestatus_o_offsets_data : out std_logic_vector(63 downto 0)
          := (others => '0');

      -- Interface for field l_linestatus_o_values: l_linestatus_o_values.
      f_l_linestatus_o_values_data : out std_logic_vector(63 downto 0)
          := (others => '0');

      -- Interface for field l_sum_qty_values: l_sum_qty_values.
      f_l_sum_qty_values_data : out std_logic_vector(63 downto 0)
          := (others => '0');

      -- Interface for field l_sum_base_price_values: l_sum_base_price_values.
      f_l_sum_base_price_values_data : out std_logic_vector(63 downto 0)
          := (others => '0');

      -- Interface for field l_sum_disc_price_values: l_sum_disc_price_values.
      f_l_sum_disc_price_values_data : out std_logic_vector(63 downto 0)
          := (others => '0');

      -- Interface for field l_sum_charge_values: l_sum_charge_values.
      f_l_sum_charge_values_data : out std_logic_vector(63 downto 0)
          := (others => '0');

      -- Interface for field l_avg_qty_values: l_avg_qty_values.
      f_l_avg_qty_values_data : out std_logic_vector(63 downto 0)
          := (others => '0');

      -- Interface for field l_avg_price_values: l_avg_price_values.
      f_l_avg_price_values_data : out std_logic_vector(63 downto 0)
          := (others => '0');

      -- Interface for field l_avg_disc_values: l_avg_disc_values.
      f_l_avg_disc_values_data : out std_logic_vector(63 downto 0)
          := (others => '0');

      -- Interface for field l_count_order_values: l_count_order_values.
      f_l_count_order_values_data : out std_logic_vector(63 downto 0)
          := (others => '0');

      -- Interface for field Profile_enable: Profile_enable.
      f_Profile_enable_data : out std_logic := '0';

      -- Interface for field Profile_clear: Profile_clear.
      f_Profile_clear_data : out std_logic := '0';

      -- AXI4-lite + interrupt request bus to the master.
      mmio_awvalid : in  std_logic := '0';
      mmio_awready : out std_logic := '1';
      mmio_awaddr  : in  std_logic_vector(31 downto 0) := X"00000000";
      mmio_awprot  : in  std_logic_vector(2 downto 0) := "000";
      mmio_wvalid  : in  std_logic := '0';
      mmio_wready  : out std_logic := '1';
      mmio_wdata   : in  std_logic_vector(31 downto 0) := (others => '0');
      mmio_wstrb   : in  std_logic_vector(3 downto 0) := (others => '0');
      mmio_bvalid  : out std_logic := '0';
      mmio_bready  : in  std_logic := '1';
      mmio_bresp   : out std_logic_vector(1 downto 0) := "00";
      mmio_arvalid : in  std_logic := '0';
      mmio_arready : out std_logic := '1';
      mmio_araddr  : in  std_logic_vector(31 downto 0) := X"00000000";
      mmio_arprot  : in  std_logic_vector(2 downto 0) := "000";
      mmio_rvalid  : out std_logic := '0';
      mmio_rready  : in  std_logic := '1';
      mmio_rdata   : out std_logic_vector(31 downto 0) := (others => '0');
      mmio_rresp   : out std_logic_vector(1 downto 0) := "00";
      mmio_uirq    : out std_logic := '0'

    );
  end component;

end package mmio_pkg;
