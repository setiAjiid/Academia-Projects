#include <iostream>
#include <vector>
#include <algorithm>
#include <chrono>
#include <fstream>
using namespace std;

const int MAX_KEYS = 4;

struct BPlusNode {
    bool cek_leaf;
    vector<int> keys;
    vector<BPlusNode*> children;
    BPlusNode* next;

    BPlusNode(bool leaf) : cek_leaf(leaf), next(nullptr) {}
};

class BPlusTree {
public:
    BPlusTree() {
        root = new BPlusNode(true);
    }

    void insert(int key) {
        int insertCnt = 0;
        if (root->keys.size() == MAX_KEYS) {
            BPlusNode* newRoot = new BPlusNode(false);
            newRoot->children.push_back(root);
            splitChild(newRoot, 0);
            root = newRoot;
        }
        insertNonFull(root, key, insertCnt);
        insertSteps += insertCnt;
    }

    bool search(int key, int& steps) {
        BPlusNode* node = root;
        while (!node->cek_leaf) {
            int i = upper_bound(node->keys.begin(), node->keys.end(), key) - node->keys.begin();
            node = node->children[i];
            steps++;
        }
        for (int k : node->keys) {
            steps++;
            if (k == key) return true;
        }
        return false;
    }

    void update(int key, int& steps) {
        if (search(key, steps)) {
            steps++; 
        }
    }

    bool remove(int key, int& steps) {
        if (search(key, steps)) {
            steps++; 
            return true;
        }
        return false;
    }

    vector<int> rangeQuery(int x, int y, int& steps) {
        vector<int> result;
        if (x > y) swap(x, y);
        BPlusNode* node = root;
        while (!node->cek_leaf) {
            int i = upper_bound(node->keys.begin(), node->keys.end(), x) - node->keys.begin();
            node = node->children[i];
            steps++;
        }
        while (node) {
            for (int k : node->keys) {
                steps++;
                if (k > y) return result;
                if (k >= x) result.push_back(k);
            }
            node = node->next;
        }
        return result;
    }

    int getInsertSteps() const { return insertSteps; }

private:
    BPlusNode* root;
    int insertSteps = 0;

    void splitChild(BPlusNode* parent, int index) {
        BPlusNode* child = parent->children[index];
        BPlusNode* sibling = new BPlusNode(child->cek_leaf);
        int mid = MAX_KEYS / 2;

        if (child->cek_leaf) {
            sibling->keys.assign(child->keys.begin() + mid, child->keys.end());
            child->keys.resize(mid);

            sibling->next = child->next;
            child->next = sibling;

            parent->keys.insert(parent->keys.begin() + index, sibling->keys[0]);
        } else {
            sibling->keys.assign(child->keys.begin() + mid + 1, child->keys.end());
            child->keys.resize(mid);

            sibling->children.assign(child->children.begin() + mid + 1, child->children.end());
            child->children.resize(mid + 1);

            parent->keys.insert(parent->keys.begin() + index, child->keys[mid]);
        }
        parent->children.insert(parent->children.begin() + index + 1, sibling);
    }

    void insertNonFull(BPlusNode* node, int key, int& steps) {
        steps++;
        if (node->cek_leaf) {
            auto it = upper_bound(node->keys.begin(), node->keys.end(), key);
            node->keys.insert(it, key);
        } else {
            int i = upper_bound(node->keys.begin(), node->keys.end(), key) - node->keys.begin();
            if (node->children[i]->keys.size() == MAX_KEYS) {
                splitChild(node, i);
                if (key > node->keys[i]) i++;
            }
            insertNonFull(node->children[i], key, steps);
        }
    }
};

vector<int> loadData(const string& filename) {
    ifstream file(filename);
    vector<int> data;
    int key;
    while (file >> key) data.push_back(key);
    return data;
}

int main(int argc, char* argv[]) {
    string filename = argv[1];
    vector<int> data = loadData(filename);
    BPlusTree tree;

    cout << "\n========== Mulai Proses B+ Tree ==========\n";
    cout << "File Input      : " << filename << "\n";
    cout << "Jumlah Data     : " << data.size() << "\n";

    //INSERT
    cout << "\nFASE INSERT\n";
    auto start = chrono::high_resolution_clock::now();
    for (int i = 0; i < data.size(); ++i) tree.insert(data[i]);
    auto end = chrono::high_resolution_clock::now();
    auto insertTime = chrono::duration_cast<chrono::microseconds>(end - start).count();
    cout << "Waktu Insert    : " << insertTime << " mikro sekon\n";
    cout << "Langkah Insert  : " << tree.getInsertSteps() << "\n";

    //pembuatan key
    srand(time(nullptr)); //inisialisasi random
    int searchKey = data[rand() % data.size()];

    //SEARCH
    int totalSearchSteps = 0;
    long long totalSearchTime = 0;
    int sz = data.size();
    for (int i = 0; i < sz; ++i) {
        int steps = 0;
        start = chrono::high_resolution_clock::now();
        tree.search(searchKey, steps);
        end = chrono::high_resolution_clock::now();
        totalSearchTime += chrono::duration_cast<chrono::nanoseconds>(end - start).count();
        totalSearchSteps += steps;
    }

    //UPDATE
    int totalUpdateSteps = 0;
    long long totalUpdateTime = 0;
    for (int i = 0; i < sz; ++i) {
        int steps = 0;
        start = chrono::high_resolution_clock::now();
        tree.update(searchKey, steps);
        end = chrono::high_resolution_clock::now();
        totalUpdateTime += chrono::duration_cast<chrono::nanoseconds>(end - start).count();
        totalUpdateSteps += steps;
    }

    //DELETE
    int totalDeleteSteps = 0;
    long long totalDeleteTime = 0;
    for (int i = 0; i < sz; ++i) {
        int steps = 0;
        start = chrono::high_resolution_clock::now();
        tree.remove(searchKey, steps);
        end = chrono::high_resolution_clock::now();
        totalDeleteTime += chrono::duration_cast<chrono::nanoseconds>(end - start).count();
        totalDeleteSteps += steps;
    }

    //RANGE QUERY
    int x = data[20], y = data[60], rangeSteps = 0;
    start = chrono::high_resolution_clock::now();
    vector<int> result = tree.rangeQuery(x, y, rangeSteps);
    end = chrono::high_resolution_clock::now();
    auto rangeTime = chrono::duration_cast<chrono::microseconds>(end - start).count();

    //OUTPUT SEMUA
    cout << "\n[SEARCH x" << sz << "]\n";
    cout << "Waktu rata-rata : " << totalSearchTime / sz << " ns\n";
    cout << "Langkah rata-rata: " << totalSearchSteps / sz << "\n";

    cout << "\n[UPDATE x" << sz << "]\n";
    cout << "Waktu rata-rata : " << totalUpdateTime / sz << " ns\n";
    cout << "Langkah rata-rata: " << totalUpdateSteps / sz << "\n";

    cout << "\n[DELETE x" << sz << "]\n";
    cout << "Waktu rata-rata : " << totalDeleteTime / sz << " ns\n";
    cout << "Langkah rata-rata: " << totalDeleteSteps / sz << "\n";

    cout << "\n[RANGE QUERY]\n";
    cout << "Range: [" << x << ", " << y << "], Jumlah hasil: " << result.size() << "\n";
    cout << "Waktu Query     : " << rangeTime << " mikro sekon\n";
    cout << "Langkah Query   : " << rangeSteps << "\n";

    cout << "\n=========== Program Selesai ===========" << endl;
    return 0;
}
