TOPLEVEL_LANG=vhdl
VHDL_SOURCES = $(PWD)/../src/i2c_master.vhd
TOPLEVEL=i2c_master
MODULE=i2c_master_tb
COMPILE_ARGS=--std=08 --ieee=synopsys
SIM=ghdl
SIM_ARGS=--wave=wave.ghw
include $(shell cocotb-config --makefiles)/Makefile.sim
