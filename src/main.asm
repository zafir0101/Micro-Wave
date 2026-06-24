# ---------------------------------------------
#
# 
# ---------------------------------------------
.data
	.globl seconds: .byte 0
	.globl timer: .byte 0
.text
.globl MAIN	

MAIN:
	jal INIT_GUI
	jal WAIT_STATE
		
	