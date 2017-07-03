library ieee;
use ieee.std_logic_1164.all;
use work.EXTERNAL_FILE.all;

entity OUTPUT_STAGE is
	port ( 		clk				: in std_logic;	
				rst             : in std_logic;	
				position		: in std_logic_vector(DEST_length-1 downto 0);
				selected_addr   : in std_logic_vector(DM_address_length-1 downto 0);	
				selected_data   : in std_logic_vector(DATA_length-1 downto 0);	
				selected_dest   : in std_logic_vector(DEST_length-1 downto 0);	
				selected_tag    : in std_logic_vector(TAG_length-1 downto 0);	
				cell_token      : in std_logic;
				request_to_UP	: out std_logic_vector(request_length-1 downto 0);
				request_to_N    : out std_logic_vector(request_length-1 downto 0);
				request_to_NW   : out std_logic_vector(request_length-1 downto 0);
				request_to_W    : out std_logic_vector(request_length-1 downto 0);
				request_to_SW   : out std_logic_vector(request_length-1 downto 0);
				request_to_S    : out std_logic_vector(request_length-1 downto 0);
				request_to_SE   : out std_logic_vector(request_length-1 downto 0);
				request_to_E    : out std_logic_vector(request_length-1 downto 0);
				request_to_NE   : out std_logic_vector(request_length-1 downto 0);
				data_to_logic	: out std_logic_vector(DATA_length-1 downto 0);				
				CU_write_en		: out std_logic;
				dec_mux_ctrl    : out std_logic;
				in_dest_ctrl    : out std_logic);
end entity OUTPUT_STAGE;				 


architecture STRUCTURAL of OUTPUT_STAGE is

	signal DM_write_en			: std_logic;		
	signal data_out_mem        	: std_logic_vector(DATA_length-1 downto 0);
	signal dec_en              	: std_logic;
	signal data_mux_ctrl       	: std_logic;	
	signal out_dec          	: std_logic_vector(8 downto 0);	
	signal wrall_ctrl          	: std_logic;
	signal TAG_mux_ctrl        	: std_logic_vector(1 downto 0);
	signal DATA_out				: std_logic_vector(DATA_length-1 downto 0);
	signal DEST_out				: std_logic_vector(DEST_length-1 downto 0);
	signal ADDR_out             : std_logic_vector(DM_address_length-1 downto 0);
	signal TAG_out              : std_logic_vector(TAG_length-1 downto 0);
	signal STROBE_out			: std_logic_vector(8 downto 0);
	signal strobe_to_logic		: std_logic;
	
	begin
	
	ADDR_out			<=	selected_addr;
	DEST_out			<=	selected_dest;

	DATA_MEM : entity work.DATA_MEMORY 
		port map( 	clk				=>	clk,
		            rst             =>  rst,
					data_in 		=>	selected_data,
					data_out 		=>	data_out_mem,
					add_in   		=>	selected_addr,	
					we       		=>	DM_write_en);
	
	dec : entity work.DECODER
		port map(	dec_en    		=>	dec_en,
					dec_input 		=>	selected_dest,
					dec_output		=>	out_dec);
					
	req_man : entity work.REQUEST_MANAGER 
		port map(	rst         	=>	rst,
		            TAG         	=>	selected_tag,
					cell_token		=>	cell_token,
					position		=>	position,
					DM_write_en		=>	DM_write_en,
					dec_en          =>	dec_en,
					data_mux_ctrl	=>	data_mux_ctrl,
					dec_mux_ctrl    =>	dec_mux_ctrl,
					in_dest_ctrl    =>	in_dest_ctrl,
					strobe_to_logic =>	strobe_to_logic,
					TAG_mux_ctrl	=>	TAG_mux_ctrl,					
					CU_write_en		=>	CU_write_en,
					wrall_ctrl		=>	wrall_ctrl);
					
					
	data_mux : entity work.MUX_2X1 
		generic map(data_mux_width  =>	DATA_length)
		port map(	mux_in0    		=>	selected_data,
					mux_in1    		=>	data_out_mem,
					ctrl       		=>	data_mux_ctrl,
					mux_out    		=>	DATA_out);	
					
	final_dest_mux : entity work.MUX_2X1 
		generic map(data_mux_width  =>	9)
		port map(	mux_in0    		=>	out_dec,
					mux_in1    		=>	( others => '1'),
					ctrl       		=>	wrall_ctrl,
					mux_out    		=>	STROBE_out);
					
					
	out_tag_mux : entity work.MUX_4X1 
		generic map(data_mux_width  =>	TAG_length)
		port map(	mux_in0    		=>	selected_tag,
					mux_in1    		=>	RET_READ,
					mux_in2    		=>	INSWR,
					mux_in3    		=>	TTW,
					ctrl       		=>	TAG_mux_ctrl,
					mux_out    		=>	TAG_out);
			
	and_plane_ent: entity work.AND_PLANE
	port map(	
			TAG_out				=> TAG_out		,	
			DEST_out			=> DEST_out		,
			ADDR_out			=> ADDR_out		,
			DATA_out			=> DATA_out		,
			strobe_to_UP		=> STROBE_out(8),
			strobe_to_N			=> STROBE_out(7),
			strobe_to_NW		=> STROBE_out(6),
			strobe_to_W			=> STROBE_out(5),
			strobe_to_SW		=> STROBE_out(4),
			strobe_to_S			=> STROBE_out(3),
			strobe_to_SE		=> STROBE_out(2),
			strobe_to_E			=> STROBE_out(1),
			strobe_to_NE		=> STROBE_out(0),	
			strobe_to_logic		=> strobe_to_logic,	
			request_to_UP		=> request_to_UP,
			request_to_N    	=> request_to_N ,  
			request_to_NW   	=> request_to_NW,  
			request_to_W    	=> request_to_W ,  
			request_to_SW   	=> request_to_SW,  
			request_to_S    	=> request_to_S ,  
			request_to_SE   	=> request_to_SE,  
			request_to_E    	=> request_to_E ,  
			request_to_NE   	=> request_to_NE,  	
			data_to_logic		=> data_to_logic
			);
end architecture;	
	