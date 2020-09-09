library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


package multiplexer_type is 
type input_array is array(natural range <>, natural range <>) of std_logic;
end package;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.multiplexer_type.all;
use ieee.numeric_std.all;

entity multiplexer is
generic(
        DATA_LEN : integer;
        MUX_BITS : integer
); 

port (
        inputs : in input_array(0 to (2 ** MUX_BITS) - 1 , (DATA_LEN - 1) downto 0);
        sel : in std_logic_vector((MUX_BITS - 1) downto 0);
        output: out std_logic_vector((DATA_LEN - 1) downto 0)
    );
end;

architecture arch of multiplexer is
begin
    gen : for i in (DATA_LEN - 1) downto 0 generate
        output(i) <= inputs(to_integer(unsigned(sel)), i);
    end generate;

end;