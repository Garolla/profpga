library ieee;
    use ieee.std_logic_1164.all;
entity user_mmi64 is
  port (

    -- clock/sync (driven by mainboard)
    -- Only using clocks 0 to 4 (i.e. not 5, 6, or 7)
    clk_n             : in  std_ulogic_vector(4 downto 0);
    clk_p             : in  std_ulogic_vector(4 downto 0);
    sync_n            : in  std_ulogic_vector(4 downto 0);
    sync_p            : in  std_ulogic_vector(4 downto 0);
    
    -- clock/sync (provided to mainboard)
    srcclk_n         : out std_ulogic_vector(3 downto 0);
    srcclk_p         : out std_ulogic_vector(3 downto 0);
    srcsync_n        : out std_ulogic_vector(3 downto 0);
    srcsync_p        : out std_ulogic_vector(3 downto 0);
    
    -- DMBI (mainboard)
    dmbi_f2h          : out std_ulogic_vector(19 downto 0);
    dmbi_h2f          : in  std_ulogic_vector(19 downto 0)

  );
end entity user_mmi64;






library ieee;
    use ieee.std_logic_1164.all;
package user_mmi64_comp is
  component user_mmi64 is
    port (
      -- clock/sync (driven by mainboard)
      -- Only using clocks 0 to 4 (i.e. not 5, 6, or 7)
      clk_n             : in  std_ulogic_vector(4 downto 0);
      clk_p             : in  std_ulogic_vector(4 downto 0);
      sync_n            : in  std_ulogic_vector(4 downto 0);
      sync_p            : in  std_ulogic_vector(4 downto 0);
      
      -- clock/sync (provided to mainboard)
      srcclk_n         : out std_ulogic_vector(3 downto 0);
      srcclk_p         : out std_ulogic_vector(3 downto 0);
      srcsync_n        : out std_ulogic_vector(3 downto 0);
      srcsync_p        : out std_ulogic_vector(3 downto 0);
      
      -- DMBI (mainboard)
      dmbi_f2h          : out std_ulogic_vector(19 downto 0);
      dmbi_h2f          : in  std_ulogic_vector(19 downto 0)
         
    );
  end component user_mmi64;
end package user_mmi64_comp;






library ieee;
    	use ieee.std_logic_1164.all;
    	use ieee.numeric_std.all;
library unisim;
    use unisim.vcomponents.all;
library work;
    use work.profpga_pkg.all;
    use work.mmi64_pkg.all;
    use work.mmi64_m_regif_comp.all;
    use work.external_file.all;

architecture rtl of user_mmi64 is
  type clk_cfg_vector is array(natural range <>) of std_ulogic_vector(19 downto 0);
  -- profpga_ctrl interface
  signal mmi64_clk   : std_ulogic;
  signal mmi64_reset : std_ulogic;
  
  signal mmi64_dn_d       : mmi64_data_t; 
  signal mmi64_dn_valid   : std_ulogic;   
  signal mmi64_dn_accept  : std_ulogic;   
  signal mmi64_dn_start   : std_ulogic;   
  signal mmi64_dn_stop    : std_ulogic;   
  
  signal mmi64_up_d       : mmi64_data_t; 
  signal mmi64_up_valid   : std_ulogic;   
  signal mmi64_up_accept  : std_ulogic;   
  signal mmi64_up_start   : std_ulogic;   
  signal mmi64_up_stop    : std_ulogic;   

  signal clk_cfg_dn  : clk_cfg_vector(4 downto 1);
  signal clk_cfg_up  : clk_cfg_vector(4 downto 1);

  -- outputs of the clock domains
  signal clk         : std_ulogic_vector(4 downto 1);
  signal reset       : std_ulogic_vector(4 downto 1);
  
  -- connections to register interface
  signal reg_en      : std_ulogic;
  signal reg_we      : std_ulogic;
  signal reg_addr    : std_ulogic_vector(3 downto 0);  -- 16 registers --> 4-bit address
  signal reg_wdata   : std_ulogic_vector(63 downto 0); -- register width 64
  signal reg_accept  : std_ulogic;
  signal reg_rdata   : std_ulogic_vector(63 downto 0); -- register width 64
  signal reg_rvalid  : std_ulogic;
  
