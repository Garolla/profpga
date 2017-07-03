library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MULTIPLIER is
	generic ( bit_num : integer);
	port (	A    : in std_logic_vector (bit_num/2-1 downto 0);
			B 	 : in std_logic_vector (bit_num/2-1 downto 0);			
			P    : out std_logic_vector (bit_num-1 downto 0));			
end entity MULTIPLIER;	

architecture BEHAVIOURAL of MULTIPLIER is
	
	begin

		P	<=	std_logic_vector(to_unsigned(to_integer(unsigned(A))*to_integer(unsigned(B)), bit_num));
	
end architecture;