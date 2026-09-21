# Jogo Adivinhe o Numero em Assembly RISC-V

Trabalho pratico da disciplina SSC0902 - Organizacao e Arquitetura de Computadores.

O projeto implementa o jogo "Adivinhe o Numero" em Assembly RISC-V. O programa gera um numero entre 1 e 100 e solicita palpites ao jogador ate que o numero correto seja encontrado.

## Funcionalidades

- Geracao de numero pseudoaleatorio com um gerador congruente linear.
- Uso do tempo atual como semente do gerador.
- Validacao de entradas entre 1 e 100.
- Mensagens indicando se o palpite foi muito alto ou muito baixo.
- Contagem da quantidade de tentativas validas.
- Armazenamento dinamico das tentativas em uma lista ligada na heap.
- Impressao da quantidade e da lista de tentativas ao final do jogo.

As tentativas sao inseridas no inicio da lista ligada. Por isso, ao final do jogo, elas sao apresentadas da mais recente para a mais antiga.

## Requisitos

- RARS, simulador de Assembly RISC-V.
- Configuracao RV32.

## Como executar

1. Abra o RARS.
2. Selecione `File > Open` e abra o arquivo `main.asm`.
3. Selecione `Run > Assemble` ou pressione `F3`.
4. Selecione `Run > Go` ou pressione `F5`.
5. Digite os palpites no console, sempre usando numeros inteiros entre 1 e 100.

## Estrutura da lista ligada

Cada no ocupa 8 bytes na heap:

| Deslocamento | Conteudo |
| --- | --- |
| 0 bytes | Valor da tentativa |
| 4 bytes | Endereco do proximo no |

A cabeca da lista e mantida no registrador `s0`. Cada nova tentativa valida e inserida no inicio da lista.

## Organizacao do programa

- `main`: inicializa o jogo, controla as tentativas e realiza as comparacoes.
- `tentativa`: le e retorna o palpite informado pelo jogador.
- `gerador_numero`: aplica o gerador congruente linear e retorna um numero entre 1 e 100.
- `adicionar_tentativa`: aloca um novo no na heap e o adiciona ao inicio da lista.
- `fim`: imprime a quantidade e os valores das tentativas.

## Registradores principais

- `s0`: cabeca da lista ligada.
- `s1`: numero secreto.
- `s2`: quantidade de tentativas validas.
- `s3`: palpite atual.
- `a0` e `a1`: argumentos e valores de retorno das funcoes.

## Arquivos

- `main.asm`: codigo-fonte do jogo.
- `README.md`: instrucoes de execucao e descricao do projeto.
