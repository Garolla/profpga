library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;
use work.EXTERNAL_FILE.all;


entity PYRAMID is
	port(	clk, rst          	: in std_logic;
			start_cu			: in std_logic;
			end_cu				: out std_logic;
			ctrl				: in grid_ctrl;		
			request_in		  	: in grid_req_UL_OUT;		
			request_out			: out grid_req_UL_OUT
			);
end entity PYRAMID;


architecture STRUCTURAL of PYRAMID is
	
	signal bottom_lay_request_in		: grid_req_BL_UL;
	signal bottom_lay_request_out		: grid_req_BL_UL;
	signal end_cu_int					: std_logic_vector(bricks_BL-1  downto 0);
	
	begin
	
	-- Next line of code is very bad, so remove it ASAP
	end_cu <= and_reduce(end_cu_int);
	
	layer_first : entity work.BOTTOM_LAYER
		port map(	clk					=>	clk,
					rst          		=>	rst,
					start_cu        	=>  start_cu, 
					end_cu				=>  end_cu_int,       
					request_in		  	=>	bottom_lay_request_in,		
					request_out		  	=>	bottom_lay_request_out
					);	
					
	layer_second : entity work.UPPER_LAYER
		port map(	
					ctrl				=> ctrl,
					up_request_in		=> request_in,	
					down_request_in		=> bottom_lay_request_out,	
					up_request_out		=> request_out,	
					down_request_out	=>	bottom_lay_request_in
				);	
	
	
end architecture;
