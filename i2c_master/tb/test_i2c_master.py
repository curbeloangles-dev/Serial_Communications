from    cocotb_test.simulator import run
import  pytest
import  os

current_dir = os.path.dirname(os.path.abspath(__file__))

@pytest.mark.skipif(os.getenv("SIM") != "ghdl", reason="")
def test_i2c_master():
    run(
        vhdl_sources=[
            os.path.join(current_dir, "../src/i2c_master.vhd"),
        ],
        toplevel="i2c_master",
        module="i2c_master_tb",
        toplevel_lang="vhdl",
        compile_args=["--std=08", "--ieee=synopsys"],
        sim_args=["--wave=wave.ghw"],
        sim_build="sim_build",
    )
