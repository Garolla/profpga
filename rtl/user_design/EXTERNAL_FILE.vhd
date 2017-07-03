library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package EXTERNAL_FILE is 

-----------Structure Dimension-------------
	-- IMPORTANT: rows_BL and cols_BL must be multiple of 9
	constant rows_BL                : integer := 9;  			 	--- Number of rows of the bottom layer
	constant cols_BL                : integer := 9;  	  			--- Number of columns of the bottom layer
      
        
  
	constant bricks_BL              : integer := rows_BL*cols_BL; 	--- Number of bricks in the bottom layer (first layer)
	constant conn_BL_UL             : integer := bricks_BL/9;		--- Number of bricks in the bottom layer comunicating with the routing elements of the upper layer. One every 9 bricks
	
	constant rows_RE                : integer := rows_BL/9;  		--- Number of rows of the upper layer.
    constant cols_RE                : integer := cols_BL/9;  		--- Number of columns of the upper layer.
	constant num_RE		            : integer := rows_RE*cols_RE; 	--- Number of Routing element in the upper layer (second layer).Each Re communicates with the outside. There is one RE every 81 bricks of the bottom layer                                                            

    -------Signals Dimensions--------------------
    
	constant IM_address_length		: integer	:= 4;	    	--- log2(number of fsm states)
	constant TAG_length				: integer 	:= 4;	
	constant DEST_length			: integer	:= 4;
	constant logic_comm				: integer 	:= 5;			--- Bits for commands the logic plane, before the decoder
	constant logic_comm_decoded		: integer 	:= 16;          --- Bits for commands the logic plane, after the decoder
	constant condition_code_length	: integer	:= 1 + 4;     		--- Jump signal + Bits to chose the response signal from the LU tha must be used to evaluate the jump
	constant conditions_length      : integer   := 14; 			--- Response signals from logic unit
														
	constant DM_address_length		: integer 	:= IM_address_length; ---4		--- DM_add_len and IM_add_len must be equal at least on busses
	
	constant comm_length			: integer	:= logic_comm + TAG_length + DM_address_length + DEST_length; --- 17 =  + 5 + 4 + 4 + 4
	constant instr_length			: integer	:= condition_code_length + IM_address_length + comm_length;   --- 26 = 5 + 4 + 17 --- jump address + command;	
	
	constant DATA_length			: integer 	:= instr_length;			--- data_len and instr_len must be equal at least on busses	
	constant request_length			: integer	:= TAG_length + DM_address_length + DEST_length + DATA_length; --- 38 = 4 + 4 + 4 + 26
	
	type grid_ctrl is array (num_RE -1 downto 0) of std_logic_vector(DEST_length-1 downto 0);					--- There is one ctrl signal for each routing element
	type grid_req_UL_OUT is array (num_RE -1 downto 0) of std_logic_vector(request_length-1 downto 0);			--- Request signals with the outside
	type grid_req_PILLARS is array (9 - 1 downto 0) of std_logic_vector(request_length-1 downto 0);				--- Request signals from a single Routing Element, must be connected to the pillars. One Routing Element every 81 bricks
    type grid_req_BL_UL is array (conn_BL_UL -1  downto 0) of std_logic_vector(request_length-1 downto 0);		--- the request signals between the bottom and the upper layer

------------ TAGS ------------
	
	constant NOTAG		           	: std_logic_vector(TAG_length-1 downto 0) := "0000";	
	
	constant RET_READ           	: std_logic_vector(TAG_length-1 downto 0) := "0001";	
	constant TTW                	: std_logic_vector(TAG_length-1 downto 0) := "0010";
    constant TTR                	: std_logic_vector(TAG_length-1 downto 0) := "0011";	
	constant LW                 	: std_logic_vector(TAG_length-1 downto 0) := "0100";
    constant LR                 	: std_logic_vector(TAG_length-1 downto 0) := "0101";
	constant INSWR                	: std_logic_vector(TAG_length-1 downto 0) := "0110";
	constant INST_WRALL				: std_logic_vector(TAG_length-1 downto 0) := "0111";
	constant DATA_WRALL				: std_logic_vector(TAG_length-1 downto 0) := "1000";
	constant INSTPASS				: std_logic_vector(TAG_length-1 downto 0) := "1001";
	constant DATAPASS				: std_logic_vector(TAG_length-1 downto 0) := "1010";
	constant MOVE					: std_logic_vector(TAG_length-1 downto 0) := "1011";
		
