module cache_stats
(
	input logic 		clk,
						instr_access,
						instr_resp,
						data_access,
						data_resp,

	output logic [31:0]	num_instr_access,
						num_data_access,
						num_l1_access,
						instr_cycles,
						data_cycles,
						l1_cycles
);


initial begin
	num_instr_access = 0;
	num_data_access = 0;
	instr_cycles = 0;
	data_cycles = 0;
end

assign num_l1_access = num_instr_access + num_data_access;
assign l1_cycles = instr_cycles + data_cycles;

always_ff @ (posedge clk)
begin
	if (instr_access)
		if (instr_resp)
			num_instr_access <= num_instr_access + 1;
		else
			instr_cycles <= instr_cycles + 1;
	if (data_access)
		if (data_resp)
			num_data_access <= num_data_access + 1;
		else
			data_cycles <= data_cycles + 1;
end
endmodule
