--Author: 242 group 6, Frank WANG, Jay SUN， Daniel LIN
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

Entity extender is port
	(
		Reset_n                       : in std_logic;
		ext_toggle,ext_enable         : in std_logic;
		ext_bits                      : in std_logic_vector(3 downto 0);
		grappler_en                   : out std_logic;
		ext_out                       : out std_logic;
		left_or_right,clk_en          : out std_logic
	);
	end entity;
	
ARCHITECTURE ext OF extender IS

signal LoR,clk_enable,extender_out,grap_en : std_logic :='0';

Begin
process1: process(Reset_n,ext_toggle,ext_enable,ext_bits) is
begin
	if(Reset_n ='0') then --reset all rigisters
		clk_enable <='0';
		LoR <='0';
	else 
		if((falling_edge(ext_toggle)) AND (ext_enable='1') AND (ext_bits="0000")) then --push to extend
		  clk_enable <='1';
		  LoR <='1';
		elsif((falling_edge(ext_toggle)) AND (ext_enable='1') AND (ext_bits="1111")) then --push to retract
		  clk_enable <='1';
		  LoR <='0';
		  end if;
   end if;
	 
end process;

process2: process(Reset_n,ext_bits) is --use to handle two output, extend_out and grappler_enable
begin
	if(Reset_n='1') then
		if(ext_bits="0000") then
		  extender_out<='0';
		  grap_en <='0';
		elsif(ext_bits="1111") then
		  grap_en <='1';
		  extender_out<='1';
		else
		  extender_out<='1';
		  grap_en <='0';
		end if;
	elsif(Reset_n='0') then
		grap_en <='0';
		  extender_out<='0';
	end if;
end process;

ext_out <= extender_out;
grappler_en <= grap_en;
left_or_right <= LoR;
clk_en <= clk_enable;

end;
