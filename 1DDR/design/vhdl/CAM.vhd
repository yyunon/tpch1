library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.Stream_pkg.all;
use work.UtilRam_pkg.all;
use work.Tpch_pkg.all;

entity CAM is
  generic (

    -- Width of the stream data vector.
    DATA_WIDTH    : natural;
    ADDRESS_WIDTH : natural := 8
  );
  port (

    -- Rising-edge sensitive clock.
    clk      : in std_logic;

    -- Active-high synchronous reset.
    reset    : in std_logic;

    --OP1 Input stream.
    in_addr  : in std_logic_vector(ADDRESS_WIDTH - 1 downto 0);

    -- Output stream.
    hit_miss : out std_logic
  );
end CAM;

architecture Behavioral of CAM is
  type state_t is (STATE_IDLE, STATE_WRITE, STATE_INCREMENT, STATE_DONE);
  signal state, state_next : state_t;
  signal write_enable      : std_logic;
  signal write_address     : std_logic_vector(ADDRESS_WIDTH - 1 downto 0);
  signal write_data        : std_logic_vector(DATA_WIDTH downto 0);

  signal read_enable       : std_logic;
  signal read_address      : std_logic_vector(ADDRESS_WIDTH - 1 downto 0);
  signal read_data         : std_logic_vector(DATA_WIDTH downto 0);
  constant ZERO            : std_logic_vector(DATA_WIDTH - 1 downto 0) := (others => '0');
begin
  read_enable   <= '1';
  read_address  <= in_addr;
  write_address <= in_addr;

  cam_ram : UtilRam1R1W
  generic map(
    WIDTH      => DATA_WIDTH + 1,
    DEPTH_LOG2 => ADDRESS_WIDTH
  )
  port map(
    w_clk  => clk,
    w_ena  => write_enable,
    w_addr => write_address,
    w_data => write_data,
    r_clk  => clk,
    r_ena  => read_enable,
    r_addr => read_address,
    r_data => read_data
  );

  -- Process to hash the input, direct addressing
  cam_proc :
  process (state, read_data, in_addr) is
    variable counter : signed(DATA_WIDTH - 1 downto 0);
  begin
    state_next   <= state;
    hit_miss     <= '0';
    write_enable <= '0';
    case state is
      when STATE_IDLE =>
        if (read_data(DATA_WIDTH) = '1') then
          hit_miss   <= '1';
          state_next <= STATE_INCREMENT;
        else
          write_data <= '1' & ZERO(DATA_WIDTH - 1 downto 1) & '1';
          state_next <= STATE_WRITE;
        end if;
      when STATE_WRITE =>
        write_enable <= '1';
        state_next   <= STATE_DONE;
      when STATE_INCREMENT =>
        hit_miss <= '1';
        counter := 1 + signed(read_data(DATA_WIDTH - 1 downto 0));
        write_data <= '1' & std_logic_vector(counter);
        state_next <= STATE_WRITE;
      when STATE_DONE =>
        state_next <= STATE_IDLE;
    end case;
  end process;
  -- Seq process
  seq_proc :
  process (clk) is
  begin
    if rising_edge(clk) then
      state <= state_next;
      if reset = '0' then
        state <= STATE_IDLE;
      end if;
    end if;
  end process;
end Behavioral;