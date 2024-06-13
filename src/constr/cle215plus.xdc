# SQRL Acorn CLE215+
# FPGA part: xc7a200tfbg484-3
# cfgmem part: s25fl128sxxxxxx1 (SPIx4)

# user_led:0
set_property LOC G3 [get_ports {led[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[0]}]

# user_led:1
set_property LOC H3 [get_ports {led[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[1]}]

# user_led:2
set_property LOC G4 [get_ports {led[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[2]}]

# user_led:3
set_property LOC H4 [get_ports {led[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[3]}]
