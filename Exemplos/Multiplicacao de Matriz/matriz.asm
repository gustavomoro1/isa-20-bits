# MULTIPLICACAO DE MATRIZES 2x2:  C = A x B
# A = | 1 2 |   B = | 5 6 |   C = | 19 22 |
#     | 3 4 |       | 7 8 |       | 43 50 |
# Posicoes na DMEM (linha a linha):
#   A em 0 a 3,  B em 4 a 7,  C em 8 a 11
# Esperado: DMEM[8..11] = 19, 22, 43, 50

# --- guarda A na memoria ---
    addi t0, zero, 1
    sw   t0, 0(zero)        # A[0][0] = 1
    addi t0, zero, 2
    sw   t0, 1(zero)        # A[0][1] = 2
    addi t0, zero, 3
    sw   t0, 2(zero)        # A[1][0] = 3
    addi t0, zero, 4
    sw   t0, 3(zero)        # A[1][1] = 4

# --- guarda B na memoria ---
    addi t0, zero, 5
    sw   t0, 4(zero)        # B[0][0] = 5
    addi t0, zero, 6
    sw   t0, 5(zero)        # B[0][1] = 6
    addi t0, zero, 7
    sw   t0, 6(zero)        # B[1][0] = 7
    addi t0, zero, 8
    sw   t0, 7(zero)        # B[1][1] = 8

# --- C = A x B ---
# s0 = i, s1 = j, s2 = k, s3 = soma, a1 = N
    addi a1, zero, 2        # N = 2
    addi s0, zero, 0        # i = 0
loop_i:
    mul  a0, s0, a1         # a0 = i * N
    addi s1, zero, 0        # j = 0
loop_j:
    addi s3, zero, 0        # soma = 0
    addi s2, zero, 0        # k = 0
loop_k:
    add  t0, a0, s2         # t0 = i*N + k
    lw   t1, 0(t0)          # t1 = A[i][k]
    mul  t2, s2, a1         # t2 = k * N
    add  t2, t2, s1         # t2 = k*N + j
    lw   t3, 4(t2)          # t3 = B[k][j]  (B comeca na posicao 4)
    mul  t1, t1, t3         # t1 = A[i][k] * B[k][j]
    add  s3, s3, t1         # soma = soma + t1
    addi s2, s2, 1          # k = k + 1
    bne  s2, a1, loop_k     # repete enquanto k != N
    add  t0, a0, s1         # t0 = i*N + j
    sw   s3, 8(t0)          # C[i][j] = soma  (C comeca na posicao 8)
    addi s1, s1, 1          # j = j + 1
    bne  s1, a1, loop_j     # repete enquanto j != N
    addi s0, s0, 1          # i = i + 1
    bne  s0, a1, loop_i     # repete enquanto i != N
fim:
    beq  zero, zero, fim    # fim do programa
