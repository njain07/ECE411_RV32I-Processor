mp0_factorial.s:
.align 4
.section .text
.globl _start

#Program to calculate fact(n). Final result is in X2. n is stored in the label number
_start:

  #x1: counter for factorial
  #x2: product
  #x3: number
  #x4: counter for mult
  #x5: temp product

  #X1 goes from 1->n, each time multiplying the product (X2) with X1. The multiplication
  #is carried out using X4 and X5 as temporary registers


  lw x3, number #X3 <= n
  lui x2, 1
  srli x2, x2, 12 #X2 <= 1
  addi x1, x2, 0  #X1 <= 1

#main loop for factorial
loop1:
  andi x4, x4, 0  #X4 and X5 <= 0
  andi x5, x5, 0

#loop to multiply X2 with X1
multloop:

  add x5, x5, x2 #X5 <= X5+X2
  addi x4, x4, 1  #X4 <= X4 + 1
  bne x4, x1, multloop  #if X4 == X1, we are done, else repeat
  #multloop done

  addi x2, x5, 0  #X2 <= X5
  addi x1, x1, 1  #X1 + 1
  bge x3, x1, loop1 #if X1 is n, we are done, else repeat
  #loop1 done

#infinite loop
halt:
  beq x1, x1, halt

.section .rodata
number: .word 0x00000005
