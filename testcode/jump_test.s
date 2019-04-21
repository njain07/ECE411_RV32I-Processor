jump_test.s:
.align 4
.section .text
.globl _start
    # Refer to the RISC-V ISA Spec for the functionality of
    # the instructions in this test program.
_start:

andi x1, x1,0
andi x2, x2,0
andi x3, x3,0
andi x4,x4,0

one:
  addi x1,x1,1
  addi x1,x1,1
  jal x7, four
  addi x3,x3,1

two:
  addi x2,x2,1
  addi x3,x3,1
  beq x0, x0, one

four:
  addi x4,x4,1
  jalr x8, x7, 0
  addi x6,x6,1


end:
  j end
  .section .rodata
