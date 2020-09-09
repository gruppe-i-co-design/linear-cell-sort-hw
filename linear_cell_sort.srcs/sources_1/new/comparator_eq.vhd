
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity comparator_eq is
generic(
        DATA_LEN : integer
        );
       
port (  A, B: in std_logic_vector((DATA_LEN - 1) downto 0);
        comp: out std_logic
     );
end comparator_eq;

architecture arch of comparator_eq is

begin
comp <= '1' when A = B else
    '0';

end arch;