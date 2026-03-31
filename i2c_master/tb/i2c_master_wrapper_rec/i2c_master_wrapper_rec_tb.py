# -*- coding: utf-8 -*-
import cocotb
from cocotb.clock import Clock
from cocotb.triggers import Timer
from cocotb.regression import TestFactory
from cocotb.triggers import Timer, RisingEdge, FallingEdge, ClockCycles

@cocotb.test()
async def run_test(dut):
    PERIOD = 10
    cocotb.fork(Clock(dut.clk_in, PERIOD, 'ns').start(start_high=False))

    dut.reset_n = 0
    dut.start_in = 0
    dut.ready_out = 0

    dut.sda_o = 0
    dut.scl_o = 0

    await Timer(20*PERIOD, units='ns')
    dut.reset_n = 1

    await Timer(20*PERIOD, units='ns')
    dut.start_in = 1
    await Timer(PERIOD, units='ns')
    dut.start_in = 0

    await Timer(20*PERIOD, units='ns')
    await RisingEdge(dut.ready_out)
    dut._log.info(str(dut.ready_out.value))
    

    await Timer(1000*PERIOD, units='ns')

# Register the test.
factory = TestFactory(run_test)
    