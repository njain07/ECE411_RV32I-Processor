.align 4
.section .text
.globl _start
    # Refer to the RISC-V ISA Spec for the functionality of
    # the instructions in this test program.
_start:
    # Note that the comments in this file should not be taken as
    # an example of good commenting style!!  They are merely provided
    # in an effort to help you understand the assembly style.

    # Note that one/two/eight are data labels

    la x1, line1
    la x2, line2
    la x3, line3
    la x4, line4
    la x5, line5
    lw x6, 0(x1) #miss
    lw x7, 0(x2) #miss
    lw x8, 0(x3) #miss, evict x1 to l2
    lw x9, 0(x4) #miss, evict x2 to l2
    lw x10, 0(x1) #l2 hit, evict x3 to l2
    sw x7, 0(x1) #hit, overwrite x1 with 22222222,
    lw x11, 0(x2) #l2 hit, evict x4
    lw x12, 0(x3) #l2 hit, evict x1, dirty write back
    lw x13, 0(x4) #l2 hit, evict x2
    lw x14, 0(x5) #miss, evict x3
    lw x15, 0(x1)
    lw x16, 0(x2)
    lw x17, 0(x3)
    lw x18, 0(x4)

inf:
    jal x0, inf


.section .rodata
.balign 256
.zero 96
line1:      .word 0x11111111
line11:	    .word 0x00000000
line12:     .word 0x00000000
line13:	    .word 0x00000000
line14:	    .word 0x00000000
line15:	    .word 0x00000000
line16:	    .word 0x00000000
line17:	    .word 0x00000000
line18:	    .word 0x00000000
line19:	    .word 0x00000000
line1a:	    .word 0x00000000
line1b:	    .word 0x00000000
line1c:	    .word 0x00000000
line1d:	    .word 0x00000000
line1e:	    .word 0x00000000
line1f:	    .word 0x00000000
.balign 256
.zero 96
line2:      .word 0x22222222
line21:	    .word 0x00000000
line22:	    .word 0x00000000
line23:	    .word 0x00000000
line24:	    .word 0x00000000
line25:	    .word 0x00000000
line26:	    .word 0x00000000
line27:	    .word 0x00000000
line28:	    .word 0x00000000
line29:	    .word 0x00000000
line2a:	    .word 0x00000000
line2b:	    .word 0x00000000
line2c:	    .word 0x00000000
line2d:	    .word 0x00000000
line2e:	    .word 0x00000000
line2f:	    .word 0x00000000
.balign 256
.zero 96
line3:	    .word 0x33333333
line31:	    .word 0x00000000
line32:	    .word 0x00000000
line33:	    .word 0x00000000
line34:	    .word 0x00000000
line35:	    .word 0x00000000
line36:	    .word 0x00000000
line37:	    .word 0x00000000
line38:	    .word 0x00000000
line39:	    .word 0x00000000
line3a:	    .word 0x00000000
line3b:	    .word 0x00000000
line3c:	    .word 0x00000000
line3d:	    .word 0x00000000
line3e:	    .word 0x00000000
line3f:	    .word 0x00000000
.balign 256
.zero 96
line4:	    .word 0x44444444
line41:	    .word 0x00000000
line42:	    .word 0x00000000
line43:	    .word 0x00000000
line44:	    .word 0x00000000
line45:	    .word 0x00000000
line46:	    .word 0x00000000
line47:	    .word 0x00000000
line48:	    .word 0x00000000
line49:	    .word 0x00000000
line4a:	    .word 0x00000000
line4b:	    .word 0x00000000
line4c:	    .word 0x00000000
line4d:	    .word 0x00000000
line4e:	    .word 0x00000000
line4f:	    .word 0x00000000
.balign 256
.zero 96
line5:	    .word 0x55555555
line51:	    .word 0x00000000
line52:	    .word 0x00000000
line53:	    .word 0x00000000
line54:	    .word 0x00000000
line55:	    .word 0x00000000
line56:	    .word 0x00000000
line57:	    .word 0x00000000
line58:	    .word 0x00000000
line59:	    .word 0x00000000
line5a:	    .word 0x00000000
line5b:	    .word 0x00000000
line5c:	    .word 0x00000000
line5d:	    .word 0x00000000
line5e:	    .word 0x00000000
line5f:	    .word 0x00000000
