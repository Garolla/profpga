library ieee;
use ieee.std_logic_1164.all;

entity AND_GATE is
	port (	a	: in std_logic; 
			b	: in std_logic;
			c	: out std_logic);
end entity AND_GATE;

architecture BEHAVIOURAL of AND_GATE is
	begin

	c <= a AND b;
	
end architecture;
