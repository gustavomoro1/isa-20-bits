# =====================================================================
# TESTE DE TODAS AS INSTRUCOES DA ISA DE 20 BITS
# Cada teste calcula um valor em t0 e grava em DMEM[k]. O valor esperado
# esta no comentario de cada 'sw'. Ao final o programa fica preso em 'fim'.
# Entradas: a0 = 12 (1100), a1 = 10 (1010), a2 = 3, a3 = -1 (FFFFF)
# =====================================================================
    jal    zero, inicio            # pula a funcao (jal para frente)
func1:                     # funcao de teste: t0 = 55 e retorna
    addi   t0, zero, 55
    jalr zero, ra, 0       # retorna
inicio:
    addi   a0, zero, 12
    addi   a1, zero, 10
    addi   a2, zero, 3
    addi   a3, zero, -1
# [0] add 12+10
    add t0, a0, a1
    sw   t0, 0(zero)    # DMEM[0] = 0x00016 (22)
# [1] sub 12-10
    sub t0, a0, a1
    sw   t0, 1(zero)    # DMEM[1] = 0x00002 (2)
# [2] sub 10-12 (negativo)
    sub t0, a1, a0
    sw   t0, 2(zero)    # DMEM[2] = 0xFFFFE (-2)
# [3] and 1100&1010
    and t0, a0, a1
    sw   t0, 3(zero)    # DMEM[3] = 0x00008 (8)
# [4] or 1100|1010
    or t0, a0, a1
    sw   t0, 4(zero)    # DMEM[4] = 0x0000E (14)
# [5] xor 1100^1010
    xor t0, a0, a1
    sw   t0, 5(zero)    # DMEM[5] = 0x00006 (6)
# [6] slt 10<12 (verdadeiro)
    slt t0, a1, a0
    sw   t0, 6(zero)    # DMEM[6] = 0x00001 (1)
# [7] slt 12<10 (falso)
    slt t0, a0, a1
    sw   t0, 7(zero)    # DMEM[7] = 0x00000 (0)
# [8] slt 12<12 (igual)
    slt t0, a0, a0
    sw   t0, 8(zero)    # DMEM[8] = 0x00000 (0)
# [9] slt -1<3 (com sinal)
    slt t0, a3, a2
    sw   t0, 9(zero)    # DMEM[9] = 0x00001 (1)
# [10] sll 12<<3
    sll t0, a0, a2
    sw   t0, 10(zero)    # DMEM[10] = 0x00060 (96)
# [11] srl 12>>3
    srl t0, a0, a2
    sw   t0, 11(zero)    # DMEM[11] = 0x00001 (1)
# [12] srl -1>>3 (logico)
    srl t0, a3, a2
    sw   t0, 12(zero)    # DMEM[12] = 0x1FFFF (131071)
# [13] mul 12*10
    mul t0, a0, a1
    sw   t0, 13(zero)    # DMEM[13] = 0x00078 (120)
# [14] mul 12*(-1)
    mul t0, a0, a3
    sw   t0, 14(zero)    # DMEM[14] = 0xFFFF4 (-12)
# [15] addi 12+5
    addi t0, a0, 5
    sw   t0, 15(zero)    # DMEM[15] = 0x00011 (17)
# [16] addi 12+(-20)
    addi t0, a0, -20
    sw   t0, 16(zero)    # DMEM[16] = 0xFFFF8 (-8)
# [17] andi com zeros (FFFFF & 255)
    addi t1, zero, -1
    andi t0, t1, 255
    sw   t0, 17(zero)    # DMEM[17] = 0x000FF (255)
# [18] andi 12&10
    andi t0, a0, 10
    sw   t0, 18(zero)    # DMEM[18] = 0x00008 (8)
# [19] ori com zeros (0 | 128)
    ori t0, zero, 128
    sw   t0, 19(zero)    # DMEM[19] = 0x00080 (128)
# [20] ori 12|3
    ori t0, a0, 3
    sw   t0, 20(zero)    # DMEM[20] = 0x0000F (15)
# [21] sw/lw base zero
    addi t1, zero, 77
    sw t1, 100(zero)
    lw t0, 100(zero)
    sw   t0, 21(zero)    # DMEM[21] = 0x0004D (77)
