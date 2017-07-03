######################################################################################
# define clocks
######################################################################################

# constrain clock inputs
create_clock  -name clk_p[0] -period 10  [get_ports clk_p[0] ]  ; # 100 MHz MMI64 clock
create_clock  -name clk_p[1] -period 10  [get_ports clk_p[1] ]  ; # synthesize for up to 100 MHz
create_clock  -name clk_p[2] -period 10  [get_ports clk_p[2] ]  ; # synthesize for up to 100 MHz
create_clock  -name clk_p[3] -period 10  [get_ports clk_p[3] ]  ; # synthesize for up to 100 MHz
create_clock  -name clk_p[4] -period 10  [get_ports clk_p[4] ]  ; # synthesize for up to 100 MHz


set_input_delay  -clock clk_p[0] 0 [get_ports sync_p[0] ]
set_input_delay  -clock clk_p[1] 0 [get_ports sync_p[1] ]
set_input_delay  -clock clk_p[2] 0 [get_ports sync_p[2] ]
set_input_delay  -clock clk_p[3] 0 [get_ports sync_p[3] ]
set_input_delay  -clock clk_p[4] 0 [get_ports sync_p[4] ]



######################################################################################
# constrain asynchronous clock domain transitions
######################################################################################

set_max_delay 10 -from [all_registers -clock clk_p[0] -clock_pins ] -to [all_registers -clock clk_p[1] -data_pins ] -datapath_only
set_max_delay 10 -from [all_registers -clock clk_p[0] -clock_pins ] -to [all_registers -clock clk_p[2] -data_pins ] -datapath_only
set_max_delay 10 -from [all_registers -clock clk_p[0] -clock_pins ] -to [all_registers -clock clk_p[3] -data_pins ] -datapath_only
set_max_delay 10 -from [all_registers -clock clk_p[0] -clock_pins ] -to [all_registers -clock clk_p[4] -data_pins ] -datapath_only

set_max_delay 10 -from [all_registers -clock clk_p[1] -clock_pins ] -to [all_registers -clock clk_p[0] -data_pins ] -datapath_only -quiet
set_max_delay 10 -from [all_registers -clock clk_p[2] -clock_pins ] -to [all_registers -clock clk_p[0] -data_pins ] -datapath_only -quiet
set_max_delay 10 -from [all_registers -clock clk_p[3] -clock_pins ] -to [all_registers -clock clk_p[0] -data_pins ] -datapath_only -quiet
set_max_delay 10 -from [all_registers -clock clk_p[4] -clock_pins ] -to [all_registers -clock clk_p[0] -data_pins ] -datapath_only -quiet

#set_property DONT_TOUCH false [get_cells *.U_CLKSYNC/clk_pad_reg]
set_false_path -to [get_cells *.U_CLKSYNC/reset_rEXT_reg[*] ]

######################################################################################
# define I/O standards
######################################################################################

set_property IOSTANDARD LVDS     [get_ports clk_n[*] ]
set_property IOSTANDARD LVDS     [get_ports clk_p[*] ]
set_property IOSTANDARD LVDS     [get_ports sync_n[*] ]
set_property IOSTANDARD LVDS     [get_ports sync_p[*] ]
set_property IOSTANDARD LVDS     [get_ports srcclk_n[*] ]
set_property IOSTANDARD LVDS     [get_ports srcclk_p[*] ]
set_property IOSTANDARD LVDS     [get_ports srcsync_n[*] ]
set_property IOSTANDARD LVDS     [get_ports srcsync_p[*] ]
set_property IOSTANDARD LVCMOS18 [get_ports dmbi_f2h[*] ]
set_property IOSTANDARD LVCMOS18 [get_ports dmbi_h2f[*] ]


set_property PACKAGE_PIN AF40  [get_ports clk_n[0] ]
set_property PACKAGE_PIN AE41  [get_ports clk_n[1] ]
set_property PACKAGE_PIN AA39  [get_ports clk_n[2] ]
set_property PACKAGE_PIN AB41  [get_ports clk_n[3] ]
set_property PACKAGE_PIN AG40  [get_ports clk_n[4] ]


set_property PACKAGE_PIN AE40  [get_ports clk_p[0] ]
set_property PACKAGE_PIN AD41  [get_ports clk_p[1] ]
set_property PACKAGE_PIN AA38  [get_ports clk_p[2] ]
set_property PACKAGE_PIN AC41  [get_ports clk_p[3] ]
set_property PACKAGE_PIN AF39  [get_ports clk_p[4] ]


set_property PACKAGE_PIN AB36  [get_ports sync_n[0] ]
set_property PACKAGE_PIN AD34  [get_ports sync_n[1] ]
set_property PACKAGE_PIN AA37  [get_ports sync_n[2] ]
set_property PACKAGE_PIN AD40  [get_ports sync_n[3] ]
set_property PACKAGE_PIN AD36  [get_ports sync_n[4] ]

set_property PACKAGE_PIN AB35  [get_ports sync_p[0] ]
set_property PACKAGE_PIN AD33  [get_ports sync_p[1] ]
set_property PACKAGE_PIN AB37  [get_ports sync_p[2] ]
set_property PACKAGE_PIN AD39  [get_ports sync_p[3] ]
set_property PACKAGE_PIN AD35  [get_ports sync_p[4] ]