------------------------------
------------ DEST ------------
	
	constant PILLAR					: std_logic_vector(DEST_length-1 downto 0) := "1000";
	
	constant UPLEV                  : std_logic_vector(DEST_length-1 downto 0) := "0101";	
	constant NORTH					: std_logic_vector(DEST_length-1 downto 0) := "1111";	
	constant NOR_WEST               : std_logic_vector(DEST_length-1 downto 0) := "1110";
	constant WEST                   : std_logic_vector(DEST_length-1 downto 0) := "1101";
	constant SOU_WEST               : std_logic_vector(DEST_length-1 downto 0) := "1100";
	constant SOUTH                  : std_logic_vector(DEST_length-1 downto 0) := "0000";
	constant SOU_EAST               : std_logic_vector(DEST_length-1 downto 0) := "0001";
	constant EAST                   : std_logic_vector(DEST_length-1 downto 0) := "0010";
	constant NOR_EAST               : std_logic_vector(DEST_length-1 downto 0) := "0011";
	
	constant NODEST					: std_logic_vector(DEST_length-1 downto 0) := "0111";
	
------------------------------
--------- ALU UCODE ----------

    constant NOP		           	: std_logic_vector(logic_comm-1 downto 0) := "00000"; -- Same control word for both NOP and READ_B
    constant WRITE_A                : std_logic_vector(logic_comm-1 downto 0) := "00001";    
    constant WRITE_B                : std_logic_vector(logic_comm-1 downto 0) := "00010";
    constant WRITE0_B               : std_logic_vector(logic_comm-1 downto 0) := "00011";    
    constant WRITE1_B               : std_logic_vector(logic_comm-1 downto 0) := "00100";
    constant READ_A                 : std_logic_vector(logic_comm-1 downto 0) := "00101";     
    constant READ_B                 : std_logic_vector(logic_comm-1 downto 0) := "00000"; 
    constant SUM                    : std_logic_vector(logic_comm-1 downto 0) := "00111";
    constant SUB                    : std_logic_vector(logic_comm-1 downto 0) := "01000"; -- Same control word for both SUM and COMP
    constant COMP                   : std_logic_vector(logic_comm-1 downto 0) := "01000";
    constant COUNT                  : std_logic_vector(logic_comm-1 downto 0) := "01001"; 
    constant OP_AND                 : std_logic_vector(logic_comm-1 downto 0) := "01010";
    constant OP_OR                  : std_logic_vector(logic_comm-1 downto 0) := "01011";
    constant OP_NOT                 : std_logic_vector(logic_comm-1 downto 0) := "01100";
    constant OP_XOR                 : std_logic_vector(logic_comm-1 downto 0) := "01101";
    constant MPY                    : std_logic_vector(logic_comm-1 downto 0) := "01110";
    constant ACC                    : std_logic_vector(logic_comm-1 downto 0) := "01111";
  
    constant MAC                    : std_logic_vector(logic_comm-1 downto 0) := "10000";
	constant COUNT7                	: std_logic_vector(logic_comm-1 downto 0) := "10100"; 
    constant COUNT13               	: std_logic_vector(logic_comm-1 downto 0) := "10101";	
	constant COUNT29               	: std_logic_vector(logic_comm-1 downto 0) := "10110";
    constant COUNT41               	: std_logic_vector(logic_comm-1 downto 0) := "10111"; 	
	constant COUNT61               	: std_logic_vector(logic_comm-1 downto 0) := "11000"; 
	constant OP_ROR             	: std_logic_vector(logic_comm-1 downto 0) := "11001"; -- Rotate Right
	constant OP_ROL             	: std_logic_vector(logic_comm-1 downto 0) := "11010"; -- Rotate Left
	constant OP_SRA 				: std_logic_vector(logic_comm-1 downto 0) := "11011"; -- Shift Right Arithmetic
	constant OP_SRL 			    : std_logic_vector(logic_comm-1 downto 0) := "11100"; -- Shift Right Logical
	constant OP_SLA 			    : std_logic_vector(logic_comm-1 downto 0) := "11101"; -- Shift Left Arithmetic
	constant OP_SLL 			    : std_logic_vector(logic_comm-1 downto 0) := "11110"; -- Shift Left Logical
	
end package EXTERNAL_FILE;

