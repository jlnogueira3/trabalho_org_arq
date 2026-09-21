.data
entrada: .asciz "Seja bem vindo ao nosso jogo, vamos começar gerando o nosso número...\n"
gerador_sucesso: .asciz "Número gerado com sucesso! Pode iniciar a tentativa\n"
msg_tentativa: .asciz "Digite um número de 1 a 100"
msg_baixo: .asciz "O palpite foi muito baixo!\n"
msg_alto: .asciz "O palpite foi muito alto!\n"
msg_correto: .asciz "Parabens! Voce acertou o numero!\n"
msg_invalido: .asciz "Valor invalido. Digite um numero entre 1 e 100.\n"
msg_qtd_tentativas: .asciz "Quantidade de tentativas: "
msg_lista_tentativas: .asciz "Tentativas feitas (da mais recente para a mais antiga): "
espaco: .asciz " "
nova_linha: .asciz "\n"

.text
.globl main


main:

    # Inicializa a cabeça da lista como vazia
    li s0, 0

    # Inicializa a quantidade de tentativas
    li s2, 0

    # Printa mensagem de entrada
    li a7, 4
    la a0, entrada
    ecall

    # Cria uma semente para o nosso gerador
    li a7, 30
    ecall
    mv t0, a0

    # Chama o gerador
    jal gerador_numero

    # Agora que implementamos o valor, imprimimos
    # a mensagem de saída  
    li a7, 4
    la a0, gerador_sucesso
    ecall


    #loop para receber todas as tentativas
loop_tentativas:

    #Agora devemos receber o valor para que possamos comparar
    jal tentativa

    #Salvamos o valor recebido para não perder durante outras funções
    mv s3, a0

    #Agora verificamos se o valor é menor que 1
    li t0, 1
    blt s3, t0, entrada_invalida

    #Agora verificamos se o valor é maior que 100
    li t0, 100
    blt t0, s3, entrada_invalida

    #Enviamos o valor recebido para adicionar na lista
    mv a0, s3
    jal adicionar_tentativa

    #Aumentamos a quantidade de tentativas
    addi s2, s2, 1

    #Agora devemos fazer a tentativa 
    #Primeiro verificamos se o valor é muito baixo
    blt s3, s1, palpite_baixo

    #Depois verificamos se o valor é muito alto
    blt s1, s3, palpite_alto

    #Se o valor não for menor nem maior, então está correto
    j palpite_correto
    

entrada_invalida:
    #Imprimimos uma mensagem informando que o valor é inválido
    li a7, 4
    la a0, msg_invalido
    ecall

    #Como o valor é inválido, voltamos sem adicionar na lista
    j loop_tentativas


palpite_baixo:
    #Imprimimos uma mensagem informando que o valor é muito baixo
    li a7, 4
    la a0, msg_baixo
    ecall

    #Voltamos para receber uma nova tentativa
    j loop_tentativas


palpite_alto:
    #Imprimimos uma mensagem informando que o valor é muito alto
    li a7, 4
    la a0, msg_alto
    ecall

    #Voltamos para receber uma nova tentativa
    j loop_tentativas


palpite_correto:
    #Imprimimos uma mensagem informando que o jogador acertou
    li a7, 4
    la a0, msg_correto
    ecall

    #Depois devemos imprimir a quantidade e a lista de tentativas
    j fim


tentativa:
	#Imprime a string de entrada
    li a7,4
    la a0, msg_tentativa
    ecall
    #Agora vamos receber o número
    li a7,5
    ecall
    mv t4,a0
    ret
    #Valor recebido armazenado em t4, retornamos a main
	

gerador_numero:
    # t0 contém a semente
    li t1, 17
    li t2, 43
    li t3, 101

    mul t4, t0, t1
    add t4, t4, t2
    remu t0, t4, t3

    # Coloca no intervalo [1,100]
    li t1, 100
    remu s1, t0, t1
    addi s1, s1, 1
    #Valor recebido armazenado em s1
    ret
    

adicionar_tentativa:
    # Precisamos preservar a tentativa porque
    # a0 será usado pelo sbrk
    mv t1, a0

    # Aloca 8 bytes na heap
    li a0, 8
    li a7, 9
    ecall
    
    # a0 = endereço do novo nó
    mv t0, a0
    # novo->tentativa = tentativa
    sw t1, 0(t0)
    # novo->proximo = head
    sw s0, 4(t0)
    # head = novo
    mv s0, t0

    ret
    
    
fim:
    # ---------------------------------------------------
    # IMPRIME A QUANTIDADE DE TENTATIVAS
    # ---------------------------------------------------
    # Imprime a string "Quantidade de tentativas: "
    li a7, 4
    la a0, msg_qtd_tentativas
    ecall

    # Imprime o valor inteiro do contador (s2)
    li a7, 1
    mv a0, s2
    ecall

    # Pula uma linha
    li a7, 4
    la a0, nova_linha
    ecall

    # ---------------------------------------------------
    # PERCORRE E IMPRIME A LISTA LIGADA
    # ---------------------------------------------------
    # Imprime a string "Tentativas feitas: "
    li a7, 4
    la a0, msg_lista_tentativas
    ecall

    # Prepara o ponteiro para percorrer a lista
    mv t0, s0              # t0 recebe a cabeça da lista (s0)

loop_imprime_lista:
    beqz t0, fim_programa  # Se o ponteiro for 0 (NULL), chegamos ao fim da lista

    # Imprime o valor da tentativa armazenado no nó atual
    lw a0, 0(t0)           # Carrega o valor (primeiros 4 bytes do nó)
    li a7, 1               # ecall para imprimir inteiro
    ecall

    # Imprime um espaço em branco para separar os números
    li a7, 4
    la a0, espaco
    ecall

    # Avança para o próximo nó da lista
    lw t0, 4(t0)           # t0 recebe o endereço do próximo nó (últimos 4 bytes)
    j loop_imprime_lista   # Volta para o início do loop

fim_programa:
    # Pula uma linha no final para o terminal ficar organizado
    li a7, 4
    la a0, nova_linha
    ecall

    # Encerra o programa corretamente
    li a7, 10
    ecall
