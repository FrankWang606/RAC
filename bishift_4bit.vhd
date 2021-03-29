--Author: 242 group 6, Frank WANG, Jay SUN， Daniel LIN
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

Entity bishift_4bit is port
	(
		CLK,Reset_n             : in std_logic;
		CLK_En,Left_Right       : in std_logic;
		regBits                 : out std_logic_vector(3 downto 0)
	);
	end entity;
	
ARCHITECTURE one OF  bishift_4bit IS

signal regbit : unsigned(3 downto 0);

Begin

process(CLK,Reset_n) is
begin
	if(Reset_n ='0') then
		regbit <= "0000";
	
	elsif(rising_edge(CLK)) then
		if((CLK_En='1') AND (Left_Right ='1')) then --increasing
			regbit <= '1' & regbit(3 downto 1);
	   elsif((CLK_En='1') AND (Left_Right ='0')) then --decreasing
			regbit <= regbit(2 downto 0) & '0';	
		end if;
   end if;
	 
end process;

regBits <= std_logic_vector(regbit);
end;