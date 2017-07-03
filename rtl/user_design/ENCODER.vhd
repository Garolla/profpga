library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.EXTERNAL_FILE.all;


entity ENCODER is
	port (	enc_input : in std_logic_vector (8 downto 0);
			out_strobe: out std_logic_vector (0 downto 0);
			enc_output:	out std_logic_vector (DEST_length-1  downto 0));
end entity ENCODER; 

architecture BEHAVIOURAL of ENCODER is

	begin
																				
	enc_output <= 	UPLEV		when enc_input(8) = '1' else	-- UP LEV	
					NORTH	 	when enc_input(7) = '1' else  	-- N
					NOR_WEST 	when enc_input(6) = '1' else    -- NW
					WEST     	when enc_input(5) = '1' else    -- W			                                        
					SOU_WEST 	when enc_input(4) = '1' else    -- SW		
					SOUTH    	when enc_input(3) = '1' else    -- S
					SOU_EAST 	when enc_input(2) = '1' else    -- SE
					EAST     	when enc_input(1) = '1' else    -- E			  
					NOR_EAST 	when enc_input(0) = '1' else    -- NE		
					NODEST 		;
					
	out_strobe <=	"0" when to_integer(unsigned(enc_input)) = 0 else
					"1";
					  
										 
end architecture;
	
