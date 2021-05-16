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
    clk                 : in std_logic;
    reset               : in std_logic;

    enable              : in std_logic;

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
  -- State Machine
  type state_type is (STATE_IDLE,
    STATE_PASS);
  type len_record is record
    ready  : std_logic;
    valid  : std_logic;
    data   : std_logic_vector(31 downto 0);
    last   : std_logic;
    dvalid : std_logic;
  end record;
  type cmd_in_record is record
    len  : unsigned(INDEX_WIDTH - 1 downto 0);
    min  : unsigned(LEN_WIDTH - 1 downto 0);
    mask : unsigned(LEN_WIDTH - 1 downto 0);
  end record;
  type regs_record is record
    state : state_type;
    cmd   : cmd_in_record;
  end record;
  type cmd_out_record is record
    ready : std_logic;
  end record;
  type out_record is record
    cmd : cmd_out_record;
    len : len_record;
  end record;

  type utf_record is record
    ready  : std_logic;
    valid  : std_logic;
    data   : std_logic_vector(7 downto 0);
    count  : unsigned(0 downto 0);
    last   : std_logic;
    dvalid : std_logic;
  end record;
  type prim64_record is record
    ready  : std_logic;
    valid  : std_logic;
    data   : std_logic_vector(63 downto 0);
    last   : std_logic;
    dvalid : std_logic;
  end record;
  type prim32_record is record
    ready  : std_logic;
    valid  : std_logic;
    data   : std_logic_vector(31 downto 0);
    last   : std_logic;
    dvalid : std_logic;
  end record;
  type sregs_record is record
    state : state_type;
    len   : unsigned(31 downto 0);
  end record;
  type buf_out_record is record
    ready : std_logic;
  end record;
  type prim64_out_record is record
    buf : buf_out_record;
    num : prim64_record;
  end record;
  type prim32_out_record is record
    buf : buf_out_record;
    num : prim32_record;
  end record;
  type chars_out_record is record
    buf : buf_out_record;
    utf : utf_record;
  end record;
  signal rs : sregs_record;
  signal ds : sregs_record;

  signal r  : regs_record;
  signal d  : regs_record;
begin

  --length stream
  --input_ready   <= output_ready;
  --output_valid  <= '1';
  --output_dvalid <= '1';
  --output_last   <= '1';
  --output_length <= std_logic_vector(to_unsigned(1, 32));
  --output_count  <= std_logic_vector(to_unsigned(1, 1));

  writer_process_len :
  process (r, enable, output_ready, input_length) is
    variable v : regs_record;
    variable o : out_record;
  begin
    v            := r;
    o.len.data   := std_logic_vector(to_unsigned(1, 32));
    o.len.valid  := '0';
    o.len.dvalid := '1';
    o.cmd.ready  := '0';

    case v.state is
      when STATE_IDLE =>
        o.len.valid := '0';
        o.len.ready := '0';
        if enable = '1' and o.len.last /= '1' then
          v.cmd.len := unsigned(input_length);
          v.state   := STATE_PASS;
        end if;
      when STATE_PASS =>
        o.len.valid  := '1';
        o.len.ready  := '1';
        o.len.dvalid := '1';
        o.len.last   := '0';

        if r.cmd.len - 1 = 0 then
          o.len.last := '1';
        end if;

        if output_ready = '1' and o.len.valid = '1' then
          v.cmd.len := r.cmd.len - 1;

          if v.cmd.len = 0 then
            v.state := STATE_IDLE;
          else
            v.state := STATE_PASS;
          end if;
        end if;
    end case;

    d             <= v;

    output_valid  <= o.len.valid;
    input_ready   <= o.len.ready;
    output_last   <= o.len.last;
    output_length <= o.len.data;
    output_dvalid <= o.len.dvalid;
    output_count  <= "1";

  end process;

  writer_process_char :
  process (rs,
    enable,
    input_chars,
    input_chars_valid, input_length,
    input_chars_count,
    output_chars_ready) is
    variable vs     : sregs_record;
    variable output : chars_out_record;
  begin
    vs                := rs;
    output.utf.valid  := '0';
    output.utf.dvalid := '1';
    output.utf.ready  := '0';

    case vs.state is
      when STATE_IDLE =>
        output.utf.last := '0';
        if enable = '1' then
          vs.len   := unsigned(input_length);
          vs.state := STATE_PASS;
        end if;
      when STATE_PASS =>

        output.buf.ready  := '0';
        output.utf.ready  := output_chars_ready;
        output.utf.data   := input_chars;
        output.utf.count  := unsigned(input_chars_count);
        output.utf.dvalid := '1';
        output.utf.valid  := input_chars_valid;

        -- Stream chars
        if output.utf.valid = '1' and output_chars_ready = '1' then
          vs.len := rs.len - output.utf.count;
          if vs.len = 0 then
            output.utf.last := '1';
            vs.state        := STATE_IDLE;
          else
            vs.state := STATE_PASS;
          end if;
        end if;

    end case;
    ds                  <= vs;
    input_chars_ready   <= output.utf.ready;
    output_chars_valid  <= output.utf.valid;
    output_chars_dvalid <= output.utf.dvalid;
    output_chars_last   <= output.utf.last;
    output_chars        <= output.utf.data;
    output_chars_count  <= std_logic_vector(output.utf.count);
  end process;

  reg_proc : process (clk)
  begin
    if rising_edge(clk) then
      -- Register new state
      rs <= ds;
      r  <= d;

      -- Reset
      if reset = '1' then
        rs.state <= STATE_IDLE;
        r.state  <= STATE_IDLE;
        rs.len   <= to_unsigned(1, 32);
      end if;
    end if;
  end process;
end Behavioral;
