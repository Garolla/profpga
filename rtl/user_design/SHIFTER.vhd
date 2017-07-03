library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.EXTERNAL_FILE.all;

entity SHIFTER is
	generic ( bit_num : integer);
	port (	A    			: in std_logic_vector (4 downto 0);  -- Shift up to 32 positions
			B				: in std_logic_vector (bit_num-1 downto 0); 
			CTRL			: in std_logic_vector (2 downto 0);
			OUTPUT			: out std_logic_vector (bit_num-1 downto 0));	
end entity SHIFTER;


architecture BEHAVIOURAL of SHIFTER is

	begin
	
	process (A,B, CTRL)
	begin
		case CTRL is
			when "000"	=>
				OUTPUT <= B;
			when "001"	=>	
				OUTPUT <= (others=>'0');
			when "010"	=>
				OUTPUT <= to_stdlogicvector((to_bitvector(B)) ror (conv_integer(A)));
			when "011"	=>
				OUTPUT <= to_stdlogicvector((to_bitvector(B)) rol (conv_integer(A)));
			when "100"	=>
				OUTPUT <= to_stdlogicvector((to_bitvector(B)) sra (conv_integer(A)));
			when "101"	=>
				OUTPUT <= to_stdlogicvector((to_bitvector(B)) srl (conv_integer(A)));
			when "110"	=>
				OUTPUT <= to_stdlogicvector((to_bitvector(B)) sla (conv_integer(A)));
			when "111"	=>
				OUTPUT <= to_stdlogicvector((to_bitvector(B)) sll (conv_integer(A)));				
			when others =>
				OUTPUT	<=	(others=>'0');
		end case;
	end process;				
end architecture;