set_property PACKAGE_PIN AB42  [get_ports srcclk_n[0] ]
set_property PACKAGE_PIN AA43  [get_ports srcclk_n[1] ]
set_property PACKAGE_PIN AC44  [get_ports srcclk_n[2] ]
set_property PACKAGE_PIN AA44  [get_ports srcclk_n[3] ]
set_property PACKAGE_PIN AC42  [get_ports srcclk_p[0] ]
set_property PACKAGE_PIN AA42  [get_ports srcclk_p[1] ]
set_property PACKAGE_PIN AC43  [get_ports srcclk_p[2] ]
set_property PACKAGE_PIN AB44  [get_ports srcclk_p[3] ]
set_property PACKAGE_PIN AB30  [get_ports srcsync_n[0] ]
set_property PACKAGE_PIN AC32  [get_ports srcsync_n[1] ]
set_property PACKAGE_PIN AA30  [get_ports srcsync_n[2] ]
set_property PACKAGE_PIN AB32  [get_ports srcsync_n[3] ]
set_property PACKAGE_PIN AB29  [get_ports srcsync_p[0] ]
set_property PACKAGE_PIN AC31  [get_ports srcsync_p[1] ]
set_property PACKAGE_PIN AA29  [get_ports srcsync_p[2] ]
set_property PACKAGE_PIN AB31  [get_ports srcsync_p[3] ]

set_property PACKAGE_PIN AH31  [get_ports dmbi_f2h[0] ]
set_property PACKAGE_PIN AG31  [get_ports dmbi_f2h[1] ]
set_property PACKAGE_PIN AJ30  [get_ports dmbi_f2h[2] ]
set_property PACKAGE_PIN AJ29  [get_ports dmbi_f2h[3] ]
set_property PACKAGE_PIN AF30  [get_ports dmbi_f2h[4] ]
set_property PACKAGE_PIN AF29  [get_ports dmbi_f2h[5] ]
set_property PACKAGE_PIN AH29  [get_ports dmbi_f2h[6] ]
set_property PACKAGE_PIN AE31  [get_ports dmbi_f2h[7] ]
set_property PACKAGE_PIN AE30  [get_ports dmbi_f2h[8] ]
set_property PACKAGE_PIN AG30  [get_ports dmbi_f2h[9] ]
set_property PACKAGE_PIN AG29  [get_ports dmbi_f2h[10] ]
set_property PACKAGE_PIN AG44  [get_ports dmbi_f2h[11] ]
set_property PACKAGE_PIN AF44  [get_ports dmbi_f2h[12] ]
set_property PACKAGE_PIN AF43  [get_ports dmbi_f2h[13] ]
set_property PACKAGE_PIN AE43  [get_ports dmbi_f2h[14] ]
set_property PACKAGE_PIN AH42  [get_ports dmbi_f2h[15] ]
set_property PACKAGE_PIN AJ28  [get_ports dmbi_f2h[16] ]
set_property PACKAGE_PIN AH28  [get_ports dmbi_f2h[17] ]
set_property PACKAGE_PIN AD44  [get_ports dmbi_f2h[18] ]
set_property PACKAGE_PIN AB28  [get_ports dmbi_f2h[19] ]

set_property PACKAGE_PIN AF33  [get_ports dmbi_h2f[0] ]
set_property PACKAGE_PIN AF34  [get_ports dmbi_h2f[1] ]
set_property PACKAGE_PIN AG34  [get_ports dmbi_h2f[2] ]
set_property PACKAGE_PIN AG35  [get_ports dmbi_h2f[3] ]
set_property PACKAGE_PIN AE32  [get_ports dmbi_h2f[4] ]
set_property PACKAGE_PIN AE33  [get_ports dmbi_h2f[5] ]
set_property PACKAGE_PIN AF32  [get_ports dmbi_h2f[6] ]
set_property PACKAGE_PIN AG32  [get_ports dmbi_h2f[7] ]
set_property PACKAGE_PIN AF35  [get_ports dmbi_h2f[8] ]
set_property PACKAGE_PIN AG41  [get_ports dmbi_h2f[9] ]
set_property PACKAGE_PIN AH41  [get_ports dmbi_h2f[10] ]
set_property PACKAGE_PIN AE37  [get_ports dmbi_h2f[11] ]
set_property PACKAGE_PIN AE38  [get_ports dmbi_h2f[12] ]
set_property PACKAGE_PIN AH39  [get_ports dmbi_h2f[13] ]
set_property PACKAGE_PIN AF37  [get_ports dmbi_h2f[14] ]
set_property PACKAGE_PIN AF38  [get_ports dmbi_h2f[15] ]
set_property PACKAGE_PIN AG39  [get_ports dmbi_h2f[16] ]
set_property PACKAGE_PIN AE35  [get_ports dmbi_h2f[17] ]
set_property PACKAGE_PIN AE36  [get_ports dmbi_h2f[18] ]
set_property PACKAGE_PIN AA35  [get_ports dmbi_h2f[19] ]

