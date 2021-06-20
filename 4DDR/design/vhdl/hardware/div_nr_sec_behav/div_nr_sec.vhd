-----------------------------------------------------------------------
-- sequential NON RESTORING Divisor
-- A, and B naturals (non negative integers) with XBITS and YBITS width
-- there is no restriction XBITS >= YBITS. 
-- Return quotient Q of XBITS and remainder R of NBITS
-- GRAIN defines the amount of bits computed at each cycle. 
-- XBITS mod GRAIN must be 0!!! and XBITS /= GRAIN (i.e. not for combinational circuit) 
-- The algorithm needs XBITS/GRAIN + 1 cylcles to calculate the quotient and
-- XBITS/GRAIN + 2 to compute the remainder
-- The ini signal captures sincronously the operands
-- fin, the end signal. To high when Q is ready (one cicle before R)
-- G.Sutter 2007
----------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
use work.mypackage.all;

entity div_nr_sec is
    port (
        A: in STD_LOGIC_VECTOR (XBITS-1 downto 0);
        B: in STD_LOGIC_VECTOR (YBITS-1 downto 0);
        clk: in STD_LOGIC;
        ini: in STD_LOGIC;	 --initialization, capture input data
        fin: out STD_LOGIC; --finish signal
        Q: out STD_LOGIC_VECTOR (XBITS-1 downto 0);
        R: out STD_LOGIC_VECTOR (YBITS-1 downto 0)
     );
end div_nr_sec;

architecture mult_arch of div_nr_sec is

component cond_adder
   port(
      op_a : in std_logic_vector(YBITS-1 downto 0);
      op_b : in std_logic_vector(YBITS-1 downto 0);
      sel : in std_logic;          
      outp : out std_logic_vector(YBITS-1 downto 0)
      );
end component;

component add_sub is
    port (
        op_a: in STD_LOGIC_VECTOR (YBITS downto 0);
        op_m: in STD_LOGIC_VECTOR (YBITS downto 0);
        sr: in STD_LOGIC;
        outp: out STD_LOGIC_VECTOR (YBITS downto 0)
     );
end component;

type connectionmatrix is array (0 to GRAIN) of STD_LOGIC_VECTOR (YBITS downto 0);
signal  wires_i, wires_o: connectionmatrix;
signal  add_subs: STD_LOGIC_VECTOR (GRAIN downto 0);
signal  counter: integer range 0 to XBITS+1;
signal  adjust, work, last: STD_LOGIC;
signal  reg_a_s: STD_LOGIC; -- register add or subtract
Signal  reg_y, remainder, remainder_N: STD_LOGIC_VECTOR (YBITS downto 0);
Signal  rem_no_Adjust, adjusted_Remainder: STD_LOGIC_VECTOR (YBITS-1 downto 0);
Signal  shift_Q, shift_A: STD_LOGIC_VECTOR (XBITS-1 downto 0);
constant  zeros: STD_LOGIC_VECTOR (YBITS-1 downto 0) := (others => '0');

begin

  state_mach: process (CLK, work, ini)
  begin
   if CLK'event and CLK='1' then  --CLK rising edge 
      if ini='1' then  -- initialization
         work <= '1'; last <= '0'; counter <= 0;
         remainder <= zeros & A(XBITS-1);
         shift_A <= A;
         reg_Y <= '0' & B;
         reg_a_s <= '0';    --Add or Substract
      elsif work = '1' then
           counter <= counter+1;
           remainder <= remainder_N(YBITS-1 downto 0) & shift_A(XBITS-1-GRAIN);      	  
           shift_Q <= shift_Q(XBITS-1-GRAIN downto 0) & add_subs(GRAIN-1 downto 0);
           shift_A <= shift_A(XBITS-1-GRAIN downto 0) & shift_A(XBITS-1 downto XBITS-GRAIN);
           reg_a_s <= remainder_N(YBITS);
           if (counter = XBITS/GRAIN-1) then
              rem_no_adjust <= remainder_N(YBITS-1 downto 0);      	  
              adjust <= remainder_N(YBITS);
              work <= '0'; last <= '1';
              Q <= not(shift_Q(XBITS-1-GRAIN downto 0) & add_subs(GRAIN-1 downto 0));
           end if;
      end if;
      if (last = '1') then
             R <= adjusted_remainder;
             last <= '0';
      end if;
    end if;
  end process;

  fin <= not(work); --if you need wait for remainder replace by: not(work or last)

  wires_i(0) <= Remainder;	
  add_subs(GRAIN) <= reg_a_s;
  divisors: for I in 0 to GRAIN-1 generate
    nrcell: add_sub port map (op_a => wires_i(i),	
          op_m => reg_Y, 
          sr => add_subs(GRAIN-i), 
          outp => wires_o(i) );

    add_subs(GRAIN-i-1) <= wires_o(i)(YBITS);
    wires_i(i+1) <= wires_o(i)(YBITS-1 downto 0) & shift_A(XBITS-2-i);
  end generate;
  remainder_N <= wires_o(GRAIN-1);

  final_rem_Adjust: cond_adder port map (op_a => rem_no_adjust,
          op_b => reg_Y(YBITS-1 downto 0), 
          sel => adjust, outp => adjusted_remainder);

end mult_arch;


