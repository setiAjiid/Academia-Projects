#include <stdio.h>
#include <stdlib.h>
#include <time.h>

void generatefile(const char *filename, int n) {
    srand(time(NULL));

    int arr[n];
    for (int i = 0; i < n; i++) {
        arr[i] = i + 1;
    }

    for (int i = n - 1; i > 0; i--) {
        int j = rand() % (i + 1);
        int temp = arr[i];
        arr[i] = arr[j];
        arr[j] = temp;
    }

    FILE *file = fopen(filename, "w");
    if (file != NULL) {
        for (int i = 0; i < n; i++) {
            fprintf(file, "%d ", arr[i]);
        }
        fclose(file);
    }
}

int main() {
    generatefile("input_100.txt", 100);
    generatefile("input_500.txt", 500);
    generatefile("input_1000.txt", 1000);
    return 0;
}
