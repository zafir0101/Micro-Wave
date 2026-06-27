# ---------------------------------------------
# Esse arquivo representa o estado de funcionamento do micro-ondas,
# onde ocorre o aquecimento.
# ---------------------------------------------
.data
.text
.globl ENTER_WORKING_STATE

# Procedimento glocbal que inicializa as variáveis. Não recebe argumento, não possui retorno
ENTER_WORKING_STATE:
	jal WAIT_NO_KEY_PRESSED	# Verifica se nenhuma tecla está apertada (Evita transições indesejadas)
	lw $s2, seconds		# Carrega o valor do timer em segundos no registrador de salvamento
	li $s1, 0		# Inicializa o registrador de salvamento que representa o tempo do sistema que e será atualizado diversas vezes
	li $s0, 0		# Inicializa o registrador de salvamento que representa o tempo do sistema que será carregado apenas uma vez
	
WORKING_STATE:
	# Mostra o timer atual no display
	move $a0, $s2
	jal DISPLAY_NUMBER
	
	beq $s2, 0, ENTER_FINISH_STATE # Realiza a transição para o estado final (quando o timer = 0)

	# Syscall que obtém o tempo atual do sistema (em ms)
	li $v0, 30
	syscall
	move $s0, $a0
	
	# Manipula o input do teclado do Digital Lab Sim, redirecionando para os procedimentos corretos
	HANDLE_INPUT:
		# Caso o B seja pressionado (Pausar)
		li $a0, 11
		jal IS_KEY_PRESSED
		beq $v0, 1, TO_PAUSE
		
		# Caso o C seja pressionado (Pausar atualizando a variável open)
		li $a0, 12
		jal IS_KEY_PRESSED
		beq $v0, 1, TO_PAUSE_OPEN
	
		# Caso nenhuma tecla seja pressionada calcula o tempo atual do sistema para obter o tempo percorrido
		li $v0, 30
		syscall
		move $s1, $a0
	
		sub $t0, $s1, $s0		# Subtrai o valor do tempo do sistema calculado anteriormente com o calculado agora, obtendo o tempo percorrido em ms
		bge $t0, 1000, DECREASE_TIMER	# Caso seja maior que 1000 reedireciona para o procedimento que atualiza o timer (passou 1 segundo)
	
		j HANDLE_INPUT
	
	# Acionado a cada segundo. Atualiza o valor do timer e retorna para `WORKING_STATE` para mostrar no display
	DECREASE_TIMER:	
		subi $s2, $s2, 1
		j WORKING_STATE
	
	# Acionado caso a porta for aberta. Atualiza o valor da variável global `open` e direciona para `TO_PAUSE`
	TO_PAUSE_OPEN:
		lw $t0, open
		not $t0, $t0
		sw $t0, open
	
	# Acionado quando o usuário pressiona B ou abre a porta. Salva o valor atualizado dos segundos redireciona para o estado de pausa
	TO_PAUSE:
		sw $s2, seconds
		jal ENTER_PAUSE_STATE
		
		
