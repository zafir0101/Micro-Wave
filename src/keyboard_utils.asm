# ---------------------------------------------
# Os procedimentos desse arquivo servem para fazer a inter-op com
# o Digital Lab Sim
# ---------------------------------------------
.data
	display_units: .word 0xFFFF0010
	display_tens: .word 0xFFFF0011
	
	kb_read_row: .word 0xFFFF0012
	kb_recieve_key: .word 0xFFFF0014

# Codificação display: 0     1     2     3     4     5     6     7     8     9     P
	seg_table: .byte 0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0x7F, 0x6F, 0x67
	
.text
.globl CLEAR_MEMORY, CLEAR_DISPLAY, DISPLAY_SYMBOL, GET_INPUT, display_units, display_tens

# Limpa a memória para que não ocorra undefined behaviour, sem argumentos e sem retorno
# Deve ser chamada no começo do programa
CLEAR_MEMORY:
	lw $t0, kb_recieve_key
	sb $zero, ($t0)
	lw $t0, kb_read_row
	sb $zero, ($t0)
	lw $t0, display_units
	sb $zero, ($t0)
	lw $t0, display_tens
	sb $zero, ($t0)
	
	jr $ra

# Desliga todos os segmentos do display, sem argumentos e sem retorno
CLEAR_DISPLAY: 
	lw $t0, display_units
	sb $zero, ($t0)
	lw $t0, display_tens
	sb $zero, ($t0)

# Args: $a0 = endereço do display, $a1 = valor para escrever
DISPLAY_SYMBOL:
	la $t0 seg_table 
	addu $t0, $t0, $a1 # Calcular o offset da lista de valores
	lb $s0, ($t0) # Carregar =o valor a ser escrito
	
	# Escrever o código para o display
	sb $s0, ($a0)
	jr $ra


# Não recebe argumentos; Retorno: $v0 = valor inserido;
GET_INPUT:
	li $t0, 1 # Começa lendo pela linha 0001
	INPUT_LOOP:
	
	# Comandar a leitura da linha:
	lw $t1, kb_read_row
	sb $t0, ($t1)
	
	# Receber resultado da leitura:
	lw $t1, kb_recieve_key 
	lb $v0, ($t1) # Carrega o valor da leitura
	bnez $v0, INPUT_RECIEVED # Se for diferente de 0, quer dizer que apertou um botão
	
	li $t1, 0x10 # valor para comparação = 10000
	beq $t0, $t1, GET_INPUT # voltar para a primeira linha caso passou do limite
	
	sll $t0, $t0, 1 # altera o contador para ler a proxima linha 
	j INPUT_LOOP
	
	INPUT_RECIEVED:
	# Transformar o código da tecla em seu valor
	# 4 bits para coluna + 4 bits para linha.
	# Tem que transformar o código em seu valor (1000 -> 0011, 0100 -> 0010, 0010 -> 0001, 0001 -> 0000)
	
	andi $t0, $v0, 0xF0 # Coluna
	srl $t0, $t0, 4 # Alinhar o número à direita
	clz $t0, $t0
	li $t2, 31
	sub $t0, $t2, $t0 # Conta o número de zeros à direita
	
	andi $t1, $v0, 0x0F # Linha
	clz $t1, $t1
	li $t2, 31
	sub $t1, $t2, $t1
	
	# o resultado é igual a 4x linha ($t1) + coluna ($t0)
	li $t2, 4
	mul $t1, $t1, $t2
	
	addu $v0, $t0, $t1
	sw $v0, n
	
	jr $ra