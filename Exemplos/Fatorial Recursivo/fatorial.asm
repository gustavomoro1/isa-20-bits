# FATORIAL RECURSIVO
# Calcula 5! e guarda o resultado em DMEM[0].
# Esperado: DMEM[0] = 120

main:
    ori  sp, zero, 255      # sp = 255 (inicio da pilha)
    addi a0, zero, 5        # n = 5
    jal  ra, fat            # chama fat(n); o resultado volta em a0
    sw   a0, 0(zero)        # DMEM[0] = resultado
fim:
    beq  zero, zero, fim    # fim do programa

fat:
    addi sp, sp, -2         # abre 2 posicoes na pilha
    sw   ra, 1(sp)          # guarda o endereco de retorno
    sw   a0, 0(sp)          # guarda n
    addi t0, zero, 1        # t0 = 1
    blt  t0, a0, recursivo  # se 1 < n, vai para o caso recursivo
    addi a0, zero, 1        # caso base: devolve 1
    addi sp, sp, 2          # fecha a pilha
    jalr zero, ra, 0        # volta para quem chamou

recursivo:
    addi a0, a0, -1         # n - 1
    jal  ra, fat            # a0 = fat(n-1)
    lw   t1, 0(sp)          # recupera n
    lw   ra, 1(sp)          # recupera o endereco de retorno
    addi sp, sp, 2          # fecha a pilha
    mul  a0, a0, t1         # a0 = n * fat(n-1)
    jalr zero, ra, 0        # volta para quem chamou