# [22] sw/lw offset positivo
    addi t2, zero, 110
    sw a0, 5(t2)
    lw t0, 5(t2)
    sw   t0, 22(zero)    # DMEM[22] = 0x0000C (12)
# [23] lw offset negativo
    addi t2, zero, 120
    lw t0, -5(t2)
    sw   t0, 23(zero)    # DMEM[23] = 0x0000C (12)
# [24] beq tomado (iguais)
    addi t0, zero, 1
    beq a0, a0, b1
    addi t0, zero, 0
b1:
    sw   t0, 24(zero)    # DMEM[24] = 0x00001 (1)
# [25] beq NAO tomado (diferentes)
    addi t0, zero, 1
    beq a0, a1, b2
    addi t0, zero, 0
b2:
    sw   t0, 25(zero)    # DMEM[25] = 0x00000 (0)
# [26] bne tomado (diferentes)
    addi t0, zero, 1
    bne a0, a1, b3
    addi t0, zero, 0
b3:
    sw   t0, 26(zero)    # DMEM[26] = 0x00001 (1)
# [27] bne NAO tomado (iguais)
    addi t0, zero, 1
    bne a0, a0, b4
    addi t0, zero, 0
b4:
    sw   t0, 27(zero)    # DMEM[27] = 0x00000 (0)
# [28] blt tomado (10<12)
    addi t0, zero, 1
    blt a1, a0, b5
    addi t0, zero, 0
b5:
    sw   t0, 28(zero)    # DMEM[28] = 0x00001 (1)
# [29] blt NAO tomado (12<10 falso)
    addi t0, zero, 1
    blt a0, a1, b6
    addi t0, zero, 0
b6:
    sw   t0, 29(zero)    # DMEM[29] = 0x00000 (0)
# [30] blt NAO tomado (iguais)
    addi t0, zero, 1
    blt a0, a0, b7
    addi t0, zero, 0
b7:
    sw   t0, 30(zero)    # DMEM[30] = 0x00000 (0)
# [31] blt tomado (-1<3, com sinal)
    addi t0, zero, 1
    blt a3, a2, b8
    addi t0, zero, 0
b8:
    sw   t0, 31(zero)    # DMEM[31] = 0x00001 (1)
# [32] blt NAO tomado (3<-1 falso)
    addi t0, zero, 1
    blt a2, a3, b9
    addi t0, zero, 0
b9:
    sw   t0, 32(zero)    # DMEM[32] = 0x00000 (0)
# [33] desvio para tras (laco bne)
    addi t0, zero, 0
    addi t1, zero, 3
lp:
    addi t0, t0, 1
    bne t0, t1, lp
    sw   t0, 33(zero)    # DMEM[33] = 0x00003 (3)
# [34] jal para tras + retorno com jalr (func1 faz t0 = 55)
    jal ra, func1
ret1:
    sw   t0, 34(zero)    # DMEM[34] = 0x00037 (55)
# [35] jal guardou ra = endereco seguinte
    addi t0, ra, 0
    sw   t0, 35(zero)    # DMEM[35] = 0x00067 (103)
# [36] jalr para frente (salta e nao executa o addi)
    ori t2, zero, jr_alvo
    addi t0, zero, 1
    jalr t3, t2, 0
jr_ret:
    addi t0, zero, 0
jr_alvo:
    sw   t0, 36(zero)    # DMEM[36] = 0x00001 (1)
# [37] jalr guardou rd = endereco seguinte
    addi t0, t3, 0
    sw   t0, 37(zero)    # DMEM[37] = 0x0006D (109)
# [38] jalr com imediato (t2 + 4)
    ori t2, zero, jr_alvo2
    addi t2, t2, -4
    addi t0, zero, 1
    jalr zero, t2, 4
    addi t0, zero, 0
jr_alvo2:
    sw   t0, 38(zero)    # DMEM[38] = 0x00001 (1)
# [39] j para frente (jal com rd = zero)
    addi t0, zero, 1
    jal zero, j_alvo
    addi t0, zero, 0
j_alvo:
    sw   t0, 39(zero)    # DMEM[39] = 0x00001 (1)
fim:
    beq  zero, zero, fim   # fim do programa (preso aqui)
