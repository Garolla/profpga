library ieee;
use ieee.std_logic_1164.all;

entity AND_GATE_3IN is
	port (	in_a	: in std_logic;
			in_b	: in std_logic;
			in_c	: in std_logic;
			output	: out std_logic);
end entity AND_GATE_3IN;

architecture STRUCTURAL of AND_GATE_3IN is
	
	signal out_and1: std_logic;

	begin
		
		and1_comp: entity work.AND_GATE
					  port map (	a 	=> in_a,
									b 	=> in_b,
									c 	=> out_and1);
									
		and2_comp: entity work.AND_GATE
					  port map (	a 	=> out_and1,
									b 	=> in_c,
									c 	=> output);
	
end architecture;
