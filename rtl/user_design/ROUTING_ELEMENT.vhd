library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.EXTERNAL_FILE.all;
	
entity ROUTING_UNIT is
		port( 	
				ctrl				: in std_logic_vector(3 downto 0); -- The number of pillars in a 9x9 is 9 so we need a 4 bits vectors
				
				request_to_OUT		: out std_logic_vector(request_length-1 downto 0);
				request_from_OUT	: in std_logic_vector(request_length-1 downto 0);
				
				request_to_DOWN		: out grid_req_PILLARS;
				request_from_DOWN	: in grid_req_PILLARS
				);					
end entity ROUTING_UNIT;

architecture BEHAVIORAL of ROUTING_UNIT is
begin
	
	--Assign request_from_OUT to the pillar pointed by ctrl. All the other pillars have request = "000000..."
	request_to_DOWN(0) <= request_from_OUT when (ctrl = "0000" OR ctrl = "1001") else (others => '0');  --ctrl = "1001" means write all
	request_to_DOWN(1) <= request_from_OUT when (ctrl = "0001" OR ctrl = "1001") else (others => '0');
	request_to_DOWN(2) <= request_from_OUT when (ctrl = "0010" OR ctrl = "1001") else (others => '0');
	request_to_DOWN(3) <= request_from_OUT when (ctrl = "0011" OR ctrl = "1001") else (others => '0');	
	request_to_DOWN(4) <= request_from_OUT when (ctrl = "0100" OR ctrl = "1001") else (others => '0'); 
	request_to_DOWN(5) <= request_from_OUT when (ctrl = "0101" OR ctrl = "1001") else (others => '0');
	request_to_DOWN(6) <= request_from_OUT when (ctrl = "0110" OR ctrl = "1001") else (others => '0');
	request_to_DOWN(7) <= request_from_OUT when (ctrl = "0111" OR ctrl = "1001") else (others => '0');	
	request_to_DOWN(8) <= request_from_OUT when (ctrl = "1000" OR ctrl = "1001") else (others => '0');		

	--The signals coming from the pillar pointed by ctrl are assigned to connection with the outside
	request_to_OUT	<= request_from_DOWN (to_integer(unsigned(ctrl))) when (to_integer(unsigned(ctrl))) <= 8 else (others => '0');

end architecture;	