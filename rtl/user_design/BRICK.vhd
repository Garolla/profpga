library ieee;
use ieee.std_logic_1164.all;
use work.EXTERNAL_FILE.all;

entity BRICK is
	port( 	clk					: in std_logic;
			rst                 : in std_logic;
			start_cu            : in std_logic;
			end_cu				: out std_logic;
			position			: in std_logic_vector(DEST_length-1 downto 0);
			request_from_UP		: in std_logic_vector(request_length-1 downto 0);
			request_from_N      : in std_logic_vector(request_length-1 downto 0);
	        request_from_NW     : in std_logic_vector(request_length-1 downto 0);
	        request_from_W      : in std_logic_vector(request_length-1 downto 0);
	        request_from_SW     : in std_logic_vector(request_length-1 downto 0);
	        request_from_S      : in std_logic_vector(request_length-1 downto 0);
	        request_from_SE     : in std_logic_vector(request_length-1 downto 0);
	        request_from_E      : in std_logic_vector(request_length-1 downto 0);
	        request_from_NE     : in std_logic_vector(request_length-1 downto 0);	
			
			DATA_from_logic     : in std_logic_vector(DATA_length-1 downto 0);
			conditions			: in std_logic_vector(conditions_length-1 downto 0);
			commands_to_logic	: out std_logic_vector(logic_comm-1 downto 0);		
				
			request_to_UP		: out std_logic_vector(request_length-1 downto 0);		
			request_to_N    	: out std_logic_vector(request_length-1 downto 0);
			request_to_NW   	: out std_logic_vector(request_length-1 downto 0);
			request_to_W    	: out std_logic_vector(request_length-1 downto 0);
			request_to_SW   	: out std_logic_vector(request_length-1 downto 0);
			request_to_S    	: out std_logic_vector(request_length-1 downto 0);
			request_to_SE   	: out std_logic_vector(request_length-1 downto 0);
			request_to_E    	: out std_logic_vector(request_length-1 downto 0);
			request_to_NE   	: out std_logic_vector(request_length-1 downto 0);

			data_to_logic		: out std_logic_vector(DATA_length-1 downto 0)
			);			
end entity BRICK;

architecture STRUCTURAL of BRICK is
		
	signal CU_mux_ctrl         	: std_logic;
	signal CU_wr_en				: std_logic;
	signal selected_address    	: std_logic_vector(DM_address_length-1 downto 0);
	signal selected_data       	: std_logic_vector(DATA_length-1 downto 0);
	signal selected_dest       	: std_logic_vector(DEST_length-1 downto 0);
	signal selected_TAG        	: std_logic_vector(TAG_length-1 downto 0);
	signal cell_token          	: std_logic;
	signal dec_mux_ctrl    		: std_logic;
	signal in_dest_ctrl    		: std_logic;
	
	begin
	
	in_stage : entity work.INPUT_STAGE
		port map(	clk							=>	clk,				
					rst                 		=>	rst,    
					start_cu                    =>  start_cu,
					end_cu                   	=>  end_cu,     
					request_from_UP				=>	request_from_UP,    
					request_from_N      		=>	request_from_N,   
					request_from_NW     		=>	request_from_NW,  
					request_from_W      		=>	request_from_W,   
					request_from_SW     		=>	request_from_SW,  
					request_from_S      		=>	request_from_S,   
					request_from_SE     		=>	request_from_SE,  
					request_from_E      		=>	request_from_E,  
					request_from_NE     		=>	request_from_NE,  				
								
					CU_wr_en					=>	CU_wr_en,	
					dec_mux_ctrl  				=>  dec_mux_ctrl,	
					in_dest_ctrl    			=>  in_dest_ctrl,
					position					=>	position,
							
					DATA_from_logic     		=>	DATA_from_logic, 
					conditions(0)				=>	'1',
					conditions(14 downto 1)		=>	conditions,				
					conditions(15)				=>	'0',
					commands_to_logic			=>	commands_to_logic,
					
					selected_address    		=>	selected_address, 
					selected_data       		=>	selected_data,    
					selected_dest       		=>	selected_dest,    
					selected_TAG        		=>	selected_TAG,         
					cell_token          		=>	cell_token); 
	
	out_stage : entity work.OUTPUT_STAGE 
		port map( 	clk					=>	clk,					
					rst             	=>	rst,             	
					position			=>	position,			
					selected_addr   	=>	selected_address,   	
					selected_data   	=>	selected_data,   	
					selected_dest   	=>	selected_dest,   	
					selected_tag    	=>	selected_TAG,    	
					cell_token      	=>	cell_token, 
					request_to_UP		=>	request_to_UP,	   
					request_to_N    	=>	request_to_N,    	
					request_to_NW   	=>	request_to_NW,   	
					request_to_W    	=>	request_to_W,    	
					request_to_SW   	=>	request_to_SW,   	
					request_to_S    	=>	request_to_S,    	
					request_to_SE   	=>	request_to_SE,   	
					request_to_E    	=>	request_to_E,    	
					request_to_NE   	=>	request_to_NE,   		
					data_to_logic		=>	data_to_logic,									
					CU_write_en			=>	CU_wr_en,
					dec_mux_ctrl		=>	dec_mux_ctrl,		
					in_dest_ctrl		=>	in_dest_ctrl);
end architecture;
