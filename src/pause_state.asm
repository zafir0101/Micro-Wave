# ---------------------------------------------
# Esse arquivo representa o estado de pausa do micro-onda.
# ---------------------------------------------
.data
.text
.globl ENTER_PAUSE_STATE

# Procedimento global chamado pelos outros estados. Não recebe argumento, não possui retorno
ENTER_PAUSE_STATE:
	jal WAIT_NO_KEY_PRESSED	# Verifica se nenhuma tecla está apertada (Evita transições indesejadas)

# Descreve a lógica do estado de pausa
PAUSE_STATE:
	# Direciona para o caso que pausou o micro-ondas
	lw $t0, open
	beq $t0, $zero, B_CASE
	jal DISPLAY_OPEN
	j OPEN_CASE
	
	# Se o usuário pausou pressionando B, esse procedimento é acionado
	B_CASE:
		# Verifica se o usuário não apertou A, com a intenção de retomar o funcionamento
		li $a0, 10
		jal IS_KEY_PRESSED
		beq $v0, 1, ENTER_WORKING_STATE
		
		# Verifica se o usuário não apertou B, com a inteção de cancelar o funcionamento
		li $a0, 11
		jal IS_KEY_PRESSED
		beq $v0, 1, MAIN
		
		j B_CASE
	
	# Se o usuário pausou abrindo a porta, esse procedimento é acionado
	OPEN_CASE:
		# Verifica se o usuário fechou a porta
		li $a0, 12
		jal IS_KEY_PRESSED
		
		beq $v0, 0, OPEN_CASE # Se o usuário não fechou, retorna ao início e verifica novamente
		
		# Quando o usuário fechar a porta, atualiza a variável `open`
		lw $t0, open
		not $t0, $t0
		sw $t0, open
		
		beq $v0, 1, ENTER_WORKING_STATE # Retoma o funcionamento
		
	
