PROJECT = jtag_led
TOP = jtag_led
TOP_VERILOG = src/rtl/jtag_led.sv
ADDITIONAL_SOURCES =

# Target Platform
FAMILY ?= artix7
PART ?= xc7a200tfbg484-3
BOARD ?= cle215plus
XDC ?= src/constr/${BOARD}.xdc
CHIPDB ?= ./chipdb
JTAG_LINK ?= digilent_hs2

include ./openXC7.mk

ifeq (${BOARD},cle215plus)
# openFPGALoader was unable to configure CLE215(+), so using openocd instead...
program: ${PROJECT}.bit
ifeq (${JTAG_LINK},digilent_hs2)
	openocd -c "adapter driver ftdi" \
		-c "ftdi vid_pid 0x0403 0x6014" \
		-c "ftdi channel 0" \
		-c "reset_config none" \
		-c "ftdi layout_init 0x00e8 0x60eb" \
		-c "source [find cpld/xilinx-xc7.cfg]" \
		-c "adapter speed 4000" \
		-c "init" \
		-c "pld load 0 $^" \
		-c "shutdown"
else
ifeq (${JTAG_LINK},ft2232)
		-c "ftdi vid_pid 0x0403 0x6010" \
		-c "ftdi channel 0" \
		-c "reset_config none" \
		-c "ftdi layout_init 0x0808 0x0b0b" \
		-c "source [find cpld/xilinx-xc7.cfg]" \
		-c "adapter speed 4000" \
		-c "init" \
		-c "pld load 0 $^" \
		-c "shutdown"
endif
endif
endif
