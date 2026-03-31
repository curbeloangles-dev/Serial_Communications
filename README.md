# Serial Communications
This repository contains serial communication master modules implemented in VHDL, with testbenches written for cocotb/pytest. Each subdirectory implements a specific serial protocol and contains documentation, source files, and testbenches.

## Contents
- `i2c_master/` — I2C master with AXI-Lite register interface. Supports multi-byte read/write transactions (up to 8 bytes) to any 7-bit addressed slave.
- `spi_master/` — SPI master with AXI-Lite register interface. Configurable number of slaves, data width, and clock divider.

Each module follows a common folder layout:
- `package.json` — Metadata for packaging/publishing the IP (name, version).
- `doc/` — Diagrams and additional documentation.
- `src/` — VHDL source files.
- `tb/` — Testbenches and unit tests (cocotb + pytest).

## Per-module descriptions
### i2c_master
I2C master with AXI-Lite slave interface. The design is structured in layers: a bit-level I2C core (`i2c_master`) handles SCL/SDA generation and the 9-state protocol FSM; a multi-byte wrapper (`i2c_master_wrapper`) sequences up to 8 consecutive bytes per transaction; and a top-level AXI-Lite module (`i2c_master_axi`) exposes the core through a register map. The clock speed (`g_input_clk`, `g_bus_clk`) is configurable via generics, supporting Standard-mode (100 kHz) and Fast-mode (400 kHz). SDA and SCL are exposed as tristate signals (`_o`/`_i`/`_t`) for use with IOBUF primitives.

### spi_master
SPI master with AXI-Lite slave interface. Supports a configurable number of chip-select lines (`g_slaves`), data bus width (`g_d_width`), and clock divider (`g_clk_div`). Exposes a simple register interface for initiating transactions and reading back received data.

## Running tests locally
These projects use cocotb and pytest for Python-based testbenches. To run tests locally:

1. Install simulator and Python dependencies (example for GHDL + cocotb):
```bash
sudo apt-get update
sudo apt-get install -y ghdl
python3 -m pip install --user cocotb pytest cocotb-test cocotb-bus
```

2. Run a module's pytest test from its `tb/` directory, for example:
```bash
pytest -o log_cli=True ./i2c_master/tb/test_i2c_master_axi.py
```

## Contributing
- Update or add tests when changing behavior.
- Keep `package.json/version` bumped when you want the CI to publish a new package version.
- Open PRs for changes and ensure CI passes before merge.
