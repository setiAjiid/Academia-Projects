#include <iostream>
#include <vector>
#include <fstream>
#include <chrono>
#include <cstdlib>
using namespace std;

const int TABLE_SIZE = 1001;

struct HashNode {
    int key;
    HashNode* next;
    HashNode(int k) : key(k), next(nullptr) {}
};

class HashMap {
private:
    HashNode* table[TABLE_SIZE];

    int hash(int key) {
        return key % TABLE_SIZE;
    }

public:
    HashMap() {
        for (int i = 0; i < TABLE_SIZE; ++i) table[i] = nullptr;
    }

    void insert(int key, int& steps) {
        int index = hash(key);
        HashNode* node = table[index];
        while (node) {
            steps++;
            if (node->key == key) return;
            node = node->next;
        }
        steps++;
        HashNode* newNode = new HashNode(key);
        newNode->next = table[index];
        table[index] = newNode;
    }

    bool search(int key, int& steps) {
        int index = hash(key);
        HashNode* node = table[index];
        while (node) {
            steps++;
            if (node->key == key) return true;
            node = node->next;
        }
        return false;
    }

    void update(int key, int& steps) {
        int index = hash(key);
        HashNode* node = table[index];
        while (node) {
            steps++;
            if (node->key == key) {
                return;
            }
            node = node->next;
        }
    }

    bool remove(int key, int& steps) {
        int index = hash(key);
        HashNode* node = table[index];
        HashNode* prev = nullptr;
        while (node) {
            steps++;
            if (node->key == key) {
                if (prev) prev->next = node->next;
                else table[index] = node->next;
                delete node;
                return true;
            }
            prev = node;
            node = node->next;
        }
        return false;
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
    HashMap hashmap;

    cout << "\n========== Mulai Proses Hashmap (with Chaining) ==========\n";
    cout << "File Input      : " << filename << "\n";
    cout << "Jumlah Data     : " << data.size() << "\n";

    //INSERT
    cout << "\nFASE INSERT\n";
    int insertSteps = 0;
    auto start = chrono::high_resolution_clock::now();
    for (int key : data) {
        hashmap.insert(key, insertSteps);
    }
    auto end = chrono::high_resolution_clock::now();
    auto insertTime = chrono::duration_cast<chrono::microseconds>(end - start).count();
    cout << "Waktu Insert    : " << insertTime << " mikro sekon\n";
    cout << "Langkah Insert  : " << insertSteps << "\n";

    //pembuatan key
    srand(time(nullptr)); //inisialisasi random
    int testKey = data[rand() % data.size()];

    //SEARCH
    int totalSearchSteps = 0;
    long long totalSearchTime = 0;
    for (int i = 0; i < 1000; ++i) {
        int steps = 0;
        start = chrono::high_resolution_clock::now();
        hashmap.search(testKey, steps);
        end = chrono::high_resolution_clock::now();
        totalSearchTime += chrono::duration_cast<chrono::nanoseconds>(end - start).count();
        totalSearchSteps += steps;
    }

    //UPDATE
    int totalUpdateSteps = 0;
    long long totalUpdateTime = 0;
    for (int i = 0; i < 1000; ++i) {
        int steps = 0;
        start = chrono::high_resolution_clock::now();
        hashmap.update(testKey, steps);
        end = chrono::high_resolution_clock::now();
        totalUpdateTime += chrono::duration_cast<chrono::nanoseconds>(end - start).count();
        totalUpdateSteps += steps;
    }

    //DELETE
    int totalDeleteSteps = 0;
    long long totalDeleteTime = 0;
    for (int i = 0; i < 1000; ++i) {
        hashmap.insert(testKey, insertSteps); 
        int steps = 0;
        start = chrono::high_resolution_clock::now();
        hashmap.remove(testKey, steps);
        end = chrono::high_resolution_clock::now();
        totalDeleteTime += chrono::duration_cast<chrono::nanoseconds>(end - start).count();
        totalDeleteSteps += steps;
    }

    //OUTPUT SEMUA
    cout << "\n[SEARCH x1000]\n";
    cout << "Rata-rata Waktu : " << totalSearchTime / 1000 << " ns\n";
    cout << "Rata-rata Langkah: " << totalSearchSteps / 1000 << "\n";

    cout << "\n[UPDATE x1000]\n";
    cout << "Rata-rata Waktu : " << totalUpdateTime / 1000 << " ns\n";
    cout << "Rata-rata Langkah: " << totalUpdateSteps / 1000 << "\n";

    cout << "\n[DELETE x1000]\n";
    cout << "Rata-rata Waktu : " << totalDeleteTime / 1000 << " ns\n";
    cout << "Rata-rata Langkah: " << totalDeleteSteps / 1000 << "\n";

    cout << "\nNote: Hash Map manual tidak mendukung Range Query.\n";
    cout << "\n=========== Program Selesai ===========\n";

    return 0;
}
