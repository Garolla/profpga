library ieee;
use ieee.std_logic_1164.all;

entity REG is
	generic (reg_width: integer);  
	port ( 	clk			: in std_logic;
			rst			: in std_logic;
			le			: in std_logic;
			in_reg      : in std_logic_vector(reg_width-1 downto 0);
			out_reg     : out std_logic_vector(reg_width-1 downto 0));
end entity REG;

architecture BEHAVIOURAL of REG is
	begin
	  
	shift_reg: process(clk, rst, le)
		begin
			if rst = '1' then
				out_reg <= (others => '0');			
			elsif rising_edge(clk) then				
                if le ='1' then
				    out_reg <= in_reg;  		
				end if;
			end if;
	end process;		
	
end architecture;
