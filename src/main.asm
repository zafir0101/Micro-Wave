# ---------------------------------------------
#
# 
# ---------------------------------------------
.data
	.globl seconds, timer, open
	seconds: .word 0
	timer: .word 0
	open: .word 0
.text
.globl MAIN	

MAIN:
	jal INIT_GUI
	jal ENTER_WAIT_STATE
		
	
