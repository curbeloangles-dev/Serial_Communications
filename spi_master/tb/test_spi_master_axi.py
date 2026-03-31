from    cocotb_test.simulator import run
import  pytest
import  os

current_dir = os.path.dirname(os.path.abspath(__file__))

@pytest.mark.skipif(os.getenv("SIM") != "ghdl", reason="")
def test_spi_master_axi():
    run(
        vhdl_sources=[
            os.path.join(current_dir, "../src/spi_interface_regs_pkg.vhd"),
            os.path.join(current_dir, "../src/spi_master_pkg.vhd"),
            os.path.join(current_dir, "../src/spi_master.vhd"),
            os.path.join(current_dir, "../src/spi_interface_regs.vhd"),
            os.path.join(current_dir, "../src/spi_master_axi.vhd"),
        ],
        toplevel="spi_master_axi",
        module="spi_master_axi_tb",
        toplevel_lang="vhdl",
        compile_args=["--std=08", "--ieee=synopsys"],
        sim_args=["--wave=wave.ghw"],
        sim_build="sim_build",
    )
