library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.EXTERNAL_FILE.all;


entity LOGIC_ELEMENT is
    Port ( rst : in STD_LOGIC;
           clk : in STD_LOGIC;
           commands_to_logic : in STD_LOGIC_VECTOR (logic_comm-1 downto 0); 
           data_to_logic   : in STD_LOGIC_VECTOR (DATA_length-1 downto 0);
		   AminB_U		   : out std_logic;
           AbigB_U         : out std_logic;
           AminB_S         : out std_logic;
           AbigB_S         : out std_logic;
           AeqB            : out std_logic;
           AneqB           : out std_logic;
           AmineqB_U       : out std_logic;
           AbigeqB_U       : out std_logic;
           AmineqB_S       : out std_logic;
           AbigeqB_S       : out std_logic;
           end_count1      : out std_logic;
           not_end_cnt1    : out std_logic;
           end_count2      : out std_logic;
           not_end_cnt2    : out std_logic;
           data_from_logic  : out std_logic_vector(DATA_length-1 downto 0));
end LOGIC_ELEMENT;

architecture STRUCTURAL of LOGIC_ELEMENT is

signal mux_in          : std_logic;
signal regA_en         : std_logic;
signal regB_en         : std_logic;
signal mux_A           : std_logic;
signal mux_B           : std_logic;
signal sum_or_diff     : std_logic;
signal LO_ctrl         : std_logic_vector(1 downto 0);
signal final_mux       : std_logic_vector(1 downto 0);
signal shift_mode      : std_logic_vector(2 downto 0);
signal start_count2    : std_logic;
signal count2_mod      : std_logic_vector(1 downto 0);
        
begin

			ucode_0 : entity work.LOGIC_UCODE
            port map(   commands_to_logic   =>    commands_to_logic,
                        mux_in              =>    mux_in,    
                        regA_en             =>    regA_en,    
                        regB_en             =>    regB_en,    
                        mux_A               =>    mux_A,    
                        mux_B               =>    mux_B,    
                        sum_or_diff         =>    sum_or_diff,
                        LO_ctrl             =>    LO_ctrl,
                        final_mux           =>    final_mux,    
                        shift_mode          =>    shift_mode,
                        start_count2        =>    start_count2,
                        count2_mod          =>    count2_mod); 
                        
            
			logic_0 : entity work.LOGIC_UNIT
            port map(   rst                 =>    rst                ,            
                        clk                 =>    clk             ,    
                        mux_in              =>    mux_in,    
                        regA_en             =>    regA_en,    
                        regB_en             =>    regB_en,    
                        mux_A               =>    mux_A,    
                        mux_B               =>    mux_B,    
                        sum_or_diff         =>    sum_or_diff,
                        LO_ctrl             =>    LO_ctrl,
                        final_mux           =>    final_mux,      
                        shift_mode          =>    shift_mode,
                        start_count2        =>    start_count2,
                        count2_mod          =>    count2_mod,    
                        data_to_logic       =>    data_to_logic,    --%%%%%%%    
                        AminB_U             =>    AminB_U,
                        AbigB_U             =>    AbigB_U,
                        AminB_S             =>    AminB_S,
                        AbigB_S             =>    AbigB_S,
                        AeqB                =>    AeqB,
                        AneqB               =>    AneqB,
                        AmineqB_U           =>    AmineqB_U,
                        AbigeqB_U           =>    AbigeqB_U,
                        AmineqB_S           =>    AmineqB_S,
                        AbigeqB_S           =>    AbigeqB_S,
                        end_count1          =>    end_count1,
                        not_end_cnt1        =>    not_end_cnt1,
                        end_count2          =>    end_count2,
                        not_end_cnt2        =>    not_end_cnt2,
                        data_from_logic     =>    data_from_logic);    --%%%%%%%    

end STRUCTURAL;
