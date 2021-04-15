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
--
-- This file was generated by Fletchgen. Modify this file at your own risk.

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

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
BEGIN

  l_quantity_unl_valid
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

  l_quantity_unl_ready <= '0';
  l_extendedprice_unl_ready <= '0';
  l_discount_unl_ready <= '0';
  l_tax_unl_ready <= '0';
  l_returnflag_unl_ready <= '0';
  l_linestatus_unl_ready <= '0';
  l_shipdate_unl_ready <= '0';

END ARCHITECTURE;