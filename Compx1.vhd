--Author: 242 group 6, Frank WANG, Jay SUN， Daniel LIN
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;


entity Compx1 is
 	port (
			A, B                    	        : in std_logic;
		   AgtB,AeqB,AltB                     : out std_logic
			);
end compx1;

architecture Circuit of Compx1 is

begin

AgtB  <= A AND (NOT B) ;
AeqB   <= A XNOR B;
AltB <= (NOT A) AND B;

end;