--Author: 242 group 6, Frank WANG, Jay SUN， Daniel LIN
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

Entity grappler_machine is port
	(
	  rst_n,CLK                    : IN std_logic;
	  grappler_en                  : IN std_logic;
	  grapstat                     : OUT std_logic
	  );
END ENTITY;

Architecture SM of grappler_machine is
 
  
 TYPE STATE_NAMES IS (Init,S0, S1);   -- S0: grappler is close S1: grappler is open

 
 SIGNAL current_state, next_state	:  STATE_NAMES;     	-- signals of type STATE_NAMES


 BEGIN
 
 -- REGISTER_LOGIC PROCESS:
 
Register_Section: PROCESS (rst_n,CLK)  -- this process synchronizes the activity to a clock
BEGIN
	IF (rst_n = '0') THEN
		current_state <= Init;
	ELSIF(falling_edge(CLK)) THEN
		current_state <= next_State;
	END IF;

END PROCESS;	
	
-- TRANSITION LOGIC PROCESS

Transition_Section: PROCESS (grappler_en,current_state) 

BEGIN
     CASE current_state IS
			WHEN Init =>	 --grappler is enabled 
			  if(grappler_en='1')  then
				next_state <= S1;
			  else
			   next_state <= S0;
				END IF;
				
          WHEN S0 =>	 --grappler is enabled 
			  if(grappler_en='1')  then
				next_state <= S1;
			  else
			   next_state <= S0;
				END IF;
			
			WHEN S1 =>	
			  if(grappler_en='1') then ----grappler is enabled
				next_state <= S0;
			  else
			   next_state <= S1;
				END IF;

 	END CASE;

 END PROCESS;
 -- DECODER SECTION PROCESS (Moore Form)

Decoder_Section: PROCESS (current_state) 

BEGIN
     CASE current_state IS
	      WHEN Init =>		
			grapstat  <= '0';
         WHEN S0 =>		
			grapstat  <= '0';

			
         WHEN S1 =>		
          grapstat <= '1';

  END CASE;
 END PROCESS;

 END ARCHITECTURE SM;
		
	







	