# SPIM S20 MIPS simulator.
# simple array addition routine (to be adapted by students for multiplication)
# $Header: $


	.data
saved_ret_pc:	.word 0		# Holds PC to return from main
m3:	.asciiz "The next few lines should contain exception error messages\n"
m4:	.asciiz "Done with exceptions\n\n"
m5:	.asciiz "Expect an address error exception:\n	"
m6:	.asciiz "Expect two address error exceptions:\n"

# here's our array data, two args and a result
	.data
	.globl array1
	.globl array2
	.globl array3
array1:	.float 1.0, 0.0, 3.14, 2.72, 2.72, 1.0, 0.0, 3.14, 1.0, 1.0, 1.0, 1.0, 1.0, 2.0, 3.0, 4.0
array2:	.float 1.0, 1.0, 0.0, 3.14, 0.0, 1.0, 3.14, 2.72, 0.0, 1.0, 1.0, 0.0, 4.0, 3.0, 2.0, 1.0
array3:	.float 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0

	.text
	.globl main
main:
	sw $31 saved_ret_pc

	.data
lb_:	.asciiz "Vector Multiplication\n"
lbd_:	.byte 1, -1, 0, 128
lbd1_:	.word 0x76543210, 0xfedcba98
	.text
	li $v0 4	# syscall 4 (print_str)
	la $a0 lb_
	syscall

# main program: add array1 & array2, store in array3
# first, the setup
	li $t0 4	# loop counter ladd1
	li $t1 4	# loop counter ladd2
	li $t2 16	# next row index of matrixA
  li $t3 0
	la $t4 array1
	la $t5 array2
	la $t6 array3
  li $t7 4 # loop counter ladd0
  li $t8 0

ladd0:
	li $t0 4	# loop counter ladd1
  li $t3 0
  la $t5 array2

ladd1:
	li $t1 4	# init loop counter ladd2
  la $t4 array1
  add $t4 $t4 $t8

ladd2:	
	lwc1 $f0 0($t4)
	lwc1 $f1 0($t5)
	lwc1 $f3 0($t6)

	mul.s $f2 $f1 $f0
  add.s $f3 $f3 $f2
	swc1 $f3 0($t6) # store $f3 data to $t6

	addi $t4 $t4 4
	addi $t5 $t5 16

	addi $t1 $t1 -1
	bne $t1 $0 ladd2
ladd2_end:

  addi $t3 $t3 4
  la $t5 array2
  add $t5 $t5 $t3
	addi $t6 $t6 4
	addi $t0 $t0 -1
	bne $t0 $0 ladd1
ladd1_end:

  addi $t8 $t8 16
	addi $t7 $t7 -1
	bne $t7 $0 ladd0
ladd0_end:

# Done adding...
	.data
sm:	.asciiz "Done adding\n"
	.text
	li $v0 4	# syscall 4 (print_str)
	la $a0 sm
	syscall

# see the list of syscalls at e.g.
# http://www.inf.pucrs.br/~eduardob/disciplinas/arqi/mips/spim/syscall_codes.html
	la $a1 array3
	addi $t0 $0 16
ploop:	lwc1 $f12 0($a1)
	li $v0 2	# syscall 2 (print_float)
	syscall
	.data
sm2:	.asciiz "\n"
	.text
	li $v0 4	# syscall 4 (print_str)
	la $a0 sm2
	syscall

	addi $t0 $t0 -1
	addi $a1 $a1 4
	bne $t0 $0 ploop

# Done with the program!
	lw $31 saved_ret_pc
	jr $31		# Return from main
