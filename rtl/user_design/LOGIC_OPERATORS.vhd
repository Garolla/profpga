library ieee;
use ieee.std_logic_1164.all;
use work.EXTERNAL_FILE.all;

entity LOGIC_OPERATORS is
	port(	IN_A	: in std_logic_vector(DATA_length-1 downto 0);
			IN_B    : in std_logic_vector(DATA_length-1 downto 0);
			LO_CTRL	: in std_logic_vector(1 downto 0);
			OUT_C   : out std_logic_vector(DATA_length-1 downto 0));
end entity LOGIC_OPERATORS;


architecture STRUCTURAL of LOGIC_OPERATORS is
	
	signal out_AND_op	: std_logic_vector(DATA_length-1 downto 0);
	signal out_OR_op	: std_logic_vector(DATA_length-1 downto 0);
	signal out_NOT_op	: std_logic_vector(DATA_length-1 downto 0);
	signal out_XOR_op	: std_logic_vector(DATA_length-1 downto 0);
	
	begin
	
	op_gen: for i in (DATA_length-1) downto 0 generate
	
		and_i : entity work.AND_GATE 
		port map(	a	=>	IN_A(i),
					b	=>	IN_B(i),
					c	=>	out_AND_op(i));
		
		or_i : entity work.OR_GATE 
		port map(	a	=>	IN_A(i),
					b	=>	IN_B(i),
					c	=>	out_OR_op(i));
		
		not_i : entity work.NOT_GATE 
		port map(	a	=>	IN_A(i),						
					b	=>	out_NOT_op(i));
	
		xor_i : entity work.XOR_GATE 
		port map(	a	=>	IN_A(i),
					b	=>	IN_B(i),
					c	=>	out_XOR_op(i));

	end generate;

	out_mux : entity work.MUX_4X1
		generic map(data_mux_width => DATA_length)  
		port map(	mux_in0    =>	out_AND_op,
					mux_in1    =>	out_OR_op,
					mux_in2    =>	out_NOT_op,
					mux_in3    =>	out_XOR_op,
					ctrl       =>	LO_CTRL,
					mux_out    =>	OUT_C);
					
end architecture;	