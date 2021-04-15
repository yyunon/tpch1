-- Copyright 2018-2019 Delft University of Technology
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
--     http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.std_logic_misc.ALL;

LIBRARY work;
USE work.Axi_pkg.ALL;
USE work.UtilInt_pkg.ALL;
USE work.UtilConv_pkg.ALL;
USE work.UtilMisc_pkg.ALL;

-------------------------------------------------------------------------------
-- AXI4 compatible top level for Fletcher generated accelerators.
-------------------------------------------------------------------------------
-- Requires an AXI4 port to host memory.
-- Requires an AXI4-lite port from host for MMIO.
-------------------------------------------------------------------------------
ENTITY AxiTop IS
  GENERIC (
    -- Accelerator properties
    INDEX_WIDTH : NATURAL := 32;
    REG_WIDTH : NATURAL := 32;
    TAG_WIDTH : NATURAL := 1;
    -- AXI4 (full) bus properties for memory access.
    BUS_ADDR_WIDTH : NATURAL := 64;
    BUS_DATA_WIDTH : NATURAL := 512;
    BUS_LEN_WIDTH : NATURAL := 8;
    BUS_BURST_MAX_LEN : NATURAL := 64;
    BUS_BURST_STEP_LEN : NATURAL := 1
  );

  PORT (
    -- Kernel clock domain.
    kcd_clk : IN STD_LOGIC;
    kcd_reset : IN STD_LOGIC;

    -- Bus clock domain.
    bcd_clk : IN STD_LOGIC;
    bcd_reset : IN STD_LOGIC;

    ---------------------------------------------------------------------------
    -- External signals
    ---------------------------------------------------------------------------

    ---------------------------------------------------------------------------
    -- AXI4 master as Host Memory Interface
    ---------------------------------------------------------------------------
    -- Read address channel
    m_axi_araddr : OUT STD_LOGIC_VECTOR(BUS_ADDR_WIDTH - 1 DOWNTO 0);
    m_axi_arlen : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    m_axi_arvalid : OUT STD_LOGIC := '0';
    m_axi_arready : IN STD_LOGIC;
    m_axi_arsize : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);

    -- Read data channel
    m_axi_rdata : IN STD_LOGIC_VECTOR(BUS_DATA_WIDTH - 1 DOWNTO 0);
    m_axi_rresp : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
    m_axi_rlast : IN STD_LOGIC;
    m_axi_rvalid : IN STD_LOGIC;
    m_axi_rready : OUT STD_LOGIC := '0';

    -- Write address channel
    m_axi_awvalid : OUT STD_LOGIC := '0';
    m_axi_awready : IN STD_LOGIC;
    m_axi_awaddr : OUT STD_LOGIC_VECTOR(BUS_ADDR_WIDTH - 1 DOWNTO 0);
    m_axi_awlen : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    m_axi_awsize : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);

    -- Write data channel
    m_axi_wvalid : OUT STD_LOGIC := '0';
    m_axi_wready : IN STD_LOGIC;
    m_axi_wdata : OUT STD_LOGIC_VECTOR(BUS_DATA_WIDTH - 1 DOWNTO 0);
    m_axi_wlast : OUT STD_LOGIC;
    m_axi_wstrb : OUT STD_LOGIC_VECTOR(BUS_DATA_WIDTH/8 - 1 DOWNTO 0);

    ---------------------------------------------------------------------------
    -- AXI4-lite Slave as MMIO interface
    ---------------------------------------------------------------------------
    -- Write address channel
    s_axi_awvalid : IN STD_LOGIC;
    s_axi_awready : OUT STD_LOGIC;
    s_axi_awaddr : IN STD_LOGIC_VECTOR(32 - 1 DOWNTO 0);

    -- Write data channel
    s_axi_wvalid : IN STD_LOGIC;
    s_axi_wready : OUT STD_LOGIC;
    s_axi_wdata : IN STD_LOGIC_VECTOR(32 - 1 DOWNTO 0);
    s_axi_wstrb : IN STD_LOGIC_VECTOR((32/8) - 1 DOWNTO 0);

    -- Write response channel
    s_axi_bvalid : OUT STD_LOGIC;
    s_axi_bready : IN STD_LOGIC;
    s_axi_bresp : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);

    -- Read address channel
    s_axi_arvalid : IN STD_LOGIC;
    s_axi_arready : OUT STD_LOGIC;
    s_axi_araddr : IN STD_LOGIC_VECTOR(32 - 1 DOWNTO 0);

    -- Read data channel
    s_axi_rvalid : OUT STD_LOGIC;
    s_axi_rready : IN STD_LOGIC;
    s_axi_rdata : OUT STD_LOGIC_VECTOR(32 - 1 DOWNTO 0);
    s_axi_rresp : OUT STD_LOGIC_VECTOR(1 DOWNTO 0)
  );
