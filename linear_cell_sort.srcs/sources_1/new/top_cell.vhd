library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package cell_type is
type t_state is (empty, full);
end package;

library IEEE;
library work;
use IEEE.STD_LOGIC_1164.ALL;
use work.cell_type.all;

entity top_cell is
generic(
        DATA_LEN : integer
        );
  Port ( 
        prev_cell_data, new_data : in std_logic_vector((DATA_LEN - 1) downto 0);
        prev_cell_state : in t_state;
        prev_cell_pushing : in std_logic;
        clk, rst, clr, enable : in std_logic;
        state : out t_state;
        pushing : out std_logic;
        data : out std_logic_vector((DATA_LEN - 1) downto 0)
        );
end top_cell;

architecture arch of top_cell is
signal cur, nxt : t_state;
signal comp, load, data_mux : std_logic;
signal reg_out, mux_out: std_logic_vector((DATA_LEN - 1) downto 0);


signal mux_inputs : work.multiplexer_type.input_array(0 to 1, (DATA_LEN - 1) downto 0);

begin
process(clk, rst)
begin 
    if rst = '1' then
        cur <= empty;
    elsif rising_edge(clk) and clr = '1' then
        cur <= empty;
    elsif rising_edge(clk) then
        cur <= nxt;
    end if;
end process; 

process(cur, enable, clr, prev_cell_state, prev_cell_pushing, comp)
begin

nxt <= cur;
load <= '0';
data_mux <= '0';
pushing <= '0';
 
    case cur is
        when empty =>
            if prev_cell_pushing = '1' then
                data_mux <= '0';
                load <= '1';
                nxt <= full;
            elsif prev_cell_state = full then
                data_mux <= '1';
                load <= '1';
                nxt <= full;
            end if;
        when full =>
            if prev_cell_pushing = '1' then
                data_mux <= '0';
                load <= '1';
                pushing <= '1';
            elsif comp = '1' then
                data_mux <= '1';
                load <= '1';
                pushing <= '1';
            end if;        
    end case;
end process;

state <= cur;
data <= reg_out;

comparator : entity work.comparator
generic map(DATA_LEN => DATA_LEN)
port map(A => new_data, B => reg_out, comp => comp);

x : for i in (DATA_LEN - 1) downto 0 generate 
    mux_inputs(0, i) <= prev_cell_data(i);
    mux_inputs(1, i) <= new_data(i);
end generate;

mux : entity work.multiplexer
generic map(DATA_LEN => DATA_LEN, MUX_BITS => 1)
port map(inputs => mux_inputs, sel(0) => data_mux, output => mux_out);

registery : entity work.reg 
generic map(DATA_LEN => DATA_LEN)
port map(clk => clk, rst => rst, load => load, data_in => mux_out, data_out => reg_out);


end arch;
