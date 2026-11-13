#include <stdio.h>

int fatorial(int n) {
    if (n <= 1)
        return 1;
    return n * fatorial(n - 1);
}

int main() {
    int resultado = fatorial(5);
    printf("%d\n", resultado);
    return 0;
}