END AxiTop;

ARCHITECTURE Behavorial OF AxiTop IS

  -----------------------------------------------------------------------------
  -- Generated top-level wrapper component.
  -----------------------------------------------------------------------------
  COMPONENT PriceSummary_Mantle IS
    GENERIC (
      INDEX_WIDTH : INTEGER := 32;
      TAG_WIDTH : INTEGER := 1;
      BUS_ADDR_WIDTH : INTEGER := 64;
      BUS_DATA_WIDTH : INTEGER := 512;
      BUS_LEN_WIDTH : INTEGER := 8;
      BUS_BURST_STEP_LEN : INTEGER := 1;
      BUS_BURST_MAX_LEN : INTEGER := 16
    );
    PORT (
      bcd_clk : IN STD_LOGIC;
      bcd_reset : IN STD_LOGIC;
      kcd_clk : IN STD_LOGIC;
      kcd_reset : IN STD_LOGIC;
      mmio_awvalid : IN STD_LOGIC;
      mmio_awready : OUT STD_LOGIC;
      mmio_awaddr : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      mmio_wvalid : IN STD_LOGIC;
      mmio_wready : OUT STD_LOGIC;
      mmio_wdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      mmio_wstrb : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      mmio_bvalid : OUT STD_LOGIC;
      mmio_bready : IN STD_LOGIC;
      mmio_bresp : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
      mmio_arvalid : IN STD_LOGIC;
      mmio_arready : OUT STD_LOGIC;
      mmio_araddr : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      mmio_rvalid : OUT STD_LOGIC;
      mmio_rready : IN STD_LOGIC;
      mmio_rdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      mmio_rresp : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
      rd_mst_rreq_valid : OUT STD_LOGIC;
      rd_mst_rreq_ready : IN STD_LOGIC;
      rd_mst_rreq_addr : OUT STD_LOGIC_VECTOR(BUS_ADDR_WIDTH - 1 DOWNTO 0);
      rd_mst_rreq_len : OUT STD_LOGIC_VECTOR(BUS_LEN_WIDTH - 1 DOWNTO 0);
      rd_mst_rdat_valid : IN STD_LOGIC;
      rd_mst_rdat_ready : OUT STD_LOGIC;
      rd_mst_rdat_data : IN STD_LOGIC_VECTOR(BUS_DATA_WIDTH - 1 DOWNTO 0);
      rd_mst_rdat_last : IN STD_LOGIC;
      wr_mst_wreq_valid : OUT STD_LOGIC;
      wr_mst_wreq_ready : IN STD_LOGIC;
      wr_mst_wreq_addr : OUT STD_LOGIC_VECTOR(BUS_ADDR_WIDTH - 1 DOWNTO 0);
      wr_mst_wreq_len : OUT STD_LOGIC_VECTOR(BUS_LEN_WIDTH - 1 DOWNTO 0);
      wr_mst_wdat_valid : OUT STD_LOGIC;
      wr_mst_wdat_ready : IN STD_LOGIC;
      wr_mst_wdat_data : OUT STD_LOGIC_VECTOR(BUS_DATA_WIDTH - 1 DOWNTO 0);
      wr_mst_wdat_strobe : OUT STD_LOGIC_VECTOR(BUS_DATA_WIDTH/8 - 1 DOWNTO 0);
      wr_mst_wdat_last : OUT STD_LOGIC
    );
  END COMPONENT;
  -----------------------------------------------------------------------------
  -- Internal signals.  

  -- Active low reset for bus clock domain
  SIGNAL bcd_reset_n : STD_LOGIC;

  -- Bus signals to convert to AXI.
  SIGNAL rd_mst_rreq_addr : STD_LOGIC_VECTOR(BUS_ADDR_WIDTH - 1 DOWNTO 0);
  SIGNAL rd_mst_rreq_len : STD_LOGIC_VECTOR(BUS_LEN_WIDTH - 1 DOWNTO 0);
  SIGNAL rd_mst_rreq_valid : STD_LOGIC;
  SIGNAL rd_mst_rreq_ready : STD_LOGIC;
  SIGNAL rd_mst_rdat_data : STD_LOGIC_VECTOR(BUS_DATA_WIDTH - 1 DOWNTO 0);
  SIGNAL rd_mst_rdat_last : STD_LOGIC;
  SIGNAL rd_mst_rdat_valid : STD_LOGIC;
  SIGNAL rd_mst_rdat_ready : STD_LOGIC;
  SIGNAL wr_mst_wreq_valid : STD_LOGIC;
  SIGNAL wr_mst_wreq_ready : STD_LOGIC;
  SIGNAL wr_mst_wreq_addr : STD_LOGIC_VECTOR(BUS_ADDR_WIDTH - 1 DOWNTO 0);
  SIGNAL wr_mst_wreq_len : STD_LOGIC_VECTOR(BUS_LEN_WIDTH - 1 DOWNTO 0);
  SIGNAL wr_mst_wdat_valid : STD_LOGIC;
  SIGNAL wr_mst_wdat_ready : STD_LOGIC;
  SIGNAL wr_mst_wdat_data : STD_LOGIC_VECTOR(BUS_DATA_WIDTH - 1 DOWNTO 0);
  SIGNAL wr_mst_wdat_strobe : STD_LOGIC_VECTOR(BUS_DATA_WIDTH/8 - 1 DOWNTO 0);
  SIGNAL wr_mst_wdat_last : STD_LOGIC;
