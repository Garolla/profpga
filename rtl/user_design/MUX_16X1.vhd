library ieee;
use ieee.std_logic_1164.all;

entity MUX_16X1 is
    generic (data_mux_width : integer);  
    port (	mux_in0    	: in std_logic_vector (data_mux_width-1 downto 0);
			mux_in1    	: in std_logic_vector (data_mux_width-1 downto 0);
			mux_in2    	: in std_logic_vector (data_mux_width-1 downto 0);
			mux_in3    	: in std_logic_vector (data_mux_width-1 downto 0);
			mux_in4    	: in std_logic_vector (data_mux_width-1 downto 0);
			mux_in5    	: in std_logic_vector (data_mux_width-1 downto 0);
			mux_in6    	: in std_logic_vector (data_mux_width-1 downto 0);
			mux_in7    	: in std_logic_vector (data_mux_width-1 downto 0);
			mux_in8		: in std_logic_vector (data_mux_width-1 downto 0); 
			mux_in9   	: in std_logic_vector (data_mux_width-1 downto 0);
			mux_in10  	: in std_logic_vector (data_mux_width-1 downto 0);
			mux_in11  	: in std_logic_vector (data_mux_width-1 downto 0);
			mux_in12  	: in std_logic_vector (data_mux_width-1 downto 0);
			mux_in13  	: in std_logic_vector (data_mux_width-1 downto 0);
			mux_in14  	: in std_logic_vector (data_mux_width-1 downto 0);
			mux_in15  	: in std_logic_vector (data_mux_width-1 downto 0);	
			ctrl       	: in std_logic_vector (3 downto 0) ;
			mux_out    	: out std_logic_vector (data_mux_width-1 downto 0));
end entity MUX_16X1;

architecture STRUCTURAL of MUX_16X1 is

	component MUX_8X1 is
		generic (data_mux_width : integer);  
		port (mux_in0   : in std_logic_vector (data_mux_width-1 downto 0);
			  mux_in1   : in std_logic_vector (data_mux_width-1 downto 0);
			  mux_in2   : in std_logic_vector (data_mux_width-1 downto 0);
			  mux_in3   : in std_logic_vector (data_mux_width-1 downto 0);
			  mux_in4   : in std_logic_vector (data_mux_width-1 downto 0);
			  mux_in5   : in std_logic_vector (data_mux_width-1 downto 0);
			  mux_in6   : in std_logic_vector (data_mux_width-1 downto 0);
			  mux_in7   : in std_logic_vector (data_mux_width-1 downto 0);			  		  
			  ctrl       : in std_logic_vector (2 downto 0) ;
			  mux_out    : out std_logic_vector (data_mux_width-1 downto 0));
	end component MUX_8X1;
	
	signal mux8X1_out1, mux8X1_out2	: std_logic_vector (data_mux_width-1 downto 0);
	
	begin
	
	
	mux8_1 : MUX_8X1
		generic map(data_mux_width => data_mux_width)  
		port map(	mux_in0    =>   mux_in0,
					mux_in1    =>   mux_in1,
					mux_in2    =>   mux_in2,
					mux_in3    =>   mux_in3,
					mux_in4    =>   mux_in4,
					mux_in5    =>   mux_in5,
					mux_in6    =>   mux_in6,
					mux_in7    =>   mux_in7,
					ctrl       =>   ctrl(2 downto 0),   
					mux_out    =>	mux8X1_out1);
					
	mux8_2 : MUX_8X1
		generic map(data_mux_width => data_mux_width)  
		port map(	mux_in0    =>   mux_in8 ,
					mux_in1    =>   mux_in9 ,
					mux_in2    =>   mux_in10,
					mux_in3    =>   mux_in11,
					mux_in4    =>   mux_in12,
					mux_in5    =>   mux_in13,
					mux_in6    =>   mux_in14,
					mux_in7    =>   mux_in15,
					ctrl       =>   ctrl(2 downto 0),   
					mux_out    =>	mux8X1_out2);
					
	final_mux : entity work.MUX_2X1 
		generic map(data_mux_width => data_mux_width)  
		port map(	mux_in0    =>	mux8X1_out1,
					mux_in1    =>	mux8X1_out2,
					ctrl       =>	ctrl(3),
					mux_out    =>	mux_out);
					
end architecture;				
	