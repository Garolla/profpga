library ieee;
use ieee.std_logic_1164.all;
use work.EXTERNAL_FILE.all;

entity UPPER_LAYER is
	port (  		
			ctrl					: in grid_ctrl;									--- One for each routing unit communicating with the outside	
			up_request_in		  	: in grid_req_UL_OUT;                   		--- One for each routing unit communicating with the outside
			down_request_in		  	: in grid_req_BL_UL;							--- One for each brick of the bottom layer
			up_request_out		  	: out grid_req_UL_OUT;                    		--- One for each routing unit communicating with the outside
			down_request_out		: out grid_req_BL_UL							--- One for each brick of the bottom layer
			);
end entity UPPER_LAYER;


architecture STRUCTURAL of UPPER_LAYER is
	
begin

	row:  for i in 0 to rows_RE-1 generate
		col:  for j in 0 to cols_RE-1 generate
			-- down_request_out(0) is connected to the pillar (1,1) of the bottom layer, down_request_out(1) to (1,4) and so on, depending on the structure of the matrix. 
			-- Each number represents one pillar and each pillar handles 9 bricks (8 neighbours + the pillar itself)
			-- For instance for a 18x18 is
			-- -----------------------
			-- | 0	1  2  | 3  4   5 | 
			-- | 6	7  8  | 9  10 11 |
			-- | 12	13 14 | 15 16 17 |
			-- -----------------------
			-- | 18	19 20 | 21 21 23 | 
			-- | 24	25 26 | 27 28 29 |
			-- | 30	31 32 | 33 34 35 |
			-- -----------------------
			-- For instance for a 9x45 is
			-- --------------------------------------------------------
			-- | 0	1  2  | 3  4  5  | 6  7  8  | 9  10 11 | 12 13 14 |
			-- | 15 16 17 | 18 19 20 | 21 21 23 | 24 25 26 | 27 28 29 |
			-- | 30	31 32 | 33 34 35 | 36 37 38 | 39 40 41 | 42 43 44 |
			-- --------------------------------------------------------		
			re_i : entity work.ROUTING_UNIT
				port map( 	
					ctrl					=>	ctrl(i*cols_RE + j)		  ,
					request_to_OUT			=>	up_request_out(i*cols_RE + j), 
					request_from_OUT		=>	up_request_in(i*cols_RE + j),		
												
					request_to_DOWN(0)		=>	down_request_out(0 + 3*(j + cols_RE*(0+3*i))), -- Pillars in North West position
					request_to_DOWN(1)		=>	down_request_out(1 + 3*(j + cols_RE*(0+3*i))), -- Pillars in North position
					request_to_DOWN(2)		=>	down_request_out(2 + 3*(j + cols_RE*(0+3*i))), -- Pillars in North East position
					request_to_DOWN(3)		=>	down_request_out(0 + 3*(j + cols_RE*(1+3*i))), -- Pillars in West position
					request_to_DOWN(4)		=>	down_request_out(1 + 3*(j + cols_RE*(1+3*i))), -- Pillars in Central position
					request_to_DOWN(5)		=>	down_request_out(2 + 3*(j + cols_RE*(1+3*i))), -- Pillars in East position
					request_to_DOWN(6)		=>	down_request_out(0 + 3*(j + cols_RE*(2+3*i))), -- Pillars in South West position
					request_to_DOWN(7)		=>	down_request_out(1 + 3*(j + cols_RE*(2+3*i))), -- Pillars in South position
					request_to_DOWN(8)		=>	down_request_out(2 + 3*(j + cols_RE*(2+3*i))), -- Pillars in South East position
					                                                                           
					request_from_DOWN(0)	=>	down_request_in	(0 + 3*(j + cols_RE*(0+3*i))), -- Pillars in North West position
					request_from_DOWN(1)	=>	down_request_in	(1 + 3*(j + cols_RE*(0+3*i))), -- Pillars in North position
					request_from_DOWN(2)	=>	down_request_in	(2 + 3*(j + cols_RE*(0+3*i))), -- Pillars in North East position
					request_from_DOWN(3)	=>	down_request_in	(0 + 3*(j + cols_RE*(1+3*i))), -- Pillars in West position
					request_from_DOWN(4)	=>	down_request_in	(1 + 3*(j + cols_RE*(1+3*i))), -- Pillars in Central position
					request_from_DOWN(5)	=>	down_request_in	(2 + 3*(j + cols_RE*(1+3*i))), -- Pillars in East position
					request_from_DOWN(6)	=>	down_request_in	(0 + 3*(j + cols_RE*(2+3*i))), -- Pillars in South West position
					request_from_DOWN(7)	=>	down_request_in	(1 + 3*(j + cols_RE*(2+3*i))), -- Pillars in South position
					request_from_DOWN(8)	=>	down_request_in	(2 + 3*(j + cols_RE*(2+3*i))) -- Pillars in South East position
				);			
			end generate col;
		end generate row;	
end architecture;
