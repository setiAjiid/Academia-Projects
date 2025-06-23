// Keputih, Surabaya, Jawa Timur, Indonesia - 13/06/25 - 09.33

#include <stdio.h>
#include <math.h>
#include <stdbool.h>
#include <stdlib.h>
#include <string.h>
#define ull unsigned long long
#define ll long long
#define min(a, b) ((a) < (b) ? (a) : (b))
#define max(a, b) ((a) > (b) ? (a) : (b))

typedef struct Node {
    int val;
    struct Node *left, *right;
} Node;

Node* initNode(int val) {
    Node* n = (Node*)malloc(sizeof(Node));
    n->val = val;
    n->left = n->right = NULL;
    return n;
}

Node* ins(Node* root, int val) {
    if (!root) return initNode(val);
    if (val < root->val) root->left = ins(root->left, val);
    else if (val > root->val) root->right = ins(root->right, val);
    return root;
}

Node* fd(Node* root, int val, int *cnt) {
    (*cnt)++;
    if (!root) return NULL;
    if (val == root->val) return root;
    return val < root->val ? fd(root->left, val, cnt) : fd(root->right, val, cnt);
}

int fd_min(Node* root) {
    if (!root) return -1;
    while (root->left) root = root->left;
    return root->val;
}

int fd_max(Node* root) {
    if (!root) return -1;
    while (root->right) root = root->right;
    return root->val;
}

void preo(Node* root) {
    if (!root) return;
    printf("%d ", root->val);
    preo(root->left);
    preo(root->right);
}

void ino(Node* root) {
    if (!root) return;
    ino(root->left);
    printf("%d ", root->val);
    ino(root->right);
}

void posto(Node* root) {
    if (!root) return;
    posto(root->left);
    posto(root->right);
    printf("%d ", root->val);
}

Node* del(Node* root, int val) {
    if (!root) return NULL;
    if (val < root->val) {
        root->left = del(root->left, val);
    } else if (val > root->val) {
        root->right = del(root->right, val);
    } else {
        if (!root->left) {
            Node* temp = root->right;
            free(root);
            return temp;
        } else if (!root->right) {
            Node* temp = root->left;
            free(root);
            return temp;
        }
        int minRight = fd_min(root->right);
        root->val = minRight;
        root->right = del(root->right, minRight);
    }
    return root;
}

void clearTree(Node* root) {
    if (!root) return;
    clearTree(root->left);
    clearTree(root->right);
    free(root);
}

int main() {
    Node* root = NULL;
    int n;
    scanf("%d", &n);
    while (n--){
        char s[10];
        ll x;
        scanf("%s", s);
        if (strcmp(s, "INSERT") == 0){
            scanf("%d", &x);
            root = ins(root, x);
        } else if (strcmp(s, "DELETE") == 0){
            scanf("%d", &x);
            root = del(root, x);
        } else if (strcmp(s, "SEARCH") == 0){
            scanf("%d", &x);
            int cnt = 0;
            Node* cek = fd(root, x, &cnt);
            if (cek) printf("%d\n", cnt);
            else printf("-1\n");
        } else {
            if (!root) {
                printf("EMPTY");
            } else ino(root);
            printf("\n");
        }
    }
    clearTree(root);
    return 0;
}
