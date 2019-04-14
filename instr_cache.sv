module instr_cache
(
    input logic           clk,
                          read_a,
    input logic [31:0]    address_a,
    output logic [31:0]   rdata_a,
    output logic          resp_a,

    input logic           pmem_resp_a,
    output logic          pmem_read_a,

    input logic [255:0]   pmem_rdata_a,
    output logic [31:0]   pmem_addr_a
);

logic array_read, array_load, pmdr_load, lru_load, dirty_load, eviction;
logic hit;
logic datareadmux_sel, datawritemux_sel, adaptermux_sel, pmemaddrmux_sel;

cache_datapath instr_datapath
(   .*,
    .mem_write(1'b0),
    .mem_read(read_a),
    .mem_byte_enable(4'b1111),
    .mem_address(address_a),
    .mem_wdata(32'd0),
    .mem_rdata(rdata_a),
    .pmem_rdata(pmem_rdata_a),
    .pmem_wdata(),
    .pmem_address(pmem_addr_a)
);

cache_control instr_control
(
    .*,
    .mem_write(1'b0),
    .mem_read(read_a),
    .mem_byte_enable(4'b1111),
    .mem_resp(resp_a),
    .pmem_resp(pmem_resp_a),
    .pmem_write(),
    .pmem_read(pmem_read_a)
);

endmodule
