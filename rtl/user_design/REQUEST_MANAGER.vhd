library ieee;
use ieee.std_logic_1164.all;
use work.EXTERNAL_FILE.all;

entity REQUEST_MANAGER is
	port(	rst         	: in std_logic;
			TAG         	: in std_logic_vector(TAG_length-1 downto 0);
			cell_token		: in std_logic;
			position		: in std_logic_vector(DEST_length-1 downto 0);
			DM_write_en     : out std_logic; 
			dec_en          : out std_logic;
			data_mux_ctrl	: out std_logic;
			dec_mux_ctrl    : out std_logic;
			in_dest_ctrl    : out std_logic;
			strobe_to_logic : out std_logic;
			TAG_mux_ctrl	: out std_logic_vector(1 downto 0);			
			CU_write_en		: out std_logic;
			wrall_ctrl		: out std_logic);
end entity REQUEST_MANAGER;


architecture BEHAVIOURAL of REQUEST_MANAGER is

	type state_type is (IDLE, WRITE_HERE, TT_READ, LOC_READ, RETURN_READ, CU_REQ, CU_WR_INSTR, INST_WRITE_ALL, DATA_WRITE_ALL, SEND_INST, SEND_DATA, MOVE_DATA);
    signal CURRENT_STATE : state_type;
	
	begin
	
	FSM_NEXT_STATE : process(rst, TAG, cell_token,position)
		begin
			if (rst = '1') then
				CURRENT_STATE <= IDLE;
			elsif (TAG = TTW AND cell_token = '1') then 
				CURRENT_STATE <= WRITE_HERE;
			elsif (TAG = TTR AND cell_token = '1') then 
				CURRENT_STATE <= TT_READ;
			elsif (TAG = RET_READ AND cell_token = '1') then 
				CURRENT_STATE <= RETURN_READ;
			elsif (TAG = INSWR AND cell_token = '1') then 
				CURRENT_STATE <= CU_WR_INSTR;
			elsif (TAG = INST_WRALL AND cell_token = '1' AND position = PILLAR) then 
				CURRENT_STATE <= INST_WRITE_ALL;
			elsif (TAG = INST_WRALL AND cell_token = '1' AND position /= PILLAR) then 
				CURRENT_STATE <= CU_WR_INSTR;
			elsif (TAG = DATA_WRALL AND cell_token = '1' AND position = PILLAR) then 
				CURRENT_STATE <= DATA_WRITE_ALL;
			elsif (TAG = DATA_WRALL AND cell_token = '1' AND position /= PILLAR) then 
				CURRENT_STATE <= WRITE_HERE;
			elsif (TAG = INSTPASS AND cell_token = '1') then 
				CURRENT_STATE <= SEND_INST;
			elsif (TAG = DATAPASS AND cell_token = '1') then 
				CURRENT_STATE <= SEND_DATA;
			elsif (TAG = MOVE AND cell_token = '1') then 
				CURRENT_STATE <= RETURN_READ;
				
			elsif (TAG = LW AND cell_token = '0') then 
				CURRENT_STATE <= WRITE_HERE;
			elsif (TAG = LR AND cell_token = '0') then 
				CURRENT_STATE <= LOC_READ;
			elsif (TAG = TTW AND cell_token = '0') then 
				CURRENT_STATE <= CU_REQ;
			elsif (TAG = TTR AND cell_token = '0') then 
				CURRENT_STATE <= CU_REQ;
			elsif (TAG = MOVE AND cell_token = '0') then 
				CURRENT_STATE <= MOVE_DATA;
			else 
				CURRENT_STATE <= IDLE;
		end if;
	end process;
				
	
	
	FSM_OUT : process (CURRENT_STATE)
      begin
        case CURRENT_STATE is
            when IDLE =>
				DM_write_en		<=	'0';
                dec_en          <=	'0';
                data_mux_ctrl	<=	'0';
                dec_mux_ctrl    <=	'0';
	            in_dest_ctrl    <=	'0';
                strobe_to_logic	<=	'0';
				TAG_mux_ctrl	<=	"00";				
				CU_write_en		<=	'0';
				wrall_ctrl		<=	'0';				
				
			when WRITE_HERE =>
				DM_write_en		<=	'1';
                dec_en          <=	'0';
                data_mux_ctrl	<=	'0';
                dec_mux_ctrl    <=	'0';
	            in_dest_ctrl    <=	'0';
                strobe_to_logic	<=	'0';
				TAG_mux_ctrl	<=	"00";	
				CU_write_en		<=	'0';
				wrall_ctrl		<=	'0';		
				
			when TT_READ =>
				DM_write_en		<=	'0';
                dec_en          <=	'1';
                data_mux_ctrl	<=	'1';
                dec_mux_ctrl    <=	'0';
	            in_dest_ctrl    <=	'0';
                strobe_to_logic	<=	'0';
				TAG_mux_ctrl	<=	"01";	
				CU_write_en		<=	'0';
				wrall_ctrl		<=	'0';		
				
			when RETURN_READ =>
				DM_write_en		<=	'0';
                dec_en          <=	'0';
                data_mux_ctrl	<=	'0';
                dec_mux_ctrl    <=	'0';
	            in_dest_ctrl    <=	'0';
                strobe_to_logic	<=	'1';
				TAG_mux_ctrl	<=	"00";	
				CU_write_en		<=	'0';
				wrall_ctrl		<=	'0';
				
			when CU_REQ =>
				DM_write_en		<=	'0';
                dec_en          <=	'1';
                data_mux_ctrl	<=	'0';
                dec_mux_ctrl    <=	'0';
	            in_dest_ctrl    <=	'0';
                strobe_to_logic	<=	'0';
				TAG_mux_ctrl	<=	"00";	
				CU_write_en		<=	'0';
				wrall_ctrl		<=	'0';
				
			when LOC_READ =>
				DM_write_en		<=	'0';
                dec_en          <=	'0';
                data_mux_ctrl	<=	'1';
                dec_mux_ctrl    <=	'0';
	            in_dest_ctrl    <=	'0';
                strobe_to_logic	<=	'1';
				TAG_mux_ctrl	<=	"00";	
				CU_write_en		<=	'0';
				wrall_ctrl		<=	'0';
				
			when CU_WR_INSTR =>
				DM_write_en		<=	'0';
                dec_en          <=	'0';
                data_mux_ctrl	<=	'0';
                dec_mux_ctrl    <=	'0';
	            in_dest_ctrl    <=	'0';
                strobe_to_logic	<=	'0';
				TAG_mux_ctrl	<=	"00";	
				CU_write_en		<=	'1';
				wrall_ctrl		<=	'0';
				
			when INST_WRITE_ALL =>
				DM_write_en		<=	'0';
                dec_en          <=	'0';
                data_mux_ctrl	<=	'0';
                dec_mux_ctrl    <=	'0';
	            in_dest_ctrl    <=	'0';
                strobe_to_logic	<=	'0';
				TAG_mux_ctrl	<=	"00";	
				CU_write_en		<=	'1';
				wrall_ctrl		<=	'1';
				
			when DATA_WRITE_ALL =>
				DM_write_en		<=	'1';
                dec_en          <=	'0';
                data_mux_ctrl	<=	'0';
                dec_mux_ctrl    <=	'0';
	            in_dest_ctrl    <=	'0';
                strobe_to_logic	<=	'0';
				TAG_mux_ctrl	<=	"00";	
				CU_write_en		<=	'0';
				wrall_ctrl		<=	'1';
				
			when SEND_INST =>
				DM_write_en		<=	'0';
                dec_en          <=	'1';
                data_mux_ctrl	<=	'0';
                dec_mux_ctrl    <=	'0';
	            in_dest_ctrl    <=	'1';
                strobe_to_logic	<=	'0';
				TAG_mux_ctrl	<=	"10";	
				CU_write_en		<=	'0';
				wrall_ctrl		<=	'0';	
				
			when SEND_DATA =>
				DM_write_en		<=	'0';
                dec_en          <=	'1';
                data_mux_ctrl	<=	'0';
                dec_mux_ctrl    <=	'0';
	            in_dest_ctrl    <=	'1';
                strobe_to_logic	<=	'0';
				TAG_mux_ctrl	<=	"11";	
				CU_write_en		<=	'0';
				wrall_ctrl		<=	'0';
				
			when MOVE_DATA =>
				DM_write_en		<=	'0';
                dec_en          <=	'1';
                data_mux_ctrl	<=	'1';
                dec_mux_ctrl    <=	'0';
	            in_dest_ctrl    <=	'0';
                strobe_to_logic	<=	'0';
				TAG_mux_ctrl	<=	"00";	
				CU_write_en		<=	'0';
				wrall_ctrl		<=	'0';
	
			when others =>
				DM_write_en		<=	'0';
                dec_en          <=	'0';
                data_mux_ctrl	<=	'0';
                dec_mux_ctrl    <=	'0';
	            in_dest_ctrl    <=	'0';
                strobe_to_logic	<=	'0';
				TAG_mux_ctrl	<=	"00";				
				CU_write_en		<=	'0';
				wrall_ctrl		<=	'0';	
		end case;			
	end process;
	
	
end architecture;		