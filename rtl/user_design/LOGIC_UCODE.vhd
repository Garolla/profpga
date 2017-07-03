library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.EXTERNAL_FILE.all;

entity LOGIC_UCODE is
Port ( 
        commands_to_logic : in STD_LOGIC_VECTOR (logic_comm-1 downto 0);
        mux_in          : out std_logic;
        regA_en         : out std_logic;
        regB_en         : out std_logic;
        mux_A           : out std_logic;
        mux_B           : out std_logic;
        sum_or_diff     : out std_logic;
        LO_ctrl         : out std_logic_vector(1 downto 0);
        final_mux       : out std_logic_vector(1 downto 0);
        shift_mode      : out std_logic_vector(2 downto 0);
        start_count2    : out std_logic;
        count2_mod      : out std_logic_vector(1 downto 0)
      
      );
end entity LOGIC_UCODE;

architecture STRUCTURAL of LOGIC_UCODE is

type mem_array is array (integer range 0 to 2**logic_comm - 1) of std_logic_vector(0 to logic_comm_decoded - 1);
CONSTANT logic_mem : mem_array := (
                                        "0000000000000000", --NOP/READ_B
                                        "0100000000000000", --WRITE_A
                                        "0010000000000000", --WRITE_B
                                        "1011100001000000", --WRITE0_B
                                        "1011100101000000", --WRITE1_B
                                        "0000100101000000", --READ_A
                                        "0000000000000000", --NOP
                                        "0000000010000000", --SUM
                                        "0000010010000000", --SUB/COMP     
                                        "1011000010000000", --COUNT
                                        "0000000001000000", --OP_AND
                                        "0000000101000000", --OP_OR
                                        "0000001001000000", --OP_NOT
                                        "0000001101000000", --OP_XOR
                                        "0000000011000000", --MPY
                                        "1010000010000000", --ACC
                                       
                                        "1010000011000000", --MAC
                                        "0000000000000000", --NOP 
                                        "0000000000000000", --NOP
                                        "0000000000000000", --NOP
                                        "1011000010000000", --COUNT7
                                        "0000000000000100", --COUNT13 
                                        "0000000000000101", --COUNT29
                                        "0000000000000110", --COUNT41
                                        "0000000000000111", --COUNT61
                                        "0000000000010000", --OP_ROR
                                        "0000000000011000", --OP_ROL
                                        "0000000000100000", --OP_SRA
                                        "0000000000101000", --OP_SRL
                                        "0000000000110000", --OP_SLA
                                        "0000000000111000", --OP_SLL
                                        "0000000000000000"  --NOP
                                                                                                                                             
                                    );
signal cw: std_logic_vector(0 to logic_comm_decoded - 1);

begin
cw <= logic_mem(to_integer(unsigned(commands_to_logic)));

mux_in             <= cw(0);
regA_en            <= cw(1);
regB_en            <= cw(2);
mux_A              <= cw(3);
mux_B              <= cw(4);
sum_or_diff        <= cw(5);
LO_ctrl(1)         <= cw(6);
LO_ctrl(0)         <= cw(7);
final_mux(1)       <= cw(8);
final_mux(0)       <= cw(9);
shift_mode(2)      <= cw(10);
shift_mode(1)      <= cw(11);
shift_mode(0)      <= cw(12);
start_count2       <= cw(13);
count2_mod(1)      <= cw(14);
count2_mod(0)      <= cw(15);

end STRUCTURAL;