---------------------- USER SPACE -------------------------------------------------------
  signal ctrl			: grid_ctrl;		
  signal request_in		: grid_req_UL_OUT;		
  signal request_out		: grid_req_UL_OUT;
  signal end_cu			: std_logic;
  signal start_cu		: std_logic := '0';

  component PYRAMID is 
	port(	clk, rst          	: in std_logic;
		start_cu		: in std_logic;
		end_cu			: out std_logic;
		ctrl			: in grid_ctrl;		
		request_in		: in grid_req_UL_OUT;		
		request_out		: out grid_req_UL_OUT
		);
  end component PYRAMID;
 ---------------------- END USER SPACE ------------------------------------------------------- 
begin

  --
  -- profpga_ctrl module for clock input 0 and clock configuration
  --
  U_PROFPGA_CTRL : profpga_ctrl 
  port map (
    -- access to FPGA pins
    clk0_p          => clk_p(0),
    clk0_n          => clk_n(0),
    sync0_p         => sync_p(0),
    sync0_n         => sync_n(0),
    srcclk_p        => srcclk_p,
    srcclk_n        => srcclk_n,
    srcsync_p       => srcsync_p,
    srcsync_n       => srcsync_n,
    dmbi_h2f        => dmbi_h2f,
    dmbi_f2h        => dmbi_f2h,

    -- MMI-64 access (synchronous to mmi64_clk)
    mmi64_present_i => '1',
    mmi64_clk_o     => mmi64_clk,
    mmi64_reset_o   => mmi64_reset,
    mmi64_m_dn_d_o      => mmi64_dn_d,
    mmi64_m_dn_valid_o  => mmi64_dn_valid ,
    mmi64_m_dn_accept_i => mmi64_dn_accept,
    mmi64_m_dn_start_o  => mmi64_dn_start ,
    mmi64_m_dn_stop_o   => mmi64_dn_stop  ,
    mmi64_m_up_d_i      => mmi64_up_d,
    mmi64_m_up_valid_i  => mmi64_up_valid ,
    mmi64_m_up_accept_o => mmi64_up_accept,
    mmi64_m_up_start_i  => mmi64_up_start ,
    mmi64_m_up_stop_i   => mmi64_up_stop  ,
    
    -- clock configuration ports (synchronous to mmi64_clk)
    clk1_cfg_dn_o   => clk_cfg_dn(1),
    clk1_cfg_up_i   => clk_cfg_up(1),
    clk2_cfg_dn_o   => clk_cfg_dn(2),
    clk2_cfg_up_i   => clk_cfg_up(2),
    clk3_cfg_dn_o   => clk_cfg_dn(3),
    clk3_cfg_up_i   => clk_cfg_up(3),
    clk4_cfg_dn_o   => clk_cfg_dn(4),
    clk4_cfg_up_i   => clk_cfg_up(4) 
  );
  
  --
  -- profpga_clksync modules for clock inputs 1 to 4
  --
  GEN_CLKSYNC : for i in 1 to 4 generate
    U_CLKSYNC : profpga_clocksync 
    generic map (
      CLK_CORE_COMPENSATION => "DELAYED"
    ) port map (
      -- access to FPGA pins
      clk_p           => clk_p(i),
      clk_n           => clk_n(i),
      sync_p          => sync_p(i),
      sync_n          => sync_n(i),

      -- clock from pad
      clk_o           => clk(i),

      -- clock feedback (either clk_o or 1:1 output from MMCM/PLL)
      clk_i           => clk(i),
      clk_locked_i    => '1',

      -- configuration access from profpga_infrastructure
      mmi64_clk       => mmi64_clk,
      mmi64_reset     => mmi64_reset,
      cfg_dn_i        => clk_cfg_dn(i),
      cfg_up_o        => clk_cfg_up(i),

      -- sync events
      user_reset_o    => reset(i)
    );
  end generate;

  USER_REGIF : mmi64_m_regif 
  generic map (
    MODULE_ID         => X"FEEDBACC",
    REGISTER_COUNT    => 16,
    REGISTER_WIDTH    => 64 
  ) port map (
    -- clock and reset
    mmi64_clk   => mmi64_clk,
    mmi64_reset => mmi64_reset,

    mmi64_h_dn_d_i       => mmi64_dn_d     ,
    mmi64_h_dn_valid_i   => mmi64_dn_valid ,
    mmi64_h_dn_accept_o  => mmi64_dn_accept,
    mmi64_h_dn_start_i   => mmi64_dn_start ,
    mmi64_h_dn_stop_i    => mmi64_dn_stop  ,
    mmi64_h_up_d_o       => mmi64_up_d     ,
    mmi64_h_up_valid_o   => mmi64_up_valid ,
    mmi64_h_up_accept_i  => mmi64_up_accept,
    mmi64_h_up_start_o   => mmi64_up_start ,
    mmi64_h_up_stop_o    => mmi64_up_stop  ,
    
    reg_en_o     => reg_en    ,      
    reg_we_o     => reg_we    ,      
    reg_addr_o   => reg_addr  ,      
    reg_wdata_o  => reg_wdata ,      
    reg_accept_i => reg_accept,      
    reg_rdata_i  => reg_rdata ,      
    reg_rvalid_i => reg_rvalid      
    );
  

