library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity reg is 
generic(
        DATA_LEN : integer
        );
port(
     clk, rst: in std_logic;
     load: in std_logic;
     data_in: in std_logic_vector((DATA_LEN - 1) downto 0);
     data_out: out std_logic_vector((DATA_LEN - 1) downto 0)
     );
end;

architecture arch of reg is
    
begin
-- clk process
	PROCESS (clk, rst)
	BEGIN
		IF (rst = '1') THEN
			data_out <= (OTHERS => '0');
		ELSIF rising_edge(clk) AND load = '1' THEN
			data_out <= data_in;
		END IF;
	END PROCESS;
	
	
end;