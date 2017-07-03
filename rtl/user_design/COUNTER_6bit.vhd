library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.EXTERNAL_FILE.all;


entity COUNTER_6bit is
	port(	clk		: in std_logic;
			rst		: in std_logic;
			start	: in std_logic;
			modul	: in std_logic_vector(1 downto 0);
			done	: out std_logic);
end entity COUNTER_6bit;


architecture STRUCTURAL of COUNTER_6bit is
	
	constant length_cnt     : integer := 6; 
	constant one_s			: std_logic_vector(length_cnt-1 downto 0) := std_logic_vector(to_unsigned(1, length_cnt));
	
	signal out_not_13_5		: std_logic;
	signal out_not_13_4	    : std_logic;
	signal out_not_13_1		: std_logic;
	signal out_not_29_5	    : std_logic;
	signal out_not_29_1		: std_logic;
	signal out_not_41_4	    : std_logic;
	signal out_not_41_2	    : std_logic;
	signal out_not_41_1		: std_logic;
	signal out_not_61_1	    : std_logic;
	signal out_13			: std_logic_vector(0 downto 0);
	signal out_29			: std_logic_vector(0 downto 0);
	signal out_41			: std_logic_vector(0 downto 0);
	signal out_61			: std_logic_vector(0 downto 0);
	signal out_adder	    : std_logic_vector(length_cnt-1 downto 0);
	signal out_reg	        : std_logic_vector(length_cnt-1 downto 0);
	signal carry_out		: std_logic;
	signal and1_13_out		: std_logic;
	signal and1_29_out		: std_logic;
	signal and1_41_out		: std_logic;
	signal and1_61_out		: std_logic;
	signal finish			: std_logic_vector(0 downto 0);
	
	
	
	begin
	
	add_6bit : entity work.ADDER
		generic map( fa_num 	=>	length_cnt)
		port map(	A    		=>	one_s,
					B 	 		=>	out_reg,
					C0   		=>	'0',
					Cout 		=>	carry_out,
					CoutS       =>  open,
					S    		=>	out_adder);

	regist : entity work.REG
		generic map( reg_width	=>	length_cnt)
		port map( 	clk			=>	clk,
					rst			=>	rst,
					le			=>	start,
					in_reg      =>	out_adder,
					out_reg     =>	out_reg);
					
	not5_13 : entity work.NOT_GATE
		port map(	a			=>	out_reg(5),
					b			=>	out_not_13_5);
					
	not4_13 : entity work.NOT_GATE
		port map(	a			=>	out_reg(4),
					b			=>	out_not_13_4);
					
	not1_13 : entity work.NOT_GATE
		port map(	a			=>	out_reg(1),
					b			=>	out_not_13_1);					
					
	and1_13 : entity work.AND_GATE_4IN
		port map(	in_a		=>	out_not_13_5,
					in_b		=>	out_not_13_4,
					in_c		=>	out_reg(3),
					in_d		=>	out_reg(2),
					output		=>	and1_13_out);
					
	and2_13 : entity work.AND_GATE_3IN 
		port map(	in_a		=>	and1_13_out,
					in_b		=>	out_not_13_1,
					in_c		=>	out_reg(0),
					output		=>	out_13(0));
					
					
					
	not5_29 : entity work.NOT_GATE
		port map(	a			=>	out_reg(5),
					b			=>	out_not_29_5);
					
	not1_29 : entity work.NOT_GATE
		port map(	a			=>	out_reg(1),
					b			=>	out_not_29_1);
					
	and1_29 : entity work.AND_GATE_4IN
		port map(	in_a		=>	out_not_29_5,
					in_b		=>	out_reg(4),
					in_c		=>	out_reg(3),
					in_d		=>	out_reg(2),
					output		=>	and1_29_out);
					
	and2_29 : entity work.AND_GATE_3IN 
		port map(	in_a		=>	and1_29_out,
					in_b		=>	out_not_29_1,
					in_c		=>	out_reg(0),
					output		=>	out_29(0));
					
					
										
	not4_41 : entity work.NOT_GATE
		port map(	a			=>	out_reg(4),
					b			=>	out_not_41_4);
					
	not2_41 : entity work.NOT_GATE
		port map(	a			=>	out_reg(2),
					b			=>	out_not_41_2);
					
	not1_41 : entity work.NOT_GATE
		port map(	a			=>	out_reg(1),
					b			=>	out_not_41_1);
					
	and1_41 : entity work.AND_GATE_4IN
		port map(	in_a		=>	out_reg(5),
					in_b		=>	out_not_41_4,
					in_c		=>	out_reg(3),
					in_d		=>	out_not_41_2,
					output		=>	and1_41_out);
					
	and2_41 : entity work.AND_GATE_3IN 
		port map(	in_a		=>	and1_41_out,
					in_b		=>	out_not_41_1,
					in_c		=>	out_reg(0),
					output		=>	out_41(0));
					
					
					
	not1_61 : entity work.NOT_GATE
		port map(	a			=>	out_reg(1),
					b			=>	out_not_61_1);
					
	and1_61 : entity work.AND_GATE_4IN
		port map(	in_a		=>	out_reg(5),
					in_b		=>	out_reg(4),
					in_c		=>	out_reg(3),
					in_d		=>	out_reg(2),
					output		=>	and1_61_out);
					
	and2_61 : entity work.AND_GATE_3IN 
		port map(	in_a		=>	and1_61_out,
					in_b		=>	out_not_61_1,
					in_c		=>	out_reg(0),
					output		=>	out_61(0));
				
	mux : entity work.MUX_4X1 
		generic map( data_mux_width => 1)  
		port map(	mux_in0    =>	out_13,
					mux_in1    =>	out_29,
					mux_in2    =>	out_41,
					mux_in3    =>	out_61,
					ctrl       =>	modul,
					mux_out    =>	finish);

	done <= finish(0);
					
end architecture;	
