.data
entrada: .asciz "Seja bem vindo ao nosso jogo, vamos começar gerando o nosso número...\n"
gerador_sucesso: .asciz "Número gerado com sucesso! Pode iniciar a tentativa\n"
msg_tentativa: .asciz "Digite um número de 1 a 100"
.text
main:
    # Printa mensagem de entrada
    li a7, 4
    la a0, entrada
    ecall
    # Chama o gerador
    jal gerador_numero


    # Agora que implementamos o valor, imprimimos
    # a mensagem de saída  
    li a7, 4
    la a0, gerador_sucesso
    
    #Agora devemos receber o valor para que possamos comparar
    jal tentativa
    jal adicionar_tentativa
    
    #Agora devemos fazer a tentativa 
    ecall
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
    li a7, 10
    ecall
