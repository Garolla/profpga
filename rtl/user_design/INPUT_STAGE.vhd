library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;
use work.EXTERNAL_FILE.all;

entity INPUT_STAGE is
	port(	clk					: in std_logic;
			rst                 : in std_logic;
			start_cu            : in std_logic;
			end_cu        		: out std_logic;
			request_from_UP		: in std_logic_vector(request_length-1 downto 0);
			request_from_N      : in std_logic_vector(request_length-1 downto 0);
	        request_from_NW     : in std_logic_vector(request_length-1 downto 0);
	        request_from_W      : in std_logic_vector(request_length-1 downto 0);
	        request_from_SW     : in std_logic_vector(request_length-1 downto 0);
	        request_from_S      : in std_logic_vector(request_length-1 downto 0);
	        request_from_SE     : in std_logic_vector(request_length-1 downto 0);
	        request_from_E      : in std_logic_vector(request_length-1 downto 0);
	        request_from_NE     : in std_logic_vector(request_length-1 downto 0);

			CU_wr_en			: in std_logic;
			dec_mux_ctrl    	: in std_logic;
			in_dest_ctrl    	: in std_logic;
			position			: in std_logic_vector(DEST_length-1 downto 0);
			
	        DATA_from_logic     : in std_logic_vector(DATA_length-1 downto 0);
			conditions			: in std_logic_vector(conditions_length+1 downto 0); -- '1' + conditions_length + '0'	
			
			commands_to_logic	: out std_logic_vector(logic_comm-1 downto 0);
			selected_address    : out std_logic_vector(DM_address_length-1 downto 0);
			selected_data       : out std_logic_vector(DATA_length-1 downto 0);
	        selected_dest       : out std_logic_vector(DEST_length-1 downto 0);
	        selected_TAG        : out std_logic_vector(TAG_length-1 downto 0);
			cell_token          : out std_logic);
end entity INPUT_STAGE;


