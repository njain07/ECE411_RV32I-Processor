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


always_comb
begin
	mem_wdata = pmem_wdata_b;
	pmem_rdata_a = 0;
	pmem_rdata_b = 0;
	pmem_resp_a = 0;
	pmem_resp_b = 0;
	mem_read = 0;
	mem_write = 0;
	mem_wdata = 0;
	mem_address = 0;
	if (pmem_read_a) begin
		pmem_resp_a = mem_resp;
		mem_address = pmem_addr_a;
		mem_read = 1;
		mem_write = 0;
		pmem_rdata_a = mem_rdata;
	end else if (pmem_read_b || pmem_write_b) begin
		pmem_resp_b = mem_resp;
		mem_address = pmem_addr_b;
		mem_read = pmem_read_b;
		mem_write = pmem_write_b;
		pmem_rdata_b = mem_rdata;
	end
end

endmodule // cache_arbiter
