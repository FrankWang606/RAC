--Author: 242 group 6, Frank WANG, Jay SUN， Daniel LIN
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;

entity Compx4 is
 	port (
			hex_A, hex_B 	           : in std_logic_vector(3 downto 0);
		   hex_AgtB,hex_AeqB,hex_AltB	  : out std_logic
			);
end Compx4;

architecture Circuit of Compx4 is

component Compx1
port (
			A, B                    	        : in std_logic;
		   AgtB,AeqB,AltB                     : out std_logic
			);
end component;

signal A3gtB3,A3eqB3,A3ltB3 : std_logic;
signal A2gtB2,A2eqB2,A2ltB2 : std_logic;
signal A1gtB1,A1eqB1,A1ltB1 : std_logic;
signal A0gtB0,A0eqB0,A0ltB0 : std_logic;

begin

compare3: Compx1 port map( hex_A(3),hex_B(3),A3gtB3,A3eqB3,A3ltB3);
compare2: Compx1 port map( hex_A(2),hex_B(2),A2gtB2,A2eqB2,A2ltB2);
compare1: Compx1 port map( hex_A(1),hex_B(1),A1gtB1,A1eqB1,A1ltB1);
compare0: Compx1 port map( hex_A(0),hex_B(0),A0gtB0,A0eqB0,A0ltB0);

hex_AgtB <= A3gtB3 OR (A3eqB3 AND A2gtB2) OR (A3eqB3 AND A2eqB2 AND A1gtB1) OR (A3eqB3 AND A2eqB2 AND A1eqB1 AND A0gtB0);
hex_AeqB <= A3eqB3 AND A2eqB2 AND A1eqB1 AND A0eqB0;
hex_AltB <= A3ltB3 OR (A3eqB3 AND A2ltB2) OR (A3eqB3 AND A2eqB2 AND A1ltB1) OR (A3eqB3 AND A2eqB2 AND A1eqB1 AND A0ltB0);
end;