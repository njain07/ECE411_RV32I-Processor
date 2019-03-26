module data_cache
(
    input logic           clk,
                          read_b,
                          write,
    input logic [3:0]     wmask,
    input logic [31:0]    address_b,
                          wdata,
    output logic [31:0]   rdata_b,
    output logic          resp_b,

    input logic           pmem_resp_b,
    output logic          pmem_read_b,
                          pmem_write_b,

    input logic [255:0]   pmem_rdata_b,
    output logic [255:0]  pmem_wdata_b,
    output logic [31:0]   pmem_addr_b
);

logic array_read, array1_load, array2_load, pmdr_load, lru_load;
logic [1:0] dirty_load, dirty_out;
logic hit, way, lru_out;
logic datareadmux_sel, datawritemux_sel, adaptermux_sel, pmemaddrmux_sel;

cache_datapath data_datapath
(   .*,
    .mem_write(write),
    .mem_read(read_b),
    .mem_byte_enable(wmask),
    .mem_address(address_b),
    .mem_wdata(wdata),
    .mem_rdata(rdata_b),
    .pmem_rdata(pmem_rdata_b),
    .pmem_wdata(pmem_wdata_b),
    .pmem_address(pmem_addr_b)
);

cache_control data_control
(
    .*,
    .mem_write(write),
    .mem_read(read_b),
    .mem_byte_enable(wmask),
    .mem_resp(resp_b),
    .pmem_resp(pmem_resp_b),
    .pmem_write(pmem_write_b),
    .pmem_read(pmem_read_b)
);

endmodule
