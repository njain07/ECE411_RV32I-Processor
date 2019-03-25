module cache_arbiter
(
	input logic 		clk,
	
	input logic			read_a,
	input logic [31:0]	addr_a,
	output logic		resp_a,
	output logic 		rdata_a,

	input logic			read_b,
						write,
	input logic [31:0]	addr_b,
						wdata,
	output logic		resp_b,
	output logic 		rdata_b,

	input logic           pmem_resp,
    output logic          pmem_read,
                          pmem_write,
    input logic [255:0]   pmem_rdata,
    output logic [255:0]  pmem_wdata,
    output logic [31:0]   pmem_address
);

always_comb
begin
	pmem_wdata = wdata;
	rdata_a = 0;
	rdata_b = 0;
	resp_a = 0;
	resp_b = 0;
	if (read_a) begin
		resp_a = pmem_resp;
		pmem_address = addr_a;
		pmem_read = 1;
		pmem_write = 0;
		rdata_a = pmem_rdata;
	end else if (read_b || write) begin
		resp_b = pmem_resp;
		pmem_address = addr_b;
		pmem_read = read_b;
		pmem_write = write;
		rdata_b = pmem_rdata;
	end
end

endmodule // cache_arbiter
