module mp3
(
  input logic 				clk,
                      resp_a,
                      resp_b,

  input logic	[31:0]	rdata_a,
                      rdata_b,

  output logic				read_b,
                      write,
                      read_a,

  output logic [3:0] 	wmask,

  output logic [31:0]	address_a,
                      address_b,
                      wdata
);

cpu_datapath datapath(.*);


endmodule
