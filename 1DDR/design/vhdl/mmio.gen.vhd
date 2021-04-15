-- Generated using vhdMMIO 0.0.3 (https://github.com/abs-tudelft/vhdmmio)

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_misc.ALL;
USE ieee.numeric_std.ALL;

LIBRARY work;
USE work.vhdmmio_pkg.ALL;
USE work.mmio_pkg.ALL;

ENTITY mmio IS
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
    f_l_tax_values_data : OUT STD_LOGIC_VECTOR(63 DOWNTO 0) := (OTHERS => '0');

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

    -- Interface for field l_returnflag_o_offsets: l_returnflag_o_offsets.
    f_l_returnflag_o_offsets_data : OUT STD_LOGIC_VECTOR(63 DOWNTO 0)
    := (OTHERS => '0');

    -- Interface for field l_returnflag_o_values: l_returnflag_o_values.
    f_l_returnflag_o_values_data : OUT STD_LOGIC_VECTOR(63 DOWNTO 0)
    := (OTHERS => '0');

    -- Interface for field l_linestatus_o_offsets: l_linestatus_o_offsets.
    f_l_linestatus_o_offsets_data : OUT STD_LOGIC_VECTOR(63 DOWNTO 0)
    := (OTHERS => '0');

    -- Interface for field l_linestatus_o_values: l_linestatus_o_values.
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
    f_status_1_write_data : IN STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');

    -- Interface for field status_2: status_2.
    f_status_2_write_data : IN STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');

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
END mmio;

ARCHITECTURE behavioral OF mmio IS
BEGIN
  reg_proc : PROCESS (kcd_clk) IS

    -- Convenience function for unsigned accumulation with differing vector
    -- widths.
    PROCEDURE accum_add(
      accum : INOUT STD_LOGIC_VECTOR;
      addend : STD_LOGIC_VECTOR) IS
    BEGIN
      accum := STD_LOGIC_VECTOR(
        unsigned(accum) + resize(unsigned(addend), accum'length));
    END PROCEDURE accum_add;

    -- Convenience function for unsigned subtraction with differing vector
    -- widths.
    PROCEDURE accum_sub(
      accum : INOUT STD_LOGIC_VECTOR;
      addend : STD_LOGIC_VECTOR) IS
    BEGIN
      accum := STD_LOGIC_VECTOR(
        unsigned(accum) - resize(unsigned(addend), accum'length));
    END PROCEDURE accum_sub;

    -- Internal alias for the reset input.
    VARIABLE reset : STD_LOGIC;

    -- Bus response output register.
    VARIABLE bus_v : axi4l32_s2m_type := AXI4L32_S2M_RESET; -- reg

    -- Holding registers for the AXI4-lite request channels. Having these
    -- allows us to make the accompanying ready signals register outputs
    -- without sacrificing a cycle's worth of delay for every transaction.
    VARIABLE awl : axi4la_type := AXI4LA_RESET; -- reg
    VARIABLE wl : axi4lw32_type := AXI4LW32_RESET; -- reg
    VARIABLE arl : axi4la_type := AXI4LA_RESET; -- reg

    -- Request flags for the register logic. When asserted, a request is
    -- present in awl/wl/arl, and the response can be returned immediately.
    -- This is used by simple registers.
    VARIABLE w_req : BOOLEAN := false;
    VARIABLE r_req : BOOLEAN := false;

    -- As above, but asserted when there is a request that can NOT be returned
    -- immediately for whatever reason, but CAN be started already if deferral
    -- is supported by the targeted block. Abbreviation for lookahead request.
    -- Note that *_lreq implies *_req.
    VARIABLE w_lreq : BOOLEAN := false;
    VARIABLE r_lreq : BOOLEAN := false;

    -- Request signals. w_strb is a validity bit for each data bit; it actually
    -- always has byte granularity but encoding it this way makes the code a
    -- lot nicer (and it should be optimized to the same thing by any sane
    -- synthesizer).
    VARIABLE w_addr : STD_LOGIC_VECTOR(31 DOWNTO 0);
    VARIABLE w_data : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    VARIABLE w_strb : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    CONSTANT w_prot : STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0');
    VARIABLE r_addr : STD_LOGIC_VECTOR(31 DOWNTO 0);
    CONSTANT r_prot : STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0');

    -- Logical write data holding registers. For multi-word registers, write
    -- data is held in w_hold and w_hstb until the last subregister is written,
    -- at which point their entire contents are written at once.
    VARIABLE w_hold : STD_LOGIC_VECTOR(63 DOWNTO 0) := (OTHERS => '0'); -- reg
    VARIABLE w_hstb : STD_LOGIC_VECTOR(63 DOWNTO 0) := (OTHERS => '0'); -- reg

    -- Between the first and last access to a multiword register, the multi
    -- bit will be set. If it is set while a request with a different *_prot is
    -- received, the interrupting request is rejected if it is A) non-secure
    -- while the interrupted request is secure or B) unprivileged while the
    -- interrupted request is privileged. If it is not rejected, previously
    -- buffered data is cleared and masked. Within the same security level, it
    -- is up to the bus master to not mess up its own access pattern. The last
    -- access to a multiword register clears the bit; for the read end r_hold
    -- is also cleared in this case to prevent data leaks.
    VARIABLE w_multi : STD_LOGIC := '0'; -- reg
    VARIABLE r_multi : STD_LOGIC := '0'; -- reg

    -- Response flags. When *_req is set and *_addr matches a register, it must
    -- set at least one of these flags; when *_rreq is set and *_rtag matches a
    -- register, it must also set at least one of these, except it cannot set
    -- *_defer. A decode error can be generated by intentionally NOT setting
    -- any of these flags, but this should only be done by registers that
    -- contain only one field (usually, these would be AXI-lite passthrough
    -- "registers"). The action taken by the non-register-specific logic is as
    -- follows (priority decoder):
    --
    --  - if *_defer is set, push *_dtag into the deferal FIFO;
    --  - if *_block is set, do nothing;
    --  - otherwise, if *_nack is set, send a slave error response;
    --  - otherwise, if *_ack is set, send a positive response;
    --  - otherwise, send a decode error response.
    --
    -- In addition to the above, the request stream(s) will be handshaked if
    -- *_req was set and a response is sent or the response is deferred.
    -- Likewise, the deferal FIFO will be popped if *_rreq was set and a
    -- response is sent.
    --
    -- The valid states can be summarized as follows:
    --
    -- .----------------------------------------------------------------------------------.
    -- | req | lreq | rreq || ack | nack | block | defer || request | response | defer    |
    -- |-----+------+------||-----+------+-------+-------||---------+----------+----------|
    -- |  0  |  0   |  0   ||  0  |  0   |   0   |   0   ||         |          |          | Idle.
    -- |-----+------+------||-----+------+-------+-------||---------+----------+----------|
    -- |  0  |  0   |  1   ||  0  |  0   |   0   |   0   ||         | dec_err  | pop      | Completing
    -- |  0  |  0   |  1   ||  1  |  0   |   0   |   0   ||         | ack      | pop      | previous,
    -- |  0  |  0   |  1   ||  -  |  1   |   0   |   0   ||         | slv_err  | pop      | no
    -- |  0  |  0   |  1   ||  -  |  -   |   1   |   0   ||         |          |          | lookahead.
    -- |-----+------+------||-----+------+-------+-------||---------+----------+----------|
    -- |  1  |  0   |  0   ||  0  |  0   |   0   |   0   || accept  | dec_err  |          | Responding
    -- |  1  |  0   |  0   ||  1  |  0   |   0   |   0   || accept  | ack      |          | immediately
    -- |  1  |  0   |  0   ||  -  |  1   |   0   |   0   || accept  | slv_err  |          | to incoming
    -- |  1  |  0   |  0   ||  -  |  -   |   1   |   0   ||         |          |          | request.
    -- |-----+------+------||-----+------+-------+-------||---------+----------+----------|
    -- |  1  |  0   |  0   ||  0  |  0   |   0   |   1   || accept  |          | push     | Deferring.
    -- |  0  |  1   |  0   ||  0  |  0   |   0   |   1   || accept  |          | push     | Deferring.
    -- |-----+------+------||-----+------+-------+-------||---------+----------+----------|
    -- |  0  |  1   |  1   ||  0  |  0   |   0   |   0   ||         | dec_err  | pop      | Completing
    -- |  0  |  1   |  1   ||  1  |  0   |   0   |   0   ||         | ack      | pop      | previous,
    -- |  0  |  1   |  1   ||  -  |  1   |   0   |   0   ||         | slv_err  | pop      | ignoring
    -- |  0  |  1   |  1   ||  -  |  -   |   1   |   0   ||         |          |          | lookahead.
    -- |-----+------+------||-----+------+-------+-------||---------+----------+----------|
    -- |  0  |  1   |  1   ||  0  |  0   |   0   |   1   || accept  | dec_err  | pop+push | Completing
    -- |  0  |  1   |  1   ||  1  |  0   |   0   |   1   || accept  | ack      | pop+push | previous,
    -- |  0  |  1   |  1   ||  -  |  1   |   0   |   1   || accept  | slv_err  | pop+push | deferring
    -- |  0  |  1   |  1   ||  -  |  -   |   1   |   1   || accept  |          | push     | lookahead.
    -- '----------------------------------------------------------------------------------'
    --
    -- This can be simplified to the following:
    --
    -- .----------------------------------------------------------------------------------.
    -- | req | lreq | rreq || ack | nack | block | defer || request | response | defer    |
    -- |-----+------+------||-----+------+-------+-------||---------+----------+----------|
    -- |  -  |  -   |  -   ||  -  |  -   |   1   |   -   ||         |          |          |
    -- |-----+------+------||-----+------+-------+-------||---------+----------+----------|
    -- |  -  |  -   |  1   ||  -  |  1   |   0   |   -   ||         | slv_err  | pop      |
    -- |  1  |  -   |  0   ||  -  |  1   |   0   |   -   || accept  | slv_err  |          |
    -- |-----+------+------||-----+------+-------+-------||---------+----------+----------|
    -- |  -  |  -   |  1   ||  1  |  0   |   0   |   -   ||         | ack      | pop      |
    -- |  1  |  -   |  0   ||  1  |  0   |   0   |   -   || accept  | ack      |          |
    -- |-----+------+------||-----+------+-------+-------||---------+----------+----------|
    -- |  -  |  -   |  1   ||  0  |  0   |   0   |   -   ||         | dec_err  | pop      |
    -- |  1  |  -   |  0   ||  0  |  0   |   0   |   -   || accept  | dec_err  |          |
    -- |-----+------+------||-----+------+-------+-------||---------+----------+----------|
    -- |  -  |  -   |  -   ||  -  |  -   |   -   |   1   || accept  |          | push     |
    -- '----------------------------------------------------------------------------------'
    --
    VARIABLE w_block : BOOLEAN := false;
    VARIABLE r_block : BOOLEAN := false;
    VARIABLE w_nack : BOOLEAN := false;
    VARIABLE r_nack : BOOLEAN := false;
    VARIABLE w_ack : BOOLEAN := false;
    VARIABLE r_ack : BOOLEAN := false;

    -- Logical read data holding register. This is set when r_ack is set during
    -- an access to the first physical register of a logical register for all
    -- fields in the logical register.
    VARIABLE r_hold : STD_LOGIC_VECTOR(63 DOWNTO 0) := (OTHERS => '0'); -- reg

    -- Physical read data. This is taken from r_hold based on which physical
    -- subregister is being read.
    VARIABLE r_data : STD_LOGIC_VECTOR(31 DOWNTO 0);

    -- Subaddress variables, used to index within large fields like memories and
    -- AXI passthroughs.
    VARIABLE subaddr_none : STD_LOGIC_VECTOR(0 DOWNTO 0);

    -- Private declarations for field start: start.
    TYPE f_start_r_type IS RECORD
      d : STD_LOGIC;
      v : STD_LOGIC;
      inval : STD_LOGIC;
    END RECORD;
    CONSTANT F_START_R_RESET : f_start_r_type := (
      d => '0',
      v => '0',
      inval => '0'
    );
    TYPE f_start_r_array IS ARRAY (NATURAL RANGE <>) OF f_start_r_type;
    VARIABLE f_start_r : f_start_r_array(0 TO 0) := (OTHERS => F_START_R_RESET);

    -- Private declarations for field stop: stop.
    TYPE f_stop_r_type IS RECORD
      d : STD_LOGIC;
      v : STD_LOGIC;
      inval : STD_LOGIC;
    END RECORD;
    CONSTANT F_STOP_R_RESET : f_stop_r_type := (
      d => '0',
      v => '0',
      inval => '0'
    );
    TYPE f_stop_r_array IS ARRAY (NATURAL RANGE <>) OF f_stop_r_type;
    VARIABLE f_stop_r : f_stop_r_array(0 TO 0) := (OTHERS => F_STOP_R_RESET);

    -- Private declarations for field reset: reset.
    TYPE f_reset_r_type IS RECORD
      d : STD_LOGIC;
      v : STD_LOGIC;
      inval : STD_LOGIC;
    END RECORD;
    CONSTANT F_RESET_R_RESET : f_reset_r_type := (
      d => '0',
      v => '0',
      inval => '0'
    );
    TYPE f_reset_r_array IS ARRAY (NATURAL RANGE <>) OF f_reset_r_type;
    VARIABLE f_reset_r : f_reset_r_array(0 TO 0) := (OTHERS => F_RESET_R_RESET);

    -- Private declarations for field idle: idle.
    TYPE f_idle_r_type IS RECORD
      d : STD_LOGIC;
      v : STD_LOGIC;
    END RECORD;
    CONSTANT F_IDLE_R_RESET : f_idle_r_type := (
      d => '0',
      v => '0'
    );
    TYPE f_idle_r_array IS ARRAY (NATURAL RANGE <>) OF f_idle_r_type;
    VARIABLE f_idle_r : f_idle_r_array(0 TO 0) := (OTHERS => F_IDLE_R_RESET);

    -- Private declarations for field busy: busy.
    TYPE f_busy_r_type IS RECORD
      d : STD_LOGIC;
      v : STD_LOGIC;
    END RECORD;
    CONSTANT F_BUSY_R_RESET : f_busy_r_type := (
      d => '0',
      v => '0'
    );
    TYPE f_busy_r_array IS ARRAY (NATURAL RANGE <>) OF f_busy_r_type;
    VARIABLE f_busy_r : f_busy_r_array(0 TO 0) := (OTHERS => F_BUSY_R_RESET);

    -- Private declarations for field done: done.
    TYPE f_done_r_type IS RECORD
      d : STD_LOGIC;
      v : STD_LOGIC;
    END RECORD;
    CONSTANT F_DONE_R_RESET : f_done_r_type := (
      d => '0',
      v => '0'
    );
    TYPE f_done_r_array IS ARRAY (NATURAL RANGE <>) OF f_done_r_type;
    VARIABLE f_done_r : f_done_r_array(0 TO 0) := (OTHERS => F_DONE_R_RESET);

    -- Private declarations for field result: result.
    TYPE f_result_r_type IS RECORD
      d : STD_LOGIC_VECTOR(63 DOWNTO 0);
      v : STD_LOGIC;
    END RECORD;
    CONSTANT F_RESULT_R_RESET : f_result_r_type := (
      d => (OTHERS => '0'),
      v => '0'
    );
    TYPE f_result_r_array IS ARRAY (NATURAL RANGE <>) OF f_result_r_type;
    VARIABLE f_result_r : f_result_r_array(0 TO 0)
    := (OTHERS => F_RESULT_R_RESET);

    -- Private declarations for field l_firstidx: l_firstidx.
    TYPE f_l_firstidx_r_type IS RECORD
      d : STD_LOGIC_VECTOR(31 DOWNTO 0);
      v : STD_LOGIC;
    END RECORD;
    CONSTANT F_L_FIRSTIDX_R_RESET : f_l_firstidx_r_type := (
      d => (OTHERS => '0'),
      v => '0'
    );
    TYPE f_l_firstidx_r_array IS ARRAY (NATURAL RANGE <>) OF f_l_firstidx_r_type;
    VARIABLE f_l_firstidx_r : f_l_firstidx_r_array(0 TO 0)
    := (OTHERS => F_L_FIRSTIDX_R_RESET);

    -- Private declarations for field l_lastidx: l_lastidx.
    TYPE f_l_lastidx_r_type IS RECORD
      d : STD_LOGIC_VECTOR(31 DOWNTO 0);
      v : STD_LOGIC;
    END RECORD;
    CONSTANT F_L_LASTIDX_R_RESET : f_l_lastidx_r_type := (
      d => (OTHERS => '0'),
      v => '0'
    );
    TYPE f_l_lastidx_r_array IS ARRAY (NATURAL RANGE <>) OF f_l_lastidx_r_type;
    VARIABLE f_l_lastidx_r : f_l_lastidx_r_array(0 TO 0)
    := (OTHERS => F_L_LASTIDX_R_RESET);

    -- Private declarations for field l_quantity_values: l_quantity_values.
    TYPE f_l_quantity_values_r_type IS RECORD
      d : STD_LOGIC_VECTOR(63 DOWNTO 0);
      v : STD_LOGIC;
    END RECORD;
    CONSTANT F_L_QUANTITY_VALUES_R_RESET : f_l_quantity_values_r_type := (
      d => (OTHERS => '0'),
      v => '0'
    );
    TYPE f_l_quantity_values_r_array IS ARRAY (NATURAL RANGE <>) OF f_l_quantity_values_r_type;
    VARIABLE f_l_quantity_values_r : f_l_quantity_values_r_array(0 TO 0)
    := (OTHERS => F_L_QUANTITY_VALUES_R_RESET);

    -- Private declarations for field l_extendedprice_values:
    -- l_extendedprice_values.
    TYPE f_l_extendedprice_values_r_type IS RECORD
      d : STD_LOGIC_VECTOR(63 DOWNTO 0);
      v : STD_LOGIC;
    END RECORD;
    CONSTANT F_L_EXTENDEDPRICE_VALUES_R_RESET : f_l_extendedprice_values_r_type := (
      d => (OTHERS => '0'),
      v => '0'
    );
    TYPE f_l_extendedprice_values_r_array IS ARRAY (NATURAL RANGE <>) OF f_l_extendedprice_values_r_type;
    VARIABLE f_l_extendedprice_values_r : f_l_extendedprice_values_r_array(0 TO 0)
    := (OTHERS => F_L_EXTENDEDPRICE_VALUES_R_RESET);

    -- Private declarations for field l_discount_values: l_discount_values.
    TYPE f_l_discount_values_r_type IS RECORD
      d : STD_LOGIC_VECTOR(63 DOWNTO 0);
      v : STD_LOGIC;
    END RECORD;
    CONSTANT F_L_DISCOUNT_VALUES_R_RESET : f_l_discount_values_r_type := (
      d => (OTHERS => '0'),
      v => '0'
    );
    TYPE f_l_discount_values_r_array IS ARRAY (NATURAL RANGE <>) OF f_l_discount_values_r_type;
    VARIABLE f_l_discount_values_r : f_l_discount_values_r_array(0 TO 0)
    := (OTHERS => F_L_DISCOUNT_VALUES_R_RESET);

    -- Private declarations for field l_tax_values: l_tax_values.
    TYPE f_l_tax_values_r_type IS RECORD
      d : STD_LOGIC_VECTOR(63 DOWNTO 0);
      v : STD_LOGIC;
    END RECORD;
    CONSTANT F_L_TAX_VALUES_R_RESET : f_l_tax_values_r_type := (
      d => (OTHERS => '0'),
      v => '0'
    );
    TYPE f_l_tax_values_r_array IS ARRAY (NATURAL RANGE <>) OF f_l_tax_values_r_type;
    VARIABLE f_l_tax_values_r : f_l_tax_values_r_array(0 TO 0)
    := (OTHERS => F_L_TAX_VALUES_R_RESET);

    -- Private declarations for field l_returnflag_offsets:
    -- l_returnflag_offsets.
    TYPE f_l_returnflag_offsets_r_type IS RECORD
      d : STD_LOGIC_VECTOR(63 DOWNTO 0);
      v : STD_LOGIC;
    END RECORD;
    CONSTANT F_L_RETURNFLAG_OFFSETS_R_RESET : f_l_returnflag_offsets_r_type := (
      d => (OTHERS => '0'),
      v => '0'
    );
    TYPE f_l_returnflag_offsets_r_array IS ARRAY (NATURAL RANGE <>) OF f_l_returnflag_offsets_r_type;
    VARIABLE f_l_returnflag_offsets_r : f_l_returnflag_offsets_r_array(0 TO 0)
    := (OTHERS => F_L_RETURNFLAG_OFFSETS_R_RESET);

    -- Private declarations for field l_returnflag_values: l_returnflag_values.
    TYPE f_l_returnflag_values_r_type IS RECORD
      d : STD_LOGIC_VECTOR(63 DOWNTO 0);
      v : STD_LOGIC;
    END RECORD;
    CONSTANT F_L_RETURNFLAG_VALUES_R_RESET : f_l_returnflag_values_r_type := (
      d => (OTHERS => '0'),
      v => '0'
    );
    TYPE f_l_returnflag_values_r_array IS ARRAY (NATURAL RANGE <>) OF f_l_returnflag_values_r_type;
    VARIABLE f_l_returnflag_values_r : f_l_returnflag_values_r_array(0 TO 0)
    := (OTHERS => F_L_RETURNFLAG_VALUES_R_RESET);

    -- Private declarations for field l_linestatus_offsets:
    -- l_linestatus_offsets.
    TYPE f_l_linestatus_offsets_r_type IS RECORD
      d : STD_LOGIC_VECTOR(63 DOWNTO 0);
      v : STD_LOGIC;
    END RECORD;
    CONSTANT F_L_LINESTATUS_OFFSETS_R_RESET : f_l_linestatus_offsets_r_type := (
      d => (OTHERS => '0'),
      v => '0'
    );
    TYPE f_l_linestatus_offsets_r_array IS ARRAY (NATURAL RANGE <>) OF f_l_linestatus_offsets_r_type;
    VARIABLE f_l_linestatus_offsets_r : f_l_linestatus_offsets_r_array(0 TO 0)
    := (OTHERS => F_L_LINESTATUS_OFFSETS_R_RESET);

    -- Private declarations for field l_linestatus_values: l_linestatus_values.
    TYPE f_l_linestatus_values_r_type IS RECORD
      d : STD_LOGIC_VECTOR(63 DOWNTO 0);
      v : STD_LOGIC;
    END RECORD;
    CONSTANT F_L_LINESTATUS_VALUES_R_RESET : f_l_linestatus_values_r_type := (
      d => (OTHERS => '0'),
      v => '0'
    );
    TYPE f_l_linestatus_values_r_array IS ARRAY (NATURAL RANGE <>) OF f_l_linestatus_values_r_type;
    VARIABLE f_l_linestatus_values_r : f_l_linestatus_values_r_array(0 TO 0)
    := (OTHERS => F_L_LINESTATUS_VALUES_R_RESET);

    -- Private declarations for field l_shipdate_values: l_shipdate_values.
    TYPE f_l_shipdate_values_r_type IS RECORD
      d : STD_LOGIC_VECTOR(63 DOWNTO 0);
      v : STD_LOGIC;
    END RECORD;
    CONSTANT F_L_SHIPDATE_VALUES_R_RESET : f_l_shipdate_values_r_type := (
      d => (OTHERS => '0'),
      v => '0'
    );
    TYPE f_l_shipdate_values_r_array IS ARRAY (NATURAL RANGE <>) OF f_l_shipdate_values_r_type;
    VARIABLE f_l_shipdate_values_r : f_l_shipdate_values_r_array(0 TO 0)
    := (OTHERS => F_L_SHIPDATE_VALUES_R_RESET);

    -- Private declarations for field l_returnflag_o_offsets:
    -- l_returnflag_o_offsets.
    TYPE f_l_returnflag_o_offsets_r_type IS RECORD
      d : STD_LOGIC_VECTOR(63 DOWNTO 0);
      v : STD_LOGIC;
    END RECORD;
    CONSTANT F_L_RETURNFLAG_O_OFFSETS_R_RESET : f_l_returnflag_o_offsets_r_type := (
      d => (OTHERS => '0'),
      v => '0'
    );
    TYPE f_l_returnflag_o_offsets_r_array IS ARRAY (NATURAL RANGE <>) OF f_l_returnflag_o_offsets_r_type;
    VARIABLE f_l_returnflag_o_offsets_r : f_l_returnflag_o_offsets_r_array(0 TO 0)
    := (OTHERS => F_L_RETURNFLAG_O_OFFSETS_R_RESET);

    -- Private declarations for field l_returnflag_o_values:
    -- l_returnflag_o_values.
    TYPE f_l_returnflag_o_values_r_type IS RECORD
      d : STD_LOGIC_VECTOR(63 DOWNTO 0);
      v : STD_LOGIC;
    END RECORD;
    CONSTANT F_L_RETURNFLAG_O_VALUES_R_RESET : f_l_returnflag_o_values_r_type := (
      d => (OTHERS => '0'),
      v => '0'
    );
    TYPE f_l_returnflag_o_values_r_array IS ARRAY (NATURAL RANGE <>) OF f_l_returnflag_o_values_r_type;
    VARIABLE f_l_returnflag_o_values_r : f_l_returnflag_o_values_r_array(0 TO 0)
    := (OTHERS => F_L_RETURNFLAG_O_VALUES_R_RESET);

    -- Private declarations for field l_linestatus_o_offsets:
    -- l_linestatus_o_offsets.
    TYPE f_l_linestatus_o_offsets_r_type IS RECORD
      d : STD_LOGIC_VECTOR(63 DOWNTO 0);
      v : STD_LOGIC;
    END RECORD;
    CONSTANT F_L_LINESTATUS_O_OFFSETS_R_RESET : f_l_linestatus_o_offsets_r_type := (
      d => (OTHERS => '0'),
      v => '0'
    );
    TYPE f_l_linestatus_o_offsets_r_array IS ARRAY (NATURAL RANGE <>) OF f_l_linestatus_o_offsets_r_type;
    VARIABLE f_l_linestatus_o_offsets_r : f_l_linestatus_o_offsets_r_array(0 TO 0)
    := (OTHERS => F_L_LINESTATUS_O_OFFSETS_R_RESET);

    -- Private declarations for field l_linestatus_o_values:
    -- l_linestatus_o_values.
    TYPE f_l_linestatus_o_values_r_type IS RECORD
      d : STD_LOGIC_VECTOR(63 DOWNTO 0);
      v : STD_LOGIC;
    END RECORD;
    CONSTANT F_L_LINESTATUS_O_VALUES_R_RESET : f_l_linestatus_o_values_r_type := (
      d => (OTHERS => '0'),
      v => '0'
    );
    TYPE f_l_linestatus_o_values_r_array IS ARRAY (NATURAL RANGE <>) OF f_l_linestatus_o_values_r_type;
    VARIABLE f_l_linestatus_o_values_r : f_l_linestatus_o_values_r_array(0 TO 0)
    := (OTHERS => F_L_LINESTATUS_O_VALUES_R_RESET);
    -- Private declarations for field l_sum_qty_values: l_sum_qty_values.
    TYPE f_l_sum_qty_values_r_type IS RECORD
      d : STD_LOGIC_VECTOR(63 DOWNTO 0);
      v : STD_LOGIC;
    END RECORD;
    CONSTANT F_L_SUM_QTY_VALUES_R_RESET : f_l_sum_qty_values_r_type := (
      d => (OTHERS => '0'),
      v => '0'
    );
    TYPE f_l_sum_qty_values_r_array IS ARRAY (NATURAL RANGE <>) OF f_l_sum_qty_values_r_type;
    VARIABLE f_l_sum_qty_values_r : f_l_sum_qty_values_r_array(0 TO 0)
    := (OTHERS => F_L_SUM_QTY_VALUES_R_RESET);

    -- Private declarations for field l_sum_base_price_values:
    -- l_sum_base_price_values.
    TYPE f_l_sum_base_price_values_r_type IS RECORD
      d : STD_LOGIC_VECTOR(63 DOWNTO 0);
      v : STD_LOGIC;
    END RECORD;
    CONSTANT F_L_SUM_BASE_PRICE_VALUES_R_RESET : f_l_sum_base_price_values_r_type := (
      d => (OTHERS => '0'),
      v => '0'
    );
    TYPE f_l_sum_base_price_values_r_array IS ARRAY (NATURAL RANGE <>) OF f_l_sum_base_price_values_r_type;
    VARIABLE f_l_sum_base_price_values_r : f_l_sum_base_price_values_r_array(0 TO 0)
    := (OTHERS => F_L_SUM_BASE_PRICE_VALUES_R_RESET);

    -- Private declarations for field l_sum_disc_price_values:
    -- l_sum_disc_price_values.
    TYPE f_l_sum_disc_price_values_r_type IS RECORD
      d : STD_LOGIC_VECTOR(63 DOWNTO 0);
      v : STD_LOGIC;
    END RECORD;
    CONSTANT F_L_SUM_DISC_PRICE_VALUES_R_RESET : f_l_sum_disc_price_values_r_type := (
      d => (OTHERS => '0'),
      v => '0'
    );
    TYPE f_l_sum_disc_price_values_r_array IS ARRAY (NATURAL RANGE <>) OF f_l_sum_disc_price_values_r_type;
    VARIABLE f_l_sum_disc_price_values_r : f_l_sum_disc_price_values_r_array(0 TO 0)
    := (OTHERS => F_L_SUM_DISC_PRICE_VALUES_R_RESET);

    -- Private declarations for field l_sum_charge_values: l_sum_charge_values.
    TYPE f_l_sum_charge_values_r_type IS RECORD
      d : STD_LOGIC_VECTOR(63 DOWNTO 0);
      v : STD_LOGIC;
    END RECORD;
    CONSTANT F_L_SUM_CHARGE_VALUES_R_RESET : f_l_sum_charge_values_r_type := (
      d => (OTHERS => '0'),
      v => '0'
    );
    TYPE f_l_sum_charge_values_r_array IS ARRAY (NATURAL RANGE <>) OF f_l_sum_charge_values_r_type;
    VARIABLE f_l_sum_charge_values_r : f_l_sum_charge_values_r_array(0 TO 0)
    := (OTHERS => F_L_SUM_CHARGE_VALUES_R_RESET);

    -- Private declarations for field l_avg_qty_values: l_avg_qty_values.
    TYPE f_l_avg_qty_values_r_type IS RECORD
      d : STD_LOGIC_VECTOR(63 DOWNTO 0);
      v : STD_LOGIC;
    END RECORD;
    CONSTANT F_L_AVG_QTY_VALUES_R_RESET : f_l_avg_qty_values_r_type := (
      d => (OTHERS => '0'),
      v => '0'
    );
    TYPE f_l_avg_qty_values_r_array IS ARRAY (NATURAL RANGE <>) OF f_l_avg_qty_values_r_type;
    VARIABLE f_l_avg_qty_values_r : f_l_avg_qty_values_r_array(0 TO 0)
    := (OTHERS => F_L_AVG_QTY_VALUES_R_RESET);

    -- Private declarations for field l_avg_price_values: l_avg_price_values.
    TYPE f_l_avg_price_values_r_type IS RECORD
      d : STD_LOGIC_VECTOR(63 DOWNTO 0);
      v : STD_LOGIC;
    END RECORD;
    CONSTANT F_L_AVG_PRICE_VALUES_R_RESET : f_l_avg_price_values_r_type := (
      d => (OTHERS => '0'),
      v => '0'
    );
    TYPE f_l_avg_price_values_r_array IS ARRAY (NATURAL RANGE <>) OF f_l_avg_price_values_r_type;
    VARIABLE f_l_avg_price_values_r : f_l_avg_price_values_r_array(0 TO 0)
    := (OTHERS => F_L_AVG_PRICE_VALUES_R_RESET);

    -- Private declarations for field l_avg_disc_values: l_avg_disc_values.
    TYPE f_l_avg_disc_values_r_type IS RECORD
      d : STD_LOGIC_VECTOR(63 DOWNTO 0);
      v : STD_LOGIC;
    END RECORD;
    CONSTANT F_L_AVG_DISC_VALUES_R_RESET : f_l_avg_disc_values_r_type := (
      d => (OTHERS => '0'),
      v => '0'
    );
    TYPE f_l_avg_disc_values_r_array IS ARRAY (NATURAL RANGE <>) OF f_l_avg_disc_values_r_type;
    VARIABLE f_l_avg_disc_values_r : f_l_avg_disc_values_r_array(0 TO 0)
    := (OTHERS => F_L_AVG_DISC_VALUES_R_RESET);

    -- Private declarations for field l_count_order_values:
    -- l_count_order_values.
    TYPE f_l_count_order_values_r_type IS RECORD
      d : STD_LOGIC_VECTOR(63 DOWNTO 0);
      v : STD_LOGIC;
    END RECORD;
    CONSTANT F_L_COUNT_ORDER_VALUES_R_RESET : f_l_count_order_values_r_type := (
      d => (OTHERS => '0'),
      v => '0'
    );
    TYPE f_l_count_order_values_r_array IS ARRAY (NATURAL RANGE <>) OF f_l_count_order_values_r_type;
    VARIABLE f_l_count_order_values_r : f_l_count_order_values_r_array(0 TO 0)
    := (OTHERS => F_L_COUNT_ORDER_VALUES_R_RESET);

    -- Private declarations for field rhigh: rhigh.
    TYPE f_rhigh_r_type IS RECORD
      d : STD_LOGIC_VECTOR(31 DOWNTO 0);
      v : STD_LOGIC;
    END RECORD;
    CONSTANT F_RHIGH_R_RESET : f_rhigh_r_type := (
      d => (OTHERS => '0'),
      v => '0'
    );
    TYPE f_rhigh_r_array IS ARRAY (NATURAL RANGE <>) OF f_rhigh_r_type;
    VARIABLE f_rhigh_r : f_rhigh_r_array(0 TO 0) := (OTHERS => F_RHIGH_R_RESET);

    -- Private declarations for field rlow: rlow.
    TYPE f_rlow_r_type IS RECORD
      d : STD_LOGIC_VECTOR(31 DOWNTO 0);
      v : STD_LOGIC;
    END RECORD;
    CONSTANT F_RLOW_R_RESET : f_rlow_r_type := (
      d => (OTHERS => '0'),
      v => '0'
    );
    TYPE f_rlow_r_array IS ARRAY (NATURAL RANGE <>) OF f_rlow_r_type;
    VARIABLE f_rlow_r : f_rlow_r_array(0 TO 0) := (OTHERS => F_RLOW_R_RESET);

    -- Private declarations for field status_1: status_1.
    TYPE f_status_1_r_type IS RECORD
      d : STD_LOGIC_VECTOR(31 DOWNTO 0);
      v : STD_LOGIC;
    END RECORD;
    CONSTANT F_STATUS_1_R_RESET : f_status_1_r_type := (
      d => (OTHERS => '0'),
      v => '0'
    );
    TYPE f_status_1_r_array IS ARRAY (NATURAL RANGE <>) OF f_status_1_r_type;
    VARIABLE f_status_1_r : f_status_1_r_array(0 TO 0)
    := (OTHERS => F_STATUS_1_R_RESET);

    -- Private declarations for field status_2: status_2.
    TYPE f_status_2_r_type IS RECORD
      d : STD_LOGIC_VECTOR(31 DOWNTO 0);
      v : STD_LOGIC;
    END RECORD;
    CONSTANT F_STATUS_2_R_RESET : f_status_2_r_type := (
      d => (OTHERS => '0'),
      v => '0'
    );
    TYPE f_status_2_r_array IS ARRAY (NATURAL RANGE <>) OF f_status_2_r_type;
    VARIABLE f_status_2_r : f_status_2_r_array(0 TO 0)
    := (OTHERS => F_STATUS_2_R_RESET);

    -- Private declarations for field r1: r1.
    TYPE f_r1_r_type IS RECORD
      d : STD_LOGIC_VECTOR(63 DOWNTO 0);
      v : STD_LOGIC;
    END RECORD;
    CONSTANT F_R1_R_RESET : f_r1_r_type := (
      d => (OTHERS => '0'),
      v => '0'
    );
    TYPE f_r1_r_array IS ARRAY (NATURAL RANGE <>) OF f_r1_r_type;
    VARIABLE f_r1_r : f_r1_r_array(0 TO 0) := (OTHERS => F_R1_R_RESET);

    -- Private declarations for field r2: r2.
    TYPE f_r2_r_type IS RECORD
      d : STD_LOGIC_VECTOR(63 DOWNTO 0);
      v : STD_LOGIC;
    END RECORD;
    CONSTANT F_R2_R_RESET : f_r2_r_type := (
      d => (OTHERS => '0'),
      v => '0'
    );
    TYPE f_r2_r_array IS ARRAY (NATURAL RANGE <>) OF f_r2_r_type;
    VARIABLE f_r2_r : f_r2_r_array(0 TO 0) := (OTHERS => F_R2_R_RESET);

    -- Private declarations for field r3: r3.
    TYPE f_r3_r_type IS RECORD
      d : STD_LOGIC_VECTOR(63 DOWNTO 0);
      v : STD_LOGIC;
    END RECORD;
    CONSTANT F_R3_R_RESET : f_r3_r_type := (
      d => (OTHERS => '0'),
      v => '0'
    );
    TYPE f_r3_r_array IS ARRAY (NATURAL RANGE <>) OF f_r3_r_type;
    VARIABLE f_r3_r : f_r3_r_array(0 TO 0) := (OTHERS => F_R3_R_RESET);

    -- Private declarations for field r4: r4.
    TYPE f_r4_r_type IS RECORD
      d : STD_LOGIC_VECTOR(63 DOWNTO 0);
      v : STD_LOGIC;
    END RECORD;
    CONSTANT F_R4_R_RESET : f_r4_r_type := (
      d => (OTHERS => '0'),
      v => '0'
    );
    TYPE f_r4_r_array IS ARRAY (NATURAL RANGE <>) OF f_r4_r_type;
    VARIABLE f_r4_r : f_r4_r_array(0 TO 0) := (OTHERS => F_R4_R_RESET);

    -- Private declarations for field r5: r5.
    TYPE f_r5_r_type IS RECORD
      d : STD_LOGIC_VECTOR(63 DOWNTO 0);
      v : STD_LOGIC;
    END RECORD;
    CONSTANT F_R5_R_RESET : f_r5_r_type := (
      d => (OTHERS => '0'),
      v => '0'
    );
    TYPE f_r5_r_array IS ARRAY (NATURAL RANGE <>) OF f_r5_r_type;
    VARIABLE f_r5_r : f_r5_r_array(0 TO 0) := (OTHERS => F_R5_R_RESET);

    -- Private declarations for field r6: r6.
    TYPE f_r6_r_type IS RECORD
      d : STD_LOGIC_VECTOR(63 DOWNTO 0);
      v : STD_LOGIC;
    END RECORD;
    CONSTANT F_R6_R_RESET : f_r6_r_type := (
      d => (OTHERS => '0'),
      v => '0'
    );
    TYPE f_r6_r_array IS ARRAY (NATURAL RANGE <>) OF f_r6_r_type;
    VARIABLE f_r6_r : f_r6_r_array(0 TO 0) := (OTHERS => F_R6_R_RESET);

    -- Private declarations for field r7: r7.
    TYPE f_r7_r_type IS RECORD
      d : STD_LOGIC_VECTOR(63 DOWNTO 0);
      v : STD_LOGIC;
    END RECORD;
    CONSTANT F_R7_R_RESET : f_r7_r_type := (
      d => (OTHERS => '0'),
      v => '0'
    );
    TYPE f_r7_r_array IS ARRAY (NATURAL RANGE <>) OF f_r7_r_type;
    VARIABLE f_r7_r : f_r7_r_array(0 TO 0) := (OTHERS => F_R7_R_RESET);

    -- Private declarations for field r8: r8.
    TYPE f_r8_r_type IS RECORD
      d : STD_LOGIC_VECTOR(63 DOWNTO 0);
      v : STD_LOGIC;
    END RECORD;
    CONSTANT F_R8_R_RESET : f_r8_r_type := (
      d => (OTHERS => '0'),
      v => '0'
    );
    TYPE f_r8_r_array IS ARRAY (NATURAL RANGE <>) OF f_r8_r_type;
    VARIABLE f_r8_r : f_r8_r_array(0 TO 0) := (OTHERS => F_R8_R_RESET);

    -- Private declarations for field Profile_enable: Profile_enable.
    TYPE f_Profile_enable_r_type IS RECORD
      d : STD_LOGIC;
      v : STD_LOGIC;
    END RECORD;
    CONSTANT F_PROFILE_ENABLE_R_RESET : f_Profile_enable_r_type := (
      d => '0',
      v => '0'
    );
    TYPE f_Profile_enable_r_array IS ARRAY (NATURAL RANGE <>) OF f_Profile_enable_r_type;
    VARIABLE f_Profile_enable_r : f_Profile_enable_r_array(0 TO 0)
    := (OTHERS => F_PROFILE_ENABLE_R_RESET);

    -- Private declarations for field Profile_clear: Profile_clear.
    TYPE f_Profile_clear_r_type IS RECORD
      d : STD_LOGIC;
      v : STD_LOGIC;
      inval : STD_LOGIC;
    END RECORD;
    CONSTANT F_PROFILE_CLEAR_R_RESET : f_Profile_clear_r_type := (
      d => '0',
      v => '0',
      inval => '0'
    );
    TYPE f_Profile_clear_r_array IS ARRAY (NATURAL RANGE <>) OF f_Profile_clear_r_type;
    VARIABLE f_Profile_clear_r : f_Profile_clear_r_array(0 TO 0)
    := (OTHERS => F_PROFILE_CLEAR_R_RESET);

    -- Temporary variables for the field templates.
    VARIABLE tmp_data : STD_LOGIC;
    VARIABLE tmp_strb : STD_LOGIC;
    VARIABLE tmp_data32 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    VARIABLE tmp_strb32 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    VARIABLE tmp_data64 : STD_LOGIC_VECTOR(63 DOWNTO 0);
    VARIABLE tmp_strb64 : STD_LOGIC_VECTOR(63 DOWNTO 0);

  BEGIN
    IF rising_edge(kcd_clk) THEN

      -- Reset variables that shouldn't become registers to default values.
      reset := kcd_reset;
      w_req := false;
      r_req := false;
      w_lreq := false;
      r_lreq := false;
      w_addr := (OTHERS => '0');
      w_data := (OTHERS => '0');
      w_strb := (OTHERS => '0');
      r_addr := (OTHERS => '0');
      w_block := false;
      r_block := false;
      w_nack := false;
      r_nack := false;
      w_ack := false;
      r_ack := false;
      r_data := (OTHERS => '0');

      -------------------------------------------------------------------------
      -- Finish up the previous cycle
      -------------------------------------------------------------------------
      -- Invalidate responses that were acknowledged by the master in the
      -- previous cycle.
      IF mmio_bready = '1' THEN
        bus_v.b.valid := '0';
      END IF;
      IF mmio_rready = '1' THEN
        bus_v.r.valid := '0';
      END IF;

      -- If we indicated to the master that we were ready for a transaction on
      -- any of the incoming channels, we must latch any incoming requests. If
      -- we're ready but there is no incoming request this becomes don't-care.
      IF bus_v.aw.ready = '1' THEN
        awl.valid := mmio_awvalid;
        awl.addr := mmio_awaddr;
        awl.prot := mmio_awprot;
      END IF;
      IF bus_v.w.ready = '1' THEN
        wl.valid := mmio_wvalid;
        wl.data := mmio_wdata;
        wl.strb := mmio_wstrb;
      END IF;
      IF bus_v.ar.ready = '1' THEN
        arl.valid := mmio_arvalid;
        arl.addr := mmio_araddr;
        arl.prot := mmio_arprot;
      END IF;

      -------------------------------------------------------------------------
      -- Handle interrupts
      -------------------------------------------------------------------------
      -- No incoming interrupts; request signal is always released.
      bus_v.u.irq := '0';

      -------------------------------------------------------------------------
      -- Handle MMIO fields
      -------------------------------------------------------------------------
      -- We're ready for a write/read when all the respective channels (or
      -- their holding registers) are ready/waiting for us.
      IF awl.valid = '1' AND wl.valid = '1' THEN
        IF bus_v.b.valid = '0' THEN
          w_req := true; -- Request valid and response register empty.
        ELSE
          w_lreq := true; -- Request valid, but response register is busy.
        END IF;
      END IF;
      IF arl.valid = '1' THEN
        IF bus_v.r.valid = '0' THEN
          r_req := true; -- Request valid and response register empty.
        ELSE
          r_lreq := true; -- Request valid, but response register is busy.
        END IF;
      END IF;

      -- Capture request inputs into more consistently named variables.
      w_addr := awl.addr;
      FOR b IN w_strb'RANGE LOOP
        w_strb(b) := wl.strb(b / 8);
      END LOOP;
      w_data := wl.data AND w_strb;
      r_addr := arl.addr;

      -------------------------------------------------------------------------
      -- Generated field logic
      -------------------------------------------------------------------------

      -- Pre-bus logic for field start: start.

      -- Handle post-write invalidation for field start one cycle after the
      -- write occurs.
      IF f_start_r((0)).inval = '1' THEN
        f_start_r((0)).d := '0';
        f_start_r((0)).v := '0';
      END IF;
      f_start_r((0)).inval := '0';

      -- Pre-bus logic for field stop: stop.

      -- Handle post-write invalidation for field stop one cycle after the write
      -- occurs.
      IF f_stop_r((0)).inval = '1' THEN
        f_stop_r((0)).d := '0';
        f_stop_r((0)).v := '0';
      END IF;
      f_stop_r((0)).inval := '0';

      -- Pre-bus logic for field reset: reset.

      -- Handle post-write invalidation for field reset one cycle after the
      -- write occurs.
      IF f_reset_r((0)).inval = '1' THEN
        f_reset_r((0)).d := '0';
        f_reset_r((0)).v := '0';
      END IF;
      f_reset_r((0)).inval := '0';

      -- Pre-bus logic for field idle: idle.

      -- Handle hardware write for field idle: status.
      f_idle_r((0)).d := f_idle_write_data;
      f_idle_r((0)).v := '1';

      -- Pre-bus logic for field busy: busy.

      -- Handle hardware write for field busy: status.
      f_busy_r((0)).d := f_busy_write_data;
      f_busy_r((0)).v := '1';

      -- Pre-bus logic for field done: done.

      -- Handle hardware write for field done: status.
      f_done_r((0)).d := f_done_write_data;
      f_done_r((0)).v := '1';

      -- Pre-bus logic for field result: result.

      -- Handle hardware write for field result: status.
      f_result_r((0)).d := f_result_write_data;
      f_result_r((0)).v := '1';

      -- Pre-bus logic for field rhigh: rhigh.

      -- Handle hardware write for field rhigh: status.
      f_rhigh_r((0)).d := f_rhigh_write_data;
      f_rhigh_r((0)).v := '1';

      -- Pre-bus logic for field rlow: rlow.

      -- Handle hardware write for field rlow: status.
      f_rlow_r((0)).d := f_rlow_write_data;
      f_rlow_r((0)).v := '1';

      -- Pre-bus logic for field status_1: status_1.

      -- Handle hardware write for field status_1: status.
      f_status_1_r((0)).d := f_status_1_write_data;
      f_status_1_r((0)).v := '1';

      -- Pre-bus logic for field status_2: status_2.

      -- Handle hardware write for field status_2: status.
      f_status_2_r((0)).d := f_status_2_write_data;
      f_status_2_r((0)).v := '1';

      -- Pre-bus logic for field r1: r1.

      -- Handle hardware write for field r1: status.
      f_r1_r((0)).d := f_r1_write_data;
      f_r1_r((0)).v := '1';

      -- Pre-bus logic for field r2: r2.

      -- Handle hardware write for field r2: status.
      f_r2_r((0)).d := f_r2_write_data;
      f_r2_r((0)).v := '1';

      -- Pre-bus logic for field r3: r3.

      -- Handle hardware write for field r3: status.
      f_r3_r((0)).d := f_r3_write_data;
      f_r3_r((0)).v := '1';

      -- Pre-bus logic for field r4: r4.

      -- Handle hardware write for field r4: status.
      f_r4_r((0)).d := f_r4_write_data;
      f_r4_r((0)).v := '1';

      -- Pre-bus logic for field r5: r5.

      -- Handle hardware write for field r5: status.
      f_r5_r((0)).d := f_r5_write_data;
      f_r5_r((0)).v := '1';

      -- Pre-bus logic for field r6: r6.

      -- Handle hardware write for field r6: status.
      f_r6_r((0)).d := f_r6_write_data;
      f_r6_r((0)).v := '1';

      -- Pre-bus logic for field r7: r7.

      -- Handle hardware write for field r7: status.
      f_r7_r((0)).d := f_r7_write_data;
      f_r7_r((0)).v := '1';

      -- Pre-bus logic for field r8: r8.

      -- Handle hardware write for field r8: status.
      f_r8_r((0)).d := f_r8_write_data;
      f_r8_r((0)).v := '1';

      -- Pre-bus logic for field Profile_clear: Profile_clear.

      -- Handle post-write invalidation for field Profile_clear one cycle after
      -- the write occurs.
      IF f_Profile_clear_r((0)).inval = '1' THEN
        f_Profile_clear_r((0)).d := '0';
        f_Profile_clear_r((0)).v := '0';
      END IF;
      f_Profile_clear_r((0)).inval := '0';

      -------------------------------------------------------------------------
      -- Bus read logic
      -------------------------------------------------------------------------

      -- Construct the subaddresses for read mode.
      subaddr_none(0) := '0';

      -- Read address decoder.
      CASE r_addr(8 DOWNTO 2) IS
        WHEN "0000001" =>
          -- r_addr = 000000000000000000000000000001--

          IF r_req THEN

            -- Clear holding register location prior to read.
            r_hold := (OTHERS => '0');

          END IF;

          -- Read logic for field idle: idle.

          IF r_req THEN
            tmp_data := r_hold(0);
          END IF;
          IF r_req THEN

            -- Regular access logic. Read mode: enabled.
            tmp_data := f_idle_r((0)).d;
            r_ack := true;

          END IF;
          IF r_req THEN
            r_hold(0) := tmp_data;
          END IF;

          -- Read logic for field busy: busy.

          IF r_req THEN
            tmp_data := r_hold(1);
          END IF;
          IF r_req THEN

            -- Regular access logic. Read mode: enabled.
            tmp_data := f_busy_r((0)).d;
            r_ack := true;

          END IF;
          IF r_req THEN
            r_hold(1) := tmp_data;
          END IF;

          -- Read logic for field done: done.

          IF r_req THEN
            tmp_data := r_hold(2);
          END IF;
          IF r_req THEN

            -- Regular access logic. Read mode: enabled.
            tmp_data := f_done_r((0)).d;
            r_ack := true;

          END IF;
          IF r_req THEN
            r_hold(2) := tmp_data;
          END IF;

          -- Read logic for block idle_reg: block containing bits 31..0 of
          -- register `idle_reg` (`IDLE`).
          IF r_req THEN

            r_data := r_hold(31 DOWNTO 0);
            r_multi := '0';

          END IF;

        WHEN "0000010" =>
          -- r_addr = 000000000000000000000000000010--

          IF r_req THEN

            -- Clear holding register location prior to read.
            r_hold := (OTHERS => '0');

          END IF;

          -- Read logic for field result: result.

          IF r_req THEN
            tmp_data64 := r_hold(63 DOWNTO 0);
          END IF;
          IF r_req THEN

            -- Regular access logic. Read mode: enabled.
            tmp_data64 := f_result_r((0)).d;
            r_ack := true;

          END IF;
          IF r_req THEN
            r_hold(63 DOWNTO 0) := tmp_data64;
          END IF;

          -- Read logic for block result_reg_low: block containing bits 31..0 of
          -- register `result_reg` (`RESULT`).
          IF r_req THEN

            r_data := r_hold(31 DOWNTO 0);
            r_multi := '1';

          END IF;

        WHEN "0000011" =>
          -- r_addr = 000000000000000000000000000011--

          -- Read logic for block result_reg_high: block containing bits 63..32
          -- of register `result_reg` (`RESULT`).
          IF r_req THEN

            r_data := r_hold(63 DOWNTO 32);
            IF r_multi = '1' THEN
              r_ack := true;
            ELSE
              r_nack := true;
            END IF;
            r_multi := '0';

          END IF;

        WHEN "0000100" =>
          -- r_addr = 000000000000000000000000000100--

          IF r_req THEN

            -- Clear holding register location prior to read.
            r_hold := (OTHERS => '0');

          END IF;

          -- Read logic for field l_firstidx: l_firstidx.

          IF r_req THEN
            tmp_data32 := r_hold(31 DOWNTO 0);
          END IF;
          IF r_req THEN

            -- Regular access logic. Read mode: enabled.
            tmp_data32 := f_l_firstidx_r((0)).d;
            r_ack := true;

          END IF;
          IF r_req THEN
            r_hold(31 DOWNTO 0) := tmp_data32;
          END IF;

          -- Read logic for block l_firstidx_reg: block containing bits 31..0 of
          -- register `l_firstidx_reg` (`L_FIRSTIDX`).
          IF r_req THEN

            r_data := r_hold(31 DOWNTO 0);
            r_multi := '0';

          END IF;

        WHEN "0000101" =>
          -- r_addr = 000000000000000000000000000101--

          IF r_req THEN

            -- Clear holding register location prior to read.
            r_hold := (OTHERS => '0');

          END IF;

          -- Read logic for field l_lastidx: l_lastidx.

          IF r_req THEN
            tmp_data32 := r_hold(31 DOWNTO 0);
          END IF;
          IF r_req THEN

            -- Regular access logic. Read mode: enabled.
            tmp_data32 := f_l_lastidx_r((0)).d;
            r_ack := true;

          END IF;
          IF r_req THEN
            r_hold(31 DOWNTO 0) := tmp_data32;
          END IF;

          -- Read logic for block l_lastidx_reg: block containing bits 31..0 of
          -- register `l_lastidx_reg` (`L_LASTIDX`).
          IF r_req THEN

            r_data := r_hold(31 DOWNTO 0);
            r_multi := '0';

          END IF;

        WHEN "0000110" =>
          -- r_addr = 000000000000000000000000000110--

          IF r_req THEN

            -- Clear holding register location prior to read.
            r_hold := (OTHERS => '0');

          END IF;

          -- Read logic for field l_quantity_values: l_quantity_values.

          IF r_req THEN
            tmp_data64 := r_hold(63 DOWNTO 0);
          END IF;
          IF r_req THEN

            -- Regular access logic. Read mode: enabled.
            tmp_data64 := f_l_quantity_values_r((0)).d;
            r_ack := true;

          END IF;
          IF r_req THEN
            r_hold(63 DOWNTO 0) := tmp_data64;
          END IF;

          -- Read logic for block l_quantity_values_reg_low: block containing
          -- bits 31..0 of register `l_quantity_values_reg`
          -- (`L_QUANTITY_VALUES`).
          IF r_req THEN

            r_data := r_hold(31 DOWNTO 0);
            r_multi := '1';

          END IF;

        WHEN "0000111" =>
          -- r_addr = 000000000000000000000000000111--

          -- Read logic for block l_quantity_values_reg_high: block containing
          -- bits 63..32 of register `l_quantity_values_reg`
          -- (`L_QUANTITY_VALUES`).
          IF r_req THEN

            r_data := r_hold(63 DOWNTO 32);
            IF r_multi = '1' THEN
              r_ack := true;
            ELSE
              r_nack := true;
            END IF;
            r_multi := '0';

          END IF;

        WHEN "0001000" =>
          -- r_addr = 000000000000000000000000001000--

          IF r_req THEN

            -- Clear holding register location prior to read.
            r_hold := (OTHERS => '0');

          END IF;

          -- Read logic for field l_extendedprice_values:
          -- l_extendedprice_values.

          IF r_req THEN
            tmp_data64 := r_hold(63 DOWNTO 0);
          END IF;
          IF r_req THEN

            -- Regular access logic. Read mode: enabled.
            tmp_data64 := f_l_extendedprice_values_r((0)).d;
            r_ack := true;

          END IF;
          IF r_req THEN
            r_hold(63 DOWNTO 0) := tmp_data64;
          END IF;

          -- Read logic for block l_extendedprice_values_reg_low: block
          -- containing bits 31..0 of register `l_extendedprice_values_reg`
          -- (`L_EXTENDEDPRICE_VALUES`).
          IF r_req THEN

            r_data := r_hold(31 DOWNTO 0);
            r_multi := '1';

          END IF;

        WHEN "0001001" =>
          -- r_addr = 000000000000000000000000001001--

          -- Read logic for block l_extendedprice_values_reg_high: block
          -- containing bits 63..32 of register `l_extendedprice_values_reg`
          -- (`L_EXTENDEDPRICE_VALUES`).
          IF r_req THEN

            r_data := r_hold(63 DOWNTO 32);
            IF r_multi = '1' THEN
              r_ack := true;
            ELSE
              r_nack := true;
            END IF;
            r_multi := '0';

          END IF;

        WHEN "0001010" =>
          -- r_addr = 000000000000000000000000001010--

          IF r_req THEN

            -- Clear holding register location prior to read.
            r_hold := (OTHERS => '0');

          END IF;

          -- Read logic for field l_discount_values: l_discount_values.

          IF r_req THEN
            tmp_data64 := r_hold(63 DOWNTO 0);
          END IF;
          IF r_req THEN

            -- Regular access logic. Read mode: enabled.
            tmp_data64 := f_l_discount_values_r((0)).d;
            r_ack := true;

          END IF;
          IF r_req THEN
            r_hold(63 DOWNTO 0) := tmp_data64;
          END IF;

          -- Read logic for block l_discount_values_reg_low: block containing
          -- bits 31..0 of register `l_discount_values_reg`
          -- (`L_DISCOUNT_VALUES`).
          IF r_req THEN

            r_data := r_hold(31 DOWNTO 0);
            r_multi := '1';

          END IF;

        WHEN "0001011" =>
          -- r_addr = 000000000000000000000000001011--

          -- Read logic for block l_discount_values_reg_high: block containing
          -- bits 63..32 of register `l_discount_values_reg`
          -- (`L_DISCOUNT_VALUES`).
          IF r_req THEN

            r_data := r_hold(63 DOWNTO 32);
            IF r_multi = '1' THEN
              r_ack := true;
            ELSE
              r_nack := true;
            END IF;
            r_multi := '0';

          END IF;

        WHEN "0001100" =>
          -- r_addr = 000000000000000000000000001100--

          IF r_req THEN

            -- Clear holding register location prior to read.
            r_hold := (OTHERS => '0');

          END IF;

          -- Read logic for field l_tax_values: l_tax_values.

          IF r_req THEN
            tmp_data64 := r_hold(63 DOWNTO 0);
          END IF;
          IF r_req THEN

            -- Regular access logic. Read mode: enabled.
            tmp_data64 := f_l_tax_values_r((0)).d;
            r_ack := true;

          END IF;
          IF r_req THEN
            r_hold(63 DOWNTO 0) := tmp_data64;
          END IF;

          -- Read logic for block l_tax_values_reg_low: block containing bits
          -- 31..0 of register `l_tax_values_reg` (`L_TAX_VALUES`).
          IF r_req THEN

            r_data := r_hold(31 DOWNTO 0);
            r_multi := '1';

          END IF;

        WHEN "0001101" =>
          -- r_addr = 000000000000000000000000001101--

          -- Read logic for block l_tax_values_reg_high: block containing bits
          -- 63..32 of register `l_tax_values_reg` (`L_TAX_VALUES`).
          IF r_req THEN

            r_data := r_hold(63 DOWNTO 32);
            IF r_multi = '1' THEN
              r_ack := true;
            ELSE
              r_nack := true;
            END IF;
            r_multi := '0';

          END IF;

        WHEN "0001110" =>
          -- r_addr = 000000000000000000000000001110--

          IF r_req THEN

            -- Clear holding register location prior to read.
            r_hold := (OTHERS => '0');

          END IF;

          -- Read logic for field l_returnflag_offsets: l_returnflag_offsets.

          IF r_req THEN
            tmp_data64 := r_hold(63 DOWNTO 0);
          END IF;
          IF r_req THEN

            -- Regular access logic. Read mode: enabled.
            tmp_data64 := f_l_returnflag_offsets_r((0)).d;
            r_ack := true;

          END IF;
          IF r_req THEN
            r_hold(63 DOWNTO 0) := tmp_data64;
          END IF;

          -- Read logic for block l_returnflag_offsets_reg_low: block containing
          -- bits 31..0 of register `l_returnflag_offsets_reg`
          -- (`L_RETURNFLAG_OFFSETS`).
          IF r_req THEN

            r_data := r_hold(31 DOWNTO 0);
            r_multi := '1';

          END IF;

        WHEN "0001111" =>
          -- r_addr = 000000000000000000000000001111--

          -- Read logic for block l_returnflag_offsets_reg_high: block
          -- containing bits 63..32 of register `l_returnflag_offsets_reg`
          -- (`L_RETURNFLAG_OFFSETS`).
          IF r_req THEN

            r_data := r_hold(63 DOWNTO 32);
            IF r_multi = '1' THEN
              r_ack := true;
            ELSE
              r_nack := true;
            END IF;
            r_multi := '0';

          END IF;

        WHEN "0010000" =>
          -- r_addr = 000000000000000000000000010000--

          IF r_req THEN

            -- Clear holding register location prior to read.
            r_hold := (OTHERS => '0');

          END IF;

          -- Read logic for field l_returnflag_values: l_returnflag_values.

          IF r_req THEN
            tmp_data64 := r_hold(63 DOWNTO 0);
          END IF;
          IF r_req THEN

            -- Regular access logic. Read mode: enabled.
            tmp_data64 := f_l_returnflag_values_r((0)).d;
            r_ack := true;

          END IF;
          IF r_req THEN
            r_hold(63 DOWNTO 0) := tmp_data64;
          END IF;

          -- Read logic for block l_returnflag_values_reg_low: block containing
          -- bits 31..0 of register `l_returnflag_values_reg`
          -- (`L_RETURNFLAG_VALUES`).
          IF r_req THEN

            r_data := r_hold(31 DOWNTO 0);
            r_multi := '1';

          END IF;

        WHEN "0010001" =>
          -- r_addr = 000000000000000000000000010001--

          -- Read logic for block l_returnflag_values_reg_high: block containing
          -- bits 63..32 of register `l_returnflag_values_reg`
          -- (`L_RETURNFLAG_VALUES`).
          IF r_req THEN

            r_data := r_hold(63 DOWNTO 32);
            IF r_multi = '1' THEN
              r_ack := true;
            ELSE
              r_nack := true;
            END IF;
            r_multi := '0';

          END IF;

        WHEN "0010010" =>
          -- r_addr = 000000000000000000000000010010--

          IF r_req THEN

            -- Clear holding register location prior to read.
            r_hold := (OTHERS => '0');

          END IF;

          -- Read logic for field l_linestatus_offsets: l_linestatus_offsets.

          IF r_req THEN
            tmp_data64 := r_hold(63 DOWNTO 0);
          END IF;
          IF r_req THEN

            -- Regular access logic. Read mode: enabled.
            tmp_data64 := f_l_linestatus_offsets_r((0)).d;
            r_ack := true;

          END IF;
          IF r_req THEN
            r_hold(63 DOWNTO 0) := tmp_data64;
          END IF;

          -- Read logic for block l_linestatus_offsets_reg_low: block containing
          -- bits 31..0 of register `l_linestatus_offsets_reg`
          -- (`L_LINESTATUS_OFFSETS`).
          IF r_req THEN

            r_data := r_hold(31 DOWNTO 0);
            r_multi := '1';

          END IF;

        WHEN "0010011" =>
          -- r_addr = 000000000000000000000000010011--

          -- Read logic for block l_linestatus_offsets_reg_high: block
          -- containing bits 63..32 of register `l_linestatus_offsets_reg`
          -- (`L_LINESTATUS_OFFSETS`).
          IF r_req THEN

            r_data := r_hold(63 DOWNTO 32);
            IF r_multi = '1' THEN
              r_ack := true;
            ELSE
              r_nack := true;
            END IF;
            r_multi := '0';

          END IF;

        WHEN "0010100" =>
          -- r_addr = 000000000000000000000000010100--

          IF r_req THEN

            -- Clear holding register location prior to read.
            r_hold := (OTHERS => '0');

          END IF;

          -- Read logic for field l_linestatus_values: l_linestatus_values.

          IF r_req THEN
            tmp_data64 := r_hold(63 DOWNTO 0);
          END IF;
          IF r_req THEN

            -- Regular access logic. Read mode: enabled.
            tmp_data64 := f_l_linestatus_values_r((0)).d;
            r_ack := true;

          END IF;
          IF r_req THEN
            r_hold(63 DOWNTO 0) := tmp_data64;
          END IF;

          -- Read logic for block l_linestatus_values_reg_low: block containing
          -- bits 31..0 of register `l_linestatus_values_reg`
          -- (`L_LINESTATUS_VALUES`).
          IF r_req THEN

            r_data := r_hold(31 DOWNTO 0);
            r_multi := '1';

          END IF;

        WHEN "0010101" =>
          -- r_addr = 000000000000000000000000010101--

          -- Read logic for block l_linestatus_values_reg_high: block containing
          -- bits 63..32 of register `l_linestatus_values_reg`
          -- (`L_LINESTATUS_VALUES`).
          IF r_req THEN

            r_data := r_hold(63 DOWNTO 32);
            IF r_multi = '1' THEN
              r_ack := true;
            ELSE
              r_nack := true;
            END IF;
            r_multi := '0';

          END IF;

        WHEN "0010110" =>
          -- r_addr = 000000000000000000000000010110--

          IF r_req THEN

            -- Clear holding register location prior to read.
            r_hold := (OTHERS => '0');

          END IF;

          -- Read logic for field l_shipdate_values: l_shipdate_values.

          IF r_req THEN
            tmp_data64 := r_hold(63 DOWNTO 0);
          END IF;
          IF r_req THEN

            -- Regular access logic. Read mode: enabled.
            tmp_data64 := f_l_shipdate_values_r((0)).d;
            r_ack := true;

          END IF;
          IF r_req THEN
            r_hold(63 DOWNTO 0) := tmp_data64;
          END IF;

          -- Read logic for block l_shipdate_values_reg_low: block containing
          -- bits 31..0 of register `l_shipdate_values_reg`
          -- (`L_SHIPDATE_VALUES`).
          IF r_req THEN

            r_data := r_hold(31 DOWNTO 0);
            r_multi := '1';

          END IF;

        WHEN "0010111" =>
          -- r_addr = 000000000000000000000000010111--

          -- Read logic for block l_shipdate_values_reg_high: block containing
          -- bits 63..32 of register `l_shipdate_values_reg`
          -- (`L_SHIPDATE_VALUES`).
          IF r_req THEN

            r_data := r_hold(63 DOWNTO 32);
            IF r_multi = '1' THEN
              r_ack := true;
            ELSE
              r_nack := true;
            END IF;
            r_multi := '0';

          END IF;

        WHEN "0011000" =>
          -- r_addr = 000000000000000000000000011000--

          IF r_req THEN

            -- Clear holding register location prior to read.
            r_hold := (OTHERS => '0');

          END IF;

          -- Read logic for field rhigh: rhigh.

          IF r_req THEN
            tmp_data32 := r_hold(31 DOWNTO 0);
          END IF;
          IF r_req THEN

            -- Regular access logic. Read mode: enabled.
            tmp_data32 := f_rhigh_r((0)).d;
            r_ack := true;

          END IF;
          IF r_req THEN
            r_hold(31 DOWNTO 0) := tmp_data32;
          END IF;

          -- Read logic for block rhigh_reg: block containing bits 31..0 of
          -- register `rhigh_reg` (`RHIGH`).
          IF r_req THEN

            r_data := r_hold(31 DOWNTO 0);
            r_multi := '0';

          END IF;

        WHEN "0011001" =>
          -- r_addr = 000000000000000000000000011001--

          IF r_req THEN

            -- Clear holding register location prior to read.
            r_hold := (OTHERS => '0');

          END IF;

          -- Read logic for field rlow: rlow.

          IF r_req THEN
            tmp_data32 := r_hold(31 DOWNTO 0);
          END IF;
          IF r_req THEN

            -- Regular access logic. Read mode: enabled.
            tmp_data32 := f_rlow_r((0)).d;
            r_ack := true;

          END IF;
          IF r_req THEN
            r_hold(31 DOWNTO 0) := tmp_data32;
          END IF;

          -- Read logic for block rlow_reg: block containing bits 31..0 of
          -- register `rlow_reg` (`RLOW`).
          IF r_req THEN

            r_data := r_hold(31 DOWNTO 0);
            r_multi := '0';

          END IF;

        WHEN "0011010" =>
          -- r_addr = 000000000000000000000000011010--

          IF r_req THEN

            -- Clear holding register location prior to read.
            r_hold := (OTHERS => '0');

          END IF;

          -- Read logic for field status_1: status_1.

          IF r_req THEN
            tmp_data32 := r_hold(31 DOWNTO 0);
          END IF;
          IF r_req THEN

            -- Regular access logic. Read mode: enabled.
            tmp_data32 := f_status_1_r((0)).d;
            r_ack := true;

          END IF;
          IF r_req THEN
            r_hold(31 DOWNTO 0) := tmp_data32;
          END IF;

          -- Read logic for block status_1_reg: block containing bits 31..0 of
          -- register `status_1_reg` (`STATUS_1`).
          IF r_req THEN

            r_data := r_hold(31 DOWNTO 0);
            r_multi := '0';

          END IF;

        WHEN "0011011" =>
          -- r_addr = 000000000000000000000000011011--

          IF r_req THEN

            -- Clear holding register location prior to read.
            r_hold := (OTHERS => '0');

          END IF;

          -- Read logic for field status_2: status_2.

          IF r_req THEN
            tmp_data32 := r_hold(31 DOWNTO 0);
          END IF;
          IF r_req THEN

            -- Regular access logic. Read mode: enabled.
            tmp_data32 := f_status_2_r((0)).d;
            r_ack := true;

          END IF;
          IF r_req THEN
            r_hold(31 DOWNTO 0) := tmp_data32;
          END IF;

          -- Read logic for block status_2_reg: block containing bits 31..0 of
          -- register `status_2_reg` (`STATUS_2`).
          IF r_req THEN

            r_data := r_hold(31 DOWNTO 0);
            r_multi := '0';

          END IF;

        WHEN "0011100" =>
          -- r_addr = 000000000000000000000000011100--

          IF r_req THEN

            -- Clear holding register location prior to read.
            r_hold := (OTHERS => '0');

          END IF;

          -- Read logic for field r1: r1.

          IF r_req THEN
            tmp_data64 := r_hold(63 DOWNTO 0);
          END IF;
          IF r_req THEN

            -- Regular access logic. Read mode: enabled.
            tmp_data64 := f_r1_r((0)).d;
            r_ack := true;

          END IF;
          IF r_req THEN
            r_hold(63 DOWNTO 0) := tmp_data64;
          END IF;

          -- Read logic for block r1_reg_low: block containing bits 31..0 of
          -- register `r1_reg` (`R1`).
          IF r_req THEN

            r_data := r_hold(31 DOWNTO 0);
            r_multi := '1';

          END IF;

        WHEN "0011101" =>
          -- r_addr = 000000000000000000000000011101--

          -- Read logic for block r1_reg_high: block containing bits 63..32 of
          -- register `r1_reg` (`R1`).
          IF r_req THEN

            r_data := r_hold(63 DOWNTO 32);
            IF r_multi = '1' THEN
              r_ack := true;
            ELSE
              r_nack := true;
            END IF;
            r_multi := '0';

          END IF;

        WHEN "0011110" =>
          -- r_addr = 000000000000000000000000011110--

          IF r_req THEN

            -- Clear holding register location prior to read.
            r_hold := (OTHERS => '0');

          END IF;

          -- Read logic for field r2: r2.

          IF r_req THEN
            tmp_data64 := r_hold(63 DOWNTO 0);
          END IF;
          IF r_req THEN

            -- Regular access logic. Read mode: enabled.
            tmp_data64 := f_r2_r((0)).d;
            r_ack := true;

          END IF;
          IF r_req THEN
            r_hold(63 DOWNTO 0) := tmp_data64;
          END IF;

          -- Read logic for block r2_reg_low: block containing bits 31..0 of
          -- register `r2_reg` (`R2`).
          IF r_req THEN

            r_data := r_hold(31 DOWNTO 0);
            r_multi := '1';

          END IF;

        WHEN "0011111" =>
          -- r_addr = 000000000000000000000000011111--

          -- Read logic for block r2_reg_high: block containing bits 63..32 of
          -- register `r2_reg` (`R2`).
          IF r_req THEN

            r_data := r_hold(63 DOWNTO 32);
            IF r_multi = '1' THEN
              r_ack := true;
            ELSE
              r_nack := true;
            END IF;
            r_multi := '0';

          END IF;

        WHEN "0100000" =>
          -- r_addr = 000000000000000000000000100000--

          IF r_req THEN

            -- Clear holding register location prior to read.
            r_hold := (OTHERS => '0');

          END IF;

          -- Read logic for field r3: r3.

          IF r_req THEN
            tmp_data64 := r_hold(63 DOWNTO 0);
          END IF;
          IF r_req THEN

            -- Regular access logic. Read mode: enabled.
            tmp_data64 := f_r3_r((0)).d;
            r_ack := true;

          END IF;
          IF r_req THEN
            r_hold(63 DOWNTO 0) := tmp_data64;
          END IF;

          -- Read logic for block r3_reg_low: block containing bits 31..0 of
          -- register `r3_reg` (`R3`).
          IF r_req THEN

            r_data := r_hold(31 DOWNTO 0);
            r_multi := '1';

          END IF;

        WHEN "0100001" =>
          -- r_addr = 000000000000000000000000100001--

          -- Read logic for block r3_reg_high: block containing bits 63..32 of
          -- register `r3_reg` (`R3`).
          IF r_req THEN

            r_data := r_hold(63 DOWNTO 32);
            IF r_multi = '1' THEN
              r_ack := true;
            ELSE
              r_nack := true;
            END IF;
            r_multi := '0';

          END IF;

        WHEN "0100010" =>
          -- r_addr = 000000000000000000000000100010--

          IF r_req THEN

            -- Clear holding register location prior to read.
            r_hold := (OTHERS => '0');

          END IF;

          -- Read logic for field r4: r4.

          IF r_req THEN
            tmp_data64 := r_hold(63 DOWNTO 0);
          END IF;
          IF r_req THEN

            -- Regular access logic. Read mode: enabled.
            tmp_data64 := f_r4_r((0)).d;
            r_ack := true;

          END IF;
          IF r_req THEN
            r_hold(63 DOWNTO 0) := tmp_data64;
          END IF;

          -- Read logic for block r4_reg_low: block containing bits 31..0 of
          -- register `r4_reg` (`R4`).
          IF r_req THEN

            r_data := r_hold(31 DOWNTO 0);
            r_multi := '1';

          END IF;

        WHEN "0100011" =>
          -- r_addr = 000000000000000000000000100011--

          -- Read logic for block r4_reg_high: block containing bits 63..32 of
          -- register `r4_reg` (`R4`).
          IF r_req THEN

            r_data := r_hold(63 DOWNTO 32);
            IF r_multi = '1' THEN
              r_ack := true;
            ELSE
              r_nack := true;
            END IF;
            r_multi := '0';

          END IF;

        WHEN "0100100" =>
          -- r_addr = 000000000000000000000000100100--

          IF r_req THEN

            -- Clear holding register location prior to read.
            r_hold := (OTHERS => '0');

          END IF;

          -- Read logic for field r5: r5.

          IF r_req THEN
            tmp_data64 := r_hold(63 DOWNTO 0);
          END IF;
          IF r_req THEN

            -- Regular access logic. Read mode: enabled.
            tmp_data64 := f_r5_r((0)).d;
            r_ack := true;

          END IF;
          IF r_req THEN
            r_hold(63 DOWNTO 0) := tmp_data64;
          END IF;

          -- Read logic for block r5_reg_low: block containing bits 31..0 of
          -- register `r5_reg` (`R5`).
          IF r_req THEN

            r_data := r_hold(31 DOWNTO 0);
            r_multi := '1';

          END IF;

        WHEN "0100101" =>
          -- r_addr = 000000000000000000000000100101--

          -- Read logic for block r5_reg_high: block containing bits 63..32 of
          -- register `r5_reg` (`R5`).
          IF r_req THEN

            r_data := r_hold(63 DOWNTO 32);
            IF r_multi = '1' THEN
              r_ack := true;
            ELSE
              r_nack := true;
            END IF;
            r_multi := '0';

          END IF;

        WHEN "0100110" =>
          -- r_addr = 000000000000000000000000100110--

          IF r_req THEN

            -- Clear holding register location prior to read.
            r_hold := (OTHERS => '0');

          END IF;

          -- Read logic for field r6: r6.

          IF r_req THEN
            tmp_data64 := r_hold(63 DOWNTO 0);
          END IF;
          IF r_req THEN

            -- Regular access logic. Read mode: enabled.
            tmp_data64 := f_r6_r((0)).d;
            r_ack := true;

          END IF;
          IF r_req THEN
            r_hold(63 DOWNTO 0) := tmp_data64;
          END IF;

          -- Read logic for block r6_reg_low: block containing bits 31..0 of
          -- register `r6_reg` (`R6`).
          IF r_req THEN

            r_data := r_hold(31 DOWNTO 0);
            r_multi := '1';

          END IF;

        WHEN "0100111" =>
          -- r_addr = 000000000000000000000000100111--

          -- Read logic for block r6_reg_high: block containing bits 63..32 of
          -- register `r6_reg` (`R6`).
          IF r_req THEN

            r_data := r_hold(63 DOWNTO 32);
            IF r_multi = '1' THEN
              r_ack := true;
            ELSE
              r_nack := true;
            END IF;
            r_multi := '0';

          END IF;

        WHEN "0101000" =>
          -- r_addr = 000000000000000000000000101000--

          IF r_req THEN

            -- Clear holding register location prior to read.
            r_hold := (OTHERS => '0');

          END IF;

          -- Read logic for field r7: r7.

          IF r_req THEN
            tmp_data64 := r_hold(63 DOWNTO 0);
          END IF;
          IF r_req THEN

            -- Regular access logic. Read mode: enabled.
            tmp_data64 := f_r7_r((0)).d;
            r_ack := true;

          END IF;
          IF r_req THEN
            r_hold(63 DOWNTO 0) := tmp_data64;
          END IF;

          -- Read logic for block r7_reg_low: block containing bits 31..0 of
          -- register `r7_reg` (`R7`).
          IF r_req THEN

            r_data := r_hold(31 DOWNTO 0);
            r_multi := '1';

          END IF;

        WHEN "0101001" =>
          -- r_addr = 000000000000000000000000101001--

          -- Read logic for block r7_reg_high: block containing bits 63..32 of
          -- register `r7_reg` (`R7`).
          IF r_req THEN

            r_data := r_hold(63 DOWNTO 32);
            IF r_multi = '1' THEN
              r_ack := true;
            ELSE
              r_nack := true;
            END IF;
            r_multi := '0';

          END IF;

        WHEN "0101010" =>
          -- r_addr = 000000000000000000000000101010--

          IF r_req THEN

            -- Clear holding register location prior to read.
            r_hold := (OTHERS => '0');

          END IF;

          -- Read logic for field r8: r8.

          IF r_req THEN
            tmp_data64 := r_hold(63 DOWNTO 0);
          END IF;
          IF r_req THEN

            -- Regular access logic. Read mode: enabled.
            tmp_data64 := f_r8_r((0)).d;
            r_ack := true;

          END IF;
          IF r_req THEN
            r_hold(63 DOWNTO 0) := tmp_data64;
          END IF;

          -- Read logic for block r8_reg_low: block containing bits 31..0 of
          -- register `r8_reg` (`R8`).
          IF r_req THEN

            r_data := r_hold(31 DOWNTO 0);
            r_multi := '1';

          END IF;

        WHEN "0101011" =>
          -- r_addr = 000000000000000000000000101011--

          -- Read logic for block r8_reg_high: block containing bits 63..32 of
          -- register `r8_reg` (`R8`).
          IF r_req THEN

            r_data := r_hold(63 DOWNTO 32);
            IF r_multi = '1' THEN
              r_ack := true;
            ELSE
              r_nack := true;
            END IF;
            r_multi := '0';

          END IF;

        WHEN "0101100" =>
          -- r_addr = 000000000000000000000000000110--

          IF r_req THEN

            -- Clear holding register location prior to read.
            r_hold := (OTHERS => '0');

          END IF;

          -- Read logic for field l_returnflag_o_offsets:
          -- l_returnflag_o_offsets.

          IF r_req THEN
            tmp_data64 := r_hold(63 DOWNTO 0);
          END IF;
          IF r_req THEN

            -- Regular access logic. Read mode: enabled.
            tmp_data64 := f_l_returnflag_o_offsets_r((0)).d;
            r_ack := true;

          END IF;
          IF r_req THEN
            r_hold(63 DOWNTO 0) := tmp_data64;
          END IF;

          -- Read logic for block l_returnflag_o_offsets_reg_low: block
          -- containing bits 31..0 of register `l_returnflag_o_offsets_reg`
          -- (`L_RETURNFLAG_O_OFFSETS`).
          IF r_req THEN

            r_data := r_hold(31 DOWNTO 0);
            r_multi := '1';

          END IF;

        WHEN "0101101" =>
          -- r_addr = 000000000000000000000000000111--

          -- Read logic for block l_returnflag_o_offsets_reg_high: block
          -- containing bits 63..32 of register `l_returnflag_o_offsets_reg`
          -- (`L_RETURNFLAG_O_OFFSETS`).
          IF r_req THEN

            r_data := r_hold(63 DOWNTO 32);
            IF r_multi = '1' THEN
              r_ack := true;
            ELSE
              r_nack := true;
            END IF;
            r_multi := '0';

          END IF;

        WHEN "0101110" =>
          -- r_addr = 000000000000000000000000001000--

          IF r_req THEN

            -- Clear holding register location prior to read.
            r_hold := (OTHERS => '0');

          END IF;

          -- Read logic for field l_returnflag_o_values: l_returnflag_o_values.

          IF r_req THEN
            tmp_data64 := r_hold(63 DOWNTO 0);
          END IF;
          IF r_req THEN

            -- Regular access logic. Read mode: enabled.
            tmp_data64 := f_l_returnflag_o_values_r((0)).d;
            r_ack := true;

          END IF;
          IF r_req THEN
            r_hold(63 DOWNTO 0) := tmp_data64;
          END IF;

          -- Read logic for block l_returnflag_o_values_reg_low: block
          -- containing bits 31..0 of register `l_returnflag_o_values_reg`
          -- (`L_RETURNFLAG_O_VALUES`).
          IF r_req THEN

            r_data := r_hold(31 DOWNTO 0);
            r_multi := '1';

          END IF;

        WHEN "0101111" =>
          -- r_addr = 000000000000000000000000001001--

          -- Read logic for block l_returnflag_o_values_reg_high: block
          -- containing bits 63..32 of register `l_returnflag_o_values_reg`
          -- (`L_RETURNFLAG_O_VALUES`).
          IF r_req THEN

            r_data := r_hold(63 DOWNTO 32);
            IF r_multi = '1' THEN
              r_ack := true;
            ELSE
              r_nack := true;
            END IF;
            r_multi := '0';

          END IF;

        WHEN "0110000" =>
          -- r_addr = 000000000000000000000000001010--

          IF r_req THEN

            -- Clear holding register location prior to read.
            r_hold := (OTHERS => '0');

          END IF;

          -- Read logic for field l_linestatus_o_offsets:
          -- l_linestatus_o_offsets.

          IF r_req THEN
            tmp_data64 := r_hold(63 DOWNTO 0);
          END IF;
          IF r_req THEN

            -- Regular access logic. Read mode: enabled.
            tmp_data64 := f_l_linestatus_o_offsets_r((0)).d;
            r_ack := true;

          END IF;
          IF r_req THEN
            r_hold(63 DOWNTO 0) := tmp_data64;
          END IF;

          -- Read logic for block l_linestatus_o_offsets_reg_low: block
          -- containing bits 31..0 of register `l_linestatus_o_offsets_reg`
          -- (`L_LINESTATUS_O_OFFSETS`).
          IF r_req THEN

            r_data := r_hold(31 DOWNTO 0);
            r_multi := '1';

          END IF;

        WHEN "0110001" =>
          -- r_addr = 000000000000000000000000001011--

          -- Read logic for block l_linestatus_o_offsets_reg_high: block
          -- containing bits 63..32 of register `l_linestatus_o_offsets_reg`
          -- (`L_LINESTATUS_O_OFFSETS`).
          IF r_req THEN

            r_data := r_hold(63 DOWNTO 32);
            IF r_multi = '1' THEN
              r_ack := true;
            ELSE
              r_nack := true;
            END IF;
            r_multi := '0';

          END IF;

        WHEN "0110010" =>
          -- r_addr = 000000000000000000000000001100--

          IF r_req THEN

            -- Clear holding register location prior to read.
            r_hold := (OTHERS => '0');

          END IF;

          -- Read logic for field l_linestatus_o_values: l_linestatus_o_values.

          IF r_req THEN
            tmp_data64 := r_hold(63 DOWNTO 0);
          END IF;
          IF r_req THEN

            -- Regular access logic. Read mode: enabled.
            tmp_data64 := f_l_linestatus_o_values_r((0)).d;
            r_ack := true;

          END IF;
          IF r_req THEN
            r_hold(63 DOWNTO 0) := tmp_data64;
          END IF;

          -- Read logic for block l_linestatus_o_values_reg_low: block
          -- containing bits 31..0 of register `l_linestatus_o_values_reg`
          -- (`L_LINESTATUS_O_VALUES`).
          IF r_req THEN

            r_data := r_hold(31 DOWNTO 0);
            r_multi := '1';

          END IF;

        WHEN "0110011" =>
          -- r_addr = 000000000000000000000000001101--

          -- Read logic for block l_linestatus_o_values_reg_high: block
          -- containing bits 63..32 of register `l_linestatus_o_values_reg`
          -- (`L_LINESTATUS_O_VALUES`).
          IF r_req THEN

            r_data := r_hold(63 DOWNTO 32);
            IF r_multi = '1' THEN
              r_ack := true;
            ELSE
              r_nack := true;
            END IF;
            r_multi := '0';

          END IF;

        WHEN "0110100" =>
          -- r_addr = 000000000000000000000000001110--

          IF r_req THEN

            -- Clear holding register location prior to read.
            r_hold := (OTHERS => '0');

          END IF;

          -- Read logic for field l_sum_qty_values: l_sum_qty_values.

          IF r_req THEN
            tmp_data64 := r_hold(63 DOWNTO 0);
          END IF;
          IF r_req THEN

            -- Regular access logic. Read mode: enabled.
            tmp_data64 := f_l_sum_qty_values_r((0)).d;
            r_ack := true;

          END IF;
          IF r_req THEN
            r_hold(63 DOWNTO 0) := tmp_data64;
          END IF;

          -- Read logic for block l_sum_qty_values_reg_low: block containing
          -- bits 31..0 of register `l_sum_qty_values_reg` (`L_SUM_QTY_VALUES`).
          IF r_req THEN

            r_data := r_hold(31 DOWNTO 0);
            r_multi := '1';

          END IF;

        WHEN "0110101" =>
          -- r_addr = 000000000000000000000000001111--

          -- Read logic for block l_sum_qty_values_reg_high: block containing
          -- bits 63..32 of register `l_sum_qty_values_reg`
          -- (`L_SUM_QTY_VALUES`).
          IF r_req THEN

            r_data := r_hold(63 DOWNTO 32);
            IF r_multi = '1' THEN
              r_ack := true;
            ELSE
              r_nack := true;
            END IF;
            r_multi := '0';

          END IF;

        WHEN "0110110" =>
          -- r_addr = 000000000000000000000000010000--

          IF r_req THEN

            -- Clear holding register location prior to read.
            r_hold := (OTHERS => '0');

          END IF;

          -- Read logic for field l_sum_base_price_values:
          -- l_sum_base_price_values.

          IF r_req THEN
            tmp_data64 := r_hold(63 DOWNTO 0);
          END IF;
          IF r_req THEN

            -- Regular access logic. Read mode: enabled.
            tmp_data64 := f_l_sum_base_price_values_r((0)).d;
            r_ack := true;

          END IF;
          IF r_req THEN
            r_hold(63 DOWNTO 0) := tmp_data64;
          END IF;

          -- Read logic for block l_sum_base_price_values_reg_low: block
          -- containing bits 31..0 of register `l_sum_base_price_values_reg`
          -- (`L_SUM_BASE_PRICE_VALUES`).
          IF r_req THEN

            r_data := r_hold(31 DOWNTO 0);
            r_multi := '1';

          END IF;

        WHEN "0110111" =>
          -- r_addr = 000000000000000000000000010001--

          -- Read logic for block l_sum_base_price_values_reg_high: block
          -- containing bits 63..32 of register `l_sum_base_price_values_reg`
          -- (`L_SUM_BASE_PRICE_VALUES`).
          IF r_req THEN

            r_data := r_hold(63 DOWNTO 32);
            IF r_multi = '1' THEN
              r_ack := true;
            ELSE
              r_nack := true;
            END IF;
            r_multi := '0';

          END IF;

        WHEN "0111000" =>
          -- r_addr = 000000000000000000000000010010--

          IF r_req THEN

            -- Clear holding register location prior to read.
            r_hold := (OTHERS => '0');

          END IF;

          -- Read logic for field l_sum_disc_price_values:
          -- l_sum_disc_price_values.

          IF r_req THEN
            tmp_data64 := r_hold(63 DOWNTO 0);
          END IF;
          IF r_req THEN

            -- Regular access logic. Read mode: enabled.
            tmp_data64 := f_l_sum_disc_price_values_r((0)).d;
            r_ack := true;

          END IF;
          IF r_req THEN
            r_hold(63 DOWNTO 0) := tmp_data64;
          END IF;

          -- Read logic for block l_sum_disc_price_values_reg_low: block
          -- containing bits 31..0 of register `l_sum_disc_price_values_reg`
          -- (`L_SUM_DISC_PRICE_VALUES`).
          IF r_req THEN

            r_data := r_hold(31 DOWNTO 0);
            r_multi := '1';

          END IF;

        WHEN "0111001" =>
          -- r_addr = 000000000000000000000000010011--

          -- Read logic for block l_sum_disc_price_values_reg_high: block
          -- containing bits 63..32 of register `l_sum_disc_price_values_reg`
          -- (`L_SUM_DISC_PRICE_VALUES`).
          IF r_req THEN

            r_data := r_hold(63 DOWNTO 32);
            IF r_multi = '1' THEN
              r_ack := true;
            ELSE
              r_nack := true;
            END IF;
            r_multi := '0';

          END IF;

        WHEN "0111010" =>
          -- r_addr = 000000000000000000000000010100--

          IF r_req THEN

            -- Clear holding register location prior to read.
            r_hold := (OTHERS => '0');

          END IF;

          -- Read logic for field l_sum_charge_values: l_sum_charge_values.

          IF r_req THEN
            tmp_data64 := r_hold(63 DOWNTO 0);
          END IF;
          IF r_req THEN

            -- Regular access logic. Read mode: enabled.
            tmp_data64 := f_l_sum_charge_values_r((0)).d;
            r_ack := true;

          END IF;
          IF r_req THEN
            r_hold(63 DOWNTO 0) := tmp_data64;
          END IF;

          -- Read logic for block l_sum_charge_values_reg_low: block containing
          -- bits 31..0 of register `l_sum_charge_values_reg`
          -- (`L_SUM_CHARGE_VALUES`).
          IF r_req THEN

            r_data := r_hold(31 DOWNTO 0);
            r_multi := '1';

          END IF;

        WHEN "0111011" =>
          -- r_addr = 000000000000000000000000010101--

          -- Read logic for block l_sum_charge_values_reg_high: block containing
          -- bits 63..32 of register `l_sum_charge_values_reg`
          -- (`L_SUM_CHARGE_VALUES`).
          IF r_req THEN

            r_data := r_hold(63 DOWNTO 32);
            IF r_multi = '1' THEN
              r_ack := true;
            ELSE
              r_nack := true;
            END IF;
            r_multi := '0';

          END IF;

        WHEN "0111100" =>
          -- r_addr = 000000000000000000000000010110--

          IF r_req THEN

            -- Clear holding register location prior to read.
            r_hold := (OTHERS => '0');

          END IF;

          -- Read logic for field l_avg_qty_values: l_avg_qty_values.

          IF r_req THEN
            tmp_data64 := r_hold(63 DOWNTO 0);
          END IF;
          IF r_req THEN

            -- Regular access logic. Read mode: enabled.
            tmp_data64 := f_l_avg_qty_values_r((0)).d;
            r_ack := true;

          END IF;
          IF r_req THEN
            r_hold(63 DOWNTO 0) := tmp_data64;
          END IF;

          -- Read logic for block l_avg_qty_values_reg_low: block containing
          -- bits 31..0 of register `l_avg_qty_values_reg` (`L_AVG_QTY_VALUES`).
          IF r_req THEN

            r_data := r_hold(31 DOWNTO 0);
            r_multi := '1';

          END IF;

        WHEN "0111101" =>
          -- r_addr = 000000000000000000000000010111--

          -- Read logic for block l_avg_qty_values_reg_high: block containing
          -- bits 63..32 of register `l_avg_qty_values_reg`
          -- (`L_AVG_QTY_VALUES`).
          IF r_req THEN

            r_data := r_hold(63 DOWNTO 32);
            IF r_multi = '1' THEN
              r_ack := true;
            ELSE
              r_nack := true;
            END IF;
            r_multi := '0';

          END IF;

        WHEN "0111110" =>
          -- r_addr = 000000000000000000000000011000--

          IF r_req THEN

            -- Clear holding register location prior to read.
            r_hold := (OTHERS => '0');

          END IF;

          -- Read logic for field l_avg_price_values: l_avg_price_values.

          IF r_req THEN
            tmp_data64 := r_hold(63 DOWNTO 0);
          END IF;
          IF r_req THEN

            -- Regular access logic. Read mode: enabled.
            tmp_data64 := f_l_avg_price_values_r((0)).d;
            r_ack := true;

          END IF;
          IF r_req THEN
            r_hold(63 DOWNTO 0) := tmp_data64;
          END IF;

          -- Read logic for block l_avg_price_values_reg_low: block containing
          -- bits 31..0 of register `l_avg_price_values_reg`
          -- (`L_AVG_PRICE_VALUES`).
          IF r_req THEN

            r_data := r_hold(31 DOWNTO 0);
            r_multi := '1';

          END IF;

        WHEN "0111111" =>
          -- r_addr = 000000000000000000000000011001--

          -- Read logic for block l_avg_price_values_reg_high: block containing
          -- bits 63..32 of register `l_avg_price_values_reg`
          -- (`L_AVG_PRICE_VALUES`).
          IF r_req THEN

            r_data := r_hold(63 DOWNTO 32);
            IF r_multi = '1' THEN
              r_ack := true;
            ELSE
              r_nack := true;
            END IF;
            r_multi := '0';

          END IF;

        WHEN "1000000" =>
          -- r_addr = 000000000000000000000000011010--

          IF r_req THEN

            -- Clear holding register location prior to read.
            r_hold := (OTHERS => '0');

          END IF;

          -- Read logic for field l_avg_disc_values: l_avg_disc_values.

          IF r_req THEN
            tmp_data64 := r_hold(63 DOWNTO 0);
          END IF;
          IF r_req THEN

            -- Regular access logic. Read mode: enabled.
            tmp_data64 := f_l_avg_disc_values_r((0)).d;
            r_ack := true;

          END IF;
          IF r_req THEN
            r_hold(63 DOWNTO 0) := tmp_data64;
          END IF;

          -- Read logic for block l_avg_disc_values_reg_low: block containing
          -- bits 31..0 of register `l_avg_disc_values_reg`
          -- (`L_AVG_DISC_VALUES`).
          IF r_req THEN

            r_data := r_hold(31 DOWNTO 0);
            r_multi := '1';

          END IF;

        WHEN "1000001" =>
          -- r_addr = 000000000000000000000000011011--

          -- Read logic for block l_avg_disc_values_reg_high: block containing
          -- bits 63..32 of register `l_avg_disc_values_reg`
          -- (`L_AVG_DISC_VALUES`).
          IF r_req THEN

            r_data := r_hold(63 DOWNTO 32);
            IF r_multi = '1' THEN
              r_ack := true;
            ELSE
              r_nack := true;
            END IF;
            r_multi := '0';

          END IF;

        WHEN "1000010" =>
          -- r_addr = 000000000000000000000000011100--

          IF r_req THEN

            -- Clear holding register location prior to read.
            r_hold := (OTHERS => '0');

          END IF;

          -- Read logic for field l_count_order_values: l_count_order_values.

          IF r_req THEN
            tmp_data64 := r_hold(63 DOWNTO 0);
          END IF;
          IF r_req THEN

            -- Regular access logic. Read mode: enabled.
            tmp_data64 := f_l_count_order_values_r((0)).d;
            r_ack := true;

          END IF;
          IF r_req THEN
            r_hold(63 DOWNTO 0) := tmp_data64;
          END IF;

          -- Read logic for block l_count_order_values_reg_low: block containing
          -- bits 31..0 of register `l_count_order_values_reg`
          -- (`L_COUNT_ORDER_VALUES`).
          IF r_req THEN

            r_data := r_hold(31 DOWNTO 0);
            r_multi := '1';

          END IF;

        WHEN "1000011" =>
          -- r_addr = 000000000000000000000000011101--

          -- Read logic for block l_count_order_values_reg_high: block
          -- containing bits 63..32 of register `l_count_order_values_reg`
          -- (`L_COUNT_ORDER_VALUES`).
          IF r_req THEN

            r_data := r_hold(63 DOWNTO 32);
            IF r_multi = '1' THEN
              r_ack := true;
            ELSE
              r_nack := true;
            END IF;
            r_multi := '0';

          END IF;
        WHEN OTHERS => -- "101100"
          -- r_addr = 000000000000000000000000101100--

          IF r_req THEN

            -- Clear holding register location prior to read.
            r_hold := (OTHERS => '0');

          END IF;

          -- Read logic for field Profile_enable: Profile_enable.

          IF r_req THEN
            tmp_data := r_hold(0);
          END IF;
          IF r_req THEN

            -- Regular access logic. Read mode: enabled.
            tmp_data := f_Profile_enable_r((0)).d;
            r_ack := true;

          END IF;
          IF r_req THEN
            r_hold(0) := tmp_data;
          END IF;

          -- Read logic for block Profile_enable_reg: block containing bits
          -- 31..0 of register `Profile_enable_reg` (`PROFILE_ENABLE`).
          IF r_req THEN

            r_data := r_hold(31 DOWNTO 0);
            r_multi := '0';

          END IF;

      END CASE;

      -------------------------------------------------------------------------
      -- Bus write logic
      -------------------------------------------------------------------------

      -- Construct the subaddresses for write mode.
      subaddr_none(0) := '0';

      -- Write address decoder.
      CASE w_addr(8 DOWNTO 2) IS
        WHEN "0000000" =>
          -- w_addr = 000000000000000000000000000000--

          -- Write logic for block start_reg: block containing bits 31..0 of
          -- register `start_reg` (`START`).
          IF w_req OR w_lreq THEN
            w_hold(31 DOWNTO 0) := w_data;
            w_hstb(31 DOWNTO 0) := w_strb;
            w_multi := '0';
          END IF;

          -- Write logic for field start: start.

          tmp_data := w_hold(0);
          tmp_strb := w_hstb(0);
          IF w_req THEN

            -- Regular access logic. Write mode: enabled.

            f_start_r((0)).d := tmp_data;
            w_ack := true;

            -- Handle post-write operation: invalidate.
            f_start_r((0)).v := '1';
            f_start_r((0)).inval := '1';

          END IF;

          -- Write logic for field stop: stop.

          tmp_data := w_hold(1);
          tmp_strb := w_hstb(1);
          IF w_req THEN

            -- Regular access logic. Write mode: enabled.

            f_stop_r((0)).d := tmp_data;
            w_ack := true;

            -- Handle post-write operation: invalidate.
            f_stop_r((0)).v := '1';
            f_stop_r((0)).inval := '1';

          END IF;

          -- Write logic for field reset: reset.

          tmp_data := w_hold(2);
          tmp_strb := w_hstb(2);
          IF w_req THEN

            -- Regular access logic. Write mode: enabled.

            f_reset_r((0)).d := tmp_data;
            w_ack := true;

            -- Handle post-write operation: invalidate.
            f_reset_r((0)).v := '1';
            f_reset_r((0)).inval := '1';

          END IF;

        WHEN "0000100" =>
          -- w_addr = 000000000000000000000000000100--

          -- Write logic for block l_firstidx_reg: block containing bits 31..0
          -- of register `l_firstidx_reg` (`L_FIRSTIDX`).
          IF w_req OR w_lreq THEN
            w_hold(31 DOWNTO 0) := w_data;
            w_hstb(31 DOWNTO 0) := w_strb;
            w_multi := '0';
          END IF;

          -- Write logic for field l_firstidx: l_firstidx.

          tmp_data32 := w_hold(31 DOWNTO 0);
          tmp_strb32 := w_hstb(31 DOWNTO 0);
          IF w_req THEN

            -- Regular access logic. Write mode: masked.

            f_l_firstidx_r((0)).d := (f_l_firstidx_r((0)).d AND NOT tmp_strb32)
            OR tmp_data32;
            w_ack := true;

          END IF;

        WHEN "0000101" =>
          -- w_addr = 000000000000000000000000000101--

          -- Write logic for block l_lastidx_reg: block containing bits 31..0 of
          -- register `l_lastidx_reg` (`L_LASTIDX`).
          IF w_req OR w_lreq THEN
            w_hold(31 DOWNTO 0) := w_data;
            w_hstb(31 DOWNTO 0) := w_strb;
            w_multi := '0';
          END IF;

          -- Write logic for field l_lastidx: l_lastidx.

          tmp_data32 := w_hold(31 DOWNTO 0);
          tmp_strb32 := w_hstb(31 DOWNTO 0);
          IF w_req THEN

            -- Regular access logic. Write mode: masked.

            f_l_lastidx_r((0)).d := (f_l_lastidx_r((0)).d AND NOT tmp_strb32)
            OR tmp_data32;
            w_ack := true;

          END IF;

        WHEN "0000110" =>
          -- w_addr = 000000000000000000000000000110--

          -- Write logic for block l_quantity_values_reg_low: block containing
          -- bits 31..0 of register `l_quantity_values_reg`
          -- (`L_QUANTITY_VALUES`).
          IF w_req OR w_lreq THEN
            w_hold(31 DOWNTO 0) := w_data;
            w_hstb(31 DOWNTO 0) := w_strb;
            w_multi := '1';
          END IF;
          IF w_req THEN
            w_ack := true;
          END IF;

        WHEN "0000111" =>
          -- w_addr = 000000000000000000000000000111--

          -- Write logic for block l_quantity_values_reg_high: block containing
          -- bits 63..32 of register `l_quantity_values_reg`
          -- (`L_QUANTITY_VALUES`).
          IF w_req OR w_lreq THEN
            w_hold(63 DOWNTO 32) := w_data;
            w_hstb(63 DOWNTO 32) := w_strb;
            w_multi := '0';
          END IF;

          -- Write logic for field l_quantity_values: l_quantity_values.

          tmp_data64 := w_hold(63 DOWNTO 0);
          tmp_strb64 := w_hstb(63 DOWNTO 0);
          IF w_req THEN

            -- Regular access logic. Write mode: masked.

            f_l_quantity_values_r((0)).d
            := (f_l_quantity_values_r((0)).d AND NOT tmp_strb64)
            OR tmp_data64;
            w_ack := true;

          END IF;

        WHEN "0001000" =>
          -- w_addr = 000000000000000000000000001000--

          -- Write logic for block l_extendedprice_values_reg_low: block
          -- containing bits 31..0 of register `l_extendedprice_values_reg`
          -- (`L_EXTENDEDPRICE_VALUES`).
          IF w_req OR w_lreq THEN
            w_hold(31 DOWNTO 0) := w_data;
            w_hstb(31 DOWNTO 0) := w_strb;
            w_multi := '1';
          END IF;
          IF w_req THEN
            w_ack := true;
          END IF;

        WHEN "0001001" =>
          -- w_addr = 000000000000000000000000001001--

          -- Write logic for block l_extendedprice_values_reg_high: block
          -- containing bits 63..32 of register `l_extendedprice_values_reg`
          -- (`L_EXTENDEDPRICE_VALUES`).
          IF w_req OR w_lreq THEN
            w_hold(63 DOWNTO 32) := w_data;
            w_hstb(63 DOWNTO 32) := w_strb;
            w_multi := '0';
          END IF;

          -- Write logic for field l_extendedprice_values:
          -- l_extendedprice_values.

          tmp_data64 := w_hold(63 DOWNTO 0);
          tmp_strb64 := w_hstb(63 DOWNTO 0);
          IF w_req THEN

            -- Regular access logic. Write mode: masked.

            f_l_extendedprice_values_r((0)).d
            := (f_l_extendedprice_values_r((0)).d AND NOT tmp_strb64)
            OR tmp_data64;
            w_ack := true;

          END IF;

        WHEN "0001010" =>
          -- w_addr = 000000000000000000000000001010--

          -- Write logic for block l_discount_values_reg_low: block containing
          -- bits 31..0 of register `l_discount_values_reg`
          -- (`L_DISCOUNT_VALUES`).
          IF w_req OR w_lreq THEN
            w_hold(31 DOWNTO 0) := w_data;
            w_hstb(31 DOWNTO 0) := w_strb;
            w_multi := '1';
          END IF;
          IF w_req THEN
            w_ack := true;
          END IF;

        WHEN "0001011" =>
          -- w_addr = 000000000000000000000000001011--

          -- Write logic for block l_discount_values_reg_high: block containing
          -- bits 63..32 of register `l_discount_values_reg`
          -- (`L_DISCOUNT_VALUES`).
          IF w_req OR w_lreq THEN
            w_hold(63 DOWNTO 32) := w_data;
            w_hstb(63 DOWNTO 32) := w_strb;
            w_multi := '0';
          END IF;

          -- Write logic for field l_discount_values: l_discount_values.

          tmp_data64 := w_hold(63 DOWNTO 0);
          tmp_strb64 := w_hstb(63 DOWNTO 0);
          IF w_req THEN

            -- Regular access logic. Write mode: masked.

            f_l_discount_values_r((0)).d
            := (f_l_discount_values_r((0)).d AND NOT tmp_strb64)
            OR tmp_data64;
            w_ack := true;

          END IF;

        WHEN "0001100" =>
          -- w_addr = 000000000000000000000000001100--

          -- Write logic for block l_tax_values_reg_low: block containing bits
          -- 31..0 of register `l_tax_values_reg` (`L_TAX_VALUES`).
          IF w_req OR w_lreq THEN
            w_hold(31 DOWNTO 0) := w_data;
            w_hstb(31 DOWNTO 0) := w_strb;
            w_multi := '1';
          END IF;
          IF w_req THEN
            w_ack := true;
          END IF;

        WHEN "0001101" =>
          -- w_addr = 000000000000000000000000001101--

          -- Write logic for block l_tax_values_reg_high: block containing bits
          -- 63..32 of register `l_tax_values_reg` (`L_TAX_VALUES`).
          IF w_req OR w_lreq THEN
            w_hold(63 DOWNTO 32) := w_data;
            w_hstb(63 DOWNTO 32) := w_strb;
            w_multi := '0';
          END IF;

          -- Write logic for field l_tax_values: l_tax_values.

          tmp_data64 := w_hold(63 DOWNTO 0);
          tmp_strb64 := w_hstb(63 DOWNTO 0);
          IF w_req THEN

            -- Regular access logic. Write mode: masked.

            f_l_tax_values_r((0)).d
            := (f_l_tax_values_r((0)).d AND NOT tmp_strb64) OR tmp_data64;
            w_ack := true;

          END IF;

        WHEN "0001110" =>
          -- w_addr = 000000000000000000000000001110--

          -- Write logic for block l_returnflag_offsets_reg_low: block
          -- containing bits 31..0 of register `l_returnflag_offsets_reg`
          -- (`L_RETURNFLAG_OFFSETS`).
          IF w_req OR w_lreq THEN
            w_hold(31 DOWNTO 0) := w_data;
            w_hstb(31 DOWNTO 0) := w_strb;
            w_multi := '1';
          END IF;
          IF w_req THEN
            w_ack := true;
          END IF;

        WHEN "0001111" =>
          -- w_addr = 000000000000000000000000001111--

          -- Write logic for block l_returnflag_offsets_reg_high: block
          -- containing bits 63..32 of register `l_returnflag_offsets_reg`
          -- (`L_RETURNFLAG_OFFSETS`).
          IF w_req OR w_lreq THEN
            w_hold(63 DOWNTO 32) := w_data;
            w_hstb(63 DOWNTO 32) := w_strb;
            w_multi := '0';
          END IF;

          -- Write logic for field l_returnflag_offsets: l_returnflag_offsets.

          tmp_data64 := w_hold(63 DOWNTO 0);
          tmp_strb64 := w_hstb(63 DOWNTO 0);
          IF w_req THEN

            -- Regular access logic. Write mode: masked.

            f_l_returnflag_offsets_r((0)).d
            := (f_l_returnflag_offsets_r((0)).d AND NOT tmp_strb64)
            OR tmp_data64;
            w_ack := true;

          END IF;

        WHEN "0010000" =>
          -- w_addr = 000000000000000000000000010000--

          -- Write logic for block l_returnflag_values_reg_low: block containing
          -- bits 31..0 of register `l_returnflag_values_reg`
          -- (`L_RETURNFLAG_VALUES`).
          IF w_req OR w_lreq THEN
            w_hold(31 DOWNTO 0) := w_data;
            w_hstb(31 DOWNTO 0) := w_strb;
            w_multi := '1';
          END IF;
          IF w_req THEN
            w_ack := true;
          END IF;

        WHEN "0010001" =>
          -- w_addr = 000000000000000000000000010001--

          -- Write logic for block l_returnflag_values_reg_high: block
          -- containing bits 63..32 of register `l_returnflag_values_reg`
          -- (`L_RETURNFLAG_VALUES`).
          IF w_req OR w_lreq THEN
            w_hold(63 DOWNTO 32) := w_data;
            w_hstb(63 DOWNTO 32) := w_strb;
            w_multi := '0';
          END IF;

          -- Write logic for field l_returnflag_values: l_returnflag_values.

          tmp_data64 := w_hold(63 DOWNTO 0);
          tmp_strb64 := w_hstb(63 DOWNTO 0);
          IF w_req THEN

            -- Regular access logic. Write mode: masked.

            f_l_returnflag_values_r((0)).d
            := (f_l_returnflag_values_r((0)).d AND NOT tmp_strb64)
            OR tmp_data64;
            w_ack := true;

          END IF;

        WHEN "0010010" =>
          -- w_addr = 000000000000000000000000010010--

          -- Write logic for block l_linestatus_offsets_reg_low: block
          -- containing bits 31..0 of register `l_linestatus_offsets_reg`
          -- (`L_LINESTATUS_OFFSETS`).
          IF w_req OR w_lreq THEN
            w_hold(31 DOWNTO 0) := w_data;
            w_hstb(31 DOWNTO 0) := w_strb;
            w_multi := '1';
          END IF;
          IF w_req THEN
            w_ack := true;
          END IF;

        WHEN "0010011" =>
          -- w_addr = 000000000000000000000000010011--

          -- Write logic for block l_linestatus_offsets_reg_high: block
          -- containing bits 63..32 of register `l_linestatus_offsets_reg`
          -- (`L_LINESTATUS_OFFSETS`).
          IF w_req OR w_lreq THEN
            w_hold(63 DOWNTO 32) := w_data;
            w_hstb(63 DOWNTO 32) := w_strb;
            w_multi := '0';
          END IF;

          -- Write logic for field l_linestatus_offsets: l_linestatus_offsets.

          tmp_data64 := w_hold(63 DOWNTO 0);
          tmp_strb64 := w_hstb(63 DOWNTO 0);
          IF w_req THEN

            -- Regular access logic. Write mode: masked.

            f_l_linestatus_offsets_r((0)).d
            := (f_l_linestatus_offsets_r((0)).d AND NOT tmp_strb64)
            OR tmp_data64;
            w_ack := true;

          END IF;

        WHEN "0010100" =>
          -- w_addr = 000000000000000000000000010100--

          -- Write logic for block l_linestatus_values_reg_low: block containing
          -- bits 31..0 of register `l_linestatus_values_reg`
          -- (`L_LINESTATUS_VALUES`).
          IF w_req OR w_lreq THEN
            w_hold(31 DOWNTO 0) := w_data;
            w_hstb(31 DOWNTO 0) := w_strb;
            w_multi := '1';
          END IF;
          IF w_req THEN
            w_ack := true;
          END IF;

        WHEN "0010101" =>
          -- w_addr = 000000000000000000000000010101--

          -- Write logic for block l_linestatus_values_reg_high: block
          -- containing bits 63..32 of register `l_linestatus_values_reg`
          -- (`L_LINESTATUS_VALUES`).
          IF w_req OR w_lreq THEN
            w_hold(63 DOWNTO 32) := w_data;
            w_hstb(63 DOWNTO 32) := w_strb;
            w_multi := '0';
          END IF;

          -- Write logic for field l_linestatus_values: l_linestatus_values.

          tmp_data64 := w_hold(63 DOWNTO 0);
          tmp_strb64 := w_hstb(63 DOWNTO 0);
          IF w_req THEN

            -- Regular access logic. Write mode: masked.

            f_l_linestatus_values_r((0)).d
            := (f_l_linestatus_values_r((0)).d AND NOT tmp_strb64)
            OR tmp_data64;
            w_ack := true;

          END IF;

        WHEN "0010110" =>
          -- w_addr = 000000000000000000000000010110--

          -- Write logic for block l_shipdate_values_reg_low: block containing
          -- bits 31..0 of register `l_shipdate_values_reg`
          -- (`L_SHIPDATE_VALUES`).
          IF w_req OR w_lreq THEN
            w_hold(31 DOWNTO 0) := w_data;
            w_hstb(31 DOWNTO 0) := w_strb;
            w_multi := '1';
          END IF;
          IF w_req THEN
            w_ack := true;
          END IF;

        WHEN "0010111" =>
          -- w_addr = 000000000000000000000000010111--

          -- Write logic for block l_shipdate_values_reg_high: block containing
          -- bits 63..32 of register `l_shipdate_values_reg`
          -- (`L_SHIPDATE_VALUES`).
          IF w_req OR w_lreq THEN
            w_hold(63 DOWNTO 32) := w_data;
            w_hstb(63 DOWNTO 32) := w_strb;
            w_multi := '0';
          END IF;

          -- Write logic for field l_shipdate_values: l_shipdate_values.

          tmp_data64 := w_hold(63 DOWNTO 0);
          tmp_strb64 := w_hstb(63 DOWNTO 0);
          IF w_req THEN

            -- Regular access logic. Write mode: masked.

            f_l_shipdate_values_r((0)).d
            := (f_l_shipdate_values_r((0)).d AND NOT tmp_strb64)
            OR tmp_data64;
            w_ack := true;

          END IF;

        WHEN "0101100" =>
          -- w_addr = 000000000000000000000000000110--

          -- Write logic for block l_returnflag_o_offsets_reg_low: block
          -- containing bits 31..0 of register `l_returnflag_o_offsets_reg`
          -- (`L_RETURNFLAG_O_OFFSETS`).
          IF w_req OR w_lreq THEN
            w_hold(31 DOWNTO 0) := w_data;
            w_hstb(31 DOWNTO 0) := w_strb;
            w_multi := '1';
          END IF;
          IF w_req THEN
            w_ack := true;
          END IF;

        WHEN "0101101" =>
          -- w_addr = 000000000000000000000000000111--

          -- Write logic for block l_returnflag_o_offsets_reg_high: block
          -- containing bits 63..32 of register `l_returnflag_o_offsets_reg`
          -- (`L_RETURNFLAG_O_OFFSETS`).
          IF w_req OR w_lreq THEN
            w_hold(63 DOWNTO 32) := w_data;
            w_hstb(63 DOWNTO 32) := w_strb;
            w_multi := '0';
          END IF;

          -- Write logic for field l_returnflag_o_offsets:
          -- l_returnflag_o_offsets.

          tmp_data64 := w_hold(63 DOWNTO 0);
          tmp_strb64 := w_hstb(63 DOWNTO 0);
          IF w_req THEN

            -- Regular access logic. Write mode: masked.

            f_l_returnflag_o_offsets_r((0)).d
            := (f_l_returnflag_o_offsets_r((0)).d AND NOT tmp_strb64)
            OR tmp_data64;
            w_ack := true;

          END IF;

        WHEN "0101110" =>
          -- w_addr = 000000000000000000000000001000--

          -- Write logic for block l_returnflag_o_values_reg_low: block
          -- containing bits 31..0 of register `l_returnflag_o_values_reg`
          -- (`L_RETURNFLAG_O_VALUES`).
          IF w_req OR w_lreq THEN
            w_hold(31 DOWNTO 0) := w_data;
            w_hstb(31 DOWNTO 0) := w_strb;
            w_multi := '1';
          END IF;
          IF w_req THEN
            w_ack := true;
          END IF;

        WHEN "0101111" =>
          -- w_addr = 000000000000000000000000001001--

          -- Write logic for block l_returnflag_o_values_reg_high: block
          -- containing bits 63..32 of register `l_returnflag_o_values_reg`
          -- (`L_RETURNFLAG_O_VALUES`).
          IF w_req OR w_lreq THEN
            w_hold(63 DOWNTO 32) := w_data;
            w_hstb(63 DOWNTO 32) := w_strb;
            w_multi := '0';
          END IF;

          -- Write logic for field l_returnflag_o_values: l_returnflag_o_values.

          tmp_data64 := w_hold(63 DOWNTO 0);
          tmp_strb64 := w_hstb(63 DOWNTO 0);
          IF w_req THEN

            -- Regular access logic. Write mode: masked.

            f_l_returnflag_o_values_r((0)).d
            := (f_l_returnflag_o_values_r((0)).d AND NOT tmp_strb64)
            OR tmp_data64;
            w_ack := true;

          END IF;

        WHEN "0110000" =>
          -- w_addr = 000000000000000000000000001010--

          -- Write logic for block l_linestatus_o_offsets_reg_low: block
          -- containing bits 31..0 of register `l_linestatus_o_offsets_reg`
          -- (`L_LINESTATUS_O_OFFSETS`).
          IF w_req OR w_lreq THEN
            w_hold(31 DOWNTO 0) := w_data;
            w_hstb(31 DOWNTO 0) := w_strb;
            w_multi := '1';
          END IF;
          IF w_req THEN
            w_ack := true;
          END IF;

        WHEN "0110001" =>
          -- w_addr = 000000000000000000000000001011--

          -- Write logic for block l_linestatus_o_offsets_reg_high: block
          -- containing bits 63..32 of register `l_linestatus_o_offsets_reg`
          -- (`L_LINESTATUS_O_OFFSETS`).
          IF w_req OR w_lreq THEN
            w_hold(63 DOWNTO 32) := w_data;
            w_hstb(63 DOWNTO 32) := w_strb;
            w_multi := '0';
          END IF;

          -- Write logic for field l_linestatus_o_offsets:
          -- l_linestatus_o_offsets.

          tmp_data64 := w_hold(63 DOWNTO 0);
          tmp_strb64 := w_hstb(63 DOWNTO 0);
          IF w_req THEN

            -- Regular access logic. Write mode: masked.

            f_l_linestatus_o_offsets_r((0)).d
            := (f_l_linestatus_o_offsets_r((0)).d AND NOT tmp_strb64)
            OR tmp_data64;
            w_ack := true;

          END IF;

        WHEN "0110010" =>
          -- w_addr = 000000000000000000000000001100--

          -- Write logic for block l_linestatus_o_values_reg_low: block
          -- containing bits 31..0 of register `l_linestatus_o_values_reg`
          -- (`L_LINESTATUS_O_VALUES`).
          IF w_req OR w_lreq THEN
            w_hold(31 DOWNTO 0) := w_data;
            w_hstb(31 DOWNTO 0) := w_strb;
            w_multi := '1';
          END IF;
          IF w_req THEN
            w_ack := true;
          END IF;

        WHEN "0110011" =>
          -- w_addr = 000000000000000000000000001101--

          -- Write logic for block l_linestatus_o_values_reg_high: block
          -- containing bits 63..32 of register `l_linestatus_o_values_reg`
          -- (`L_LINESTATUS_O_VALUES`).
          IF w_req OR w_lreq THEN
            w_hold(63 DOWNTO 32) := w_data;
            w_hstb(63 DOWNTO 32) := w_strb;
            w_multi := '0';
          END IF;

          -- Write logic for field l_linestatus_o_values: l_linestatus_o_values.

          tmp_data64 := w_hold(63 DOWNTO 0);
          tmp_strb64 := w_hstb(63 DOWNTO 0);
          IF w_req THEN

            -- Regular access logic. Write mode: masked.

            f_l_linestatus_o_values_r((0)).d
            := (f_l_linestatus_o_values_r((0)).d AND NOT tmp_strb64)
            OR tmp_data64;
            w_ack := true;

          END IF;

        WHEN "0110100" =>
          -- w_addr = 000000000000000000000000001110--

          -- Write logic for block l_sum_qty_values_reg_low: block containing
          -- bits 31..0 of register `l_sum_qty_values_reg` (`L_SUM_QTY_VALUES`).
          IF w_req OR w_lreq THEN
            w_hold(31 DOWNTO 0) := w_data;
            w_hstb(31 DOWNTO 0) := w_strb;
            w_multi := '1';
          END IF;
          IF w_req THEN
            w_ack := true;
          END IF;

        WHEN "0110101" =>
          -- w_addr = 000000000000000000000000001111--

          -- Write logic for block l_sum_qty_values_reg_high: block containing
          -- bits 63..32 of register `l_sum_qty_values_reg`
          -- (`L_SUM_QTY_VALUES`).
          IF w_req OR w_lreq THEN
            w_hold(63 DOWNTO 32) := w_data;
            w_hstb(63 DOWNTO 32) := w_strb;
            w_multi := '0';
          END IF;

          -- Write logic for field l_sum_qty_values: l_sum_qty_values.

          tmp_data64 := w_hold(63 DOWNTO 0);
          tmp_strb64 := w_hstb(63 DOWNTO 0);
          IF w_req THEN

            -- Regular access logic. Write mode: masked.

            f_l_sum_qty_values_r((0)).d
            := (f_l_sum_qty_values_r((0)).d AND NOT tmp_strb64)
            OR tmp_data64;
            w_ack := true;

          END IF;

        WHEN "0110110" =>
          -- w_addr = 000000000000000000000000010000--

          -- Write logic for block l_sum_base_price_values_reg_low: block
          -- containing bits 31..0 of register `l_sum_base_price_values_reg`
          -- (`L_SUM_BASE_PRICE_VALUES`).
          IF w_req OR w_lreq THEN
            w_hold(31 DOWNTO 0) := w_data;
            w_hstb(31 DOWNTO 0) := w_strb;
            w_multi := '1';
          END IF;
          IF w_req THEN
            w_ack := true;
          END IF;

        WHEN "0110111" =>
          -- w_addr = 000000000000000000000000010001--

          -- Write logic for block l_sum_base_price_values_reg_high: block
          -- containing bits 63..32 of register `l_sum_base_price_values_reg`
          -- (`L_SUM_BASE_PRICE_VALUES`).
          IF w_req OR w_lreq THEN
            w_hold(63 DOWNTO 32) := w_data;
            w_hstb(63 DOWNTO 32) := w_strb;
            w_multi := '0';
          END IF;

          -- Write logic for field l_sum_base_price_values:
          -- l_sum_base_price_values.

          tmp_data64 := w_hold(63 DOWNTO 0);
          tmp_strb64 := w_hstb(63 DOWNTO 0);
          IF w_req THEN

            -- Regular access logic. Write mode: masked.

            f_l_sum_base_price_values_r((0)).d
            := (f_l_sum_base_price_values_r((0)).d AND NOT tmp_strb64)
            OR tmp_data64;
            w_ack := true;

          END IF;

        WHEN "0111000" =>
          -- w_addr = 000000000000000000000000010010--

          -- Write logic for block l_sum_disc_price_values_reg_low: block
          -- containing bits 31..0 of register `l_sum_disc_price_values_reg`
          -- (`L_SUM_DISC_PRICE_VALUES`).
          IF w_req OR w_lreq THEN
            w_hold(31 DOWNTO 0) := w_data;
            w_hstb(31 DOWNTO 0) := w_strb;
            w_multi := '1';
          END IF;
          IF w_req THEN
            w_ack := true;
          END IF;

        WHEN "0111001" =>
          -- w_addr = 000000000000000000000000010011--

          -- Write logic for block l_sum_disc_price_values_reg_high: block
          -- containing bits 63..32 of register `l_sum_disc_price_values_reg`
          -- (`L_SUM_DISC_PRICE_VALUES`).
          IF w_req OR w_lreq THEN
            w_hold(63 DOWNTO 32) := w_data;
            w_hstb(63 DOWNTO 32) := w_strb;
            w_multi := '0';
          END IF;

          -- Write logic for field l_sum_disc_price_values:
          -- l_sum_disc_price_values.

          tmp_data64 := w_hold(63 DOWNTO 0);
          tmp_strb64 := w_hstb(63 DOWNTO 0);
          IF w_req THEN

            -- Regular access logic. Write mode: masked.

            f_l_sum_disc_price_values_r((0)).d
            := (f_l_sum_disc_price_values_r((0)).d AND NOT tmp_strb64)
            OR tmp_data64;
            w_ack := true;

          END IF;

        WHEN "0111010" =>
          -- w_addr = 000000000000000000000000010100--

          -- Write logic for block l_sum_charge_values_reg_low: block containing
          -- bits 31..0 of register `l_sum_charge_values_reg`
          -- (`L_SUM_CHARGE_VALUES`).
          IF w_req OR w_lreq THEN
            w_hold(31 DOWNTO 0) := w_data;
            w_hstb(31 DOWNTO 0) := w_strb;
            w_multi := '1';
          END IF;
          IF w_req THEN
            w_ack := true;
          END IF;

        WHEN "0111011" =>
          -- w_addr = 000000000000000000000000010101--

          -- Write logic for block l_sum_charge_values_reg_high: block
          -- containing bits 63..32 of register `l_sum_charge_values_reg`
          -- (`L_SUM_CHARGE_VALUES`).
          IF w_req OR w_lreq THEN
            w_hold(63 DOWNTO 32) := w_data;
            w_hstb(63 DOWNTO 32) := w_strb;
            w_multi := '0';
          END IF;

          -- Write logic for field l_sum_charge_values: l_sum_charge_values.

          tmp_data64 := w_hold(63 DOWNTO 0);
          tmp_strb64 := w_hstb(63 DOWNTO 0);
          IF w_req THEN

            -- Regular access logic. Write mode: masked.

            f_l_sum_charge_values_r((0)).d
            := (f_l_sum_charge_values_r((0)).d AND NOT tmp_strb64)
            OR tmp_data64;
            w_ack := true;

          END IF;

        WHEN "0111100" =>
          -- w_addr = 000000000000000000000000010110--

          -- Write logic for block l_avg_qty_values_reg_low: block containing
          -- bits 31..0 of register `l_avg_qty_values_reg` (`L_AVG_QTY_VALUES`).
          IF w_req OR w_lreq THEN
            w_hold(31 DOWNTO 0) := w_data;
            w_hstb(31 DOWNTO 0) := w_strb;
            w_multi := '1';
          END IF;
          IF w_req THEN
            w_ack := true;
          END IF;

        WHEN "0111101" =>
          -- w_addr = 000000000000000000000000010111--

          -- Write logic for block l_avg_qty_values_reg_high: block containing
          -- bits 63..32 of register `l_avg_qty_values_reg`
          -- (`L_AVG_QTY_VALUES`).
          IF w_req OR w_lreq THEN
            w_hold(63 DOWNTO 32) := w_data;
            w_hstb(63 DOWNTO 32) := w_strb;
            w_multi := '0';
          END IF;

          -- Write logic for field l_avg_qty_values: l_avg_qty_values.

          tmp_data64 := w_hold(63 DOWNTO 0);
          tmp_strb64 := w_hstb(63 DOWNTO 0);
          IF w_req THEN

            -- Regular access logic. Write mode: masked.

            f_l_avg_qty_values_r((0)).d
            := (f_l_avg_qty_values_r((0)).d AND NOT tmp_strb64)
            OR tmp_data64;
            w_ack := true;

          END IF;

        WHEN "0111110" =>
          -- w_addr = 000000000000000000000000011000--

          -- Write logic for block l_avg_price_values_reg_low: block containing
          -- bits 31..0 of register `l_avg_price_values_reg`
          -- (`L_AVG_PRICE_VALUES`).
          IF w_req OR w_lreq THEN
            w_hold(31 DOWNTO 0) := w_data;
            w_hstb(31 DOWNTO 0) := w_strb;
            w_multi := '1';
          END IF;
          IF w_req THEN
            w_ack := true;
          END IF;

        WHEN "0111111" =>
          -- w_addr = 000000000000000000000000011001--

          -- Write logic for block l_avg_price_values_reg_high: block containing
          -- bits 63..32 of register `l_avg_price_values_reg`
          -- (`L_AVG_PRICE_VALUES`).
          IF w_req OR w_lreq THEN
            w_hold(63 DOWNTO 32) := w_data;
            w_hstb(63 DOWNTO 32) := w_strb;
            w_multi := '0';
          END IF;

          -- Write logic for field l_avg_price_values: l_avg_price_values.

          tmp_data64 := w_hold(63 DOWNTO 0);
          tmp_strb64 := w_hstb(63 DOWNTO 0);
          IF w_req THEN

            -- Regular access logic. Write mode: masked.

            f_l_avg_price_values_r((0)).d
            := (f_l_avg_price_values_r((0)).d AND NOT tmp_strb64)
            OR tmp_data64;
            w_ack := true;

          END IF;

        WHEN "1000000" =>
          -- w_addr = 000000000000000000000000011010--

          -- Write logic for block l_avg_disc_values_reg_low: block containing
          -- bits 31..0 of register `l_avg_disc_values_reg`
          -- (`L_AVG_DISC_VALUES`).
          IF w_req OR w_lreq THEN
            w_hold(31 DOWNTO 0) := w_data;
            w_hstb(31 DOWNTO 0) := w_strb;
            w_multi := '1';
          END IF;
          IF w_req THEN
            w_ack := true;
          END IF;

        WHEN "1000001" =>
          -- w_addr = 000000000000000000000000011011--

          -- Write logic for block l_avg_disc_values_reg_high: block containing
          -- bits 63..32 of register `l_avg_disc_values_reg`
          -- (`L_AVG_DISC_VALUES`).
          IF w_req OR w_lreq THEN
            w_hold(63 DOWNTO 32) := w_data;
            w_hstb(63 DOWNTO 32) := w_strb;
            w_multi := '0';
          END IF;

          -- Write logic for field l_avg_disc_values: l_avg_disc_values.

          tmp_data64 := w_hold(63 DOWNTO 0);
          tmp_strb64 := w_hstb(63 DOWNTO 0);
          IF w_req THEN

            -- Regular access logic. Write mode: masked.

            f_l_avg_disc_values_r((0)).d
            := (f_l_avg_disc_values_r((0)).d AND NOT tmp_strb64)
            OR tmp_data64;
            w_ack := true;

          END IF;

        WHEN "1000010" =>
          -- w_addr = 000000000000000000000000011100--

          -- Write logic for block l_count_order_values_reg_low: block
          -- containing bits 31..0 of register `l_count_order_values_reg`
          -- (`L_COUNT_ORDER_VALUES`).
          IF w_req OR w_lreq THEN
            w_hold(31 DOWNTO 0) := w_data;
            w_hstb(31 DOWNTO 0) := w_strb;
            w_multi := '1';
          END IF;
          IF w_req THEN
            w_ack := true;
          END IF;

        WHEN "1000011" =>
          -- w_addr = 000000000000000000000000011101--

          -- Write logic for block l_count_order_values_reg_high: block
          -- containing bits 63..32 of register `l_count_order_values_reg`
          -- (`L_COUNT_ORDER_VALUES`).
          IF w_req OR w_lreq THEN
            w_hold(63 DOWNTO 32) := w_data;
            w_hstb(63 DOWNTO 32) := w_strb;
            w_multi := '0';
          END IF;

          -- Write logic for field l_count_order_values: l_count_order_values.

          tmp_data64 := w_hold(63 DOWNTO 0);
          tmp_strb64 := w_hstb(63 DOWNTO 0);
          IF w_req THEN

            -- Regular access logic. Write mode: masked.

            f_l_count_order_values_r((0)).d
            := (f_l_count_order_values_r((0)).d AND NOT tmp_strb64)
            OR tmp_data64;
            w_ack := true;

          END IF;
        WHEN "1000100" =>
          -- w_addr = 000000000000000000000000101100--

          -- Write logic for block Profile_enable_reg: block containing bits
          -- 31..0 of register `Profile_enable_reg` (`PROFILE_ENABLE`).
          IF w_req OR w_lreq THEN
            w_hold(31 DOWNTO 0) := w_data;
            w_hstb(31 DOWNTO 0) := w_strb;
            w_multi := '0';
          END IF;

          -- Write logic for field Profile_enable: Profile_enable.

          tmp_data := w_hold(0);
          tmp_strb := w_hstb(0);
          IF w_req THEN

            -- Regular access logic. Write mode: masked.

            f_Profile_enable_r((0)).d
            := (f_Profile_enable_r((0)).d AND NOT tmp_strb) OR tmp_data;
            w_ack := true;

          END IF;

        WHEN OTHERS => -- "101101"
          -- w_addr = 000000000000000000000000101101--

          -- Write logic for block Profile_clear_reg: block containing bits
          -- 31..0 of register `Profile_clear_reg` (`PROFILE_CLEAR`).
          IF w_req OR w_lreq THEN
            w_hold(31 DOWNTO 0) := w_data;
            w_hstb(31 DOWNTO 0) := w_strb;
            w_multi := '0';
          END IF;

          -- Write logic for field Profile_clear: Profile_clear.

          tmp_data := w_hold(0);
          tmp_strb := w_hstb(0);
          IF w_req THEN

            -- Regular access logic. Write mode: enabled.

            f_Profile_clear_r((0)).d := tmp_data;
            w_ack := true;

            -- Handle post-write operation: invalidate.
            f_Profile_clear_r((0)).v := '1';
            f_Profile_clear_r((0)).inval := '1';

          END IF;

      END CASE;

      -------------------------------------------------------------------------
      -- Generated field logic
      -------------------------------------------------------------------------

      -- Post-bus logic for field start: start.

      -- Handle reset for field start.
      IF reset = '1' THEN
        f_start_r((0)).d := '0';
        f_start_r((0)).v := '1';
        f_start_r((0)).inval := '0';
      END IF;
      -- Assign the read outputs for field start.
      f_start_data <= f_start_r((0)).d;

      -- Post-bus logic for field stop: stop.

      -- Handle reset for field stop.
      IF reset = '1' THEN
        f_stop_r((0)).d := '0';
        f_stop_r((0)).v := '1';
        f_stop_r((0)).inval := '0';
      END IF;
      -- Assign the read outputs for field stop.
      f_stop_data <= f_stop_r((0)).d;

      -- Post-bus logic for field reset: reset.

      -- Handle reset for field reset.
      IF reset = '1' THEN
        f_reset_r((0)).d := '0';
        f_reset_r((0)).v := '1';
        f_reset_r((0)).inval := '0';
      END IF;
      -- Assign the read outputs for field reset.
      f_reset_data <= f_reset_r((0)).d;

      -- Post-bus logic for field l_firstidx: l_firstidx.

      -- Handle reset for field l_firstidx.
      IF reset = '1' THEN
        f_l_firstidx_r((0)).d := (OTHERS => '0');
        f_l_firstidx_r((0)).v := '0';
      END IF;
      -- Assign the read outputs for field l_firstidx.
      f_l_firstidx_data <= f_l_firstidx_r((0)).d;

      -- Post-bus logic for field l_lastidx: l_lastidx.

      -- Handle reset for field l_lastidx.
      IF reset = '1' THEN
        f_l_lastidx_r((0)).d := (OTHERS => '0');
        f_l_lastidx_r((0)).v := '0';
      END IF;
      -- Assign the read outputs for field l_lastidx.
      f_l_lastidx_data <= f_l_lastidx_r((0)).d;

      -- Post-bus logic for field l_quantity_values: l_quantity_values.

      -- Handle reset for field l_quantity_values.
      IF reset = '1' THEN
        f_l_quantity_values_r((0)).d := (OTHERS => '0');
        f_l_quantity_values_r((0)).v := '0';
      END IF;
      -- Assign the read outputs for field l_quantity_values.
      f_l_quantity_values_data <= f_l_quantity_values_r((0)).d;

      -- Post-bus logic for field l_extendedprice_values:
      -- l_extendedprice_values.

      -- Handle reset for field l_extendedprice_values.
      IF reset = '1' THEN
        f_l_extendedprice_values_r((0)).d := (OTHERS => '0');
        f_l_extendedprice_values_r((0)).v := '0';
      END IF;
      -- Assign the read outputs for field l_extendedprice_values.
      f_l_extendedprice_values_data <= f_l_extendedprice_values_r((0)).d;

      -- Post-bus logic for field l_discount_values: l_discount_values.

      -- Handle reset for field l_discount_values.
      IF reset = '1' THEN
        f_l_discount_values_r((0)).d := (OTHERS => '0');
        f_l_discount_values_r((0)).v := '0';
      END IF;
      -- Assign the read outputs for field l_discount_values.
      f_l_discount_values_data <= f_l_discount_values_r((0)).d;

      -- Post-bus logic for field l_tax_values: l_tax_values.

      -- Handle reset for field l_tax_values.
      IF reset = '1' THEN
        f_l_tax_values_r((0)).d := (OTHERS => '0');
        f_l_tax_values_r((0)).v := '0';
      END IF;
      -- Assign the read outputs for field l_tax_values.
      f_l_tax_values_data <= f_l_tax_values_r((0)).d;

      -- Post-bus logic for field l_returnflag_offsets: l_returnflag_offsets.

      -- Handle reset for field l_returnflag_offsets.
      IF reset = '1' THEN
        f_l_returnflag_offsets_r((0)).d := (OTHERS => '0');
        f_l_returnflag_offsets_r((0)).v := '0';
      END IF;
      -- Assign the read outputs for field l_returnflag_offsets.
      f_l_returnflag_offsets_data <= f_l_returnflag_offsets_r((0)).d;

      -- Post-bus logic for field l_returnflag_values: l_returnflag_values.

      -- Handle reset for field l_returnflag_values.
      IF reset = '1' THEN
        f_l_returnflag_values_r((0)).d := (OTHERS => '0');
        f_l_returnflag_values_r((0)).v := '0';
      END IF;
      -- Assign the read outputs for field l_returnflag_values.
      f_l_returnflag_values_data <= f_l_returnflag_values_r((0)).d;

      -- Post-bus logic for field l_linestatus_offsets: l_linestatus_offsets.

      -- Handle reset for field l_linestatus_offsets.
      IF reset = '1' THEN
        f_l_linestatus_offsets_r((0)).d := (OTHERS => '0');
        f_l_linestatus_offsets_r((0)).v := '0';
      END IF;
      -- Assign the read outputs for field l_linestatus_offsets.
      f_l_linestatus_offsets_data <= f_l_linestatus_offsets_r((0)).d;

      -- Post-bus logic for field l_linestatus_values: l_linestatus_values.

      -- Handle reset for field l_linestatus_values.
      IF reset = '1' THEN
        f_l_linestatus_values_r((0)).d := (OTHERS => '0');
        f_l_linestatus_values_r((0)).v := '0';
      END IF;
      -- Assign the read outputs for field l_linestatus_values.
      f_l_linestatus_values_data <= f_l_linestatus_values_r((0)).d;

      -- Post-bus logic for field l_shipdate_values: l_shipdate_values.

      -- Handle reset for field l_shipdate_values.
      IF reset = '1' THEN
        f_l_shipdate_values_r((0)).d := (OTHERS => '0');
        f_l_shipdate_values_r((0)).v := '0';
      END IF;
      -- Assign the read outputs for field l_shipdate_values.
      f_l_shipdate_values_data <= f_l_shipdate_values_r((0)).d;

      -- Post-bus logic for field l_returnflag_o_offsets:
      -- l_returnflag_o_offsets.

      -- Handle reset for field l_returnflag_o_offsets.
      IF reset = '1' THEN
        f_l_returnflag_o_offsets_r((0)).d := (OTHERS => '0');
        f_l_returnflag_o_offsets_r((0)).v := '0';
      END IF;
      -- Assign the read outputs for field l_returnflag_o_offsets.
      f_l_returnflag_o_offsets_data <= f_l_returnflag_o_offsets_r((0)).d;

      -- Post-bus logic for field l_returnflag_o_values: l_returnflag_o_values.

      -- Handle reset for field l_returnflag_o_values.
      IF reset = '1' THEN
        f_l_returnflag_o_values_r((0)).d := (OTHERS => '0');
        f_l_returnflag_o_values_r((0)).v := '0';
      END IF;
      -- Assign the read outputs for field l_returnflag_o_values.
      f_l_returnflag_o_values_data <= f_l_returnflag_o_values_r((0)).d;

      -- Post-bus logic for field l_linestatus_o_offsets:
      -- l_linestatus_o_offsets.

      -- Handle reset for field l_linestatus_o_offsets.
      IF reset = '1' THEN
        f_l_linestatus_o_offsets_r((0)).d := (OTHERS => '0');
        f_l_linestatus_o_offsets_r((0)).v := '0';
      END IF;
      -- Assign the read outputs for field l_linestatus_o_offsets.
      f_l_linestatus_o_offsets_data <= f_l_linestatus_o_offsets_r((0)).d;

      -- Post-bus logic for field l_linestatus_o_values: l_linestatus_o_values.

      -- Handle reset for field l_linestatus_o_values.
      IF reset = '1' THEN
        f_l_linestatus_o_values_r((0)).d := (OTHERS => '0');
        f_l_linestatus_o_values_r((0)).v := '0';
      END IF;
      -- Assign the read outputs for field l_linestatus_o_values.
      f_l_linestatus_o_values_data <= f_l_linestatus_o_values_r((0)).d;

      -- Post-bus logic for field l_sum_qty_values: l_sum_qty_values.

      -- Handle reset for field l_sum_qty_values.
      IF reset = '1' THEN
        f_l_sum_qty_values_r((0)).d := (OTHERS => '0');
        f_l_sum_qty_values_r((0)).v := '0';
      END IF;
      -- Assign the read outputs for field l_sum_qty_values.
      f_l_sum_qty_values_data <= f_l_sum_qty_values_r((0)).d;

      -- Post-bus logic for field l_sum_base_price_values:
      -- l_sum_base_price_values.

      -- Handle reset for field l_sum_base_price_values.
      IF reset = '1' THEN
        f_l_sum_base_price_values_r((0)).d := (OTHERS => '0');
        f_l_sum_base_price_values_r((0)).v := '0';
      END IF;
      -- Assign the read outputs for field l_sum_base_price_values.
      f_l_sum_base_price_values_data <= f_l_sum_base_price_values_r((0)).d;

      -- Post-bus logic for field l_sum_disc_price_values:
      -- l_sum_disc_price_values.

      -- Handle reset for field l_sum_disc_price_values.
      IF reset = '1' THEN
        f_l_sum_disc_price_values_r((0)).d := (OTHERS => '0');
        f_l_sum_disc_price_values_r((0)).v := '0';
      END IF;
      -- Assign the read outputs for field l_sum_disc_price_values.
      f_l_sum_disc_price_values_data <= f_l_sum_disc_price_values_r((0)).d;

      -- Post-bus logic for field l_sum_charge_values: l_sum_charge_values.

      -- Handle reset for field l_sum_charge_values.
      IF reset = '1' THEN
        f_l_sum_charge_values_r((0)).d := (OTHERS => '0');
        f_l_sum_charge_values_r((0)).v := '0';
      END IF;
      -- Assign the read outputs for field l_sum_charge_values.
      f_l_sum_charge_values_data <= f_l_sum_charge_values_r((0)).d;

      -- Post-bus logic for field l_avg_qty_values: l_avg_qty_values.

      -- Handle reset for field l_avg_qty_values.
      IF reset = '1' THEN
        f_l_avg_qty_values_r((0)).d := (OTHERS => '0');
        f_l_avg_qty_values_r((0)).v := '0';
      END IF;
      -- Assign the read outputs for field l_avg_qty_values.
      f_l_avg_qty_values_data <= f_l_avg_qty_values_r((0)).d;

      -- Post-bus logic for field l_avg_price_values: l_avg_price_values.

      -- Handle reset for field l_avg_price_values.
      IF reset = '1' THEN
        f_l_avg_price_values_r((0)).d := (OTHERS => '0');
        f_l_avg_price_values_r((0)).v := '0';
      END IF;
      -- Assign the read outputs for field l_avg_price_values.
      f_l_avg_price_values_data <= f_l_avg_price_values_r((0)).d;

      -- Post-bus logic for field l_avg_disc_values: l_avg_disc_values.

      -- Handle reset for field l_avg_disc_values.
      IF reset = '1' THEN
        f_l_avg_disc_values_r((0)).d := (OTHERS => '0');
        f_l_avg_disc_values_r((0)).v := '0';
      END IF;
      -- Assign the read outputs for field l_avg_disc_values.
      f_l_avg_disc_values_data <= f_l_avg_disc_values_r((0)).d;

      -- Post-bus logic for field l_count_order_values: l_count_order_values.

      -- Handle reset for field l_count_order_values.
      IF reset = '1' THEN
        f_l_count_order_values_r((0)).d := (OTHERS => '0');
        f_l_count_order_values_r((0)).v := '0';
      END IF;
      -- Assign the read outputs for field l_count_order_values.
      f_l_count_order_values_data <= f_l_count_order_values_r((0)).d;
      -- Post-bus logic for field Profile_enable: Profile_enable.

      -- Handle reset for field Profile_enable.
      IF reset = '1' THEN
        f_Profile_enable_r((0)).d := '0';
        f_Profile_enable_r((0)).v := '0';
      END IF;
      -- Assign the read outputs for field Profile_enable.
      f_Profile_enable_data <= f_Profile_enable_r((0)).d;

      -- Post-bus logic for field Profile_clear: Profile_clear.

      -- Handle reset for field Profile_clear.
      IF reset = '1' THEN
        f_Profile_clear_r((0)).d := '0';
        f_Profile_clear_r((0)).v := '1';
        f_Profile_clear_r((0)).inval := '0';
      END IF;
      -- Assign the read outputs for field Profile_clear.
      f_Profile_clear_data <= f_Profile_clear_r((0)).d;

      -------------------------------------------------------------------------
      -- Boilerplate bus access logic
      -------------------------------------------------------------------------
      -- Perform the write action dictated by the field logic.
      IF w_req AND NOT w_block THEN

        -- Accept write requests by invalidating the request holding
        -- registers.
        awl.valid := '0';
        wl.valid := '0';

        -- Send the appropriate write response.
        bus_v.b.valid := '1';
        IF w_nack THEN
          bus_v.b.resp := AXI4L_RESP_SLVERR;
        ELSIF w_ack THEN
          bus_v.b.resp := AXI4L_RESP_OKAY;
        ELSE
          bus_v.b.resp := AXI4L_RESP_DECERR;
        END IF;

      END IF;

      -- Perform the read action dictated by the field logic.
      IF r_req AND NOT r_block THEN

        -- Accept read requests by invalidating the request holding
        -- registers.
        arl.valid := '0';

        -- Send the appropriate read response.
        bus_v.r.valid := '1';
        IF r_nack THEN
          bus_v.r.resp := AXI4L_RESP_SLVERR;
        ELSIF r_ack THEN
          bus_v.r.resp := AXI4L_RESP_OKAY;
          bus_v.r.data := r_data;
        ELSE
          bus_v.r.resp := AXI4L_RESP_DECERR;
        END IF;

      END IF;

      -- If we're at the end of a multi-word write, clear the write strobe
      -- holding register to prevent previously written data from leaking into
      -- later partial writes.
      IF w_multi = '0' THEN
        w_hstb := (OTHERS => '0');
      END IF;

      -- Mark the incoming channels as ready when their respective holding
      -- registers are empty.
      bus_v.aw.ready := NOT awl.valid;
      bus_v.w.ready := NOT wl.valid;
      bus_v.ar.ready := NOT arl.valid;

      -------------------------------------------------------------------------
      -- Handle AXI4-lite bus reset
      -------------------------------------------------------------------------
      -- Reset overrides everything, so it comes last. Note that field
      -- registers are *not* reset here; this would complicate code generation.
      -- Instead, the generated field logic blocks include reset logic for the
      -- field-specific registers.
      IF reset = '1' THEN
        bus_v := AXI4L32_S2M_RESET;
        awl := AXI4LA_RESET;
        wl := AXI4LW32_RESET;
        arl := AXI4LA_RESET;
        w_hstb := (OTHERS => '0');
        w_hold := (OTHERS => '0');
        w_multi := '0';
        r_multi := '0';
        r_hold := (OTHERS => '0');
      END IF;

      mmio_awready <= bus_v.aw.ready;
      mmio_wready <= bus_v.w.ready;
      mmio_bvalid <= bus_v.b.valid;
      mmio_bresp <= bus_v.b.resp;
      mmio_arready <= bus_v.ar.ready;
      mmio_rvalid <= bus_v.r.valid;
      mmio_rdata <= bus_v.r.data;
      mmio_rresp <= bus_v.r.resp;
      mmio_uirq <= bus_v.u.irq;

    END IF;
  END PROCESS;
END behavioral;