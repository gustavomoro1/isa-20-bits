#!/usr/bin/env python3
"""Montador da ISA de 20 bits.

Uso:  python montador.py programa.asm [saida_base]
Gera: saida_base.hex.txt  (imagem para a ROM do Logisim)
      saida_base.bin.txt  (linguagem de maquina em binario, uma instrucao por linha)
      saida_base.lst.txt  (listagem: endereco, hex, assembly)
"""
import re
import sys

REGS = {"zero": 0, "ra": 1, "sp": 2, "gp": 3,
        "a0": 4, "a1": 5, "a2": 6, "a3": 7,
        "t0": 8, "t1": 9, "t2": 10, "t3": 11,
        "s0": 12, "s1": 13, "s2": 14, "s3": 15}
for i in range(16):
    REGS[f"x{i}"] = i

# tipo R: opcode 0000, funct escolhe
R_FUNCT = {"add": 0, "sub": 1, "and": 2, "or": 3,
           "xor": 4, "slt": 5, "sll": 6, "srl": 7, "mul": 8}
OPC = {"addi": 1, "andi": 2, "ori": 3, "lw": 4, "sw": 5,
       "beq": 6, "bne": 7, "blt": 8, "jal": 9, "jalr": 10}


class Erro(Exception):
    pass


def reg(s):
    s = s.strip().lower()
    if s not in REGS:
        raise Erro(f"registrador invalido: '{s}'")
    return REGS[s]


def num(s, labels=None, pc=None, relativo=False):
    s = s.strip()
    if labels is not None and s in labels:
        alvo = labels[s]
        return alvo - (pc + 1) if relativo else alvo
    try:
        return int(s, 0)
    except ValueError:
        raise Erro(f"valor/rotulo invalido: '{s}'")


def checa(v, bits, sinal, nome):
    lo, hi = (-(1 << (bits - 1)), (1 << (bits - 1)) - 1) if sinal else (0, (1 << bits) - 1)
    if not lo <= v <= hi:
        raise Erro(f"{nome} = {v} fora da faixa [{lo}, {hi}] ({bits} bits)")
    return v & ((1 << bits) - 1)


def expande(mn, ops):
    """Pseudoinstrucoes -> instrucoes reais."""
    if mn == "nop":
        return "addi", ["zero", "zero", "0"]
    if mn == "li":
        return "addi", [ops[0], "zero", ops[1]]
    if mn == "mv":
        return "addi", [ops[0], ops[1], "0"]
    if mn == "j":
        return "jal", ["zero", ops[0]]
    if mn == "ret":
        return "jalr", ["zero", "ra", "0"]
    if mn == "call":
        return "jal", ["ra", ops[0]]
    return mn, ops


def limpa(linha):
    linha = linha.split("#")[0].split(";")[0]
    return linha.strip()


def primeira_passada(linhas):
    labels, instrs, pc = {}, [], 0
    for n, bruta in enumerate(linhas, 1):
        l = limpa(bruta)
        while ":" in l:
            rot, l = l.split(":", 1)
            rot = rot.strip()
            if not re.fullmatch(r"[A-Za-z_]\w*", rot):
                raise Erro(f"linha {n}: rotulo invalido '{rot}'")
            if rot in labels:
                raise Erro(f"linha {n}: rotulo repetido '{rot}'")
            labels[rot] = pc
            l = l.strip()
        if not l:
            continue
        partes = l.replace(",", " ").split()
        mn, ops = partes[0].lower(), partes[1:]
        instrs.append((n, pc, mn, ops, bruta.rstrip()))
        pc += 1
    return labels, instrs


def codifica(mn, ops, labels, pc):
    mn, ops = expande(mn, ops)
    if mn in R_FUNCT:
        rd, rs1, rs2 = reg(ops[0]), reg(ops[1]), reg(ops[2])
        return (0 << 16) | (rd << 12) | (rs1 << 8) | (rs2 << 4) | R_FUNCT[mn]
    if mn in ("addi", "andi", "ori"):
        rd, rs1 = reg(ops[0]), reg(ops[1])
        v = num(ops[2], labels, pc)
        imm = checa(v, 8, mn == "addi", "imediato")
        return (OPC[mn] << 16) | (rd << 12) | (rs1 << 8) | imm
    if mn == "lw":  # lw rd, imm(rs1)
        rd = reg(ops[0])
        m = re.fullmatch(r"(.+)\((\w+)\)", ops[1])
        if not m:
            raise Erro("use lw rd, imm(rs1)")
        imm = checa(num(m.group(1), labels, pc), 8, True, "offset")
        return (4 << 16) | (rd << 12) | (reg(m.group(2)) << 8) | imm
    if mn == "sw":  # sw rs2, imm(rs1)
        rs2 = reg(ops[0])
        m = re.fullmatch(r"(.+)\((\w+)\)", ops[1])
        if not m:
            raise Erro("use sw rs2, imm(rs1)")
        imm = checa(num(m.group(1), labels, pc), 8, True, "offset")
        return (5 << 16) | (rs2 << 12) | (reg(m.group(2)) << 8) | imm
    if mn in ("beq", "bne", "blt"):  # b rs1, rs2, alvo
        rs1, rs2 = reg(ops[0]), reg(ops[1])
        imm = checa(num(ops[2], labels, pc, True), 8, True, "deslocamento do desvio")
        return (OPC[mn] << 16) | (rs2 << 12) | (rs1 << 8) | imm
    if mn == "jal":  # jal rd, alvo
        rd = reg(ops[0])
        imm = checa(num(ops[1], labels, pc, True), 12, True, "deslocamento do jal")
        return (9 << 16) | (rd << 12) | imm
    if mn == "jalr":  # jalr rd, rs1, imm
        rd, rs1 = reg(ops[0]), reg(ops[1])
        imm = checa(num(ops[2], labels, pc), 8, True, "offset")
        return (10 << 16) | (rd << 12) | (rs1 << 8) | imm
    raise Erro(f"instrucao desconhecida: '{mn}'")


def main():
    if len(sys.argv) < 2:
        print(__doc__)
        sys.exit(1)
    arq = sys.argv[1]
    base = sys.argv[2] if len(sys.argv) > 2 else re.sub(r"\.\w+$", "", arq)
    with open(arq, encoding="utf-8") as f:
        linhas = f.read().splitlines()
    try:
        labels, instrs = primeira_passada(linhas)
    except Erro as e:
        print("ERRO:", e)
        sys.exit(1)

    palavras, lst = [], []
    for n, pc, mn, ops, bruta in instrs:
        try:
            w = codifica(mn, ops, labels, pc)
        except (Erro, IndexError) as e:
            print(f"ERRO na linha {n} ({bruta.strip()}): {e}")
            sys.exit(1)
        palavras.append(w)
        lst.append(f"{pc:03X}: {w:05X}  {w:020b}  {bruta.strip()}")

    with open(base + ".hex.txt", "w") as f:
        f.write("v3.0 hex words addressed\n")
        for i in range(0, len(palavras), 8):
            grupo = " ".join(f"{w:05X}" for w in palavras[i:i + 8])
            f.write(f"{i:03X}: {grupo}\n")
    with open(base + ".bin.txt", "w") as f:
        f.write("\n".join(f"{w:020b}" for w in palavras) + "\n")
    with open(base + ".lst.txt", "w") as f:
        f.write("\n".join(lst) + "\n")
    print(f"{len(palavras)} instrucoes -> {base}.hex.txt, {base}.bin.txt, {base}.lst.txt")


if __name__ == "__main__":
    main()
