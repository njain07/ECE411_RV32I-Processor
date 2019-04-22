.align 4
.section .text
.globl _start
_start:

andi x17, x17, 0


andi x22, x22, 0
andi x23, x23, 0
andi x24, x24, 0

andi x31, x31, 0
addi x31, x31, 100

 check_divisible_2:

    addi x17, x17, 1
    and  x12, x17, 1
    bne  x12, x0, check_divisible_2
    addi  x22, x22, 1
 check_divisible_4:
    and  x13, x17, 3
    bne  x13, x0, check_divisible_2
    addi x23, x23, 1

 check_divisible_8:
    and  x14, x17, 7
    bne  x14, x0, check_divisible_2
    addi x24, x24, 1
    bge  x31, x1, check_divisible_2


lw x1, ONE
lw x2, TWO
lw x3, THREE
lw x4, FOUR
lw x5, FIVE
lw x6, SIX
lw x7, SEVEN
lw x8, EIGHT
lw x9, NINE
lw x10,TEN




ONE:    .word           0x00000000
TWO:    .word           0x00000004
THREE:  .word           0x00000008
FOUR:   .word           0x0000000c
FIVE:   .word           0x00000010
SIX:    .word           0x00000014
SEVEN:  .word           0x00000018
EIGHT:  .word           0x0000001c
NINE:   .word           0x00000020
TEN:    .word           0x00000024
