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
		# Obtém a entrada do teclado e espera o botão ser solto
		jal GET_INPUT
		move $s2, $v0 # $v0 é usado pelo procedimento seguinte, portanto guardamos em $s2
		jal WAIT_NO_KEY_PRESSED
		
		# Reedireciona de acordo com a entrada recebida
		beq $s2, 10, ENTER_WORKING_STATE		# A apertado
		beq $s2, 11, ENTER_WAIT_STATE			# B apertado (cancela a escolha)
		beq $s2, 12, OPEN_DOOR_B_CASE			# C apertado (abre a porta)
		
		j B_CASE
	
	# Se o usuário pausou abrindo a porta, esse procedimento é acionado
	OPEN_CASE:
		jal DISPLAY_OPEN # Mostra "OP" no display
		
		LOOP_1: 
		# Verifica se o usuário fechou a porta
		li $a0, 12
		jal IS_KEY_PRESSED
		
		beq $v0, $zero, LOOP_1 # Volta ao tratamento do pause com B caso o usuário tenha fechado a porta
		
		jal WAIT_NO_KEY_PRESSED	# Verifica se nenhuma tecla está apertada (Evita transições indesejadas)
		
		# Quando o usuário fechar a porta, atualiza a variável `open`
		lw $t0, open
		not $t0, $t0
		sw $t0, open
		
		j ENTER_WORKING_STATE # Retoma o funcionamento
		
	# É usado quando a porta é aberta depois de pausar. Não atualiza a variável global `open`, pois é necessário fechar a porta para sair desse procedimento.
	OPEN_DOOR_B_CASE:
		jal DISPLAY_OPEN # Mostra "OP" no display
		
		LOOP_2: 
		# Verifica se o usuário fechou a porta
		li $a0, 12
		jal IS_KEY_PRESSED
		
		beq $v0, $zero, LOOP_2 # Volta ao tratamento do pause com B caso o usuário tenha fechado a porta
		
		jal WAIT_NO_KEY_PRESSED	# Verifica se nenhuma tecla está apertada (Evita transições indesejadas)
		
		# Mostra o timer atual no display (Para o caso em que a porta é aberta enquanto está no estado pause)
		lw $t0, seconds
		move $a0, $t0
		jal DISPLAY_NUMBER
		
		j PAUSE_STATE # Retorna quando fecha a porta
