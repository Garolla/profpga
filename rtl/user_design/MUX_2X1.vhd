library ieee;
use ieee.std_logic_1164.all;

entity MUX_2X1 is
    generic (data_mux_width       : integer);  
    port (	mux_in0    : in std_logic_vector (data_mux_width-1 downto 0);
			mux_in1    : in std_logic_vector (data_mux_width-1 downto 0);
			ctrl       : in std_logic;
			mux_out    : out std_logic_vector(data_mux_width-1 downto 0));
end entity MUX_2X1;

architecture STRUCTURAL of MUX_2X1 is
	
	signal out_not: std_logic_vector(data_mux_width-1 downto 0);
	signal out_and1: std_logic_vector (data_mux_width-1 downto 0);
	signal out_and2: std_logic_vector (data_mux_width-1 downto 0);
	
begin

	gen: for i in (data_mux_width-1) downto 0 generate
	
		not_comp_i: entity work.NOT_GATE 
					 port map (		a => ctrl,
									b => out_not(i));

		and1_comp_i: entity work.AND_GATE 
					  port map (	a => mux_in0(i),
									b => out_not(i),
									c => out_and1(i));
								 
		and2_comp_i: entity work.AND_GATE 
					  port map (	a => mux_in1(i),
									b => ctrl,
									c => out_and2(i));
					
		or_comp_i: entity work.OR_GATE 
					port map (		a => out_and1(i),
									b => out_and2(i),
									c => mux_out(i));
							 
	end generate;
			
end architecture;			
							 
