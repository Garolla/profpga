library ieee;
use ieee.std_logic_1164.all;

entity OR_GATE_4IN is
    port (	in_a    : in std_logic ;
			in_b    : in std_logic ;
			in_c    : in std_logic ;
			in_d    : in std_logic ;
			output	: out std_logic); 
end entity OR_GATE_4IN;

architecture STRUCTURAL of OR_GATE_4IN is
	
	signal out_or1: std_logic;
	signal out_or2: std_logic;
	
	begin
	
		or1_comp: entity work.OR_GATE
					 port map (	a	=> in_a,
								b	=> in_b,
								c 	=> out_or1);
								  
		or2_comp: entity work.OR_GATE
					 port map (	a	=> out_or1,
								b	=> in_c,
								c 	=> out_or2);
								 
		or3_comp: entity work.OR_GATE
					 port map (	a	=> out_or2,
								b	=> in_d,
								c 	=> output);
							
end architecture;
