.align 4
.section .text
.globl start
start:
	li sp, 0x84000000
	li	t1,-4194304
	addi	t1,t1,-16
	add	sp,sp,t1
	addi	a3,sp,16
	li	a5,4194304
	add	a5,a5,a3
	li	a4,-4194304
	add	a4,a5,a4
	li	a3,1048576
	li	a5,0
.L2:
	sw	a5,0(a4)
	addi	a5,a5,1
	addi	a4,a4,4
	bne	a5,a3,.L2
	li	a4,4194304
	addi	a3,sp,16
	li	a5,-4194304
	add	a4,a4,a3
	add	a5,a4,a5
	sw	a5,12(sp)
	lw	a5,20(a5)
	beqz	a5,.L1
.L4:
	j	.L4
.L1:
	li	t1,4194304
	addi	t1,t1,16
	add	sp,sp,t1
	jr	ra
	.size	start, .-start

	.section .text
	.align	4
	.globl	main
main:
	addi	sp,sp,-16
	sw	ra,12(sp)
	call	start
	lw	ra,12(sp)
	li	a0,1
	addi	sp,sp,16
	jr	ra
	.size	main, .-main
