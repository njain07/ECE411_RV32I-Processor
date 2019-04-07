#  mp3-cp3.s version 1.0
.align 4
.section .text
.globl _start
_start:

add x1, x0, x0
addi x1,x1,2

add x2, x0, x0
addi x2,x2,2

bne x2,x3,bad

good:
  lw x7, GOOD
  beq x0,x0,good

bad:
  lw x7,BAD
  beq x0,x0,bad

  .section .rodata
  .balign 256

  BAD:    		.word 0x00BADBAD
  GOOD:	.word 0x600D600D
