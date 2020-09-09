
library ieee;
use ieee.std_logic_1164.all;
entity control is
	port (
		clk, rst, enable, clr, comp : in std_logic;
		in_cnt_inc, mux_cnt_inc, in_cnt_clr, mux_cnt_clr, cells_clr : out std_logic
	);
end control;
architecture arch of control is
type t_state is (idle, reading, outputting);
signal cur, nxt: t_state;
begin
-- state register
process (clk, rst)
begin
	if (rst = '1') then
		cur <= idle; -- initial state
	elsif rising_edge(clk) then
		cur <= nxt;
	end if;
end process;
-- next-state logic
process (cur, comp, enable)
begin
	nxt <= cur; -- stay in current state by default
	in_cnt_clr <= '0';
    mux_cnt_clr <= '0';
    cells_clr <= '0';
    in_cnt_inc <= '0';
    mux_cnt_inc <= '0';
	case cur is
		when idle =>
		    in_cnt_clr <= '1';
		    mux_cnt_clr <= '1';
		    cells_clr <= '1';
			if enable = '1' then 
			    nxt <= reading;
			end if;
        when reading =>
            if enable = '0' then 
                nxt <= outputting;
            else 
                in_cnt_inc <= '1';
			end if;
        when outputting =>
            if comp = '1' then 
                nxt <= idle;
            else 
                mux_cnt_inc <= '1';
			end if;
	end case;
end process;
end arch;