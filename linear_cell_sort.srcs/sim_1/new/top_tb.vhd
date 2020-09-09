library ieee;
use ieee.std_logic_1164.all;
library work;

entity top_tb is
end top_tb;

architecture tb of top_tb is
signal clk, rst, enable, clr : std_logic;
signal data_in : std_logic_vector(3 downto 0);
    constant clk_period : time := 10 ns;
begin
	uut : entity work.top
	generic map(DATA_LEN => 4, LOG_N => 3)
    port map (clk => clk, 
              rst => rst, 
              clr => clr, 
              enable => enable, 
              data_in => data_in);
              
clk_process: process 
   begin
      clk <= '0';
      wait for clk_period/2;
      clk <= '1';
      wait for clk_period/2;
   end process;
   
-- Stimuli process 
   stim_proc: process
      begin
         rst <= '1';      
         wait for clk_period*2;
         rst <= '0';      
         wait for clk_period;
         enable <= '1';
         data_in <= x"5";
         wait for clk_period;
         data_in <= x"7";
         wait for clk_period;
         data_in <= x"3";
         wait for clk_period;
         data_in <= x"8";
         wait for clk_period;
         data_in <= x"5";
         wait for clk_period;
         data_in <= x"1";
         wait for clk_period;
         enable <= '0';
         wait for clk_period*20;
      end process ;
end tb;