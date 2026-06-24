# ---------------------------------------------
#
# 
# ---------------------------------------------
.data
	.globl seconds, timer
	seconds: .byte 0
	timer: .byte 0
.text
.globl MAIN	

MAIN:
	jal INIT_GUI
	jal WAIT_STATE
		
	