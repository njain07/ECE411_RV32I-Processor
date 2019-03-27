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

logic load_a, load_b;
always_comb begin
    load_a = 1;
    load_b = 1;
    if (read_b || write)
        load_b = resp_b;
    if (read_a)
        load_a = resp_a;
    load = load_a && load_b;
end



endmodule
