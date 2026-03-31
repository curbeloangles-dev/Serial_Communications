from    cocotb_test.simulator import run
import  pytest
import  os
import  glob

current_dir = os.path.dirname(os.path.abspath(__file__))
sources_list = glob.glob(os.path.join(current_dir, "../../src/*.vhd"))

@pytest.mark.skipif(os.getenv("SIM") != "ghdl", reason="")
def test_i2c_master_wrapper():
    run(
        vhdl_sources=[os.path.join(current_dir, file) for file in sources_list],         # sources
        toplevel="i2c_master_wrapper",
        module="i2c_master_wrapper_tb",
        toplevel_lang="vhdl",
        compile_args=["--std=08", "--ieee=synopsys"],
        sim_args=["--wave=wave.ghw"],
        sim_build="sim_build",
    )
