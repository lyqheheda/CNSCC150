#Lin Yunqi -- 2020/5/12
#coursework.asm-- A multiplication program.

.data
	num: .word 10, 12, 0  			 				#  memory holding a, b and result
	result_s: .asciiz "The result is: "	 			#  output preamble
	error_s: .asciiz "Multiplication Error." 	    #  error message
	
.text
	j main 											#  used to jump over the following function

#the multiplication function
#$a0 contains pointer to array (num in our case)
#$v0 is used to return result 0 or 1
mult:
	li $v0, 5										#  read int to a, store in 0($a0)
	syscall
	sw $v0, 0($a0)
	li $v0, 5										#  read int to b, store in 4($a0)
	syscall
	sw $v0, 4($a0)

#multiply a and b

#judge whether input a and b is invalid
	li $s1, 32767									#  $s1=0x7fff (maximum of 16bit number)
	li $s5, -32768									#  $s5=(minimum of 16bit number)
	lw $t1, 0($a0)									#  load a to $t1
	bgt $t1, $s1, error								#  if input invalid, branch to error
	blt $t1, $s5, error

	lw $t2, 4($a0)									#  load b to $t2
	bgt $t2, $s1, error  							#  if input invalid, branch to error
	blt $t2, $s5, error
#judge whether input contains zero
	beq $t1, $zero, input_zero						#  if input contains zero, print result
	beq $t2, $zero, input_zero

#Ethiopian multiplication implementation
	li $s3, 1										#  load 1 into $s3 for the last step of a, as well as judging whether a is odd or even
	lw $t3, 8($a0)									#  load result which is in the array into $t3
#judge if a is positive or negative. If a<0, branch to a_less_than_zero:
	bltz $t1, a_less_than_zero
loop:
	and $t6, $t1, $s3
	beq $s3, $t6, plus_b							#  if a & 1 equal 1, then a is odd, jump to plus_b
out:
	beq $t1, $s3, end_loop							#  if a equals 1, end loop
	srl $t1, $t1, 1									#  half a
	sll $t2, $t2, 1									#  double b
	j loop	

#result plus b
plus_b:
	add $t3, $t3, $t2								#  result+=b   
	j out

a_less_than_zero:
	li $s4, -1										#  load -1 into $s4 for the last step of a	
loop_2:
	and $t6, $t1, $s3
	beq $s3, $t6, minus_b							#  if a & 1 equal 1, then a is odd, jump to minus_b
out_2:
	beq $t1, $s4, end_loop							#  if a equals -1, end loop
	
	not $t1, $t1
	addi $t1, $t1,1
	srl $t1, $t1, 1									#  half a
	not $t1, $t1
	addi $t1, $t1,1

	sll $t2, $t2, 1									#  double b
	j loop_2
#result minus b
minus_b:
	sub $t3, $t3, $t2								# result-=b   
	j out_2

end_loop:
	sw $t3, 8($a0)									#  save result into 8($a0)	
	jr $ra											#  return to main
#handle invalid input a, b error
error:
	li $v0, 0										#  load 0 into $v0
	jr $ra											#  return to main

#print error and exit the program. Called by main
print_error:
	la $a0, error_s									#  print error
	li $v0, 4
	syscall
	li $v0, 10										#  exit the program
	syscall

#a or b is zero
input_zero:
	li $v0, 1										#  load 1 into $v0
	sw $zero, 8($a0)								#  load result into 8($a0)
	jr $ra											#  return to main

main:
	la $a0, num										#  load address of array num in $a0
	jal mult										#  call multiplication procedure

	li $s2, 0										#  store in $s2 0 to compare the value in  $v0
	beq $s2, $v0, print_error						#  if $v0 is 0, branch to print error.
	move $t0, $a0									#  save array address into $t0
	la $a0, result_s								#  else, print string and result, string first
	li $v0, 4
	syscall
	move $a0, $t0
	lw $a0, 8($a0)									#  then print result	
	li $v0, 1
	syscall
	li $v0, 10										#  exit the program
	syscall