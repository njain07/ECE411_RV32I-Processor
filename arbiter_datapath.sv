module arbiter_datapath
(
    input logic 			clk,

    input logic [31:0]		pmem_addr_a,
    output logic [255:0]	pmem_rdata_a,

    input logic [31:0]		pmem_addr_b,
    output logic [255:0]	pmem_rdata_b,
    input logic [255:0]		pmem_wdata_b,

    input logic [255:0]   	mem_rdata,
    output logic [255:0]  	mem_wdata,
    output logic [31:0]   	mem_address,

    input logic             req_a,
                            req_b,
                            load_prefetch,
    input logic [1:0]       addrmux_sel
);

logic [31:0] lookahead_addr;

assign mem_wdata = pmem_wdata_b;

register prefetch_addr
(
	.clk,
	.load(load_prefetch),
	.in(mem_address),
	.out(lookahead_addr)
);

mux4 addrmux
(
	.sel(addrmux_sel),
	.a(pmem_addr_a),
	.b(pmem_addr_b),
	.c(lookahead_addr + 32),
	.d(),
	.f(mem_address)
);

mux2 #(.width(256)) rdatamuxa
(
	.sel(req_a),
	.a(256'd0),
	.b(mem_rdata),
	.f(pmem_rdata_a)
);

mux2 #(.width(256)) rdatamuxb
(
	.sel(req_b),
	.a(256'd0),
	.b(mem_rdata),
	.f(pmem_rdata_b)
);


endmodule
