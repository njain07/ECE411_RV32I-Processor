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

	input logic         	pmem_resp,
  	output logic        	pmem_read,
                        	pmem_write,
  	input logic [255:0]   	pmem_rdata,
  	output logic [255:0]  	pmem_wdata,
  	output logic [31:0]   	pmem_address
);

always_comb
begin
	pmem_wdata = pmem_wdata_b;
	pmem_rdata_a = 0;
	pmem_rdata_b = 0;
	pmem_resp_a = 0;
	pmem_resp_b = 0;
	pmem_read = 0;
	pmem_write = 0;
	pmem_wdata = 0;
	pmem_address = 0;
	if (pmem_read_a) begin
		pmem_resp_a = pmem_resp;
		pmem_address = pmem_addr_a;
		pmem_read = 1;
		pmem_write = 0;
		pmem_rdata_a = pmem_rdata;
	end else if (pmem_read_b || pmem_write_b) begin
		pmem_resp_b = pmem_resp;
		pmem_address = pmem_addr_b;
		pmem_read = pmem_read_b;
		pmem_write = pmem_write_b;
		pmem_rdata_b = pmem_rdata;
	end
end

endmodule // cache_arbiter
