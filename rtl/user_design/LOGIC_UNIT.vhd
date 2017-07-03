library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.EXTERNAL_FILE.all;

entity LOGIC_UNIT is
	port( 	rst				: in std_logic;
			clk             : in std_logic;
			mux_in          : in std_logic;
			regA_en         : in std_logic;
			regB_en         : in std_logic;
			mux_A           : in std_logic;
			mux_B			: in std_logic;
			sum_or_diff     : in std_logic;
			LO_ctrl		    : in std_logic_vector(1 downto 0);
			final_mux       : in std_logic_vector(1 downto 0);
			shift_mode      : in std_logic_vector(2 downto 0);
			start_count2    : in std_logic;
			count2_mod      : in std_logic_vector(1 downto 0);
			data_to_logic	: in std_logic_vector(DATA_length-1 downto 0);
			AminB_U			: out std_logic;
			AbigB_U         : out std_logic;
			AminB_S         : out std_logic;
			AbigB_S         : out std_logic;
			AeqB            : out std_logic;
			AneqB           : out std_logic;
			AmineqB_U       : out std_logic;
			AbigeqB_U       : out std_logic;
			AmineqB_S       : out std_logic;
			AbigeqB_S       : out std_logic;
			end_count1      : out std_logic;
			not_end_cnt1    : out std_logic;
			end_count2      : out std_logic;
			not_end_cnt2    : out std_logic;
			data_from_logic	: out std_logic_vector(DATA_length-1 downto 0));
end entity LOGIC_UNIT;

