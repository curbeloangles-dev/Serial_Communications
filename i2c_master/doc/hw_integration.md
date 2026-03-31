# Entity: i2c_master_axi

## Diagram

![Diagram](hw_integration.svg "Diagram")
## Description

Maps i2c master registers into axi-lite

## Generics

| Generic name     | Type    | Value       | Description                                |
| ---------------- | ------- | ----------- | ------------------------------------------ |
| g_axi_addr_width | integer | 32          |                                            |
| g_input_clk      | integer | 100_000_000 |  input clock speed from user logic in Hz   |
| g_bus_clk        | integer | 100_000     |  speed the i2c bus (scl) will run at in Hz |
## Ports

| Port name       | Direction | Type        | Description                                     |
| --------------- | --------- | ----------- | ----------------------------------------------- |
| axi_aclk        | in        | std_logic   |                                                 |
| axi_aresetn     | in        | std_logic   |                                                 |
| sda_o           | in        | std_logic   |  serial data input of i2c bus                   |
| sda_i           | out       | std_logic   |  serial data output of i2c bus                  |
| sda_t           | out       | std_logic   |  serial data tristate of i2c bus                |
| scl_o           | in        | std_logic   |  serial clock input of i2c bus                  |
| scl_i           | out       | std_logic   |  serial clock output of i2c bus                 |
| scl_t           | out       | std_logic   |  serial clock tristate of i2c bus               |
| axi_lite_config | in        | Virtual bus |  an AXI4-Lite interface to write core registers |
### Virtual Buses

#### axi_lite_config

| Port name     | Direction | Type                                            | Description |
| ------------- | --------- | ----------------------------------------------- | ----------- |
| s_axi_awaddr  | in        | std_logic_vector(g_axi_addr_width - 1 downto 0) |             |
| s_axi_awprot  | in        | std_logic_vector(2 downto 0)                    |             |
| s_axi_awvalid | in        | std_logic                                       |             |
| s_axi_awready | out       | std_logic                                       |             |
| s_axi_wdata   | in        | std_logic_vector(31 downto 0)                   |             |
| s_axi_wstrb   | in        | std_logic_vector(3 downto 0)                    |             |
| s_axi_wvalid  | in        | std_logic                                       |             |
| s_axi_wready  | out       | std_logic                                       |             |
| s_axi_araddr  | in        | std_logic_vector(g_axi_addr_width - 1 downto 0) |             |
| s_axi_arprot  | in        | std_logic_vector(2 downto 0)                    |             |
| s_axi_arvalid | in        | std_logic                                       |             |
| s_axi_arready | out       | std_logic                                       |             |
| s_axi_rdata   | out       | std_logic_vector(31 downto 0)                   |             |
| s_axi_rresp   | out       | std_logic_vector(1 downto 0)                    |             |
| s_axi_rvalid  | out       | std_logic                                       |             |
| s_axi_rready  | in        | std_logic                                       |             |
| s_axi_bresp   | out       | std_logic_vector(1 downto 0)                    |             |
| s_axi_bvalid  | out       | std_logic                                       |             |
| s_axi_bready  | in        | std_logic                                       |             |

