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

logic read_a, read_b, write_b, resp_a, resp_b;
logic [31:0] addr_a, addr_b;
logic [255:0] wdata_b, rdata;

initial begin
	read_a = 0;
	addr_a = 0;
	read_b = 0;
	write_b = 0;
	addr_b = 0;
	wdata_b = 0;
	resp_a = 0;
	resp_b = 0;
	rdata = 0;
end


always_ff @ (posedge clk)
begin
	read_a <= pmem_read_a;
	addr_a <= pmem_addr_a;
	read_b <= pmem_read_b;
	write_b <= pmem_write_b;
	addr_b <= pmem_addr_b;
	wdata_b <= pmem_wdata_b;
	resp_a <= pmem_read_a ? mem_resp : 0;
	resp_b <= ((pmem_read_b | pmem_write_b) & ~read_a) ? mem_resp : 0;
	rdata <= mem_rdata;
end


always_comb
begin
	pmem_resp_a = 0;
	pmem_resp_b = 0;
	mem_read = 0;
	mem_write = 0;
	pmem_rdata_a = 0;
	pmem_rdata_b = 0;
	mem_address = 0;
	mem_wdata = 0;
	if (read_a) begin
		pmem_resp_a = resp_a;
		mem_address = addr_a;
		mem_read = 1;
		mem_write = 0;
		pmem_rdata_a = rdata;
	end else if (read_b || write_b) begin
		pmem_resp_b = resp_b;
		mem_address = addr_b;
		mem_read = read_b;
		mem_write = write_b;
		pmem_rdata_b = rdata;
		mem_wdata = wdata_b;
	end
end

endmodule // cache_arbiter
