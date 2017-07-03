library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;

entity EQUIVALENCE_OPERATOR is
	generic ( num_length : integer);
	port (	A    	: in std_logic_vector (num_length-1 downto 0);
			B 	 	: in std_logic_vector (num_length-1 downto 0);			
			a_eq_b 	: out std_logic;
			a_neq_b	: out std_logic);			
end entity EQUIVALENCE_OPERATOR;

--			-If a_eq_b  = 1 then A == B
--			-If a_neq_b = 1 then A =! B

architecture STRUCTURAL of EQUIVALENCE_OPERATOR is

	signal xor_int		: std_logic_vector (num_length-1 downto 0);
	signal temp			: std_logic;

	begin
	
	gen_proc: for i in 0 to num_length-1 generate

	XOR_i:  entity work.XOR_GATE 
			port  map (	a    => A(i), 
						b 	 => B(i),
						c    => xor_int(i));	
						
	end generate;	
	
	
	temp		<=	or_reduce(xor_int);
	a_neq_b		<=	temp;
	
	
	gate_not : entity work.NOT_GATE
			port map(	a	=> temp,
						b	=> a_eq_b);
						
end architecture;