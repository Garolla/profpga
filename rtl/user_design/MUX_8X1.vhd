library ieee;
use ieee.std_logic_1164.all;

entity MUX_8X1 is
    generic (data_mux_width : integer);  
    port (mux_in0    : in std_logic_vector (data_mux_width-1 downto 0);
          mux_in1    : in std_logic_vector (data_mux_width-1 downto 0);
          mux_in2    : in std_logic_vector (data_mux_width-1 downto 0);
          mux_in3    : in std_logic_vector (data_mux_width-1 downto 0);
		  mux_in4    : in std_logic_vector (data_mux_width-1 downto 0);
          mux_in5    : in std_logic_vector (data_mux_width-1 downto 0);
          mux_in6    : in std_logic_vector (data_mux_width-1 downto 0);
          mux_in7    : in std_logic_vector (data_mux_width-1 downto 0);
	      ctrl       : in std_logic_vector (2 downto 0) ;
	      mux_out    : out std_logic_vector (data_mux_width-1 downto 0));
end entity MUX_8X1;

architecture STRUCTURAL of MUX_8X1 is
	
	component AND_GATE_4IN is
		port (	in_a	: in std_logic;
				in_b	: in std_logic;
				in_c	: in std_logic;
				in_d	: in std_logic;
				output	: out std_logic);
	end component AND_GATE_4IN;
	
	component OR_GATE_4IN is
		 port (	in_a    : in std_logic ;
				in_b    : in std_logic ;
				in_c    : in std_logic ;
				in_d    : in std_logic ;
				output       : out std_logic); 
	end component OR_GATE_4IN;
	
	signal out_not1: std_logic;
	signal out_not2: std_logic;
	signal out_not3: std_logic;
	signal out_and1: std_logic_vector (data_mux_width-1 downto 0);
	signal out_and2: std_logic_vector (data_mux_width-1 downto 0);
	signal out_and3: std_logic_vector (data_mux_width-1 downto 0);
	signal out_and4: std_logic_vector (data_mux_width-1 downto 0);
	signal out_and5: std_logic_vector (data_mux_width-1 downto 0);
	signal out_and6: std_logic_vector (data_mux_width-1 downto 0);
	signal out_and7: std_logic_vector (data_mux_width-1 downto 0);
	signal out_and8: std_logic_vector (data_mux_width-1 downto 0);
	signal part_or1: std_logic_vector (data_mux_width-1 downto 0);
	signal part_or2: std_logic_vector (data_mux_width-1 downto 0);
	
	begin
	
	not1_comp: entity work.NOT_GATE 
						port map(		a => ctrl(2),
										b => out_not1);
	  
	not2_comp: entity work.NOT_GATE 
						port map(		a => ctrl(1),
										b => out_not2);
									  
	not3_comp: entity work.NOT_GATE 
						port map(		a => ctrl(0),
										b => out_not3);

	gen: for i in (data_mux_width-1) downto 0 generate

		and1_comp_i: AND_GATE_4IN 
					    port map (		in_a 	=> mux_in0(i),
									    in_b 	=> out_not1,
									    in_c 	=> out_not2,
										in_d 	=> out_not3,
									    output 		=> out_and1(i));
								 
		and2_comp_i: AND_GATE_4IN 
					    port map (		in_a 	=> mux_in1(i),
									    in_b 	=> out_not1,
									    in_c 	=> out_not2,
										in_d 	=> ctrl(0),
									    output 		=> out_and2(i));
									  
		and3_comp_i: AND_GATE_4IN 
					    port map (		in_a 	=> mux_in2(i),
									    in_b 	=> out_not1,
									    in_c 	=> ctrl(1),
										in_d 	=> out_not3,
									    output 		=> out_and3(i));
									  
		and4_comp_i: AND_GATE_4IN 
					    port map (		in_a 	=> mux_in3(i),
									    in_b 	=> out_not1,
									    in_c 	=> ctrl(1),
										in_d 	=> ctrl(0),
									    output 		=> out_and4(i));
										
		and5_comp_i: AND_GATE_4IN 
					    port map (		in_a 	=> mux_in4(i),
									    in_b 	=> ctrl(2),
									    in_c 	=> out_not2,
										in_d 	=> out_not3,
									    output 		=> out_and5(i));
										
		and6_comp_i: AND_GATE_4IN 
					    port map (		in_a 	=> mux_in5(i),
									    in_b 	=> ctrl(2),
									    in_c 	=> out_not2,
										in_d 	=> ctrl(0),
									    output 		=> out_and6(i));
										
		and7_comp_i: AND_GATE_4IN 
					    port map (		in_a 	=> mux_in6(i),
									    in_b 	=> ctrl(2),
									    in_c 	=> ctrl(1),
										in_d 	=> out_not3,
									    output 		=> out_and7(i));
										
		and8_comp_i: AND_GATE_4IN 
					    port map (		in_a 	=> mux_in7(i),
									    in_b 	=> ctrl(2),
									    in_c 	=> ctrl(1),
										in_d 	=> ctrl(0),
									    output 		=> out_and8(i));
										
										
					
		or_comp_i1: OR_GATE_4IN
						port map (		in_a 	=> out_and1(i),
										in_b 	=> out_and2(i),
										in_c 	=> out_and3(i),
										in_d 	=> out_and4(i),
										output 		=> part_or1(i));
										
		or_comp_i2: OR_GATE_4IN
						port map (		in_a 	=> out_and5(i),
										in_b 	=> out_and6(i),
										in_c 	=> out_and7(i),
										in_d 	=> out_and8(i),
										output 		=> part_or2(i));
										
		final_or : entity work.OR_GATE
						port map (		a    	=> part_or1(i),
										b    	=> part_or2(i),
										c   	=> mux_out(i)); 
							 
	end generate;
			
end architecture;			
							 
