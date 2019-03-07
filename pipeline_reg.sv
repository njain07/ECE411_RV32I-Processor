import rv32i_types::*;

module if_id_reg
(
  input logic           clk,
                        load,
  input logic [31:0]    instr_in,
                        pc_in,
  output logic [31:0]   instr_out,
                        pc_out
);

logic [31:0] instr, pc;

initial
begin
    instr = 1'b0;
end

always_ff @(posedge clk)
begin
    if (load)
    begin
        instr <= instr_in;
        pc <= pc_in;
    end
end

always_comb
begin
    instr_out = instr;
    pc_out = pc;
end

endmodule : if_id_reg


module id_ex_reg
(
  input logic           clk,
                        load,

  input rv32i_control_word controlw_in,
  output rv32i_control_word controlw_out,

  input logic [31:0]    pc_in,
                        i_imm_in,
                        s_imm_in,
                        b_imm_in,
                        u_imm_in,
                        j_imm_in,
                        rs1out_in,
                        rs2out_in,

  input logic [2:0]     funct3_in,
  input logic [6:0]     funct7_in,


  output logic [31:0]   pc_out,
                        i_imm_out,
                        s_imm_out,
                        b_imm_out,
                        u_imm_out,
                        j_imm_out,
                        rs1out_out,
                        rs2out_out,

  output logic [2:0]    funct3_out,
  output logic [6:0]    funct7_out
);

rv32i_control_word controlw;
logic [2:0] funct3;
logic [6:0] funct7;
logic [31:0] pc, i_imm;
logic [31:0] s_imm, b_imm, u_imm, j_imm, rs1out, rs2out;

initial
begin
    pc = 32'b0;
    i_imm = 32'b0;
    s_imm = 32'b0;
    b_imm = 32'b0;
    u_imm = 32'b0;
    j_imm = 32'b0;
    rs1out = 32'b0;
    rs2out = 32'b0;
    funct3 = 3'b0;
    funct7 = 7'b0;
end

always_ff @(posedge clk)
begin
    if (load)
    begin
      pc <= pc_in;
      i_imm <= i_imm_in;
      s_imm <= s_imm_in;
      b_imm <= b_imm_in;
      u_imm <= u_imm_in;
      j_imm <= j_imm_in;
      rs1out <= rs1out_in;
      rs2out <= rs2out_in;
      funct3 <= funct3_in;
      funct7 <= funct7_in;
      controlw <= controlw_in;
    end
end

always_comb
begin
    pc_out = pc;
    i_imm_out = i_imm;
    s_imm_out = s_imm;
    b_imm_out = b_imm;
    u_imm_out = u_imm;
    j_imm_out = j_imm;
    rs1out_out = rs1out;
    rs2out_out = rs2out;
    funct3_out = funct3;
    funct7_out = funct7;
    controlw_out = controlw;
end

endmodule : if_id_reg



module ex_mem_reg
(
  input logic         clk,
                      load,

  input rv32i_control_word controlw_in,
  output rv32i_control_word controlw_out,

  input logic [31:0]  aluout_in,
                      rs2out_in,
                      bren_in,
  output logic [31:0] aluout_out,
                      rs2out_out,
                      bren_out
);

logic [31:0] aluout, rs2out, bren;
rv32i_control_word controlw;

initial
begin
    aluout = 32'b0;
    rs2out = 32'b0;
    bren = 32'b0;
end

always_ff @(posedge clk)
begin
    if (load)
    begin
      aluout <= aluout_in;
      rs2out <= rs2out_in;
      bren <= bren_in;
      controlw <= controlw_in;
    end
end

always_comb
begin
  aluout_out = aluout;
  rs2out_out = rs2out;
  bren_out = bren;
  controlw_out = controlw;
end

endmodule : ex_mem_reg


module mem_wb_reg
(
  input logic         clk,
                      load,

  input rv32i_control_word controlw_in,
  output rv32i_control_word controlw_out,

  input logic [31:0]  aluout_in,
                      bren_in,
                      dmemout_in,
  output logic [31:0] aluout_out,
                      bren_out,
                      dmemout_out
);

rv32i_control_word controlw;
logic [31:0] aluout, bren, dmemout;

initial
begin
    aluout = 32'b0;
    bren = 32'b0;
    dmemout = 32'b0;
end

always_ff @(posedge clk)
begin
    if (load)
    begin
        aluout <= aluout_in;
        bren <= bren_in;
        dmemout <= dmemout_in;
        controlw <= controlw_in;
    end
end

always_comb
begin
    aluout_out = aluout;
    bren_out = bren;
    dmemout_out = dmemout;
    controlw_out = controlw;
end

endmodule : mem_wb_reg
