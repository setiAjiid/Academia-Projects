// Keputih, Surabaya, Jawa Timur, Indonesia - 14/06/25 - 09.29

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <stdbool.h>
#include <string.h>

#define ull unsigned long long //%llu  >10^18
#define ll long long //%lld 10^18
//#define float %f
//#define double %lf
#define min(a, b) ((a) < (b) ? (a) : (b))
#define max(a, b) ((a) > (b) ? (a) : (b))

typedef struct{
    int *arr;
    size_t maks_cap, size_cur;
    int head, tail;
} Queue;

void init(Queue *q, size_t sz_awal){
    q->arr = (int*)malloc(sz_awal * sizeof(int));
    if (!(q->arr)){
        exit(1);
    }
    q->maks_cap = sz_awal;
    q->size_cur = 0;
    q->head = q->tail = 0; //push dlu, baru increment
}

int empty(Queue *q){
    return (q->size_cur == 0);
}

bool full(Queue *q){
    return (q->size_cur == q->maks_cap);
}

void resize(Queue *q){
    int new_cap = q->maks_cap * 2;
    int *new_arr = (int*)malloc(new_cap * sizeof(int));
    if (!new_arr){
        exit(1);
    }
    //reser idx ke 0 lagi
    for (int i = 0; i < q->size_cur; i++){
        new_arr[i] = q->arr[(q->head + i) % q->maks_cap];
    }
    free(q->arr);
    q->arr = new_arr;
    q->maks_cap = new_cap;
    q->head = 0;
    q->tail = q->size_cur;
}

void push_back(Queue *q, int val){
    if (full(q)) resize(q);
    q->arr[q->tail] = val;
    q->tail = (q->tail + 1) % q->maks_cap;
    q->size_cur++;
}

void push_front(Queue *q, int val){
    if (full(q)) resize(q);
    q->head = (q->head - 1 + q->maks_cap) % q->maks_cap;
    q->arr[q->head] = val;
    q->size_cur++;
}

void pop_front(Queue *q){
    if (empty(q)) return;
    q->head = (q->head + 1) % q->maks_cap;
    q->size_cur--;
}

void pop_back(Queue *q){
    if (empty(q)) return;
    q->tail = (q->tail - 1 + q->maks_cap) % q->maks_cap;
    q->size_cur--;
}

void balik(Queue *q){
    if (empty(q) || q->size_cur <= 1) return;
    int tmp = q->arr[q->head];
    q->arr[q->head] = q->arr[(q->tail - 1 + q->maks_cap) % q->maks_cap];
    q->arr[(q->tail - 1 + q->maks_cap) % q->maks_cap] = tmp;
}

int front(Queue *q){
    if (empty(q)) return -1;
    return q->arr[q->head];
}

int back(Queue *q){
    if (empty(q)) return -1;
    return q->arr[(q->tail - 1 + q->maks_cap) % q->maks_cap];
}

void clear(Queue *q){
    free(q->arr);
    q->arr = NULL;
    q->maks_cap = q->size_cur = q->head = q->tail = 0;
}

int main(){
    Queue q;
    int n;
    scanf("%d", &n);
    init(&q, n);

    for (int i = 0; i < n; i++){
        char s[20];
        scanf("%s", s);
        int x = 0;
        if (strcmp(s, "tambahDepan") == 0){
            scanf("%d", &x);
            push_front(&q, x);
        } else if (strcmp(s, "tambahBelakang") == 0){
            scanf("%d", &x);
            push_back(&q, x);
        } else if (strcmp(s, "depan") == 0){
            x = front(&q);
            if (x == -1) printf("\n");
            else printf("%d\n", x);
            pop_front(&q);
        } else if (strcmp(s, "belakang") == 0){
            x = back(&q);
            if (x == -1) printf("\n");
            else printf("%d\n", x);
            pop_back(&q);
        } else {
            balik(&q);
        }
    }
    clear(&q);
}




