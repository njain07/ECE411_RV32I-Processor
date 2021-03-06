module l2_cache
(
    input logic           clk,
                          mem_read,
                          mem_write,
    input logic [31:0]    mem_address,
    input logic [255:0]   mem_wdata,
    output logic [255:0]  mem_rdata,
    output logic          mem_resp,

    input logic           pmem_resp,
    output logic          pmem_read,
                          pmem_write,
    input logic [255:0]   pmem_rdata,
    output logic [255:0]  pmem_wdata,
    output logic [31:0]   pmem_address
);

logic array_read, array_load, pmdr_load, lru_load, dirty_load, eviction;
logic hit;
logic datareadmux_sel, datawritemux_sel, adaptermux_sel, pmemaddrmux_sel;

cache_4way_datapath l2_datapath (.*);
cache_l2_control l2_control (.*, .mem_byte_enable(4'b1111));

endmodule : l2_cache