architecture STRUCTURAL of INPUT_STAGE is
			
	signal out_mux_16x1			: std_logic_vector(request_length-1 downto 0);
	signal out_encoder      	: std_logic_vector(DEST_length-1 downto 0);
	signal cell_token_int		: std_logic_vector(0 downto 0);
	signal out_cell_token		: std_logic_vector(0 downto 0);
	signal in_reg_DM_addr       : std_logic_vector(DM_address_length-1 downto 0);
	signal in_reg_data          : std_logic_vector(DATA_length-1 downto 0);
	signal in_reg_tag           : std_logic_vector(TAG_length-1 downto 0);
	signal in_reg_field_dest	: std_logic_vector(DEST_length-1 downto 0);
	signal out_reg_DM_addr      : std_logic_vector(DM_address_length-1 downto 0);
	signal out_reg_data         : std_logic_vector(DATA_length-1 downto 0);
	signal out_reg_tag          : std_logic_vector(TAG_length-1 downto 0);
	signal out_reg_dest         : std_logic_vector(DEST_length-1 downto 0);
	signal out_reg_field_dest	: std_logic_vector(DEST_length-1 downto 0);
	
	signal CU_DM_addr       	: std_logic_vector(DM_address_length-1 downto 0);
	signal CU_dest          	: std_logic_vector(DEST_length-1 downto 0);
	signal CU_TAG           	: std_logic_vector(TAG_length-1 downto 0);
	signal selected_data_int	: std_logic_vector(DATA_length-1 downto 0);
	signal selected_addr_int	: std_logic_vector(DM_address_length-1 downto 0);
	signal first_dest			: std_logic_vector(DEST_length-1 downto 0);
	signal second_dest			: std_logic_vector(DEST_length-1 downto 0);
	signal not_position        	: std_logic_vector(DEST_length-1 downto 0);
	
	begin
	
	selected_address	<=	selected_addr_int;
	selected_data		<=	selected_data_int;
	
	gen: for i in (DEST_length-1) downto 0 generate
		
		not_pos : entity work.NOT_GATE 
			port map(	a	=>	position(i),
						b	=>	not_position(i));
	end generate;
	
	
	enc : entity work.ENCODER						
		port map(	enc_input(8)  	=>	or_reduce(request_from_UP(request_length-1 downto request_length-TAG_length)),
					enc_input(7)  	=>	or_reduce(request_from_N(request_length-1 downto request_length-TAG_length)), 
					enc_input(6)  	=>	or_reduce(request_from_NW(request_length-1 downto request_length-TAG_length)),
					enc_input(5)  	=>	or_reduce(request_from_W(request_length-1 downto request_length-TAG_length)), 
					enc_input(4)  	=>	or_reduce(request_from_SW(request_length-1 downto request_length-TAG_length)),
					enc_input(3)  	=>	or_reduce(request_from_S(request_length-1 downto request_length-TAG_length)), 
					enc_input(2)  	=>	or_reduce(request_from_SE(request_length-1 downto request_length-TAG_length)),
					enc_input(1)  	=>	or_reduce(request_from_E(request_length-1 downto request_length-TAG_length)), 
					enc_input(0)  	=>	or_reduce(request_from_NE(request_length-1 downto request_length-TAG_length)),				
					out_strobe 		=>	cell_token_int,
					enc_output 		=>	out_encoder);	
					
	req_mux : entity work.MUX_16X1 
		generic map(data_mux_width 	=>	request_length)  
		port map(	mux_in0    		=>	request_from_S, 
					mux_in1    		=>	request_from_SE,
					mux_in2    		=>	request_from_E, 
					mux_in3    		=>	request_from_NE,
					mux_in4    		=>	(others => '0'),
					mux_in5    		=>	request_from_UP,
					mux_in6    		=>	(others => '0'),
					mux_in7    		=>	(others => '0'),
					mux_in8			=>	(others => '0'),
					mux_in9   		=>	(others => '0'),
					mux_in10  		=>	(others => '0'),
					mux_in11  		=>	(others => '0'),
					mux_in12  		=>	request_from_SW,
					mux_in13  		=>	request_from_W,
					mux_in14  		=>	request_from_NW,
					mux_in15  		=>	request_from_N,
					ctrl       		=>	out_encoder,
					mux_out    		=>	out_mux_16x1);
					
	
	in_reg_tag			<=	out_mux_16x1(request_length-1 downto DM_address_length+DEST_length+DATA_length);
	in_reg_DM_addr		<=	out_mux_16x1(DM_address_length+DEST_length+DATA_length-1 downto DEST_length+DATA_length);
	in_reg_field_dest	<=	out_mux_16x1(DEST_length+DATA_length-1 downto DATA_length);
	in_reg_data			<=	out_mux_16x1(DATA_length-1 downto 0);					
				
					
	CU : entity work.CONTROL_UNIT 
		port map( 	clk					=>	clk,											
					rst					=>	rst,	
					start_cu    		=>  start_cu,
					end_cu        		=> 	end_cu,					
					CU_instr_in			=>	selected_data_int,                              
					CU_write_add		=>	selected_addr_int, 
					CU_write_en			=>	CU_wr_en,   
					conditions			=>	conditions, 
					CU_request(DEST_length+DM_address_length+TAG_length-1 downto DEST_length+DM_address_length)	=> CU_TAG,
					CU_request(DEST_length+DM_address_length-1 downto DEST_length)								=> CU_DM_addr,
					CU_request(DEST_length-1 downto 0) 															=> CU_dest,
					commands_to_logic	=>	commands_to_logic
					);
	
	DM_addr_reg : entity work.REG 
		generic map(reg_width		=>	DM_address_length)
		port map( 	clk				=>	clk,
					rst				=>	rst,
					le				=>	'1',
					in_reg      	=>	in_reg_DM_addr,
					out_reg     	=>	out_reg_DM_addr);
					
	DM_addr_mux : entity work.MUX_2X1
		generic map(data_mux_width  =>	DM_address_length)
		port map(	mux_in0    		=>	CU_DM_addr,
					mux_in1    		=>	out_reg_DM_addr, 
					ctrl       		=>	out_cell_token(0),
					mux_out    		=>	selected_addr_int);				
					
	data_reg : entity work.REG 
		generic map(reg_width		=>	DATA_length)
		port map( 	clk				=>	clk,
					rst				=>	rst,
					le				=>	'1',
					in_reg      	=>	in_reg_data,
					out_reg     	=>	out_reg_data);
	 			
	data_mux : entity work.MUX_2X1
		generic map(data_mux_width  =>	DATA_length)
		port map(	mux_in0    		=>	DATA_from_logic,
					mux_in1    		=>	out_reg_data,
					ctrl       		=>	out_cell_token(0),
					mux_out    		=>	selected_data_int);				
	
	dest_reg : entity work.REG 	
		generic map(reg_width		=>	DEST_length)
		port map( 	clk				=>	clk,
					rst				=>	rst,
					le				=>	'1',
					in_reg      	=>	out_encoder,
					out_reg     	=>	out_reg_dest);
					
	field_dest_reg : entity work.REG 	
		generic map(reg_width		=>	DEST_length)
		port map( 	clk				=>	clk,
					rst				=>	rst,
					le				=>	'1',
					in_reg      	=>	in_reg_field_dest,
					out_reg     	=>	out_reg_field_dest);						

					
	dest_mux : entity work.MUX_2X1
		generic map(data_mux_width  =>	DEST_length)
		port map(	mux_in0    		=>	CU_dest,
					mux_in1    		=>	out_reg_dest, 
					ctrl       		=>	out_cell_token(0),
					mux_out    		=>	first_dest);					
					
	dest_field_mux : entity work.MUX_2X1
		generic map(data_mux_width  =>	DEST_length)
		port map(	mux_in0    		=>	first_dest,
					mux_in1    		=>	out_reg_field_dest,
					ctrl       		=>	in_dest_ctrl,						
					mux_out    		=>	second_dest);
					
	last_dest_mux : entity work.MUX_2X1
		generic map(data_mux_width  =>	DEST_length)
		port map(	mux_in0    		=>	second_dest,
					mux_in1    		=>	not_position,
					ctrl       		=>	dec_mux_ctrl,						
					mux_out    		=>	selected_dest);
						
	tag_reg : entity work.REG 	
		generic map(reg_width		=>	TAG_length)
		port map( 	clk				=>	clk,
					rst				=>	rst,
					le				=>	'1',
					in_reg      	=>	in_reg_tag,
					out_reg     	=>	out_reg_tag);
					
	TAG_mux : entity work.MUX_2X1
		generic map(data_mux_width  =>	TAG_length)
		port map(	mux_in0    		=>	CU_TAG,
					mux_in1    		=>	out_reg_tag, 
					ctrl       		=>	out_cell_token(0),
					mux_out    		=>	selected_TAG);
						
	cell_token_reg : entity work.REG 	
		generic map(reg_width		=>	1)
		port map( 	clk				=>	clk,
					rst				=>	rst,
					le				=>	'1',
					in_reg      	=>	cell_token_int,
					out_reg     	=>	out_cell_token);


	cell_token	<=	out_cell_token(0);
	
	
end architecture;