architecture STRUCTURAL of LOGIC_UNIT is
	
	signal one_s		    : std_logic_vector(DATA_length-1 downto 0) := std_logic_vector(to_unsigned(1, DATA_length));
    signal zeros_s          : std_logic_vector(DATA_length-1 downto 0) := (others => '0');	
	signal out_in_mux		: std_logic_vector(DATA_length-1 downto 0);
	signal out_regA			: std_logic_vector(DATA_length-1 downto 0);
	signal out_regB			: std_logic_vector(DATA_length-1 downto 0);
	signal A_or_one			: std_logic_vector(DATA_length-1 downto 0);
	signal B_or_zero		: std_logic_vector(DATA_length-1 downto 0);
	signal out_ADD			: std_logic_vector(DATA_length-1 downto 0);
	signal out_MPY			: std_logic_vector(DATA_length-1 downto 0);
	signal out_LO			: std_logic_vector(DATA_length-1 downto 0);
	signal out_SHIFT		: std_logic_vector(DATA_length-1 downto 0);
	signal final_result		: std_logic_vector(DATA_length-1 downto 0);
	signal cout_Unsigned	: std_logic;
	signal cout_Signed		: std_logic;
	signal not_cout_Unsigned: std_logic;
	signal not_cout_Signed	: std_logic;
	signal end_counter2		: std_logic;
	signal end_counter1		: std_logic_vector(0 downto 0);
	signal a_eq_b 			: std_logic;
	signal a_neq_b         	: std_logic;

	signal fin_cnt_7		: std_logic_vector(0 downto 0);	
	signal final_res7		: std_logic_vector(2 downto 0);
	
	
	begin
	
	init_mux : entity work.MUX_2X1
		generic map(	data_mux_width      =>	DATA_length)
		port map(		mux_in0    			=>	data_to_logic,
						mux_in1    			=>	final_result,
						ctrl       			=>	mux_in,
						mux_out    			=>	out_in_mux);
						
	regA : entity work.REG
		generic map(	reg_width			=>	DATA_length)
		port map( 		clk					=>	clk,
						rst					=>	rst,
						le					=>	regA_en,
						in_reg      		=>	data_to_logic,
						out_reg     		=>	out_regA);
						
	regB : entity work.REG
		generic map(	reg_width			=>	DATA_length)
		port map( 		clk					=>	clk,
						rst					=>	rst,
						le					=>	regB_en,
						in_reg      		=>	out_in_mux,
						out_reg     		=>	out_regB);
						
	Aone_mux : entity work.MUX_2X1
		generic map(	data_mux_width      =>	DATA_length)
		port map(		mux_in0    			=>	out_regA,
						mux_in1    			=>	one_s,
						ctrl       			=>	mux_A,
						mux_out    			=>	A_or_one);
						
	Bzero_mux : entity work.MUX_2X1
		generic map(	data_mux_width      =>	DATA_length)
		port map(		mux_in0    			=>	out_regB,
						mux_in1    			=>	zeros_s,
						ctrl       			=>	mux_B,
						mux_out    			=>	B_or_zero);						

	
	add : entity work.ADDER 
		generic map( 	fa_num 				=>	DATA_length)
		port map(		A    				=>	A_or_one,
						B 	 				=>	B_or_zero,
						C0   				=>	sum_or_diff,
						Cout  				=>	cout_Unsigned,
						CoutS				=>	cout_Signed,
						S    				=>	out_ADD);
						
						
	AminB_U		<=	cout_Unsigned;					--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 1
	AminB_S		<=	cout_Signed;					--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 3
	
	
	cout_U : entity work.NOT_GATE
		port map(		a		=>	cout_Unsigned,
						b		=>	not_cout_Unsigned);		
						
				
	AbigB_U		<=	not_cout_Unsigned;				--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 2
						
						
	cout_S : entity work.NOT_GATE
		port map(		a		=>	cout_Signed,
						b		=>	not_cout_Signed);		
						
						
	AbigB_S		<=	not_cout_Signed;           		--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 4
						
						
	mpy : entity work.MULTIPLIER
		generic map( 	bit_num 			=>	DATA_length)
		port map(		A    				=>	A_or_one(DATA_length/2-1 downto 0),
						B 	 				=>	B_or_zero(DATA_length/2-1 downto 0),	
						P    				=>	out_MPY);
						
	shift : entity work.SHIFTER
		generic map( 	bit_num 			=>	DATA_length)
		port map(		A    				=>	A_or_one(4 downto 0),
						B					=>  B_or_zero,
						CTRL				=>	shift_mode,
						OUTPUT 				=>	out_SHIFT);	
	
	
	lo : entity work.LOGIC_OPERATORS 
		port map(		IN_A				=>	A_or_one,
						IN_B    			=>	B_or_zero,
						LO_CTRL				=>	LO_ctrl,
						OUT_C   			=>	out_LO);

						
	end_mux : entity work.MUX_4X1
		generic map(	data_mux_width      =>	DATA_length)
		port map(		mux_in0    			=>	out_SHIFT,
						mux_in1    			=>	out_LO,
						mux_in2				=>	out_ADD,
						mux_in3				=>	out_MPY,
						ctrl       			=>	final_mux,
						mux_out    			=>	final_result);

	data_from_logic	<=	final_result;
	
	equ_operator : entity work.EQUIVALENCE_OPERATOR 
		generic map( 	num_length 			=>	DATA_length)
		port map(		A    				=>	out_regA, -- Was A_or_one,that's the super variation that allows to use the COUNT op
						B 	 				=>	B_or_zero,		
						a_eq_b 				=>	a_eq_b, 
						a_neq_b				=>  a_neq_b);
						
	
	AeqB	<=	a_eq_b; 							--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 5
    AneqB	<=	a_neq_b;							--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 6
	
	
	Or_AmineqB_U : entity work.OR_GATE
			port map(	a					=>	cout_Unsigned,
						b					=>	a_eq_b,
						c					=>	AmineqB_U);	--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 7
						
	Or_AbigeqB_U : entity work.OR_GATE
			port map(	a					=>	not_cout_Unsigned,
						b					=>	a_eq_b,
						c					=>	AbigeqB_U);	--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 8
						
	Or_AmineqB_S : entity work.OR_GATE
			port map(	a					=>	cout_Signed,
						b					=>	a_eq_b,
						c					=>	AmineqB_S);	--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 9
						
	Or_AbigeqB_S : entity work.OR_GATE
			port map(	a					=>	not_cout_Signed,
						b					=>	a_eq_b,
						c					=>	AbigeqB_S);	--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 10
	
						
	bit6_cnt : entity work.COUNTER_6bit
		port map(		clk					=>	clk,
						rst					=>	rst,
						start				=>	start_count2,
						modul				=>	count2_mod,
						done				=>	end_counter2);	
						
						
	end_count2	<=	end_counter2;					--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 13
	
						
	cnt2_end : entity work.NOT_GATE
		port map(		a		=>	end_counter2,
						b		=>	not_end_cnt2);	--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 14
						
	 							


	final_res7	<=	final_result(2) & final_result(1) & final_result(0);
		
	and_red_7: entity work.AND_GATE_3IN
		port map(	
					in_a	=> final_res7(0),
					in_b	=> final_res7(1),
					in_c	=> final_res7(2),
					output	=> fin_cnt_7(0)
					);																	
				
					
	end_count1	<=	fin_cnt_7(0);				--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 11
					
	
	cnt1_end : entity work.NOT_GATE
		port map(		a		=>	fin_cnt_7(0),
						b		=>	not_end_cnt1);	--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 12
	
	
	
	
end architecture;
