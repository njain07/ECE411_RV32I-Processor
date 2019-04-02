module instr_read
(
    input logic     clk,
                    load,
                    resp_a,
    output logic    read_a
);

initial begin
	read_a = 1;
end

always_ff @ (posedge clk)
begin
	if (load)
		read_a <= 1;
	else
		if (resp_a)
			read_a <= 0;
end

endmodule
