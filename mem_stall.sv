module mem_stall
(
  input logic   clk,
                read_b,
                write,
                resp_b,
  output logic  load
);

always_comb
begin
  load = 1;
  // if (read_b || write)
  //   load <= resp_b;
end

endmodule
