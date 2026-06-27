# ---------------------------------------------
# Esse arquivo possui a lógica do estado de finalização de uma operação
# do micro-ondas, ou seja, quando o timer chega a 0. Redireciona para o
# estado Main e pisca 3 vezes o display.
# ---------------------------------------------
.data
.text
.globl ENTER_FINISH_STATE

# Procedimento glocbal que inicializa as variáveis e é chamado pelos outros estados. Não recebe argumento, não possui retorno
ENTER_FINISH_STATE:
	li $s3, 0	# Inicializa o registrador de salvamento que será o iterador para a quantidade de vezes que o display irá piscar
	li $s2, 0	# Inicializa o registrador de salvamento que será o indicador se o display irá apagar ou acender
	li $s1, 0	# Inicializa o registrador de salvamento que será armazenado o tempo atual do sistema
	li $s0, 0	# Inicializa o registrador de salvamento que será armazenado o tempo atual do sistema dentro do loop

# Descreve o estado de finalização
FINISH_STATE:
	beq $s3, 6, MAIN # Retorna a Main caso o display tenha piscado 3 vezes

	not $s2, $s2 # Inverte o sinal que é usado para decidir se o display irá apagar ou acender

	# Obtém o tempo atual do sistema e armazena no registrador `$s0`
	li $v0, 30
	syscall
	move $s0, $a0
	
	# Loop usado para verificar quando passar 500ms
	LOOP:
		# Obtém o tempo atual do sistema e armazena no registrador `$s1`
		li $v0, 30
		syscall
		move $s1, $a0
		
		sub $t0, $s1, $s0		# Subtrai os registradores `$s1` e `$s0`, obtendo o tempo passado
		bge $t0, 500, CHANGE_DISPLAY	# Caso tenha passado, chama o procedimento que muda o display
		
		j LOOP # Retorna ao laço caso não tenha passado 500ms
	
	# Altera o display a cada 500ms de acordo com o sinal armazenado em `$s2`
	CHANGE_DISPLAY:
		addi $s3, $s3, 1 # Atualiza o iterado
		
		bne $s2, $zero, OFF # Decide se vai apagar ou acender o display
		
		# Acende o display
		ON:
		li $a0, 0
		jal DISPLAY_NUMBER
		j FINISH_STATE
		
		# Apaga o display
		OFF:
		jal CLEAR_DISPLAY
		j FINISH_STATE
			
			
	
