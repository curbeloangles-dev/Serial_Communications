import cocotb
from cocotb.triggers import Timer, RisingEdge, FallingEdge, ClockCycles
from cocotb.result import TestFailure
from cocotb.clock import Clock
from cocotb_bus.drivers.amba import  AXI4LiteMaster, AXIProtocolError
from cocotb import coroutine

# Constants
c_CLK_PERIOD = 10 #ns

@cocotb.test(skip = False, stage = 1)
def i2c_master_tb(dut):
    # Setting up clocks
    clk_100MHz = Clock(dut.clk, c_CLK_PERIOD, units='ns')
    cocotb.fork(clk_100MHz.start(start_high=False))

    # Setting init values
    dut.reset_n <= 1
    dut.ena <= 0
    dut.addr <= 0
    dut.rw <= 0
    dut.data_wr <= 0    

    # Write data
    yield Timer(20*c_CLK_PERIOD, units='ns')
    yield RisingEdge(dut.clk)
    dut.ena <= 1
    dut.addr <= 0x04
    dut.rw <= 0
    dut.data_wr <= 0x00
    yield RisingEdge(dut.busy)
    dut.data_wr <= 0x01
    # Start condition
    yield FallingEdge(dut.sda_i)
    scl = str(dut.scl_t.value)
    if (scl == "1"):
        dut._log.info("Start condition")

    # Slave acknowledge address
    for i in range(9):
        yield FallingEdge(dut.scl_t)
        if i == 8:
            while (str(dut.scl_t.value)=='0'):
                dut.sda_o <= 0
                yield RisingEdge(dut.clk)
            dut._log.info("Slave acknowledge")

    # Slave acknowledge data
    for i in range(9):
        yield FallingEdge(dut.scl_t)
        if i == 8:
            while (str(dut.scl_t.value)=='0'):
                dut.sda_o <= 0
                yield RisingEdge(dut.clk)
            dut._log.info("Slave acknowledge")

    # Slave acknowledge data
    for i in range(9):
        yield FallingEdge(dut.scl_t)
        if i == 8:
            dut.data_wr <= 0xAA
            while (str(dut.scl_t.value)=='0'):
                dut.sda_o <= 0
                yield RisingEdge(dut.clk)
            dut._log.info("Slave acknowledge")

    # Slave acknowledge data
    for i in range(9):
        yield FallingEdge(dut.scl_t)
        if i == 8:
            dut.ena <= 0
            while (str(dut.scl_t.value)=='0'):
                dut.sda_o <= 0
                yield RisingEdge(dut.clk)
            dut._log.info("Slave acknowledge")
    
    # Stop condition
    sda_o = str(dut.sda_i.value)
    while (sda_o == '0'):
        sda_o = str(dut.sda_i.value)
        yield RisingEdge(dut.clk)

    scl = str(dut.scl_t.value)
    if (scl == "1"):
        dut._log.info("Stop condition")

    yield Timer(5000*c_CLK_PERIOD, units='ns') 

    # Issue a read command
    # Write data
    yield Timer(20*c_CLK_PERIOD, units='ns')
    yield RisingEdge(dut.clk)
    dut.ena <= 1
    dut.addr <= 0x04
    dut.rw <= 0
    dut.data_wr <= 0x00
    yield RisingEdge(dut.busy)
    dut.data_wr <= 0x01
    # Start condition
    yield FallingEdge(dut.sda_i)
    scl = str(dut.scl_t.value)
    if (scl == "1"):
        dut._log.info("Start condition")

    # Slave acknowledge address
    for i in range(9):
        yield FallingEdge(dut.scl_t)
        if i == 8:
            while (str(dut.scl_t.value)=='0'):
                dut.sda_o <= 0
                yield RisingEdge(dut.clk)
            dut._log.info("Slave acknowledge")

    # Slave acknowledge data
    for i in range(9):
        yield FallingEdge(dut.scl_t)
        if i == 8:
            while (str(dut.scl_t.value)=='0'):
                dut.sda_o <= 0
                yield RisingEdge(dut.clk)
            dut._log.info("Slave acknowledge")
    # Slave acknowledge data
    for i in range(9):
        yield FallingEdge(dut.scl_t)
        if i == 8:
            dut.ena <= 1
            dut.rw <= 1
            dut.addr <= 0x04
            dut.data_wr <= 0xFF
            while (str(dut.scl_t.value)=='0'):
                #dut.sda_o <= 0
                yield RisingEdge(dut.clk)
            dut._log.info("Slave acknowledge") 

    # Start condition
    yield FallingEdge(dut.sda_i)
    scl = str(dut.scl_t.value)
    if (scl == "1"):
        dut._log.info("Start condition")

    yield RisingEdge(dut.busy)
    dut.ena <= 0
    dut.rw <= 0
    
    # Slave acknowledge read
    for i in range(9):
        yield FallingEdge(dut.scl_t)
        if i == 8:
            while (str(dut.scl_t.value)=='0'):
                #dut.sda_o <= 0
                yield RisingEdge(dut.clk)
            dut._log.info("Slave acknowledge")
    # Slave data
    for i in range(9):
        yield FallingEdge(dut.scl_t)
        if i == 3:
            dut.ena <= 0
        if i != 8:
            while (str(dut.scl_t.value)=='0'):
                #dut.sda_o <= 1
                yield RisingEdge(dut.clk)
    dut._log.info("Slave data")

    # Stop condition
    sda_o = str(dut.sda_i.value)
    while (sda_o == '0'):
        sda_o = str(dut.sda_i.value)
        yield RisingEdge(dut.clk)

    scl = str(dut.scl_t.value)
    if (scl == "1"):
        dut._log.info("Stop condition")

    yield Timer(5000*c_CLK_PERIOD, units='ns') 