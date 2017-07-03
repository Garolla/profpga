library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.EXTERNAL_FILE.all;


entity DATA_MEMORY is	
	port( 	clk,rst			: in std_logic;
			data_in 	: in std_logic_vector(DATA_length-1 downto 0);	
			data_out 	: out std_logic_vector(DATA_length-1 downto 0);
			add_in   	: in std_logic_vector(DM_address_length-1 downto 0);	
			we       	: in std_logic);					
end entity DATA_MEMORY;

architecture BEHAVIOURAL of DATA_MEMORY is
	
	type mem_type is array ((2**DM_address_length)-1 downto 0) of std_logic_vector(DATA_length-1 downto 0);
	signal mem : mem_type;


begin

	writing : process (clk,rst,we)
	begin	
	    if rst ='1'then
            mem	<= (others => (others => '0' ));
		elsif rising_edge(clk) then
		  if we = '1' then
            mem(to_integer(unsigned(add_in))) <= data_in;
          end if;
		end if;
	end process;
    
	data_out <= mem(to_integer(unsigned(add_in)));
				
end architecture;