---------------------- USER SPACE -------------------------------------------------------
  -- Accept commands always, you must obey!
  reg_accept <= '1';

          
  REG_FF : process(mmi64_clk)

  begin
    if rising_edge(mmi64_clk) then
      

      -- handle register transfers
      if reg_en='1' and reg_accept='1' then
        if reg_we='1' then -- write to registers
          reg_rvalid <= '0';
          reg_rdata <= (others=>'0');
          
          case reg_addr is
          when "0000" => ctrl(0) <= std_logic_vector( reg_wdata(request_length +4-1 downto request_length ) ) ; request_in(0) <= std_logic_vector( reg_wdata(request_length -1 downto 0) ); 
	  --when "0001" => ctrl(1) <= std_logic_vector( reg_wdata(request_length +4-1 downto request_length ) ) ; request_in(1) <= std_logic_vector( reg_wdata(request_length -1 downto 0) ); 
          --when "0010" => ctrl(2) <= std_logic_vector( reg_wdata(request_length +4-1 downto request_length ) ) ; request_in(2) <= std_logic_vector( reg_wdata(request_length -1 downto 0) ); 
          --when "0011" => ctrl(3) <= std_logic_vector( reg_wdata(request_length +4-1 downto request_length ) ) ; request_in(3) <= std_logic_vector( reg_wdata(request_length -1 downto 0) ); 
	  when "0001" => start_cu <= std_logic( reg_wdata(0) );	
          when others => ctrl <= (others=> "1001"); request_in <= (others=> (others=>'0')); start_cu <= '0';
          end case;
        else -- read from registers
          reg_rvalid <= '1';
          case reg_addr is
          when "0000" => reg_rdata(request_length -1 downto 0) <= std_ulogic_vector( request_out(0)) ;
	  --when "0001" => reg_rdata(request_length -1 downto 0) <= std_ulogic_vector( request_out(1)) ;	
	  --when "0010" => reg_rdata(request_length -1 downto 0) <= std_ulogic_vector( request_out(2)) ;
	  --when "0011" => reg_rdata(request_length -1 downto 0) <= std_ulogic_vector( request_out(3)) ;
	  when "0001" => reg_rdata(0) <= std_ulogic(end_cu);	
          when others => reg_rdata(request_length -1 downto 0) <= (others => '0');
          end case;
        end if;
      else -- no transfer or not accepted
        reg_rvalid <= '0';
        reg_rdata <= (others=>'0');
      end if;
      
      
      -- reset values
      if mmi64_reset='1' then
        reg_rvalid	<= '0';
        reg_rdata	<= (others=>'0');
        request_in	<= (others=> (others=>'0'));
	ctrl		<= (others=> "1001");	
	start_cu 	<= '0';
      end if;
    end if;
  end process REG_FF;

  
  LIM_0 : PYRAMID port map (
		clk		=> mmi64_clk, --clk(1),
		rst		=> mmi64_reset,--reset(1),
		start_cu	=> start_cu,
		end_cu		=> end_cu,
		ctrl		=> ctrl,
		request_in	=> request_in,		
		request_out	=> request_out
  );

----------------------END USER SPACE -------------------------------------------------------  
end architecture rtl;

  
