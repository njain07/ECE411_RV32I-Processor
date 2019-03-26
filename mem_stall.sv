module mem_stall
(
  input logic   clk,
                read_a,
                read_b,
                write,
                resp_a,
                resp_b,
  output logic  load
);

always_comb
begin
    if (read_b || write)
        load = resp_b;
    else
        load = resp_a;
end

endmodule
