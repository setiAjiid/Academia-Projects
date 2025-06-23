// Keputih, Surabaya, Jawa Timur, Indonesia - 12/06/25 - 15.46

#include <stdio.h>
#include <math.h>
#include <stdbool.h>
#include <stdlib.h>
#include <string.h>
#define ull unsigned long long //%llu  >10^18
#define ll long long //%lld 10^18
//#define float %f
//#define double %lf
#define min(a, b) ((a) < (b) ? (a) : (b))
#define max(a, b) ((a) > (b) ? (a) : (b))

typedef struct Node {
    int val;
    int ht;
    struct Node *left, *right;
} Node;


int nodeH(Node *node) {
    return node ? node->ht : 0;
}

Node* initNode(int val) {
    Node *newNode = (Node*)malloc(sizeof(Node));
    newNode->val = val;
    newNode->ht = 1;
    newNode->left = newNode->right = NULL;
    return newNode;
}

int bf(Node *node) { //balance factor
    return node ? nodeH(node->left) - nodeH(node->right) : 0;
}

Node* RRot(Node *y) { //rotasi kanan/Right Rotation
    Node *x = y->left; //ambil anak kiri dari node Y (root) yakni dinamain node X
    Node *subTree = x->right; //ambil subtree di kanan X buat digeser/dipindah ke ntar dibagian kiri node Y
    x->right = y; //pindahin root awal jadi child dari node X (jadi node X itu root baru kita)
    y->left = subTree; //nah ini pindahin subtree ke chlid kiri node Y
    //update ht dr node Y sama node X soalnya struktur childnya berubah, sisanya sama aja
    y->ht = max(nodeH(y->left), nodeH(y->right)) + 1;
    x->ht = max(nodeH(x->left), nodeH(x->right)) + 1;
    return x;
}


Node* LRot(Node *x) { //rotasi kiri/Left Rotation
    Node *y = x->right; //ambil anak kanan dari node X (root) dan dinamain node Y
    Node *subTree = y->left; //ambil subtree dari child2 yg ada pada bagian kiri node Y (biar ga ilang)
    y->left = x; //jadiin root awal sebagai child bagian kiri dari node Y (node Y jadi root baru)
    x->right = subTree; //subtree yg dah diambil tadi dipindahin ke kanan dari node X (mantan root kita)
    //update ht node X dan Y
    x->ht = max(nodeH(x->left), nodeH(x->right)) + 1;
    y->ht = max(nodeH(y->left), nodeH(y->right)) + 1;
    return y;
}

Node* insertAVL(Node *root, int val) {
    //cek + insert kek binary tree biasa
    if (!root) return initNode(val);
    if (val < root->val) root->left = insertAVL(root->left, val);
    else if (val > root->val) root->right = insertAVL(root->right, val);
    else return root; //duplikat, ga diinsert

    //update height setiap path dalam node baru (ini jalan scr bottom-up)
    root->ht = max(nodeH(root->left), nodeH(root->right)) + 1;
    int balance = bf(root); //harga balance factor/keseimbangan/kestabilan

    //4 kasus balancing
    if (balance > 1 && val < root->left->val) {
        Node *tmp = RRot(root);

        printf("Left Case\n");
        printf("PivotNode: %d\n", tmp->right->val);
        printf("PivotNode->left: %d\n", tmp->val);
        printf("PivotNode->left->left: %d\n", tmp->left->val);
        printf("\n");

        printf("result:\n");
        printf("NewNode: %d\n", tmp->val);
        printf("NewNode->left: %d\n", tmp->left->val);
        printf("NewNode->right: %d\n", tmp->right->val);
        printf("\n");

        return tmp; //LL-Left Left
    }
    if (balance < -1 && val > root->right->val) {
        Node *tmp = LRot(root);

        printf("Right Case\n");
        printf("PivotNode: %d\n", tmp->left->val);
        printf("PivotNode->right: %d\n", tmp->val);
        printf("PivotNode->right->right: %d\n", tmp->right->val);
        printf("\n");

        printf("result:\n");
        printf("NewNode: %d\n", tmp->val);
        printf("NewNode->left: %d\n", tmp->left->val);
        printf("NewNode->right: %d\n", tmp->right->val);
        printf("\n");

        return tmp; //RR-Right Right
    }
    if (balance > 1 && val > root->left->val) {  //LR-Left Right
        root->left = LRot(root->left);
        Node *tmp = RRot(root);

        printf("Left Right Case\n");
        printf("PivotNode: %d\n", tmp->right->val);
        printf("PivotNode->left: %d\n", tmp->left->val);
        printf("PivotNode->left->right: %d\n", tmp->val);
        printf("\n");

        printf("result:\n");
        printf("NewNode: %d\n", tmp->val);
        printf("NewNode->left: %d\n", tmp->left->val);
        printf("NewNode->right: %d\n", tmp->right->val);
        printf("\n");

        return tmp;
    }
    if (balance < -1 && val < root->right->val) { //RL-Right Left
        root->right = RRot(root->right);
        Node *tmp = LRot(root);

        printf("Right Left Case\n");
        printf("PivotNode: %d\n", tmp->left->val);
        printf("PivotNode->right: %d\n", tmp->right->val);
        printf("PivotNode->right->left: %d\n", tmp->val);
        printf("\n");

        printf("result:\n");
        printf("NewNode: %d\n", tmp->val);
        printf("NewNode->left: %d\n", tmp->left->val);
        printf("NewNode->right: %d\n", tmp->right->val);
        printf("\n");

        return tmp;
    }
    return root;
}

Node* findVal(Node *root, int val) { //search/find val tertentu
    if (!root) return NULL;
    if (val == root->val) return root;
    return (val < root->val) ? findVal(root->left, val) : findVal(root->right, val);
}

void ino(Node *root) {
    if (!root) return;
    ino(root->left);
    printf("%d ", root->val);
    ino(root->right);
}

void preo(Node *root) {
    if (!root) return;
    printf("%d ", root->val);
    preo(root->left);
    preo(root->right);
}

void posto(Node *root) {
    if (!root) return;
    posto(root->left);
    posto(root->right);
    printf("%d ", root->val);
}

void postoModifikasi(Node *root) {
    if (!root) return;
    postoModifikasi(root->right);
    postoModifikasi(root->left);
    printf("%d ", root->val);
}

void clearTree(Node *root) {
    if (!root) return;
    clearTree(root->left);
    clearTree(root->right);
    free(root);
}

int main() {
    Node *root = NULL;
    int n;
    scanf("%d", &n);
    while (n--){
        int val;
        scanf("%d", &val);
        root = insertAVL(root, val);
    }
    clearTree(root);
    return 0;
}

