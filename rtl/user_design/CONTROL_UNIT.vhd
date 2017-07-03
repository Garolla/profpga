library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.EXTERNAL_FILE.all;

entity CONTROL_UNIT is
	port( 	clk					: in std_logic;
			rst			 		: in std_logic;	
			start_cu        	: in std_logic;	
			end_cu        		: out std_logic;		
			CU_instr_in	 		: in std_logic_vector(instr_length-1 downto 0);
			CU_write_add		: in std_logic_vector(IM_address_length-1 downto 0);
			CU_write_en			: in std_logic;
			conditions			: in std_logic_vector(conditions_length+1 downto 0); -- '1' + conditions_length + '0'	
			CU_request			: out std_logic_vector(DEST_length+DM_address_length+TAG_length-1 downto 0);
			commands_to_logic	: out std_logic_vector(logic_comm-1 downto 0)
			);
end entity CONTROL_UNIT;

architecture BEHAVIOURAL of CONTROL_UNIT is

	signal instr_out	        : std_logic_vector(instr_length-1 downto 0);
	signal cond_code			: std_logic_vector(condition_code_length-1 downto 0);	
	signal jump_code			: std_logic;
	signal cc_mux				: std_logic_vector(3 downto 0);
	signal status_vect			: std_logic_vector(0 downto 0);
	signal status				: std_logic;
	signal jump_addr	        : std_logic_vector(IM_address_length-1 downto 0);
	signal jump_mux_ctrl		: std_logic;
	signal out_incr_internal	: std_logic_vector (IM_address_length-1 downto 0);
	signal PC_in_internal		: std_logic_vector (IM_address_length-1 downto 0);
	signal PC_out_internal		: std_logic_vector (IM_address_length-1 downto 0);
	signal carry_out_U			: std_logic;
	signal carry_out_S			: std_logic;
	signal one_s				: std_logic_vector (IM_address_length-1 downto 0) := std_logic_vector(to_unsigned(1, IM_address_length));
	
	begin

    cond_code			<= instr_out(instr_length-1 downto instr_length-condition_code_length);
	jump_addr			<= instr_out(comm_length+IM_address_length-1 downto comm_length);
	CU_request			<= instr_out(DEST_length+DM_address_length+TAG_length-1 downto 0);	
	commands_to_logic	<= instr_out(DEST_length+DM_address_length+TAG_length+logic_comm-1 downto DEST_length+DM_address_length+TAG_length);
	
	jump_code			<= cond_code(4);
	cc_mux				<= cond_code(3 downto 0);	
	
	instr_mem	:	entity work.INSTR_MEMORY 	
		port map(	clk			=>	clk,
					rst 		=>	rst,
					write_add	=>	CU_write_add,
					read_add	=>  PC_out_internal,
					write_en	=>	CU_write_en,
					instr_in	=>	CU_instr_in,
					instr_out	=>  instr_out);
					
	cond_mux : entity work.MUX_16X1
		generic map(data_mux_width => 1)  
		port map(	mux_in0    	=>	conditions(0 downto 0),
					mux_in1    	=>	conditions(1 downto 1),
					mux_in2    	=>	conditions(2 downto 2),
					mux_in3    	=>	conditions(3 downto 3),
					mux_in4    	=>	conditions(4 downto 4),
					mux_in5    	=>	conditions(5 downto 5),
					mux_in6    	=>	conditions(6 downto 6),
					mux_in7    	=>	conditions(7 downto 7),
					mux_in8		=>	conditions(8 downto 8),
					mux_in9   	=>	conditions(9 downto 9),
					mux_in10  	=>	conditions(10 downto 10),
					mux_in11  	=>	conditions(11 downto 11),
					mux_in12  	=>	conditions(12 downto 12),
					mux_in13  	=>	conditions(13 downto 13),
					mux_in14  	=>	conditions(14 downto 14),
					mux_in15  	=>	conditions(15 downto 15),
					ctrl       	=>	cc_mux,
					mux_out    	=>	status_vect);
					
	status	<=	status_vect(0);
	
					
	pla			:	entity work.STATUS_PLA 
		port map(	jump		=>	jump_code,
					status		=>	status,		
					mux_ctrl	=>	jump_mux_ctrl);
				
	incrementer	:	entity work.ADDER 
		generic map( fa_num 	=>	IM_address_length)
		port map(	A    		=>	one_s,
					B 	 		=>	PC_out_internal,
					C0   		=>	'0',
					Cout 		=>	carry_out_U,
					CoutS		=>	carry_out_S,
					S    		=>	out_incr_internal);
					
	jump_addr_mux :	entity work.MUX_2X1
		generic map(data_mux_width	=>	IM_address_length)  
		port map(	mux_in0		=>	out_incr_internal,    
					mux_in1     =>	jump_addr,
					ctrl        =>	jump_mux_ctrl,
					mux_out     =>	PC_in_internal);
		
		
					
	PC_reg		:	entity work.REG
		generic map(reg_width	=>	IM_address_length)  
		port map( 	clk			=>	clk,
					rst			=>	rst,
					le			=>  start_cu,
					in_reg      =>	PC_in_internal,
					out_reg     =>	PC_out_internal);
	
	and_end_cu: entity work.AND_GATE_4IN 
					port map (	in_a	=> PC_out_internal(3),
								in_b	=> PC_out_internal(2),
								in_c	=> PC_out_internal(1),
								in_d	=> PC_out_internal(0),
								output	=> end_cu
								);			
end architecture;	
	
	
