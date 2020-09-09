library IEEE;
library work;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.cell_type.all;

entity top is
generic( 
        DATA_LEN : integer := 8;
        LOG_N : integer := 3
);
Port ( 
       data_in : in std_logic_vector((DATA_LEN - 1) downto 0);
       data_out : out std_logic_vector((DATA_LEN - 1) downto 0);
       enable, clk, rst, clr : in std_logic
);
end top;

architecture arch of top is
type t_data_signals is array(0 to (2 ** LOG_N) - 1) of std_logic_vector((DATA_LEN - 1) downto 0);
signal data_signals : t_data_signals;
type t_pushing_signals is array(0 to (2 ** LOG_N) - 2) of std_logic;
signal pushing_signals : t_pushing_signals;
type t_state_signals is array(0 to (2 ** LOG_N) - 2) of t_state;
signal state_signals : t_state_signals;
signal mux_inputs : work.multiplexer_type.input_array(0 to ((2 ** LOG_N) - 1), (DATA_LEN - 1) downto 0);
signal data_mux : std_logic_vector((LOG_N - 1) downto 0);
signal in_cnt_inc, mux_cnt_inc, comp, in_cnt_clr, mux_cnt_clr, cells_clr : std_logic;
signal in_cnt_data, mux_cnt_data : std_logic_vector((LOG_N - 1) downto 0);
begin

first_cell : entity work.top_cell
generic map(DATA_LEN => DATA_LEN)
port map(clk => clk, 
         rst => rst, 
         clr => cells_clr, 
         enable => enable, 
         prev_cell_data => (others => '0'), 
         new_data => data_in, 
         prev_cell_pushing => '0', 
         prev_cell_state => full, 
         state => state_signals(0), 
         pushing => pushing_signals(0), 
         data => data_signals(0));
        
cells : for i in 0 to (2 ** LOG_N) - 3 generate
cell : entity work.top_cell
generic map(DATA_LEN => DATA_LEN)
port map(clk => clk, 
         rst => rst, 
         clr => cells_clr, 
         enable => enable, 
         prev_cell_data => data_signals(i), 
         new_data => data_in, 
         prev_cell_pushing => pushing_signals(i), 
         prev_cell_state => state_signals(i), 
         state => state_signals(i + 1), 
         pushing => pushing_signals(i + 1), 
         data => data_signals(i + 1));
end generate;

last_cell : entity work.top_cell
generic map(DATA_LEN => DATA_LEN)
port map(clk => clk, 
         rst => rst, 
         clr => cells_clr, 
         enable => enable, 
         prev_cell_data => data_signals((2 ** LOG_N) - 2), 
         new_data => data_in, 
         prev_cell_pushing => pushing_signals((2 ** LOG_N) - 2), 
         prev_cell_state => state_signals((2 ** LOG_N) - 2), 
         state => open, 
         pushing => open, 
         data => data_signals((2 ** LOG_N) - 1));         

x : for i in (DATA_LEN - 1) downto 0 generate    
    y : for j in 0 to (2 ** LOG_N) - 1 generate
        mux_inputs(j, i) <= data_signals(j)(i);
    end generate;
end generate;

mux : entity work.multiplexer
generic map(DATA_LEN => DATA_LEN, MUX_BITS => LOG_N)
port map(inputs => mux_inputs, sel => mux_cnt_data, output => data_out);

in_cnt : entity work.counter
generic map(LOG_N => LOG_N)
port map(clk => clk, 
         rst => rst,
         clr => in_cnt_clr,
         inc => in_cnt_inc,
         output => in_cnt_data
         );
         
mux_cnt : entity work.counter
generic map(LOG_N => LOG_N)
port map(clk => clk, 
         rst => rst,
         clr => mux_cnt_clr,
         inc => mux_cnt_inc,
         output => mux_cnt_data
         );      
         
comp_eq : entity work.comparator_eq
generic map(INPUT_SIZE => LOG_N)
port map(A => in_cnt_data, B => mux_cnt_data, comp => comp); 

control : entity work.control
port map(comp => comp,
         clk => clk, 
         rst => rst,
         clr => clr,
         enable => enable,
         in_cnt_inc => in_cnt_inc, 
         mux_cnt_inc => mux_cnt_inc, 
         in_cnt_clr => in_cnt_clr, 
         mux_cnt_clr => mux_cnt_clr, 
         cells_clr => cells_clr);
end arch;
