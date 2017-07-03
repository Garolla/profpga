library ieee;
use ieee.std_logic_1164.all;
use work.EXTERNAL_FILE.all;

entity AND_PLANE is
	port (	
			TAG_out				: in std_logic_vector(TAG_length-1 downto 0);	
			DEST_out			: in std_logic_vector(DEST_length-1 downto 0);
			ADDR_out			: in std_logic_vector(DM_address_length-1 downto 0);
			DATA_out			: in std_logic_vector(DATA_length-1 downto 0);
			strobe_to_UP		: in std_logic;
			strobe_to_N			: in std_logic;
			strobe_to_NW		: in std_logic;
			strobe_to_W			: in std_logic;
			strobe_to_SW		: in std_logic;
			strobe_to_S			: in std_logic;
			strobe_to_SE		: in std_logic;
			strobe_to_E			: in std_logic;
		    strobe_to_NE		: in std_logic;
			strobe_to_logic		: in std_logic;
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
end entity AND_PLANE; 

architecture BEHAVIOURAL of AND_PLANE is
	signal REQUEST_out		: std_logic_vector(request_length-1 downto 0);	
	
	begin
	
	REQUEST_out				<= 	TAG_out & ADDR_out & DEST_out & DATA_out;
	
	str_gen: for i in (request_length-1) downto 0 generate
		
		UP_and_i : entity work.AND_GATE 
		port map(	a	=>	REQUEST_out(i),
					b	=>	strobe_to_UP,
					c	=>	request_to_UP(i));
						
		NORTH_and_i : entity work.AND_GATE 
			port map(	a	=>	REQUEST_out(i),
						b	=>	strobe_to_N,
						c	=>	request_to_N(i));
					
		NORTH_WEST_and_i : entity work.AND_GATE 
			port map(	a	=>	REQUEST_out(i),
						b	=>	strobe_to_NW,
						c	=>	request_to_NW(i));
					
		WEST_and_i : entity work.AND_GATE 
			port map(	a	=>	REQUEST_out(i),
						b	=>	strobe_to_W,
						c	=>	request_to_W(i));
					
		SOUTH_WEST_and_i : entity work.AND_GATE 
			port map(	a	=>	REQUEST_out(i),
						b	=>	strobe_to_SW,
						c	=>	request_to_SW(i));
					
		SOUTH_and_i : entity work.AND_GATE 
			port map(	a	=>	REQUEST_out(i),
						b	=>	strobe_to_S,
						c	=>	request_to_S(i));
					
		SOUTH_EAST_and_i : entity work.AND_GATE 
			port map(	a	=>	REQUEST_out(i),
						b	=>	strobe_to_SE,
						c	=>	request_to_SE(i));
					
		EAST_and_i : entity work.AND_GATE 
			port map(	a	=>	REQUEST_out(i),
						b	=>	strobe_to_E,
						c	=>	request_to_E(i));
					
		NORTH_EAST_and_i : entity work.AND_GATE 
			port map(	a	=>	REQUEST_out(i),
						b	=>	strobe_to_NE,
						c	=>	request_to_NE(i));
					
	end generate;
	
	--Data for the logic plane
	dwn_gen: for i in (DATA_length-1) downto 0 generate
	
		DOWN_and_i : entity work.AND_GATE 
			port map(	a	=>	DATA_out(i),
						b	=>	strobe_to_logic,
						c	=>	data_to_logic(i));
	
	end generate;
					  										 
end architecture;