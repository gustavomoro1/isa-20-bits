# Arquitetura de Conjunto de Instruções de 20 Bits (ISA)

Projeto acadêmico de desenvolvimento de uma arquitetura de conjunto de instruções (ISA) de 20 bits, realizado como parte da disciplina de Projetos Digitais.

O trabalho envolve a definição de uma arquitetura de processador própria, incluindo seu conjunto de instruções, implementação em circuito digital, desenvolvimento de um montador e criação de programas em Assembly.

## Visão Geral da Arquitetura

A arquitetura do processador foi projetada e implementada utilizando o Logisim.

![Arquitetura completa](images/DataPath.png)

## Principais Componentes

### Banco de Registradores

![Banco de registradores](images/BancoRegistradores.png)

### Unidade Lógica e Aritmética (ULA)

![ULA](images/Ula.png)

### Unidade de Controle

![Unidade de controle](images/UnidadeControle.png)

## Montador (Assembler)

O projeto inclui um montador desenvolvido em Python, responsável por traduzir programas escritos em Assembly para a representação de instruções utilizada pela arquitetura.

## Programas em Assembly

O repositório contém exemplos desenvolvidos para demonstrar e testar o funcionamento da arquitetura:

- **Fatorial Recursivo:** implementação do cálculo de fatorial utilizando recursividade.
- **Multiplicação de Matrizes:** programa para realizar multiplicação de matrizes utilizando o conjunto de instruções desenvolvido.
- **Teste de Instruções:** programas destinados a testar as instruções implementadas na arquitetura.


## Tecnologias e Ferramentas

- **Logisim:** desenvolvimento e simulação de circuitos digitais.
- **Assembly:** programação em baixo nível utilizando o conjunto de instruções próprio.
- **Python:** desenvolvimento do montador.

## Estrutura do Repositório

```text
isa-20-bits/
├── Documentos/
├── Circuitos/
├── Assembler/
├── Exemplos/
├── Imagens/
└── README.md
```

## Sobre o Projeto

Desenvolvido como parte de um projeto acadêmico da graduação em Ciência da Computação.

Repositório disponibilizado para fins educacionais e de portfólio.
