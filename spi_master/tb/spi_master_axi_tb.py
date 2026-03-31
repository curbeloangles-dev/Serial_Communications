# -*- coding: utf-8 -*-
import cocotb
from cocotb.clock import Clock
from cocotb.triggers import Timer
from cocotb.regression import TestFactory
from cocotb.triggers import Timer, RisingEdge, FallingEdge, ClockCycles
from cocotb.result import TestFailure
from cocotb_bus.drivers.amba import  AXI4LiteMaster, AXIProtocolError

# Address
VERSION_OFFSET = 0x00000000
CONTROL_OFFSET = 0x00000004
STATUS_OFFSET = 0x00000008
ADDR_OFFSET = 0x0000000C
DATA_WR = 0x00000010
DATA_RD = 0x00000014

def check(dut, act, exp):
    # Check
    if act != exp:
        raise TestFailure("Read = 0x%08X, Expected = 0x%08X" % (int(act), exp))

    dut._log.info("Correct!")

@cocotb.test()
def run_test(dut):
    PERIOD = 10
    cocotb.fork(Clock(dut.axi_aclk, PERIOD, 'ns').start(start_high=False))
    cocotb.fork(Clock(dut.clock, PERIOD, 'ns').start(start_high=False))

    dut.clock = 0
    dut.reset_n = 0
    dut.miso = 0
    dut.axi_aclk = 0
    dut.axi_aresetn = 0

    yield Timer(20*PERIOD, units='ns')
    dut.axi_aresetn = 1
    dut.reset_n = 1
    yield Timer(200*PERIOD, units='ns')

    # AXI-Lite Master object
    axil_m = AXI4LiteMaster(dut, "s_axi", dut.axi_aclk)
    yield Timer(20*PERIOD, units='ns')

    # AXI-Lite read VERSION
    dut._log.info("AXI-Lite: Reading address 0x%02X" % (VERSION_OFFSET))
    s_version = yield axil_m.read(VERSION_OFFSET)
    s_ready = yield axil_m.read(STATUS_OFFSET)
    dut._log.info(s_ready)
    # Check
    check(dut, s_version, 0x1)
    check(dut, s_ready[31], 0x0)

    # Data write
    dut._log.info("AXI-Lite: Writing 0x%02X at address 0x%02X" % (0xa, ADDR_OFFSET))
    yield axil_m.write(ADDR_OFFSET, 0xa)
    yield axil_m.write(DATA_WR, 0x44332211)
    # write control register
    yield axil_m.write(CONTROL_OFFSET, (1<<2) | (1<<1) | 1)
    yield Timer(20*PERIOD, units='ns')

    ready_status = yield axil_m.read(STATUS_OFFSET)
    while int(ready_status[31]) == 0:
        ready_status = yield axil_m.read(STATUS_OFFSET)
        yield Timer(200*PERIOD, units='ns')
        if int(ready_status[31]) == 0:
            dut._log.info("Waiting for ready")
        else:
            dut._log.info("Ready!!")

    yield Timer(2000*PERIOD, units='ns')    

    # Data read
    data_read = yield axil_m.read(DATA_RD)

    yield Timer(2000*PERIOD, units='ns')



# Register the test.
factory = TestFactory(run_test)
    