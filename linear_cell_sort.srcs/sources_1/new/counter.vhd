library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
entity counter is
generic(
        LOG_N : integer
);
Port ( 
       clk, rst, clr, inc : in std_logic;
       output : out std_logic_vector((LOG_N - 1) downto 0)
  );
end counter;

architecture arch of counter is
signal cur, nxt : unsigned((LOG_N - 1) downto 0);

begin
-- clk process
PROCESS (clk, rst)
	BEGIN
		IF (rst = '1') THEN
			cur <= (OTHERS => '0');
		ELSIF rising_edge(clk) THEN
			cur <= nxt;
		END IF;
END PROCESS;

nxt <= (others => '0') when clr = '1' else
        cur + 1 when inc = '1' else
        cur; 
end arch;
