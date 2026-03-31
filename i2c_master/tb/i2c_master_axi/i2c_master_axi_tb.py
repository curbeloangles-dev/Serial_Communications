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
DATA_WR_L_OFFSET = 0x00000010
DATA_WR_H_OFFSET = 0x00000014
DATA_RD_L_OFFSET = 0x00000018
DATA_RD_H_OFFSET = 0x0000001C

def check(dut, act, exp):
    # Check
    if act != exp:
        raise TestFailure("Read = 0x%08X, Expected = 0x%08X" % (int(act), exp))

    dut._log.info("Correct!")

@cocotb.test()
def run_test(dut):
    PERIOD = 10
    cocotb.fork(Clock(dut.axi_aclk, PERIOD, 'ns').start(start_high=False))

    dut.axi_aclk = 0
    dut.axi_aresetn = 0
    dut.sda_o = 0
    dut.scl_o = 0

    yield Timer(20*PERIOD, units='ns')
    dut.axi_aresetn = 1
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
    check(dut, s_ready[31], 0x1)

    # Data write
    dut._log.info("AXI-Lite: Writing 0x%02X at address 0x%02X" % (0xa, ADDR_OFFSET))
    yield axil_m.write(ADDR_OFFSET, 0xa)
    yield axil_m.write(DATA_WR_L_OFFSET, 0x44332211)
    yield axil_m.write(DATA_WR_H_OFFSET, 0x88776655)
    # write data width
    data_width=0x2
    yield axil_m.write(CONTROL_OFFSET, (data_width<<2))
    # write start
    yield axil_m.write(CONTROL_OFFSET, 0x1 | (data_width<<2))
    yield Timer(20*PERIOD, units='ns')

    ready_status = yield axil_m.read(STATUS_OFFSET)
    while int(ready_status[31]) == 0:
        ready_status = yield axil_m.read(STATUS_OFFSET)
        yield Timer(2000*PERIOD, units='ns')
        if int(ready_status[31]) == 0:
            dut._log.info("Waiting for ready")
        else:
            dut._log.info("Ready!!")

    yield Timer(2000*PERIOD, units='ns')

    # Data read
    yield axil_m.write(ADDR_OFFSET, 0xf)
    # read data width
    data_width=0x5
    yield axil_m.write(CONTROL_OFFSET, (data_width<<2))
    # write start & read
    yield axil_m.write(CONTROL_OFFSET, 0x3 | (data_width<<2))
    yield Timer(20*PERIOD, units='ns')

    ready_status = yield axil_m.read(STATUS_OFFSET)
    while int(ready_status[31]) == 0:
        ready_status = yield axil_m.read(STATUS_OFFSET)
        yield Timer(2000*PERIOD, units='ns')
        if int(ready_status[31]) == 0:
            dut._log.info("Waiting for ready")
        else:
            dut._log.info("Ready!!")

    # Data read 1 byte
    yield axil_m.write(ADDR_OFFSET, 0xf)
    # read data width
    data_width=0x1
    yield axil_m.write(CONTROL_OFFSET, (data_width<<2))
    # write start & read
    yield axil_m.write(CONTROL_OFFSET, 0x3 | (data_width<<2))
    yield Timer(20*PERIOD, units='ns')

    ready_status = yield axil_m.read(STATUS_OFFSET)
    while int(ready_status[31]) == 0:
        ready_status = yield axil_m.read(STATUS_OFFSET)
        yield Timer(2000*PERIOD, units='ns')
        if int(ready_status[31]) == 0:
            dut._log.info("Waiting for ready")
        else:
            dut._log.info("Ready!!")

    s_data_l = yield axil_m.read(DATA_RD_L_OFFSET)
    s_data_h = yield axil_m.read(DATA_RD_H_OFFSET)
    dut._log.info(s_data_l)
    dut._log.info(s_data_h)

    yield Timer(2000*PERIOD, units='ns')

# Register the test.
factory = TestFactory(run_test)
    