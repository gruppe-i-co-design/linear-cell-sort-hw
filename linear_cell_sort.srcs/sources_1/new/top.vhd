library IEEE;
library work;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.cell_type.all;

entity top is
generic( 
        DATA_LEN : integer;
        LOG_N : integer
);
Port ( 
       data_in : in std_logic_vector((DATA_LEN - 1) downto 0);
       data_out : out std_logic_vector((DATA_LEN - 1) downto 0);
       enable, clk, rst : in std_logic
);
end top;

architecture arch of top is

begin

first_cell : entity work.top_cell
generic map(DATA_LEN => DATA_LEN)
port map(clk => clk, rst => rst, prev_cell_data => (others => '0'), new_data => data_in, 
         prev_cell_pushing => '0', prev_cell_state => full);

end arch;
