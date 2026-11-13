#include <stdio.h>

#define N 2

int main() {
    int A[N][N] = {{1, 2}, {3, 4}};
    int B[N][N] = {{5, 6}, {7, 8}};
    int C[N][N];

    for (int i = 0; i < N; i++) {
        for (int j = 0; j < N; j++) {
            int soma = 0;
            for (int k = 0; k < N; k++) {
                soma = soma + A[i][k] * B[k][j];
            }
            C[i][j] = soma;
        }
    }

    for (int i = 0; i < N; i++) {
        printf("%d %d\n", C[i][0], C[i][1]);
    }
    return 0;
}
