library ieee;
use ieee.std_logic_1164.all;

entity XOR_GATE is
	port (	a	: in std_logic;
			b	: in std_logic;
			c	: out std_logic);
end entity XOR_GATE;

architecture STRUCTURAL of XOR_GATE is
		
		component AND_GATE is
			port (	a	: in std_logic; 
					b	: in std_logic;
					c	: out std_logic);
		end component AND_GATE;
		
		component OR_GATE is
			port (	a	: in std_logic; 
					b	: in std_logic;
					c	: out std_logic);
		end component OR_GATE;
		
		component NOT_GATE is
			port (	a	: in std_logic;
					b	: out std_logic);
		end component NOT_GATE;

	
		signal not_a, not_b : std_logic;
		signal nota_and_b	  : std_logic;
		signal a_and_notb   : std_logic;
		
		begin
		
				NOTA  : NOT_GATE
							port map (	a => a,
										b => not_a);
										 
				NOTB  : NOT_GATE
							port map (	a => b,
										b => not_b);
										 
				AND_1 : AND_GATE
							port map (	a => not_a,
										b => b,
										c => nota_and_b);
										 
				AND_2 : AND_GATE
							port map (	a => a,
										b => not_b,
										c => a_and_notb);
										 
				OR_1  : OR_GATE
							port map (	a => nota_and_b,
										b => a_and_notb,
										c => c);
	
	
	
	
	
	
	
	
end architecture;
