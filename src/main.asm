# ---------------------------------------------
# Esse arquivo inicializa o sistema, limpando as memória, declarando as
# variáveis globais e realizando a transição para o estado de espera.
# ---------------------------------------------
.data

	.globl seconds, open	# Declaração das variáveis globais
	seconds: .word 0	# Timer do micro-ondas
	open: .word 0		# Sinal que indica se a porta está aberta	
  
.text
.globl MAIN	

# Procedimento global Main. Não recebe argumentos, não posssui retorno
MAIN:
	jal INIT_GUI		# Limpa a memória
	jal ENTER_WAIT_STATE	# Realiza a transição para o estado de espera
		
	
