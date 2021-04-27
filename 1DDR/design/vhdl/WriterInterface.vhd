-- This unit generates the command and length logic, taken from stringen example in fletcher repo.
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;
use ieee.numeric_std.all;

entity StringWriterInterface is
  generic (
    DATA_WIDTH  : natural;
    TAG_WIDTH   : natural;
    LEN_WIDTH   : natural;
    INDEX_WIDTH : integer
  );
  port (

    input_valid         : in std_logic;
    input_ready         : out std_logic;
    input_dvalid        : in std_logic;
    input_last          : in std_logic;
    input_length        : in std_logic_vector(31 downto 0);
    input_count         : in std_logic_vector(0 downto 0);

    input_chars_valid   : in std_logic;
    input_chars_ready   : out std_logic;
    input_chars_dvalid  : in std_logic;
    input_chars_last    : in std_logic;
    input_chars         : in std_logic_vector(7 downto 0);
    input_chars_count   : in std_logic_vector(0 downto 0);

    output_valid        : out std_logic;
    output_ready        : in std_logic;
    output_dvalid       : out std_logic;
    output_last         : out std_logic;
    output_length       : out std_logic_vector(31 downto 0);
    output_count        : out std_logic_vector(0 downto 0);

    output_chars_valid  : out std_logic;
    output_chars_ready  : in std_logic;
    output_chars_dvalid : out std_logic;
    output_chars_last   : out std_logic;
    output_chars        : out std_logic_vector(7 downto 0);
    output_chars_count  : out std_logic_vector(0 downto 0)
  );
end StringWriterInterface;

architecture Behavioral of StringWriterInterface is
  signal r : regs_record;
  signal d : regs_record;

begin
  -- For now only connect the l_returnflag and l_linestatus streams to their
  -- corresponding output.
  output_valid        <= input_valid;
  input_ready         <= output_ready;
  output_dvalid       <= input_dvalid;
  output_last         <= input_last;
  output_length       <= input_length;
  output_count        <= input_count;

  output_chars_valid  <= input_chars_valid;
  input_chars_ready   <= output_chars_ready;
  output_chars_dvalid <= input_chars_dvalid;
  output_chars_last   <= input_chars_last;
  output_chars        <= input_chars;
  output_chars_count  <= input_chars_count;
  output_valid        <= input_valid;

  input_ready         <= output_ready;
  output_dvalid       <= input_dvalid;
  output_last         <= input_last;
  output_length       <= input_length;
  output_count        <= input_count;

  output_chars_valid  <= input_chars_valid;
  input_chars_ready   <= output_chars_ready;
  output_chars_dvalid <= input_chars_dvalid;
  output_chars_last   <= input_chars_last;
  output_chars        <= input_chars;
  output_chars_count  <= input_chars_count;

end Behavioral;