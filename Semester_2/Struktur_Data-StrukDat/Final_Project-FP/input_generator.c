#include <stdio.h>
#include <stdlib.h>
#include <time.h>

void sorted_data(const char *filename, int n) {
    FILE *file = fopen(filename, "w");
    if (file != NULL) {
        for (int i = 1; i <= n; i++) {
            fprintf(file, "%d", i);
            if (i < n) {
                fprintf(file, " ");
            }
        }
        fclose(file);
    }
}

void random_data(const char *filename, int n) {
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
            fprintf(file, "%d", arr[i]);
            if (i < n - 1) {
                fprintf(file, " ");
            }
        }
        fclose(file);
    }
}

int main() {
    sorted_data("sorted_100.txt", 100);
    sorted_data("sorted_500.txt", 500);
    sorted_data("sorted_1000.txt", 1000);
    random_data("random_100.txt", 100);
    random_data("random_500.txt", 500);
    random_data("random_1000.txt", 1000);
    return 0;
}
