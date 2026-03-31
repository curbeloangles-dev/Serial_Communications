TOPLEVEL_LANG=vhdl
VHDL_SOURCES = $(PWD)/../../src/spi_master_axi.vhd
VHDL_SOURCES += $(PWD)/../../src/spi_master_pkg.vhd
VHDL_SOURCES += $(PWD)/../../src/spi_master.vhd
VHDL_SOURCES += $(PWD)/../../src/spi_interface_regs.vhd
VHDL_SOURCES += $(PWD)/../../src/spi_interface_regs_pkg.vhd
TOPLEVEL=spi_master_axi
MODULE=spi_master_axi_tb
COMPILE_ARGS=--std=08 --ieee=synopsys
SIM=ghdl
SIM_ARGS=--wave=wave.ghw
include $(shell cocotb-config --makefiles)/Makefile.sim
