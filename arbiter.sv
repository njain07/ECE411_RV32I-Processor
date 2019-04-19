module cache_arbiter
(
	input logic 			clk,

	input logic				pmem_read_a,
	input logic [31:0]		pmem_addr_a,
	output logic			pmem_resp_a,
	output logic [255:0]	pmem_rdata_a,

	input logic				pmem_read_b,
							pmem_write_b,
	input logic [31:0]		pmem_addr_b,
	output logic			pmem_resp_b,
	output logic [255:0]	pmem_rdata_b,
	input logic [255:0]		pmem_wdata_b,

	input logic         	mem_resp,
  	output logic        	mem_read,
                        	mem_write,
  	input logic [255:0]   	mem_rdata,
  	output logic [255:0]  	mem_wdata,
  	output logic [31:0]   	mem_address
);

logic prefetch, prefetch_resp, prefetch_wait, prefetch_done, prefetch_in;
logic [31:0] lookahead_addr;

initial begin
	prefetch_done = 1;
end

register prefetch_addr
(
	.clk,
	.load((mem_read | mem_write) & ~prefetch),
	.in(mem_address),
	.out(lookahead_addr)
);

assign prefetch_wait = ~prefetch_resp;

always_comb
begin
	mem_wdata = pmem_wdata_b;
	pmem_rdata_a = 0;
	pmem_rdata_b = 0;
	pmem_resp_a = 0;
	pmem_resp_b = 0;
	mem_read = 0;
	mem_write = 0;
	mem_address = 0;
	prefetch_resp = 1;
	prefetch = 0;
	if (pmem_read_a & ~prefetch_wait) begin
		pmem_resp_a = mem_resp;
		mem_address = pmem_addr_a;
		mem_read = 1;
		mem_write = 0;
		pmem_rdata_a = mem_rdata;
	end else if ((pmem_read_b | pmem_write_b) & ~prefetch_wait) begin
		pmem_resp_b = mem_resp;
		mem_address = pmem_addr_b;
		mem_read = pmem_read_b;
		mem_write = pmem_write_b;
		pmem_rdata_b = mem_rdata;
	end	else if (~prefetch_done) begin
		prefetch = 1;
		prefetch_resp = mem_resp;
		mem_address = lookahead_addr + 32;
		mem_read = 1;
		mem_write = 0;
	end
end

always_ff @ (posedge clk) begin
	 if (pmem_read_a | pmem_read_b | pmem_write_b)
		prefetch_done <= 0;
	else if (prefetch_resp)
		prefetch_done <= 1;
end

endmodule // cache_arbiter
