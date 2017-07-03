library ieee;
use ieee.std_logic_1164.all;

--	This component can work as adder/subtracter.
--	The choice is made selecting the value of C0:
--			-If C0 = 0 then adder
--			-If C0 = 1 then subtracter

--			-If Cout = 0 then A > B
--			-If Cout = 1 then A < B

--			-If CoutS (signed) = 0 then A > B
--			-If CoutS (signed) = 1 then A < B

entity ADDER is
	generic ( fa_num : integer);
	port (	A    : in std_logic_vector (fa_num-1 downto 0);
			B 	 : in std_logic_vector (fa_num-1 downto 0);
			C0   : in std_logic;
			Cout : out std_logic;
			CoutS: out std_logic;
			S    : out std_logic_vector (fa_num-1 downto 0));			
end entity ADDER;

architecture STRUCTURAL of ADDER is
	
	signal D, C_int				: std_logic_vector (fa_num-1 downto 0);
	signal A_xor_B, cout_int	: std_logic;			
	
	
	begin
	
	XOR_0:  entity work.XOR_GATE 
			port  map (	a    => C0, 
						b 	 => B(0),
						c    => D(0));
  
	F_A_0: 	entity work.FULL_ADDER 
			port map (	a    => A(0),
						b 	 => D(0),
						cin  => C0,
						cout => C_int(0),
						s    => S(0));
						
	
	--------- BLOCCHI da 1 a N --------
	
	gen_proc: for i in 1 to fa_num-1 generate

	XOR_i:  entity work.XOR_GATE 
			port  map (	a    => C0, 
						b 	 => B(i),
						c    => D(i));
  
	F_A_i: 	entity work.FULL_ADDER 
			port map (	a    => A(i),
						b 	 => D(i),
						cin  => C_int(i-1),
						cout => C_int(i),
						s    => S(i));
						
	end generate;	
	
	XOR_N:  entity work.XOR_GATE 
			port  map (	a    => C0, 
						b 	 => C_int(fa_num-1),
						c    => cout_int);
						
	Cout	<=	cout_int;
						
	XOR_in:  entity work.XOR_GATE 
			port  map (	a    => A(fa_num-1), 
						b 	 => B(fa_num-1),
						c    => A_xor_B);
						
	XOR_coutS:  entity work.XOR_GATE 
			port  map (	a    => cout_int, 
						b 	 => A_xor_B,
						c    => CoutS);		
	  
end architecture;
