library ieee;
use ieee.std_logic_1164.all;
use work.EXTERNAL_FILE.all;

entity DECODER is
	port (	dec_en    :     in std_logic;
			dec_input :     in std_logic_vector (DEST_length-1 downto 0);
			dec_output:     out std_logic_vector (8 downto 0));
end entity DECODER; 

architecture STRUCTURAL of DECODER is
	begin
																				
		dec_output(8) <= '1' when dec_input = UPLEV		and dec_en = '1' else '0'; -- UP LEV	
		dec_output(7) <= '1' when dec_input = NORTH		and dec_en = '1' else '0'; -- N
		dec_output(6) <= '1' when dec_input = NOR_WEST	and dec_en = '1' else '0'; -- NW
		dec_output(5) <= '1' when dec_input = WEST		and dec_en = '1' else '0'; -- W			                                        
		dec_output(4) <= '1' when dec_input = SOU_WEST	and dec_en = '1' else '0'; -- SW		
		dec_output(3) <= '1' when dec_input = SOUTH		and dec_en = '1' else '0'; -- S
		dec_output(2) <= '1' when dec_input = SOU_EAST	and dec_en = '1' else '0'; -- SE
		dec_output(1) <= '1' when dec_input = EAST		and dec_en = '1' else '0'; -- E			  
		dec_output(0) <= '1' when dec_input = NOR_EAST	and dec_en = '1' else '0'; -- NE		

end architecture;
	
