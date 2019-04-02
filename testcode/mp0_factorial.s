riscv_mp0test.s:
.align 4
.section .text
.globl _start

_start:
	lw  x1,factorial
	addi x1,x1, 1
	add x2,x0, 1	#start
	add x3,x0, x0	  #zero
	add x4,x0, x0   #result
	add x5,x0, x0	#counter

loop:
	addi x5,x5,1
	bgeu x5,x1,end
	addi x3,x0, 1

multiply:
	add x4,x4,x2
	addi x3,x3,1
	bltu x3,x5, multiply
	addi x2,x0, 0 
	addi x2,x4,0
	beq x0, x0, loop

end:
	 beq x0, x0, end

.section .rodata

factorial:        .word 0x05

