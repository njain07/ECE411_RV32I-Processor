module cache_stats
(
	input logic 	clk,
					instr_access,
					instr_resp,
					data_access,
					data_resp,
					l2_access,
					l2_resp
);

logic [31:0] num_instr_access, num_data_access, num_l1_access, num_l2_access;
logic [31:0] instr_miss, data_miss, l1_miss, l2_miss;

initial begin
	num_instr_access = 0;
	num_data_access = 0;
	num_l2_access = 0;
	instr_miss = 0;
	data_miss = 0;
	l1_miss = 0;
	l2_miss = 0;
end

assign num_l1_access = num_instr_access + num_data_access;
assign l1_miss = instr_miss + data_miss;

always_ff @ (posedge clk)
begin 
	if (instr_access)
		if (instr_resp)
			num_instr_access <= num_instr_access + 1;
		else
			instr_miss <= instr_miss + 1;
	if (data_access)
		if (data_resp)
			num_data_access <= num_data_access + 1;
		else
			data_miss <= data_miss + 1;

	if (l2_access)
		if (l2_resp)
			num_l2_access <= num_l2_access + 1;
		else
			l2_miss <= l2_miss + 1;
end

endmodule