library ieee;
use ieee.std_logic_1164.all;
use work.EXTERNAL_FILE.all;

entity BOTTOM_LAYER is
		port (	clk, rst        : in std_logic;			
		        start_cu        : in std_logic;
		        end_cu			: out std_logic_vector(bricks_BL-1  downto 0);
                request_in      : in grid_req_BL_UL;
                request_out     : out grid_req_BL_UL
                );
end entity BOTTOM_LAYER;


architecture STRUCTURAL of BOTTOM_LAYER is
			
	type req_array is array (bricks_BL-1 downto 0) of std_logic_vector(request_length-1 downto 0);
	type position_array is array (bricks_BL-1 downto 0) of std_logic_vector(DEST_length-1 downto 0);
	type data_array is array (bricks_BL-1 downto 0) of std_logic_vector(DATA_length-1 downto 0);
	type command_array is array (bricks_BL-1 downto 0) of std_logic_vector(logic_comm-1 downto 0);
	type conditions_array is array (bricks_BL-1 downto 0) of std_logic_vector(conditions_length-1 downto 0);
	
	signal request_from_N 		: req_array;
	signal request_from_NW      : req_array;
	signal request_from_W       : req_array;
	signal request_from_SW      : req_array;
	signal request_from_S       : req_array;
	signal request_from_SE      : req_array;
	signal request_from_E       : req_array;
	signal request_from_NE      : req_array;
	signal request_from_UP      : req_array;
	
	signal request_to_N 		: req_array;
	signal request_to_NW      	: req_array;
	signal request_to_W       	: req_array;
	signal request_to_SW      	: req_array;
	signal request_to_S       	: req_array;
	signal request_to_SE      	: req_array;
	signal request_to_E       	: req_array;
	signal request_to_NE      	: req_array;
	signal request_to_UP      	: req_array;
	
	signal data_from_logic     	: data_array;
	signal conditions			: conditions_array;
	signal commands_to_logic	: command_array;
	signal data_to_logic		: data_array;
	
	signal position				: position_array;
	
	begin
  
	row:  for i in 0 to rows_BL-1 generate
		col:  for j in 0 to cols_BL-1 generate
								
            -- The bricks in NORTH WEST position have as j 0,3,6,9... and as i 0,3,6,9...            
            position_gen1 : if ((j mod 3 = 0 ) AND (i mod 3 = 0 )) generate
                    position(i*cols_BL+j) <=     NOR_WEST;                
            end generate position_gen1;    
            -- The bricks in WEST position have as j 0,3,6,9... and as i 1,4,5,10...
            position_gen2 : if ((j mod 3 = 0) AND (i mod 3 = 1)) generate
                    position(i*cols_BL+j) <=     WEST;                
            end generate position_gen2;
            
            position_gen3 : if ((j mod 3 = 0) AND (i mod 3 = 2)) generate
                    position(i*cols_BL+j) <=     SOU_WEST;                
            end generate position_gen3;
            
            position_gen4 : if ((j mod 3 = 1) AND (i mod 3 = 0 )) generate
                    position(i*cols_BL+j) <=     NORTH;                
            end generate position_gen4;
            
            -- The bricks in PILLAR (central) position have as j 1,4,5,10... and as i 1,4,5,10...
            position_gen5 : if ((j mod 3 = 1) AND (i mod 3 = 1 )) generate
                    position(i*cols_BL+j) <=     PILLAR;                
            end generate position_gen5;
            
            position_gen6 : if ((j mod 3 = 1) AND (i mod 3 = 2 )) generate
                    position(i*cols_BL+j) <=     SOUTH;                
            end generate position_gen6;
            
            position_gen7 : if ((j mod 3 = 2) AND (i mod 3 = 0 )) generate
                    position(i*cols_BL+j) <=     NOR_EAST;                
            end generate position_gen7;
            
            position_gen8 : if ((j mod 3 = 2) AND (i mod 3 = 1 )) generate
                    position(i*cols_BL+j) <=     EAST;                
            end generate position_gen8;
            
            position_gen9 : if ((j mod 3 = 2) AND (i mod 3 = 2 )) generate
                    position(i*cols_BL+j) <=     SOU_EAST;                
            end generate position_gen9;
			
			
			brick_i : entity work.BRICK 
						port map( 	clk					=>	clk					,
									rst                 =>	rst                 ,
									start_cu            =>  start_cu            ,
									end_cu				=>  end_cu(i*cols_BL+j)	,
									position			=>	position(i*cols_BL+j),
									request_from_UP		=>	request_from_UP(i*cols_BL+j), 
									request_from_N      =>	request_from_N (i*cols_BL+j),
									request_from_NW     =>	request_from_NW(i*cols_BL+j),
									request_from_W      =>	request_from_W (i*cols_BL+j),
									request_from_SW     =>	request_from_SW(i*cols_BL+j),
									request_from_S      =>	request_from_S (i*cols_BL+j),
									request_from_SE     =>	request_from_SE(i*cols_BL+j),
									request_from_E      =>	request_from_E (i*cols_BL+j),
									request_from_NE     =>	request_from_NE(i*cols_BL+j),
									DATA_from_logic     =>	data_from_logic(i*cols_BL+j), --%%%%%%%				
									conditions			=>	conditions(i*cols_BL+j),
									commands_to_logic	=>	commands_to_logic(i*cols_BL+j),
									request_to_UP		=>	request_to_UP(i*cols_BL+j),  
									request_to_N    	=>	request_to_N (i*cols_BL+j),
									request_to_NW   	=>	request_to_NW(i*cols_BL+j),
									request_to_W    	=>	request_to_W (i*cols_BL+j),
									request_to_SW   	=>	request_to_SW(i*cols_BL+j),
									request_to_S    	=>	request_to_S (i*cols_BL+j),
									request_to_SE   	=>	request_to_SE(i*cols_BL+j),
									request_to_E    	=>	request_to_E (i*cols_BL+j),
									request_to_NE   	=>	request_to_NE(i*cols_BL+j),
									data_to_logic		=>	data_to_logic(i*cols_BL+j)  --%%%%%%%	
									);
									
			logic_i : entity work.LOGIC_ELEMENT
						port map(	rst					=>	rst				,			
									clk             	=>	clk             ,	
									commands_to_logic	=>	commands_to_logic(i*cols_BL+j),
									data_to_logic		=>	data_to_logic(i*cols_BL+j),	--%%%%%%%	
									AminB_U				=>	conditions(i*cols_BL+j)(0),
									AbigB_U         	=>	conditions(i*cols_BL+j)(1),
									AminB_S         	=>	conditions(i*cols_BL+j)(2),
									AbigB_S         	=>	conditions(i*cols_BL+j)(3),
									AeqB            	=>	conditions(i*cols_BL+j)(4),
									AneqB           	=>	conditions(i*cols_BL+j)(5),
									AmineqB_U       	=>	conditions(i*cols_BL+j)(6),
									AbigeqB_U       	=>	conditions(i*cols_BL+j)(7),
									AmineqB_S       	=>	conditions(i*cols_BL+j)(8),
									AbigeqB_S       	=>	conditions(i*cols_BL+j)(9),
									end_count1      	=>	conditions(i*cols_BL+j)(10),
									not_end_cnt1    	=>	conditions(i*cols_BL+j)(11),
									end_count2      	=>	conditions(i*cols_BL+j)(12),
									not_end_cnt2    	=>	conditions(i*cols_BL+j)(13),
									data_from_logic		=>	data_from_logic(i*cols_BL+j));	--%%%%%%%				
						
							
							
				-- The bricks in PILLAR position are connected with the upper layer			
                connections_UP_DW_pill0 : if ((i mod 3 = 1) and (j mod 3 = 1)) generate			
					request_from_UP(i*cols_BL+j) 		 <= request_in(((i-1)*cols_BL/3+j-1)/3); -- Indexed vector of uprequest in/out with the outside. Request(0) is connected to  pillar (1,1), request(1) to (1,4) and so on                 
                    request_out(((i-1)*cols_BL/3+j-1)/3) <= request_to_UP(i*cols_BL+j);  
				end generate connections_UP_DW_pill0;	
				

				-- All the other bricks have the upstream signals connected to the ground	
				connections_UP_DWN_NOpill : if NOT((i mod 3 = 1 )and (j mod 3 = 1)) generate	
					request_from_UP(i*cols_BL+j) 		<= (others => '0');
				end generate connections_UP_DWN_NOpill;						
				
				
				connections_we : if j /= cols_BL-1 generate
					request_from_W(i*cols_BL+j+1) 	<= request_to_E(i*cols_BL+j);
				end generate connections_we;
				 
				connections_ew : if j /= 0 generate
					request_from_E(i*cols_BL+j-1) 		<= request_to_W(i*cols_BL+j);
				end generate connections_ew;
				
				connections_ns : if i /= rows_BL-1 generate
					request_from_N((i+1)*cols_BL+j)		<= request_to_S(i*cols_BL+j);	
				end generate connections_ns;
				
				connections_sn : if i /= 0 generate
					request_from_S((i-1)*cols_BL+j)	<= request_to_N(i*cols_BL+j);
				end generate connections_sn;
				
				
				connections_nw_se : if j /= cols_BL-1 and i /= rows_BL-1 generate
					request_from_NW((i+1)*cols_BL+j+1) 	<= request_to_SE(i*cols_BL+j);	
				end generate connections_nw_se;
				
				connections_se_nw : if j /= 0 and i /= 0 generate
					request_from_SE((i-1)*cols_BL+j-1) 	<= request_to_NW(i*cols_BL+j);
				end generate connections_se_nw;
				
				connections_ne_sw : if j /= 0 and i /= rows_BL-1 generate
					request_from_NE((i+1)*cols_BL+j-1) 	<= request_to_SW(i*cols_BL+j);
				end generate connections_ne_sw;
				
				connections_sw_ne : if j /= cols_BL-1 and i /= 0 generate
					request_from_SW((i-1)*cols_BL+j+1) 	<= request_to_NE(i*cols_BL+j);	
				end generate connections_sw_ne;
				
		
				
				bound_e_connections : if j = cols_BL-1 generate
					request_from_E(i*cols_BL+j) 		<= (others => '0');
					request_from_NE(i*cols_BL+j) 		<= (others => '0');
					request_from_SE(i*cols_BL+j) 		<= (others => '0');
				end generate bound_e_connections;
				
				bound_w_connections : if j = 0 generate
					request_from_W(i*cols_BL+j) 		<= (others => '0');
					request_from_NW(i*cols_BL+j) 		<= (others => '0');
					request_from_SW(i*cols_BL+j) 		<= (others => '0');
				end generate bound_w_connections;
				
				bound_s_connections : if i = rows_BL-1 generate
					request_from_S(i*cols_BL+j) 		<= (others => '0');
					request_from_SW(i*cols_BL+j) 		<= (others => '0');
					request_from_SE(i*cols_BL+j) 		<= (others => '0');	
				end generate bound_s_connections;
				
				bound_n_connections : if i = 0 generate
					request_from_N(i*cols_BL+j) 		<= (others => '0');
					request_from_NW(i*cols_BL+j) 		<= (others => '0');
					request_from_NE(i*cols_BL+j) 		<= (others => '0');
				end generate bound_n_connections;		

				
			end generate col;
		end generate row;
		
	
end architecture;
