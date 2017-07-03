library ieee;
use ieee.std_logic_1164.all;

entity NOT_GATE is
	port (	a	: in std_logic;
			b	: out std_logic);
end entity NOT_GATE;

architecture BEHAVIOURAL of NOT_GATE is
	begin

	b <= NOT a;
	
end architecture;
