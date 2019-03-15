onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /mp3_tb/clk
add wave -noupdate /mp3_tb/resp_a
add wave -noupdate /mp3_tb/resp_b
add wave -noupdate /mp3_tb/read_a
add wave -noupdate /mp3_tb/read_b
add wave -noupdate /mp3_tb/write
add wave -noupdate /mp3_tb/wmask
add wave -noupdate /mp3_tb/address_a
add wave -noupdate /mp3_tb/address_b
add wave -noupdate /mp3_tb/rdata_a
add wave -noupdate /mp3_tb/rdata_b
add wave -noupdate /mp3_tb/wdata
add wave -noupdate /mp3_tb/halt
add wave -noupdate /mp3_tb/dut/datapath/pc/out
add wave -noupdate /mp3_tb/dut/datapath/pcmux/sel
add wave -noupdate /mp3_tb/dut/datapath/ctrl/opcode
add wave -noupdate /mp3_tb/dut/datapath/mem_wb/bren
add wave -noupdate /mp3_tb/dut/datapath/mem_wb/controlw.opcode
add wave -noupdate -group {if_id
} /mp3_tb/dut/datapath/if_id/clk
add wave -noupdate -group {if_id
} /mp3_tb/dut/datapath/if_id/load
add wave -noupdate -group {if_id
} /mp3_tb/dut/datapath/if_id/instr_in
add wave -noupdate -group {if_id
} /mp3_tb/dut/datapath/if_id/pc_in
add wave -noupdate -group {if_id
} /mp3_tb/dut/datapath/if_id/instr_out
add wave -noupdate -group {if_id
} /mp3_tb/dut/datapath/if_id/pc_out
add wave -noupdate -group {if_id
} /mp3_tb/dut/datapath/if_id/instr
add wave -noupdate -group {if_id
} /mp3_tb/dut/datapath/if_id/pc
add wave -noupdate -group {id_ex
} /mp3_tb/dut/datapath/id_ex/clk
add wave -noupdate -group {id_ex
} /mp3_tb/dut/datapath/id_ex/load
add wave -noupdate -group {id_ex
} -expand /mp3_tb/dut/datapath/id_ex/controlw_in
add wave -noupdate -group {id_ex
} /mp3_tb/dut/datapath/id_ex/controlw_out
add wave -noupdate -group {id_ex
} /mp3_tb/dut/datapath/id_ex/pc_in
add wave -noupdate -group {id_ex
} /mp3_tb/dut/datapath/id_ex/i_imm_in
add wave -noupdate -group {id_ex
} /mp3_tb/dut/datapath/id_ex/s_imm_in
add wave -noupdate -group {id_ex
} /mp3_tb/dut/datapath/id_ex/b_imm_in
add wave -noupdate -group {id_ex
} /mp3_tb/dut/datapath/id_ex/u_imm_in
add wave -noupdate -group {id_ex
} /mp3_tb/dut/datapath/id_ex/j_imm_in
add wave -noupdate -group {id_ex
} /mp3_tb/dut/datapath/id_ex/rs1out_in
add wave -noupdate -group {id_ex
} /mp3_tb/dut/datapath/id_ex/rs2out_in
add wave -noupdate -group {id_ex
} /mp3_tb/dut/datapath/id_ex/funct3_in
add wave -noupdate -group {id_ex
} /mp3_tb/dut/datapath/id_ex/funct7_in
add wave -noupdate -group {id_ex
} /mp3_tb/dut/datapath/id_ex/pc_out
add wave -noupdate -group {id_ex
} /mp3_tb/dut/datapath/id_ex/i_imm_out
add wave -noupdate -group {id_ex
} /mp3_tb/dut/datapath/id_ex/s_imm_out
add wave -noupdate -group {id_ex
} /mp3_tb/dut/datapath/id_ex/b_imm_out
add wave -noupdate -group {id_ex
} /mp3_tb/dut/datapath/id_ex/u_imm_out
add wave -noupdate -group {id_ex
} /mp3_tb/dut/datapath/id_ex/j_imm_out
add wave -noupdate -group {id_ex
} /mp3_tb/dut/datapath/id_ex/rs1out_out
add wave -noupdate -group {id_ex
} /mp3_tb/dut/datapath/id_ex/rs2out_out
add wave -noupdate -group {id_ex
} /mp3_tb/dut/datapath/id_ex/funct3_out
add wave -noupdate -group {id_ex
} /mp3_tb/dut/datapath/id_ex/funct7_out
add wave -noupdate -group {id_ex
} /mp3_tb/dut/datapath/id_ex/controlw
add wave -noupdate -group {id_ex
} /mp3_tb/dut/datapath/id_ex/funct3
add wave -noupdate -group {id_ex
} /mp3_tb/dut/datapath/id_ex/funct7
add wave -noupdate -group {id_ex
} /mp3_tb/dut/datapath/id_ex/pc
add wave -noupdate -group {id_ex
} /mp3_tb/dut/datapath/id_ex/i_imm
add wave -noupdate -group {id_ex
} /mp3_tb/dut/datapath/id_ex/s_imm
add wave -noupdate -group {id_ex
} /mp3_tb/dut/datapath/id_ex/b_imm
add wave -noupdate -group {id_ex
} /mp3_tb/dut/datapath/id_ex/u_imm
add wave -noupdate -group {id_ex
} /mp3_tb/dut/datapath/id_ex/j_imm
add wave -noupdate -group {id_ex
} /mp3_tb/dut/datapath/id_ex/rs1out
add wave -noupdate -group {id_ex
} /mp3_tb/dut/datapath/id_ex/rs2out
add wave -noupdate -group {ex_mem
} /mp3_tb/dut/datapath/ex_mem/clk
add wave -noupdate -group {ex_mem
} /mp3_tb/dut/datapath/ex_mem/load
add wave -noupdate -group {ex_mem
} /mp3_tb/dut/datapath/ex_mem/controlw_in
add wave -noupdate -group {ex_mem
} /mp3_tb/dut/datapath/ex_mem/controlw_out
add wave -noupdate -group {ex_mem
} /mp3_tb/dut/datapath/ex_mem/aluout_in
add wave -noupdate -group {ex_mem
} /mp3_tb/dut/datapath/ex_mem/rs2out_in
add wave -noupdate -group {ex_mem
} /mp3_tb/dut/datapath/ex_mem/bren_in
add wave -noupdate -group {ex_mem
} /mp3_tb/dut/datapath/ex_mem/u_imm_in
add wave -noupdate -group {ex_mem
} /mp3_tb/dut/datapath/ex_mem/aluout_out
add wave -noupdate -group {ex_mem
} /mp3_tb/dut/datapath/ex_mem/rs2out_out
add wave -noupdate -group {ex_mem
} /mp3_tb/dut/datapath/ex_mem/bren_out
add wave -noupdate -group {ex_mem
} /mp3_tb/dut/datapath/ex_mem/u_imm_out
add wave -noupdate -group {ex_mem
} /mp3_tb/dut/datapath/ex_mem/aluout
add wave -noupdate -group {ex_mem
} /mp3_tb/dut/datapath/ex_mem/rs2out
add wave -noupdate -group {ex_mem
} /mp3_tb/dut/datapath/ex_mem/bren
add wave -noupdate -group {ex_mem
} /mp3_tb/dut/datapath/ex_mem/u_imm
add wave -noupdate -group {ex_mem
} /mp3_tb/dut/datapath/ex_mem/controlw
add wave -noupdate -group {mem_wb
} /mp3_tb/dut/datapath/mem_wb/clk
add wave -noupdate -group {mem_wb
} /mp3_tb/dut/datapath/mem_wb/load
add wave -noupdate -group {mem_wb
} /mp3_tb/dut/datapath/mem_wb/controlw_in
add wave -noupdate -group {mem_wb
} /mp3_tb/dut/datapath/mem_wb/controlw_out
add wave -noupdate -group {mem_wb
} /mp3_tb/dut/datapath/mem_wb/aluout_in
add wave -noupdate -group {mem_wb
} /mp3_tb/dut/datapath/mem_wb/bren_in
add wave -noupdate -group {mem_wb
} /mp3_tb/dut/datapath/mem_wb/dmemout_in
add wave -noupdate -group {mem_wb
} /mp3_tb/dut/datapath/mem_wb/u_imm_in
add wave -noupdate -group {mem_wb
} /mp3_tb/dut/datapath/mem_wb/aluout_out
add wave -noupdate -group {mem_wb
} /mp3_tb/dut/datapath/mem_wb/bren_out
add wave -noupdate -group {mem_wb
} /mp3_tb/dut/datapath/mem_wb/dmemout_out
add wave -noupdate -group {mem_wb
} /mp3_tb/dut/datapath/mem_wb/u_imm_out
add wave -noupdate -group {mem_wb
} /mp3_tb/dut/datapath/mem_wb/pcmuxsel
add wave -noupdate -group {mem_wb
} /mp3_tb/dut/datapath/mem_wb/controlw
add wave -noupdate -group {mem_wb
} /mp3_tb/dut/datapath/mem_wb/aluout
add wave -noupdate -group {mem_wb
} /mp3_tb/dut/datapath/mem_wb/bren
add wave -noupdate -group {mem_wb
} /mp3_tb/dut/datapath/mem_wb/dmemout
add wave -noupdate -group {mem_wb
} /mp3_tb/dut/datapath/mem_wb/u_imm
add wave -noupdate -group {alu
} /mp3_tb/dut/datapath/alu/aluop
add wave -noupdate -group {alu
} /mp3_tb/dut/datapath/alu/a
add wave -noupdate -group {alu
} /mp3_tb/dut/datapath/alu/b
add wave -noupdate -group {alu
} /mp3_tb/dut/datapath/alu/f
add wave -noupdate -group {memwb_mux
} /mp3_tb/dut/datapath/memwb_mux/sel
add wave -noupdate -group {memwb_mux
} /mp3_tb/dut/datapath/memwb_mux/a
add wave -noupdate -group {memwb_mux
} /mp3_tb/dut/datapath/memwb_mux/b
add wave -noupdate -group {memwb_mux
} /mp3_tb/dut/datapath/memwb_mux/c
add wave -noupdate -group {memwb_mux
} /mp3_tb/dut/datapath/memwb_mux/d
add wave -noupdate -group {memwb_mux
} /mp3_tb/dut/datapath/memwb_mux/f
add wave -noupdate -group {regfile
} /mp3_tb/dut/datapath/regfile/clk
add wave -noupdate -group {regfile
} /mp3_tb/dut/datapath/regfile/load
add wave -noupdate -group {regfile
} /mp3_tb/dut/datapath/regfile/in
add wave -noupdate -group {regfile
} /mp3_tb/dut/datapath/regfile/src_a
add wave -noupdate -group {regfile
} /mp3_tb/dut/datapath/regfile/src_b
add wave -noupdate -group {regfile
} /mp3_tb/dut/datapath/regfile/dest
add wave -noupdate -group {regfile
} /mp3_tb/dut/datapath/regfile/reg_a
add wave -noupdate -group {regfile
} /mp3_tb/dut/datapath/regfile/reg_b
add wave -noupdate -expand /mp3_tb/dut/datapath/regfile/data
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {54951 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 159
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {132001 ps}
