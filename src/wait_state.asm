# ---------------------------------------------
# Esse arquivo possui a lógica do estado de espera do micro-onda.
# O usuário escolhe o timer que desejar, podendo cancelar a escolha,
# abrir a porta ou avançar para o estado working.
# ---------------------------------------------
.data
.text
.globl ENTER_WAIT_STATE

# Procedimento global que inicializa as variáveis. Não recebe argumento, não possui retorno
ENTER_WAIT_STATE:
	li $s2, 0 # Usado para armazenar de maneira segurao valor recebido pelo usuário
	li $s1, 0 # Representa as dezenas
	li $s0, 0 # Representa as unidades

# Descreve a lógica do estado de espera
WAIT_STATE:
	# Escreve o timer escolhido pelo usuário no display 7-seg
	mul $a0, $s1, 10
	add $a0, $a0, $s0
	jal DISPLAY_NUMBER
	
	# Manipula o input do Digital Lab Sim, redirecionando para os procedimentos corretos
	HANDLE_INPUT:  
		# Obtém a entrada do teclado e espera o botão ser solto
		jal GET_INPUT
		move $s2, $v0 # $v0 é usado pelo procedimento seguinte, portanto guardamos em $s2
		jal WAIT_NO_KEY_PRESSED
		
		# Reedireciona de acordo com a entrada recebida
		beq $s2, 10, TO_WORKING	# A apertado
		beq $s2, 11, ENTER_WAIT_STATE	# B apertado (cancela a escolha)
		beq $s2, 12, OPEN_DOOR		# C apertado (abre a porta)
		bge $s2, 13, WAIT_STATE		# Valor não válido (retorna esperando uma entrada válida)
		
	# Realiza a inserção do valor recebido nos registradores $s0 e $s1
	INSERT:
		# Lógica da inserção "deslizante"
		bne $s1, $zero, HANDLE_INPUT	# Caso for diferente de 0 o timer já foi inserido
		move $s1, $s0			# Move o valor das unidades para o registrador de dezenas			
		move $s0, $s2			# Move o valor recebido para o registrador de unidades
		
		j WAIT_STATE # Retorno para mostrar nos displays e esperar novas ações/inserções
	
	# É usado quando a porta é aberta. Não atualiza a variável global `open`, pois é necessário fechar a porta para sair desse procedimento.
	OPEN_DOOR:
		jal DISPLAY_OPEN # Mostra "OP" no display
		
		# Espera que o usuário feche a porta
		jal GET_INPUT
		move $s2, $v0
		jal WAIT_NO_KEY_PRESSED # É necessário soltar o botão
		
		beq $s2, 12, WAIT_STATE # Volta ao início caso o usuário tenha fechado a porta
		
		j OPEN_DOOR
		
	# Faz a transição para o estado de funcionamento	
	TO_WORKING:
		# Calcula o timer em segundos
		mul $t0, $s1, 10
		add $t0, $t0, $s0
		
		beq $t0, $zero, WAIT_STATE # Caso o timer seja 0 retorna para o início do estado
		
		sw $t0, seconds		# Salva o valor na variável global
		jal ENTER_WORKING_STATE	# Faz a transição para o estado de funcionamento 
		
