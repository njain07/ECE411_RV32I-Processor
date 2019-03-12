riscv_mp0.s:
.align 4
.section .text
.globl _start

_start:
	xor	 x1, x1, 0		#clear
	nop
	nop
	nop
	nop
	addi x1, x1, 6		#number + 1
	addi x3, x0, 0
	addi x5, x0, 1
	addi x4, x0, 1		#counter = 1
	addi x2, x0, 0		#result answer = 0

factorial:
	addi x3, x0, 1		#multiplication counter = 1

multiply:
	nop
	nop
	nop
	add x2, x2, x5
	addi x3, x3, 1		#increment multiplication counter
	#bltu x3, x4, multiply
	addi x5, x0, 0
	nop
	nop
	nop
	nop
	sltiu x5, x2, 10
	addi x4, x4, 1		#increment counter
	#bgeu x4, x1, halt
	#beq x0, x0, factorial

halt:
	beq	x0, x0, halt

.section .rodata

number: 	.word 0x5
