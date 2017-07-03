library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.EXTERNAL_FILE.all;

entity INSTR_MEMORY is	
	port(	clk			: in std_logic;
			rst			: in std_logic;
			write_add	: in std_logic_vector(IM_address_length-1 downto 0);
			read_add	: in std_logic_vector(IM_address_length-1 downto 0);			
			write_en	: in std_logic;
			instr_in	: in std_logic_vector(instr_length-1 downto 0);
			instr_out	: out std_logic_vector(instr_length-1 downto 0));
end entity INSTR_MEMORY;

architecture BEHAVIOURAL of INSTR_MEMORY is
	type ramtable is array ((2**IM_address_length)-1 downto 0) of std_logic_vector (instr_length-1 downto 0);
	signal ram			: ramtable;

	begin
	
	writing : process(clk, rst, write_en)
	begin		
	
		if rst = '1' then
            ram <= (others => (others => '0'));
		elsif rising_edge(clk) then	
            if write_en = '1' then
                ram(to_integer(unsigned(write_add)))    <=    instr_in;
            end if;
        end if;    
	end process;
	
    instr_out   <= ram(to_integer(unsigned(read_add)));

end architecture;
	