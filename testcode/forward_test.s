riscv_mp0test.s:
.align 4
.section .text
.globl _start

_start:

andi x1,x1,0
addi x1,x1,5

andi x3,x3,0
addi x3,x3,2

andi x5,x5,0
addi x5,x5,2

andi x6,x6,0
addi x6,x6,8


sub   x2, x1,x3 #3
and   x12,x2,x5 #2
or    x13,x6,x12 #10
add   x14,x13,x13 #10

end:
	 beq x0, x0, end

.section .rodata
