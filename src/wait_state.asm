# ---------------------------------------------
#
# 
# ---------------------------------------------
.data
.text
.globl ENTER_WAIT_STATE

ENTER_WAIT_STATE:
	li $s1, 0
	li $s0, 0

WAIT_STATE:
	mul $a0, $s1, 10
	add $a0, $a0, $s0
	jal DISPLAY_NUMBER
	
	HANDLE_INPUT:  
		jal GET_INPUT
		
		beq $v0, 10, TO_WORKING
		beq $v0, 11, ENTER_WAIT_STATE
		beq $v0, 12, OPEN_DOOR
		bge $v0, 13, WAIT_STATE
		
		INSERT:
		bne $s1, $zero, HANDLE_INPUT
		move $s1, $s0
		move $s0, $v0
		
		j WAIT_STATE
		
	OPEN_DOOR:
		jal DISPLAY_OPEN
		
		jal GET_INPUT
		beq $v0, 12, WAIT_STATE
		
		j OPEN_DOOR
		
		
	TO_WORKING:
		mul $t0, $s1, 10
		add $t0, $a0, $s0
		
		beq $t0, $zero, WAIT_STATE
		
		sw $t0, seconds
		jal WORKING_STATE
		