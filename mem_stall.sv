module mem_stall
(
  input logic   clk,
                read_a,
                read_b,
                write,
                resp_a,
                resp_b,
  output logic  load,
                pc_load
);

always_comb
begin
    if (read_b || write) begin
        load = resp_b;
        pc_load = resp_a;
    end else begin
        pc_load = resp_a;
        load = resp_a;
    end
end

endmodule
