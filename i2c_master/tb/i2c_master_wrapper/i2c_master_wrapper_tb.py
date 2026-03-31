# -*- coding: utf-8 -*-
import cocotb
from cocotb.clock import Clock
from cocotb.triggers import Timer
from cocotb.regression import TestFactory
from cocotb.triggers import Timer, RisingEdge, FallingEdge, ClockCycles

@cocotb.test(timeout_time=3, timeout_unit='ms')
async def run_test(dut):
    PERIOD = 10
    cocotb.fork(Clock(dut.clk_in, PERIOD, 'ns').start(start_high=False))

    dut.reset_n = 0
    dut.start_in = 0
    dut.byte_cnt_in = 4
    dut.addr_in = 0x7a
    dut.rw_in = 0   # write 
    dut.data_wr_in = 0x8877050403020100
    dut.sda_o = 0
    dut.scl_o = 0

    await RisingEdge(dut.clk_in)
    await Timer(100*PERIOD, units='ns')
    dut.reset_n = 1
    
    await Timer(100*PERIOD, units='ns')
    dut.start_in = 1
    await Timer(PERIOD, units='ns')
    dut.start_in = 0
    dut._log.info("Start transactions")
    await RisingEdge(dut.ready_out)
    dut._log.info(str(dut.ready_out.value))



    await Timer(100*PERIOD, units='ns')
    dut.rw_in = 1 #read
    dut.start_in = 1
    dut.byte_cnt_in = 6
    await Timer(PERIOD, units='ns')
    dut.start_in = 0
    dut._log.info("Start transactions")
    await RisingEdge(dut.ready_out)
    dut._log.info(str(dut.ready_out.value))

    await Timer(100*PERIOD, units='ns')
    dut.rw_in = 0 #write
    dut.start_in = 1
    dut.byte_cnt_in = 6
    await Timer(PERIOD, units='ns')
    dut.start_in = 0
    dut._log.info("Start transactions")
    await RisingEdge(dut.ready_out)
    dut._log.info(str(dut.ready_out.value))
    
    ### One register write/read
    await Timer(100*PERIOD, units='ns')
    dut.rw_in = 1 #read
    dut.start_in = 1
    dut.byte_cnt_in = 1
    await Timer(PERIOD, units='ns')
    dut.start_in = 0
    dut._log.info("Start transactions")
    await RisingEdge(dut.ready_out)
    dut._log.info(str(dut.ready_out.value))
    
    await Timer(100*PERIOD, units='ns')
    dut.rw_in = 0 #write
    dut.start_in = 1
    dut.byte_cnt_in = 1
    await Timer(PERIOD, units='ns')
    dut.start_in = 0
    dut._log.info("Start transactions")
    await RisingEdge(dut.ready_out)
    dut._log.info(str(dut.ready_out.value))

    await Timer(1000*PERIOD, units='ns')

# Register the test.
factory = TestFactory(run_test)
# factory.generate_tests()
