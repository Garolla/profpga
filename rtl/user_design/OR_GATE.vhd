library IEEE;
use ieee.std_logic_1164.all;

entity OR_GATE is
    port (	a    	: in std_logic ;
			b    	: in std_logic ;
			c   	: out std_logic); 
end entity OR_GATE;

architecture BEHAVIOURAL of OR_GATE is
	begin
	     c <= a or b;
end architecture;
		
