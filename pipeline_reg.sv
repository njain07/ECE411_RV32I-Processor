import rv32i_types::*;

module if_id_reg
(
  input logic           clk,
                        load,
                        flush,
  input logic [31:0]    instr_in,
                        pc_in,
                        pc_4_in,
  input logic [1:0]     pred_in,
  input logic [9:0]     bhr_in,

  output logic [31:0]   instr_out,
                        pc_out,
                        pc_4_out,
  output logic [1:0]    pred_out,
  output logic [9:0]    bhr_out

);

logic [31:0] instr, pc, pc_plus_4, nop;
logic [1:0] pred;
logic [9:0] bhr;

initial
begin
    instr = 1'd0;
    pc = 32'd0;
    pc_plus_4 = 32'd0;
    pred = 2'd0;
    bhr = 10'd0;
end

assign nop = 32'h00000013;

always_ff @(posedge clk)
begin
    if (load)
    begin
        instr <= flush ? nop : instr_in;
        pc <= pc_in;
        pc_plus_4 <= pc_4_in;
        pred <= pred_in;
        bhr <= bhr_in;
    end
end

always_comb
begin
    instr_out = instr;
    pc_out = pc;
    pc_4_out = pc_plus_4;
    pred_out = pred;
    bhr_out = bhr;
end

endmodule : if_id_reg


module id_ex_reg
(
  input logic           clk,
                        load,
                        flush,

  input rv32i_control_word controlw_in,
  output rv32i_control_word controlw_out,

  input logic [31:0]    pc_in,
                        pc_4_in,
                        i_imm_in,
                        s_imm_in,
                        b_imm_in,
                        u_imm_in,
                        j_imm_in,
                        rs1out_in,
                        rs2out_in,
                        btb_out_in,
  input logic  [1:0]    pred_in,

  input logic [2:0]     funct3_in,
  input logic [6:0]     funct7_in,
  input logic [9:0]     bhr_in,

  output logic [31:0]   pc_out,
                        pc_4_out,
                        i_imm_out,
                        s_imm_out,
                        b_imm_out,
                        u_imm_out,
                        j_imm_out,
                        rs1out_out,
                        rs2out_out,
                        btb_out_out,


  output logic [4:0]    rs1_out,
                        rs2_out,

  output logic [2:0]    funct3_out,
  output logic [6:0]    funct7_out,
  output logic [1:0]    pred_out,
  output logic [9:0]    bhr_out
);

rv32i_control_word controlw;
logic [2:0] funct3;
logic [6:0] funct7;
logic [31:0] pc, pc_plus_4, i_imm;
logic [31:0] s_imm, b_imm, u_imm, j_imm, rs1out, rs2out, btb_out;
logic [1:0]  pred;
logic [9:0] bhr;

initial
begin
    pc = 32'd0;
    pc_plus_4 = 32'd0;
    i_imm = 32'd0;
    s_imm = 32'd0;
    b_imm = 32'd0;
    u_imm = 32'd0;
    j_imm = 32'd0;
    rs1out = 32'd0;
    rs2out = 32'd0;
    funct3 = 3'd0;
    funct7 = 7'd0;
    controlw = 64'd0;
    btb_out = 32'd0;
    pred = 2'd0;
    bhr = 10'd0;
end

always_ff @(posedge clk)
begin
    if (load)
    begin
      pc <= pc_in;
      pc_plus_4 <= pc_4_in;
      i_imm <= i_imm_in;
      s_imm <= s_imm_in;
      b_imm <= b_imm_in;
      u_imm <= u_imm_in;
      j_imm <= j_imm_in;
      rs1out <= rs1out_in;
      rs2out <= rs2out_in;
      funct3 <= funct3_in;
      funct7 <= funct7_in;
      controlw <= controlw_in & { {64{~flush}} };
      btb_out <= btb_out_in;
      pred <= pred_in;
      bhr <= bhr_in;
    end
end

always_comb
begin
    pc_out = pc;
    pc_4_out = pc_plus_4;
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
    rs1_out = controlw.rs1;
    rs2_out = controlw.rs2;
    btb_out_out = btb_out;
    pred_out = pred;
    bhr_out = bhr;
end

endmodule : id_ex_reg



module ex_mem_reg
(
  input logic         clk,
                      load,

  input rv32i_control_word controlw_in,
  output rv32i_control_word controlw_out,

  input logic [31:0]  aluout_in,
                      rs2out_in,
                      bren_in,
                      u_imm_in,
                      pc_4_in,
  output logic [31:0] aluout_out,
                      rs2out_out,
                      bren_out,
                      u_imm_out,
                      pc_4_out
);

logic [31:0] aluout, rs2out, bren, u_imm, pc_plus_4;
rv32i_control_word controlw;

initial
begin
    aluout = 32'b0;
    rs2out = 32'b0;
    bren = 32'b0;
    u_imm = 32'b0;
    pc_plus_4 = 32'b0;
    controlw = 64'd0;
end

always_ff @(posedge clk)
begin
    if (load)
    begin
      aluout <= aluout_in;
      rs2out <= rs2out_in;
      bren <= bren_in;
      controlw <= controlw_in;
      u_imm <= u_imm_in;
      pc_plus_4 <= pc_4_in;
    end
end

always_comb
begin
  aluout_out = aluout;
  rs2out_out = rs2out;
  bren_out = bren;
  controlw_out = controlw;
  u_imm_out = u_imm;
  pc_4_out = pc_plus_4;
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
                      u_imm_in,
                      pc_4_in,
  output logic [31:0] aluout_out,
                      bren_out,
                      dmemout_out,
                      u_imm_out,
                      pc_4_out
);

rv32i_control_word controlw;
logic [31:0] aluout, bren, dmemout, u_imm, pc_plus_4;

initial
begin
    aluout = 32'b0;
    bren = 32'b0;
    dmemout = 32'b0;
    u_imm = 32'b0;
    pc_plus_4 = 32'b0;
    controlw = 64'd0;
end

// assign pcmuxsel = (controlw.opcode == op_jal) || (controlw.opcode == op_jalr) || (controlw.opcode == op_br && (bren[0]));

always_ff @(posedge clk)
begin
    if (load)
    begin
        aluout <= aluout_in;
        bren <= bren_in;
        dmemout <= dmemout_in;
        controlw <= controlw_in;
        u_imm <= u_imm_in;
        pc_plus_4 <= pc_4_in;
    end
end

always_comb
begin
    aluout_out = aluout;
    bren_out = bren;
    dmemout_out = dmemout;
    controlw_out = controlw;
    u_imm_out = u_imm;
    pc_4_out = pc_plus_4;

    // case(controlw.opcode)
    //   op_br : begin
    //     if(bren[0])
    //       pcmuxsel = 1;
    //     else
    //       pcmuxsel = 0;
    //   end

    //   op_jal : pcmuxsel = 2;

    //   op_jalr : pcmuxsel = 3;

    //   default: pcmuxsel = 0;

    // endcase
end

endmodule : mem_wb_reg
