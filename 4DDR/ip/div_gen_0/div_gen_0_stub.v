// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.1 (lin64) Build 2902540 Wed May 27 19:54:35 MDT 2020
// Date        : Sat Jun 19 02:55:32 2021
// Host        : yyunon-desktop running 64-bit Ubuntu 18.04.5 LTS
// Command     : write_verilog -force -mode synth_stub /home/yyunon/ip_packages/div_gen_0/div_gen_0_stub.v
// Design      : div_gen_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xcvu9p-flgb2104-2-i
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "div_gen_v5_1_16,Vivado 2020.1" *)
module div_gen_0(aclk, s_axis_divisor_tvalid, 
  s_axis_divisor_tready, s_axis_divisor_tuser, s_axis_divisor_tlast, 
  s_axis_divisor_tdata, s_axis_dividend_tvalid, s_axis_dividend_tready, 
  s_axis_dividend_tuser, s_axis_dividend_tlast, s_axis_dividend_tdata, 
  m_axis_dout_tvalid, m_axis_dout_tready, m_axis_dout_tuser, m_axis_dout_tlast, 
  m_axis_dout_tdata)
/* synthesis syn_black_box black_box_pad_pin="aclk,s_axis_divisor_tvalid,s_axis_divisor_tready,s_axis_divisor_tuser[0:0],s_axis_divisor_tlast,s_axis_divisor_tdata[63:0],s_axis_dividend_tvalid,s_axis_dividend_tready,s_axis_dividend_tuser[0:0],s_axis_dividend_tlast,s_axis_dividend_tdata[63:0],m_axis_dout_tvalid,m_axis_dout_tready,m_axis_dout_tuser[2:0],m_axis_dout_tlast,m_axis_dout_tdata[87:0]" */;
  input aclk;
  input s_axis_divisor_tvalid;
  output s_axis_divisor_tready;
  input [0:0]s_axis_divisor_tuser;
  input s_axis_divisor_tlast;
  input [63:0]s_axis_divisor_tdata;
  input s_axis_dividend_tvalid;
  output s_axis_dividend_tready;
  input [0:0]s_axis_dividend_tuser;
  input s_axis_dividend_tlast;
  input [63:0]s_axis_dividend_tdata;
  output m_axis_dout_tvalid;
  input m_axis_dout_tready;
  output [2:0]m_axis_dout_tuser;
  output m_axis_dout_tlast;
  output [87:0]m_axis_dout_tdata;
endmodule
