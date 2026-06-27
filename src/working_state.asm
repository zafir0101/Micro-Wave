# ---------------------------------------------
#
# 
# ---------------------------------------------
.data
.text
.globl ENTER_WORKING_STATE


ENTER_WORKING_STATE:
	jal WAIT_NO_KEY_PRESSED
	lw $s2, seconds
	li $s1, 0
	li $s0, 0
	
WORKING_STATE:
	move $a0, $s2
	jal DISPLAY_NUMBER
	
	beq $s2, 0, ENTER_FINISH_STATE

	li $v0, 30
	syscall
	move $s0, $a0
	
	LOOP:
		li $a0, 11
		jal IS_KEY_PRESSED
		beq $v0, 1, TO_PAUSE
		
		li $a0, 12
		jal IS_KEY_PRESSED
		beq $v0, 1, TO_PAUSE_OPEN
	
		li $v0, 30
		syscall
		move $s1, $a0
	
		sub $t0, $s1, $s0
		bge $t0, 1000, DECREASE_TIMER
	
		j LOOP
	
	DECREASE_TIMER:	
		subi $s2, $s2, 1
		j WORKING_STATE
	
	TO_PAUSE_OPEN:
		lw $t0, open
		not $t0, $t0
		sw $t0, open
		
	TO_PAUSE:
		sw $s2, seconds
		jal ENTER_PAUSE_STATE
		
		
