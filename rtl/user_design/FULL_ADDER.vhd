library ieee;
use ieee.std_logic_1164.all;
use work.EXTERNAL_FILE.all;

entity FULL_ADDER is
	port (	a    	: in std_logic;
			b 	  	: in std_logic;
			cin  	: in std_logic;
			cout 	: out std_logic;
			s    	: out std_logic);
end entity FULL_ADDER;

architecture Structural of FULL_ADDER is

	signal a_xor_b      : std_logic;
	signal a_and_b      : std_logic;
	signal cin_and_xor  : std_logic;
	
	
	
	begin
										 
			XOR1  : entity work.XOR_GATE
							port map (	a => a,
										b => b,
										c => a_xor_b);
										 
			XOR2  : entity work.XOR_GATE
							port map (	a => a_xor_b,
										b => cin,
										c => s);			
										 
--------------------------------------------------------------------------
										 
			AND1  : entity work.AND_GATE
							port map (	a => a,
										b => b,
										c => a_and_b);
										 
			AND2  : entity work.AND_GATE
							port map (	a => a_xor_b,
										b => cin,
										c => cin_and_xor);			 
			
										 
			OR_1  : entity work.OR_GATE
							port map (	a => a_and_b,
										b => cin_and_xor,
										c => cout);										 
			
										 
end architecture;
	
