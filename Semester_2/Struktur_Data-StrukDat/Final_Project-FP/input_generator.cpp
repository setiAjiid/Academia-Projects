#include <iostream>
#include <vector>
#include <fstream>
#include <algorithm>
#include <random>
using namespace std;

void generateFile(const string& filename, int n) {
    random_device rd;
    mt19937 g(rd());

    vector<int> arr;
    for (int i = 1; i <= n; ++i)
        arr.push_back(i);

    shuffle(arr.begin(), arr.end(), g);

    ofstream outFile(filename);
    if (outFile.is_open()) {
        for (int num : arr)
            outFile << num << ' ';
        outFile << endl;
        outFile.close();
        cout << "Berhasil membuat file: " << filename << " dengan " << n << " angka.\n";
    } else {
        cerr << "Gagal membuka file untuk menulis: " << filename << endl;
    }
}

int main() {
    generateFile("input_100.txt", 100);
    generateFile("input_500.txt", 500);
    generateFile("input_1000.txt", 1000);
    return 0;
} 
