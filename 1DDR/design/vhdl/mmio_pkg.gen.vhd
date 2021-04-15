-- Generated using vhdMMIO 0.0.3 (https://github.com/abs-tudelft/vhdmmio)

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_misc.ALL;
USE ieee.numeric_std.ALL;

LIBRARY work;
USE work.vhdmmio_pkg.ALL;

PACKAGE mmio_pkg IS

    -- Component declaration for mmio.
    COMPONENT mmio IS
        PORT (

            -- Clock sensitive to the rising edge and synchronous, active-high reset.
            kcd_clk : IN STD_LOGIC;
            kcd_reset : IN STD_LOGIC := '0';

            -- Interface for field start: start.
            f_start_data : OUT STD_LOGIC := '0';

            -- Interface for field stop: stop.
            f_stop_data : OUT STD_LOGIC := '0';

            -- Interface for field reset: reset.
            f_reset_data : OUT STD_LOGIC := '0';

            -- Interface for field idle: idle.
            f_idle_write_data : IN STD_LOGIC := '0';

            -- Interface for field busy: busy.
            f_busy_write_data : IN STD_LOGIC := '0';

            -- Interface for field done: done.
            f_done_write_data : IN STD_LOGIC := '0';

            -- Interface for field result: result.
            f_result_write_data : IN STD_LOGIC_VECTOR(63 DOWNTO 0) := (OTHERS => '0');

            -- Interface for field l_firstidx: l_firstidx.
            f_l_firstidx_data : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');

            -- Interface for field l_lastidx: l_lastidx.
            f_l_lastidx_data : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');

            -- Interface for field l_quantity_values: l_quantity_values.
            f_l_quantity_values_data : OUT STD_LOGIC_VECTOR(63 DOWNTO 0)
            := (OTHERS => '0');

            -- Interface for field l_extendedprice_values: l_extendedprice_values.
            f_l_extendedprice_values_data : OUT STD_LOGIC_VECTOR(63 DOWNTO 0)
            := (OTHERS => '0');

            -- Interface for field l_discount_values: l_discount_values.
            f_l_discount_values_data : OUT STD_LOGIC_VECTOR(63 DOWNTO 0)
            := (OTHERS => '0');

            -- Interface for field l_tax_values: l_tax_values.
            f_l_tax_values_data : OUT STD_LOGIC_VECTOR(63 DOWNTO 0)
            := (OTHERS => '0');

            -- Interface for field l_returnflag_offsets: l_returnflag_offsets.
            f_l_returnflag_offsets_data : OUT STD_LOGIC_VECTOR(63 DOWNTO 0)
            := (OTHERS => '0');

            -- Interface for field l_returnflag_values: l_returnflag_values.
            f_l_returnflag_values_data : OUT STD_LOGIC_VECTOR(63 DOWNTO 0)
            := (OTHERS => '0');

            -- Interface for field l_linestatus_offsets: l_linestatus_offsets.
            f_l_linestatus_offsets_data : OUT STD_LOGIC_VECTOR(63 DOWNTO 0)
            := (OTHERS => '0');

            -- Interface for field l_linestatus_values: l_linestatus_values.
            f_l_linestatus_values_data : OUT STD_LOGIC_VECTOR(63 DOWNTO 0)
            := (OTHERS => '0');

            -- Interface for field l_shipdate_values: l_shipdate_values.
            f_l_shipdate_values_data : OUT STD_LOGIC_VECTOR(63 DOWNTO 0)
            := (OTHERS => '0');

            -- Interface for field l_returnflag_offsets: l_returnflag_offsets.
            f_l_returnflag_o_offsets_data : OUT STD_LOGIC_VECTOR(63 DOWNTO 0)
            := (OTHERS => '0');

            -- Interface for field l_returnflag_values: l_returnflag_values.
            f_l_returnflag_o_values_data : OUT STD_LOGIC_VECTOR(63 DOWNTO 0)
            := (OTHERS => '0');

            -- Interface for field l_linestatus_offsets: l_linestatus_offsets.
            f_l_linestatus_o_offsets_data : OUT STD_LOGIC_VECTOR(63 DOWNTO 0)
            := (OTHERS => '0');

            -- Interface for field l_linestatus_values: l_linestatus_values.
            f_l_linestatus_o_values_data : OUT STD_LOGIC_VECTOR(63 DOWNTO 0)
            := (OTHERS => '0');

            -- Interface for field l_sum_qty_values: l_sum_qty_values.
            f_l_sum_qty_values_data : OUT STD_LOGIC_VECTOR(63 DOWNTO 0)
            := (OTHERS => '0');

            -- Interface for field l_sum_base_price_values: l_sum_base_price_values.
            f_l_sum_base_price_values_data : OUT STD_LOGIC_VECTOR(63 DOWNTO 0)
            := (OTHERS => '0');

            -- Interface for field l_sum_disc_price_values: l_sum_disc_price_values.
            f_l_sum_disc_price_values_data : OUT STD_LOGIC_VECTOR(63 DOWNTO 0)
            := (OTHERS => '0');

            -- Interface for field l_sum_charge_values: l_sum_charge_values.
            f_l_sum_charge_values_data : OUT STD_LOGIC_VECTOR(63 DOWNTO 0)
            := (OTHERS => '0');

            -- Interface for field l_avg_qty_values: l_avg_qty_values.
            f_l_avg_qty_values_data : OUT STD_LOGIC_VECTOR(63 DOWNTO 0)
            := (OTHERS => '0');

            -- Interface for field l_avg_price_values: l_avg_price_values.
            f_l_avg_price_values_data : OUT STD_LOGIC_VECTOR(63 DOWNTO 0)
            := (OTHERS => '0');

            -- Interface for field l_avg_disc_values: l_avg_disc_values.
            f_l_avg_disc_values_data : OUT STD_LOGIC_VECTOR(63 DOWNTO 0)
            := (OTHERS => '0');

            -- Interface for field l_count_order_values: l_count_order_values.
            f_l_count_order_values_data : OUT STD_LOGIC_VECTOR(63 DOWNTO 0)
            := (OTHERS => '0');

            -- Interface for field rhigh: rhigh.
            f_rhigh_write_data : IN STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');

            -- Interface for field rlow: rlow.
            f_rlow_write_data : IN STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');

            -- Interface for field status_1: status_1.
            f_status_1_write_data : IN STD_LOGIC_VECTOR(31 DOWNTO 0)
            := (OTHERS => '0');

            -- Interface for field status_2: status_2.
            f_status_2_write_data : IN STD_LOGIC_VECTOR(31 DOWNTO 0)
            := (OTHERS => '0');

            -- Interface for field r1: r1.
            f_r1_write_data : IN STD_LOGIC_VECTOR(63 DOWNTO 0) := (OTHERS => '0');

            -- Interface for field r2: r2.
            f_r2_write_data : IN STD_LOGIC_VECTOR(63 DOWNTO 0) := (OTHERS => '0');

            -- Interface for field r3: r3.
            f_r3_write_data : IN STD_LOGIC_VECTOR(63 DOWNTO 0) := (OTHERS => '0');

            -- Interface for field r4: r4.
            f_r4_write_data : IN STD_LOGIC_VECTOR(63 DOWNTO 0) := (OTHERS => '0');

            -- Interface for field r5: r5.
            f_r5_write_data : IN STD_LOGIC_VECTOR(63 DOWNTO 0) := (OTHERS => '0');

            -- Interface for field r6: r6.
            f_r6_write_data : IN STD_LOGIC_VECTOR(63 DOWNTO 0) := (OTHERS => '0');

            -- Interface for field r7: r7.
            f_r7_write_data : IN STD_LOGIC_VECTOR(63 DOWNTO 0) := (OTHERS => '0');

            -- Interface for field r8: r8.
            f_r8_write_data : IN STD_LOGIC_VECTOR(63 DOWNTO 0) := (OTHERS => '0');

            -- Interface for field Profile_enable: Profile_enable.
            f_Profile_enable_data : OUT STD_LOGIC := '0';

            -- Interface for field Profile_clear: Profile_clear.
            f_Profile_clear_data : OUT STD_LOGIC := '0';

            -- AXI4-lite + interrupt request bus to the master.
            mmio_awvalid : IN STD_LOGIC := '0';
            mmio_awready : OUT STD_LOGIC := '1';
            mmio_awaddr : IN STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000000";
            mmio_awprot : IN STD_LOGIC_VECTOR(2 DOWNTO 0) := "000";
            mmio_wvalid : IN STD_LOGIC := '0';
            mmio_wready : OUT STD_LOGIC := '1';
            mmio_wdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
            mmio_wstrb : IN STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS => '0');
            mmio_bvalid : OUT STD_LOGIC := '0';
            mmio_bready : IN STD_LOGIC := '1';
            mmio_bresp : OUT STD_LOGIC_VECTOR(1 DOWNTO 0) := "00";
            mmio_arvalid : IN STD_LOGIC := '0';
            mmio_arready : OUT STD_LOGIC := '1';
            mmio_araddr : IN STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000000";
            mmio_arprot : IN STD_LOGIC_VECTOR(2 DOWNTO 0) := "000";
            mmio_rvalid : OUT STD_LOGIC := '0';
            mmio_rready : IN STD_LOGIC := '1';
            mmio_rdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
            mmio_rresp : OUT STD_LOGIC_VECTOR(1 DOWNTO 0) := "00";
            mmio_uirq : OUT STD_LOGIC := '0'

        );
    END COMPONENT;

END PACKAGE mmio_pkg;