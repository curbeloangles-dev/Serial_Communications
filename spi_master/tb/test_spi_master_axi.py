import  glob
from    cocotb_test.simulator import run
import  pytest
import  os

current_dir = os.path.dirname(os.path.abspath(__file__))
sources_list = glob.glob(current_dir+"/../src/*.vhd")
@pytest.mark.skipif(os.getenv("SIM") != "ghdl", reason="")
def test_spi_master_axi():
    run(
        vhdl_sources=[os.path.join(current_dir, file) for file in sources_list],         # sources
        toplevel="spi_master_axi",
        module="spi_master_axi_tb",
        toplevel_lang="vhdl",
        compile_args=["--std=08", "--ieee=synopsys"],
        sim_args=["--wave=wave.ghw"],
        sim_build="sim_build",
    )