BEGIN

  -- Active low reset
  bcd_reset_n <= NOT bcd_reset;

  -----------------------------------------------------------------------------
  -- Fletcher generated wrapper
  -----------------------------------------------------------------------------
  PriceSummary_Mantle_inst : PriceSummary_Mantle
  GENERIC MAP(
    BUS_ADDR_WIDTH => BUS_ADDR_WIDTH,
    BUS_DATA_WIDTH => BUS_DATA_WIDTH,
    BUS_BURST_STEP_LEN => BUS_BURST_STEP_LEN,
    BUS_BURST_MAX_LEN => BUS_ADDR_WIDTH,
    BUS_LEN_WIDTH => BUS_LEN_WIDTH,
    INDEX_WIDTH => INDEX_WIDTH,
    TAG_WIDTH => TAG_WIDTH
  )
  PORT MAP(
    kcd_clk => kcd_clk,
    kcd_reset => kcd_reset,
    bcd_clk => bcd_clk,
    bcd_reset => bcd_reset,

    rd_mst_rreq_valid => rd_mst_rreq_valid,
    rd_mst_rreq_ready => rd_mst_rreq_ready,
    rd_mst_rreq_addr => rd_mst_rreq_addr,
    rd_mst_rreq_len => rd_mst_rreq_len,
    rd_mst_rdat_valid => rd_mst_rdat_valid,
    rd_mst_rdat_ready => rd_mst_rdat_ready,
    rd_mst_rdat_data => rd_mst_rdat_data,
    rd_mst_rdat_last => rd_mst_rdat_last,

    wr_mst_wreq_valid => wr_mst_wreq_valid,
    wr_mst_wreq_ready => wr_mst_wreq_ready,
    wr_mst_wreq_addr => wr_mst_wreq_addr,
    wr_mst_wreq_len => wr_mst_wreq_len,
    wr_mst_wdat_valid => wr_mst_wdat_valid,
    wr_mst_wdat_ready => wr_mst_wdat_ready,
    wr_mst_wdat_data => wr_mst_wdat_data,
    wr_mst_wdat_strobe => wr_mst_wdat_strobe,
    wr_mst_wdat_last => wr_mst_wdat_last,

    mmio_awvalid => s_axi_awvalid,
    mmio_awready => s_axi_awready,
    mmio_awaddr => s_axi_awaddr,
    mmio_wvalid => s_axi_wvalid,
    mmio_wready => s_axi_wready,
    mmio_wdata => s_axi_wdata,
    mmio_wstrb => s_axi_wstrb,
    mmio_bvalid => s_axi_bvalid,
    mmio_bready => s_axi_bready,
    mmio_bresp => s_axi_bresp,
    mmio_arvalid => s_axi_arvalid,
    mmio_arready => s_axi_arready,
    mmio_araddr => s_axi_araddr,
    mmio_rvalid => s_axi_rvalid,
    mmio_rready => s_axi_rready,
    mmio_rdata => s_axi_rdata,
    mmio_rresp => s_axi_rresp
  );

  -----------------------------------------------------------------------------
  -- AXI read converter
  -----------------------------------------------------------------------------
  -- Buffering bursts is disabled (ENABLE_FIFO=false) because BufferReaders
  -- are already able to absorb full bursts.
  axi_read_conv_inst : AxiReadConverter
  GENERIC MAP(
    ADDR_WIDTH => BUS_ADDR_WIDTH,
    MASTER_DATA_WIDTH => BUS_DATA_WIDTH,
    MASTER_LEN_WIDTH => BUS_LEN_WIDTH,
    SLAVE_DATA_WIDTH => BUS_DATA_WIDTH,
    SLAVE_LEN_WIDTH => BUS_LEN_WIDTH,
    SLAVE_MAX_BURST => BUS_BURST_MAX_LEN,
    ENABLE_FIFO => false,
    SLV_REQ_SLICE_DEPTH => 0,
    SLV_DAT_SLICE_DEPTH => 0,
    MST_REQ_SLICE_DEPTH => 0,
    MST_DAT_SLICE_DEPTH => 0
  )
  PORT MAP(
    clk => bcd_clk,
    reset_n => bcd_reset_n,
    slv_bus_rreq_addr => rd_mst_rreq_addr,
    slv_bus_rreq_len => rd_mst_rreq_len,
    slv_bus_rreq_valid => rd_mst_rreq_valid,
    slv_bus_rreq_ready => rd_mst_rreq_ready,
    slv_bus_rdat_data => rd_mst_rdat_data,
    slv_bus_rdat_last => rd_mst_rdat_last,
    slv_bus_rdat_valid => rd_mst_rdat_valid,
    slv_bus_rdat_ready => rd_mst_rdat_ready,
    m_axi_araddr => m_axi_araddr,
    m_axi_arlen => m_axi_arlen,
    m_axi_arvalid => m_axi_arvalid,
    m_axi_arready => m_axi_arready,
    m_axi_arsize => m_axi_arsize,
    m_axi_rdata => m_axi_rdata,
    m_axi_rlast => m_axi_rlast,
    m_axi_rvalid => m_axi_rvalid,
    m_axi_rready => m_axi_rready
  );
  -----------------------------------------------------------------------------
  -- AXI write converter
  -----------------------------------------------------------------------------
  -- Buffering bursts is disabled (ENABLE_FIFO=false) because BufferWriters
  -- are already able to absorb full bursts.
  axi_write_conv_inst : AxiWriteConverter
  GENERIC MAP(
    ADDR_WIDTH => BUS_ADDR_WIDTH,
    MASTER_DATA_WIDTH => BUS_DATA_WIDTH,
    MASTER_LEN_WIDTH => BUS_LEN_WIDTH,
    SLAVE_DATA_WIDTH => BUS_DATA_WIDTH,
    SLAVE_LEN_WIDTH => BUS_LEN_WIDTH,
    SLAVE_MAX_BURST => BUS_BURST_MAX_LEN,
    ENABLE_FIFO => false,
    SLV_REQ_SLICE_DEPTH => 0,
    SLV_DAT_SLICE_DEPTH => 0,
    MST_REQ_SLICE_DEPTH => 0,
    MST_DAT_SLICE_DEPTH => 0
  )
  PORT MAP(
    clk => bcd_clk,
    reset_n => bcd_reset_n,
    slv_bus_wreq_addr => wr_mst_wreq_addr,
    slv_bus_wreq_len => wr_mst_wreq_len,
    slv_bus_wreq_valid => wr_mst_wreq_valid,
    slv_bus_wreq_ready => wr_mst_wreq_ready,
    slv_bus_wdat_data => wr_mst_wdat_data,
    slv_bus_wdat_strobe => wr_mst_wdat_strobe,
    slv_bus_wdat_last => wr_mst_wdat_last,
    slv_bus_wdat_valid => wr_mst_wdat_valid,
    slv_bus_wdat_ready => wr_mst_wdat_ready,
    m_axi_awaddr => m_axi_awaddr,
    m_axi_awlen => m_axi_awlen,
    m_axi_awvalid => m_axi_awvalid,
    m_axi_awready => m_axi_awready,
    m_axi_awsize => m_axi_awsize,
    m_axi_wdata => m_axi_wdata,
    m_axi_wstrb => m_axi_wstrb,
    m_axi_wlast => m_axi_wlast,
    m_axi_wvalid => m_axi_wvalid,
    m_axi_wready => m_axi_wready
  );

END ARCHITECTURE;