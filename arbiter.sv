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

logic req_a, req_b, load_prefetch;
logic [1:0] addrmux_sel;

arbiter_datapath arbiter_datapath(.*);
arbiter_control arbiter_control(.*);

endmodule // cache_arbiter
