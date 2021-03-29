--Author: 242 group 6, Frank WANG, Jay SUN， Daniel LIN
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY LogicalStep_Lab4_top IS
   PORT
	(
   Clk			: in	std_logic;
	rst_n			: in	std_logic;
	pb				: in	std_logic_vector(3 downto 0);
 	sw   			: in  std_logic_vector(7 downto 0); 
   leds			: out std_logic_vector(15 downto 0)	
	);
END LogicalStep_Lab4_top;

ARCHITECTURE Circuit OF LogicalStep_Lab4_top IS

--components used
component RAC port ( --RAC part
		Reset_n                       : in std_logic;
		ext_out,motion                : in std_logic;
		X_input,Y_input               : in std_logic_vector(3 downto 0);
		Xeq,Xgt,Xlt,Yeq,Ygt,Ylt       : in std_logic;
		X_target,Y_target             : out std_logic_vector(3 downto 0);
		clken_x,UD_x,clken_y,UD_y     : out std_logic;
		error,ext_en                  : out std_logic
	);
	end component;
	
component extender port(  --extender part
		Reset_n                       : in std_logic;
		ext_toggle,ext_enable         : in std_logic;
		ext_bits                      : in std_logic_vector(3 downto 0);
		grappler_en                   : out std_logic;
		ext_out                       : out std_logic;
		left_or_right,clk_en          : out std_logic
	);
	end component;
	
component grappler_machine  port --grappler (use moore machine)
	(
	  rst_n,CLK                    : IN std_logic;
	  grappler_en                  : IN std_logic;
	  grapstat                     : OUT std_logic
	  );
END component;

component UD_counter4bit port
	(
		CLK,Reset_n             : in std_logic;
		CLK_En,Up_Down          : in std_logic;
		counterBits             : out std_logic_vector(3 downto 0)
	);
	end component;
component Compx4  port (
			hex_A, hex_B 	           : in std_logic_vector(3 downto 0);
		   hex_AgtB,hex_AeqB,hex_AltB	  : out std_logic
			);
end component;

component bishift_4bit  port
	(
		CLK,Reset_n             : in std_logic;
		CLK_En,Left_Right       : in std_logic;
		regBits                 : out std_logic_vector(3 downto 0)
	);
	end component;
--put signals here
signal xeq,xgt,xlt,yeq,ygt,ylt,clken_x,ud_x,clken_y,ud_y : std_logic;--signal used
signal grappler_en,extender_out,extender_en,clken_shift,left_or_right   : std_logic;
signal Xtarget,Ytarget    : std_logic_vector(3 downto 0);--output of RAC
signal Xcounter,Ycounter,extender_bits  : std_logic_vector(3 downto 0); --output of counter and bishift
	
BEGIN
rac1: RAC port map(rst_n,extender_out,pb(2),sw(7 downto 4),sw(3 downto 0), --RAC block
xeq,xgt,xlt,yeq,ygt,ylt,Xtarget,Ytarget,clken_x,ud_x,clken_y,ud_y,leds(0),extender_en);
ud_forx: UD_counter4bit port map(Clk,rst_n,clken_x,ud_x,Xcounter);--counter used for x
ud_fory: UD_counter4bit port map(Clk,rst_n,clken_y,ud_y,Ycounter);--counter used for y
comparex: Compx4  port map(Xcounter,Xtarget,xgt,xeq,xlt); --compared current x and target x
comparey: Compx4  port map(Ycounter,Ytarget,ygt,yeq,ylt); --compared current y and target y
extend1: extender port map(rst_n,pb(1),extender_en,extender_bits,grappler_en, --extender block
extender_out,left_or_right,clken_shift);
shift1: bishift_4bit  port map(Clk,rst_n,clken_shift,left_or_right,extender_bits); --bishift used for extender
grappler1: grappler_machine  port map(rst_n,pb(0),grappler_en,leds(3)); --grappler block(state machine)

leds(15 downto 12) <= Xcounter; --assign output
leds(11 downto 8) <= Ycounter;
leds(7 downto 4) <= extender_bits ;

END Circuit;
