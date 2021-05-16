library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.Stream_pkg.all;
use work.Tpch_pkg.all;

-- Counts the predicates, just a cobinatorial and register process 
-- to add inside a module with handshaking logic. Put filter output as 
-- an input
entity PredicateCounter is
  generic (

    -- Width of the stream data vector.
    FIXED_LEFT_INDEX  : integer;
    FIXED_RIGHT_INDEX : integer;
    DATA_WIDTH        : natural;
    DATA_TYPE         : string := ""

  );
  port (

    -- Rising-edge sensitive clock.
    clk        : in std_logic;

    -- Active-high synchronous reset.
    reset      : in std_logic;

    --OP1 Input stream.
    ops_valid  : in std_logic;
    ops_dvalid : in std_logic := '1';
    ops_data   : in std_logic;
    ops_last   : in std_logic;

    -- Output stream.
    out_valid  : out std_logic;
    out_data   : out std_logic_vector(DATA_WIDTH - 1 downto 0);
    out_dvalid : out std_logic
  );
end PredicateCounter;

architecture Behavioral of PredicateCounter is
  signal result  : std_logic_vector(DATA_WIDTH - 1 downto 0);
  signal counter : std_logic_vector(DATA_WIDTH - 1 downto 0);

begin
  reg_process :
  process (clk) is
  begin
    if rising_edge(clk) then
      out_valid <= '0';
      if ops_last = '1' then
        out_data  <= counter;
        out_valid <= '1';
      end if;
      if reset = '1' then
        out_data <= (others => '0');
        counter  <= (others => '0');
      end if;
    end if;
  end process;

  counter_process :
  process (ops_data, ops_valid, counter) is
  begin
    if (ops_valid = '1') and (ops_data = '1') then
      counter <= std_logic_vector(signed(counter) + 1);
    end if;
  end process;

end Behavioral;