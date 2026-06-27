# ---------------------------------------------
#
# 
# ---------------------------------------------
.data
.text
.globl ENTER_PAUSE_STATE

ENTER_PAUSE_STATE:
	jal WAIT_NO_KEY_PRESSED
	li $s0, 0
	
PAUSE_STATE:
	lw $t0, open
	beq $t0, $zero, B_CASE
	jal DISPLAY_OPEN
	j OPEN_CASE
	
	B_CASE:
		li $a0, 10
		jal IS_KEY_PRESSED
		beq $v0, 1, ENTER_WORKING_STATE
		
		li $a0, 11
		jal IS_KEY_PRESSED
		beq $v0, 1, MAIN
		
		j B_CASE
	
	OPEN_CASE:
		li $a0, 12
		jal IS_KEY_PRESSED
		
		beq $v0, 0, OPEN_CASE
		
		lw $t0, open
		not $t0, $t0
		sw $t0, open
		
		beq $v0, 1, ENTER_WORKING_STATE
		
	
