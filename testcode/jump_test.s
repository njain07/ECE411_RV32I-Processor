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
  j two
  addi x3,x3,1

two:
  addi x2,x2,1
  j four
  addi x3,x3,1

four:
  addi x4,x4,1
  j one
  addi x3,x3,1


end:
  j end
  .section .rodata
