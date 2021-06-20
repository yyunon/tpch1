--------------------------------------------------------
-- Adder substractor. 
-- Basic cell of non-restoring divider
--------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
use work.mypackage.all;

entity add_sub is
    port (
        op_a: in STD_LOGIC_VECTOR (YBITS downto 0);
        op_m: in STD_LOGIC_VECTOR (YBITS downto 0);
        sr: in STD_LOGIC;
        outp: out STD_LOGIC_VECTOR (YBITS downto 0)
     );
end add_sub;

architecture add_sub_arch of add_sub is

begin

sumador_restador: process (sr,op_a,op_m)
begin
   if sr = '1' then
      outp <= op_a + op_m;
   else
      outp <= op_a - op_m;
   end if; 
end process;

end add_sub_arch;


