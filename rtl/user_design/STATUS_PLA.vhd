library ieee;
use ieee.std_logic_1164.all;

entity STATUS_PLA is
	port (	jump		: in std_logic;
			status		: in std_logic;			
			mux_ctrl	: out std_logic);
end entity STATUS_PLA;

architecture BEHAVIOURAL of STATUS_PLA is
begin
	mux_ctrl <= '1' when (jump = '1' AND status = '1') else '0';
end architecture;
	