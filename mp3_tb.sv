module mp3_tb;

timeunit 1ns;
timeprecision 1ns;

logic clk;
// logic resp_a, resp_b;
// logic read_a, read_b;
// logic write;
// logic [3:0] wmask;
// logic [15:0] errcode;
// logic [31:0] address_a, address_b;
// logic [31:0] rdata_a, rdata_b;
// logic [31:0] wdata;
// logic [31:0] write_data;
// logic [31:0] write_address;
// logic write;
logic [31:0] registers [32];
logic halt;
logic pmem_resp;
logic pmem_read;
logic pmem_write;
logic [31:0] pmem_address;
logic [255:0] pmem_wdata;
logic [255:0] pmem_rdata;
// logic [63:0] order;

initial
begin
    clk = 0;
    //order = 0;
end

/* Clock generator */
always #5 clk = ~clk;

assign registers = dut.datapath.regfile.data;
//assign halt = dut.datapath.load_pc & (dut.datapath.pc_out == dut.datapath.pcmux_out);
assign halt = dut.datapath.if_id_load & (dut.datapath.pc_out == dut.datapath.pcmux_out);

always @(posedge clk)
begin
    // if (mem_write & mem_resp) begin
    //     write_address = mem_address;
    //     write_data = mem_wdata;
    //     write = 1;
    // end else begin
    //     write_address = 32'hx;
    //     write_data = 32'hx;
    //     write = 0;
    // end
    if (halt) $finish;
    // if (dut.load_pc) order = order + 1;
end

mp3 dut
(
    .*
);

// magic_memory_dp memory
// (
//     .clk,
//     .resp_a,
//     .resp_b,
//     .rdata_a,
//     .rdata_b,
//     .read_a,
//     .read_b,
//     .write,
//     .wmask,
//     .address_a,
//     .address_b,
//     .wdata
// );

physical_memory memory(
    .clk,
    .read(pmem_read),
    .write(pmem_write),
    .address(pmem_address),
    .wdata(pmem_wdata),
    .resp(pmem_resp),
    .error(pm_error),
    .rdata(pmem_rdata)
);

// riscv_formal_monitor_rv32i monitor
// (
//   .clock(clk),
//   .reset(1'b0),
//   .rvfi_valid(dut.load_pc),
//   .rvfi_order(order),
//   .rvfi_insn(dut.datapath.IR.data),
//   .rvfi_trap(dut.control.trap),
//   .rvfi_halt(halt),
//   .rvfi_intr(1'b0),
//   .rvfi_rs1_addr(dut.control.rs1_addr),
//   .rvfi_rs2_addr(dut.control.rs2_addr),
//   .rvfi_rs1_rdata(monitor.rvfi_rs1_addr ? dut.datapath.rs1_out : 0),
//   .rvfi_rs2_rdata(monitor.rvfi_rs2_addr ? dut.datapath.rs2_out : 0),
//   .rvfi_rd_addr(dut.load_regfile ? dut.datapath.rd : 5'h0),
//   .rvfi_rd_wdata(monitor.rvfi_rd_addr ? dut.datapath.regfilemux_out : 0),
//   .rvfi_pc_rdata(dut.datapath.pc_out),
//   .rvfi_pc_wdata(dut.datapath.pcmux_out),
//   .rvfi_mem_addr(mem_address),
//   .rvfi_mem_rmask(dut.control.rmask),
//   .rvfi_mem_wmask(dut.control.wmask),
//   .rvfi_mem_rdata(dut.datapath.mdrreg_out),
//   .rvfi_mem_wdata(dut.datapath.mem_wdata),
//   .errcode(errcode)
// );

endmodule
