--Author: 242 group 6, Frank WANG, Jay SUN， Daniel LIN
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

Entity RAC is port
	(
		Reset_n                       : in std_logic;
		ext_out,motion                : in std_logic;
		X_input,Y_input               : in std_logic_vector(3 downto 0);
		Xeq,Xgt,Xlt,Yeq,Ygt,Ylt       : in std_logic;
		X_target,Y_target             : out std_logic_vector(3 downto 0);
		clken_x,UD_x,clken_y,UD_y     : out std_logic;
		error,ext_en                  : out std_logic
	);
	end entity;
	
ARCHITECTURE rac_arch OF RAC IS

signal Xtarget,Ytarget   : std_logic_vector(3 downto 0) :="0000";
signal clk_en_x,clk_en_y,up_downx,up_downy,error_sign,extender_en : std_logic :='0';

begin
process1: process(Reset_n,motion,Xeq,Yeq,ext_out) is
begin
	if(Reset_n='0') then  --push reset to reset all registers
		Xtarget <="0000";
		Ytarget <="0000";

	elsif(falling_edge(motion)) then --if current x and y are equal to target
		if((Xeq='1')AND(Yeq='1')AND(ext_out='0')) then                                                                          --means the arm can move to next point
			Xtarget <= X_input; --new target assigned
			Ytarget <= Y_input;
		end if;
	end if;
end process;

process2: process(Reset_n,ext_out,Xgt,Xlt) is --to deal with X movement
begin
	if(Reset_n='1') then 
		if(ext_out='1') then --cannot move when extend
			clk_en_x <= '0';
		elsif(Xgt='1') then  --x drop because current x is greater than goal
			clk_en_x <= '1'; up_downx <='0';
		elsif(Xlt='1') then --x increase because current x is less than goal
			clk_en_x <= '1'; up_downx <='1';
		else
			clk_en_x <= '0';
	   end if;
	elsif(Reset_n='0') then 
	    clk_en_x <= '0'; up_downx <='0';
	end if;
end process;

process3: process(Reset_n,ext_out,Ygt,Ylt) is --to deal with Y movement
begin
	if(Reset_n='1') then  --logic same as process 2
		if(ext_out='1') then
			clk_en_y <= '0';
		elsif(Ygt='1') then
			clk_en_y <= '1'; up_downy <='0';
		elsif(Ylt='1') then
			clk_en_y <= '1'; up_downy <='1';
		else
			clk_en_y <= '0';
      end if;
	elsif(Reset_n='0') then 
	    clk_en_y <= '0'; up_downy <='0';
	end if;
end process;

process4: process(motion,ext_out) is --handle error signal
begin
	if(ext_out='0') then --clean the error sign
		error_sign <='0';
	elsif((falling_edge(motion)) AND(ext_out='1')) then --try to push button when extend
		error_sign <='1';
	end if;
end process;

process5: process(Xeq,Yeq) is --deal with extender enable
begin
		if((Xeq='1')AND(Yeq='1')) then --the extender will be enable only when rac is not moving
			extender_en <='1';
		else
		   extender_en <='0';
		end if;

end process;

X_target <= Xtarget;	Y_target <= Ytarget;	
clken_x <= clk_en_x; clken_y <= clk_en_y;
UD_x <= up_downx; UD_y <= up_downy;
error <= error_sign; ext_en <= extender_en;
end;
		
