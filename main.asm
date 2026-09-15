.data
entrada: .asciz "Seja bem vindo ao nosso jogo, vamos começar gerando o nosso número...\n"
gerador_sucesso: .asciz "Número gerado com sucesso! Pode iniciar a tentativa\n"

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
    ecall

   
   
   
   
   
   j fim
   


gerador_numero:
    # t0 contém a semente
    li t1, 17
    li t2, 43
    li t3, 101
    mul t4, t0, t1
    add t4, t4, t2
    remu t0, t4, t3
    # Precisamos colocar no intervalo: [1,100]
    li t1, 100
    remu t5, t0, t1
    addi t5, t5, 1

    ret
fim:
    li a7, 10
    ecall