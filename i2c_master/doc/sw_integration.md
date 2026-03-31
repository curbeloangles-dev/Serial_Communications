
 **Register table**

  | OFFSET | LABEL               |  R/W  | SC  | DESCRIPTION                                                                                                   | RESET VALUE |
  | :----: | ------------------- | :---: | --- | ------------------------------------------------------------------------------------------------------------- | ----------- |
  |  0x0   | **Version** |       |     |                                                                                                             |             |
  |        | _[31:0] Version_    |   R   | NO  | Version info                                                                                                  | 0x1         |
  |  0x4   | **Control** |       |     |                                                                                                               |             |
  |        | _[0] start_        |   W  | YES  | start signal when '1'                                                                            | 0x0         |
  |        | _[1] rw_        |  R/W  | NO  | Read -> '1';  write -> '0' | 0x0         |
  |        | _[5:2] byte count_        |  R/W  | NO  | Bytes to read or write | 0x0         |
  |        | _[31:6] Reserved_   |       |     | Reserved                                                                                                      |             |
  |  0x8   | **Status**    |       |     |                                                                                                         |             |
  |        | _[0] ready_        |   R  | NO  | Ready when '1'                                                                            | 0x0         |
  |        | _[1] ack_error_        |  R  | NO  | acknowledge error from slave when '1' | 0x0         |
  |        | _[2] busy_        |  R  | NO  | transaction in progress when '1' | 0x0         |
  |        | _[31:3] Reserved_   |       |     | Reserved                                                                                                      |             |
  |  0xC   | **addr**    |       |     |                                                                                                         |             |
  |        | _[6:0] addr_        |   W/R  | NO  | address of target slave                                                                            | 0x0         |
  |        | _[31:7] Reserved_   |       |     | Reserved                                                                                                      |             |
  |  0x10  | **data_wr_low**    |       |     |                                                                                                         |             |
  |        | _[7:0] data_wr_0_        |   W/R  | NO  | byte to write to slave                                                                            | 0x0         |
  |        | _[15:8] data_wr_1_        |   W/R  | NO  | byte to write to slave                                                                            | 0x0         |
  |        | _[23:16] data_wr_2_        |   W/R  | NO  | byte to write to slave                                                                            | 0x0         |
  |        | _[31:24] data_wr_3_        |   W/R  | NO  | byte to write to slave                                                                            | 0x0         |
  |  0x14  | **data_wr_high**    |       |     |                                                                                                         |             |
  |        | _[7:0] data_wr_4_        |   W/R  | NO  | byte to write to slave                                                                            | 0x0         |
  |        | _[15:8] data_wr_5_        |   W/R  | NO  | byte to write to slave                                                                            | 0x0         |
  |        | _[23:16] data_wr_6_        |   W/R  | NO  | byte to write to slave                                                                            | 0x0         |
  |        | _[31:24] data_wr_7_        |   W/R  | NO  | byte to write to slave                                                                            | 0x0         |
  |  0x18  | **data_rd_low**    |       |     |                                                                                                         |             |
  |        | _[7:0] data_rd_0_        |   R  | NO  | byte read from slave                                                                            | 0x0         |
  |        | _[15:8] data_rd_1_        |   R  | NO  | byte read from slave                                                                            | 0x0         |
  |        | _[23:16] data_rd_2_        |   R  | NO  | byte read from slave                                                                            | 0x0         |
  |        | _[31:24] data_rd_3_        |   R  | NO  | byte read to slave                                                                            | 0x0         |
  |  0x1C  | **data_rd_high**    |       |     |                                                                                                         |             |
  |        | _[7:0] data_rd_4_        |   R  | NO  | byte read from slave                                                                            | 0x0         |
  |        | _[15:8] data_rd_5_        |   R  | NO  | byte read from slave                                                                            | 0x0         |
  |        | _[23:16] data_rd_6_        |   R  | NO  | byte read from slave                                                                            | 0x0         |
  |        | _[31:24] data_rd_7_        |   R  | NO  | byte read from slave                                                                            | 0x0         |
 
 