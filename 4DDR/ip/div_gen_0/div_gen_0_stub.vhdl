-- Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2020.1 (lin64) Build 2902540 Wed May 27 19:54:35 MDT 2020
-- Date        : Sat Jun 19 02:55:32 2021
-- Host        : yyunon-desktop running 64-bit Ubuntu 18.04.5 LTS
-- Command     : write_vhdl -force -mode synth_stub /home/yyunon/ip_packages/div_gen_0/div_gen_0_stub.vhdl
-- Design      : div_gen_0
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xcvu9p-flgb2104-2-i
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity div_gen_0 is
  Port ( 
    aclk : in STD_LOGIC;
    s_axis_divisor_tvalid : in STD_LOGIC;
    s_axis_divisor_tready : out STD_LOGIC;
    s_axis_divisor_tuser : in STD_LOGIC_VECTOR ( 0 to 0 );
    s_axis_divisor_tlast : in STD_LOGIC;
    s_axis_divisor_tdata : in STD_LOGIC_VECTOR ( 63 downto 0 );
    s_axis_dividend_tvalid : in STD_LOGIC;
    s_axis_dividend_tready : out STD_LOGIC;
    s_axis_dividend_tuser : in STD_LOGIC_VECTOR ( 0 to 0 );
    s_axis_dividend_tlast : in STD_LOGIC;
    s_axis_dividend_tdata : in STD_LOGIC_VECTOR ( 63 downto 0 );
    m_axis_dout_tvalid : out STD_LOGIC;
    m_axis_dout_tready : in STD_LOGIC;
    m_axis_dout_tuser : out STD_LOGIC_VECTOR ( 2 downto 0 );
    m_axis_dout_tlast : out STD_LOGIC;
    m_axis_dout_tdata : out STD_LOGIC_VECTOR ( 87 downto 0 )
  );

end div_gen_0;

architecture stub of div_gen_0 is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "aclk,s_axis_divisor_tvalid,s_axis_divisor_tready,s_axis_divisor_tuser[0:0],s_axis_divisor_tlast,s_axis_divisor_tdata[63:0],s_axis_dividend_tvalid,s_axis_dividend_tready,s_axis_dividend_tuser[0:0],s_axis_dividend_tlast,s_axis_dividend_tdata[63:0],m_axis_dout_tvalid,m_axis_dout_tready,m_axis_dout_tuser[2:0],m_axis_dout_tlast,m_axis_dout_tdata[87:0]";
attribute x_core_info : string;
attribute x_core_info of stub : architecture is "div_gen_v5_1_16,Vivado 2020.1";
begin
end;
