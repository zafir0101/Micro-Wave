# ---------------------------------------------
#
# 
# ---------------------------------------------
.data
.text
.globl ENTER_FINISH_STATE

ENTER_FINISH_STATE:
	li $s3, 0
	li $s2, 0
	li $s1, 0
	li $s0, 0
	
FINISH_STATE:
	beq $s3, 6, MAIN

	not $s2, $s2

	li $v0, 30
	syscall
	move $s0, $a0
	
	LOOP:
		li $v0, 30
		syscall
		move $s1, $a0
		
		sub $t0, $s1, $s0
		bge $t0, 500, CHANGE_DISPLAY
		
		j LOOP
		
	CHANGE_DISPLAY:
		addi $s3, $s3, 1
		
		bne $s2, $zero, OFF
			
		ON:
		li $a0, 0
		jal DISPLAY_NUMBER
		j FINISH_STATE
			
		OFF:
		jal CLEAR_DISPLAY
		j FINISH_STATE
			
			
	
