module mp3
(
    input logic			  clk,
    input logic           pmem_resp,
    output logic          pmem_read,
                          pmem_write,
    input logic [255:0]   pmem_rdata,
    output logic [255:0]  pmem_wdata,
    output logic [31:0]   pmem_address
);

logic read_a, read_b, write, resp_a, resp_b;
logic [31:0] address_a, address_b;
logic [3:0] wmask;
logic [31:0] rdata_a, rdata_b, wdata;

cpu_datapath datapath(.*);
cache cache(.*);


endmodule
