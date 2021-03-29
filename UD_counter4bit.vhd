--Author: 242 group 6, Frank WANG, Jay SUN， Daniel LIN
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

Entity UD_counter4bit is port
	(
		CLK,Reset_n             : in std_logic;
		CLK_En,Up_Down          : in std_logic;
		counterBits             : out std_logic_vector(3 downto 0)
	);
	end entity;
	
ARCHITECTURE one OF UD_counter4bit IS

signal counterbit : unsigned(3 downto 0);

Begin

process(CLK,Reset_n) is
begin
	if(Reset_n ='0') then
		counterbit <= "0000";
	
	elsif(rising_edge(CLK)) then
		if((CLK_En='1') AND (Up_Down='1')) then --increasing
			counterbit <= (counterbit + 1);
	   elsif((CLK_En='1') AND (Up_Down='0')) then --decreasing
			counterbit <= (counterbit - 1);	
		end if;
   end if;
	 
end process;

counterBits <= std_logic_vector(counterbit);
end;