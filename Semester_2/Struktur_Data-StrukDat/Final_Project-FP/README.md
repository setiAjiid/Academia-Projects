## A. Pembuatan Generator Data

## B. Implementasi B+ Tree

Berikut adalah penjelasan mengenai implementasi B+ Tree dalam bahasa C++ yang saya buat. Program ini dirancang untuk menyimpan data dalam struktur B+ Tree, yang merupakan variasi dari B-Tree dengan beberapa keunggulan, terutama dalam hal efisiensi pencarian dan penyimpanan data.

### Header dan Konstanta

---

```cpp
#include <iostream>
#include <vector>
#include <algorithm>
#include <chrono>
#include <fstream>
using namespace std;
```

Di awal program, saya menyertakan beberapa header penting:

- `<iostream>`: Untuk proses input-output ke terminal.
- `<vector>`: Untuk menyimpan struktur data dinamis seperti array.
- `<algorithm>`: Untuk fungsi-fungsi STL seperti `upper_bound`.
- `<chrono>`: Untuk menghitung durasi eksekusi waktu.
- `<fstream>`: Untuk membaca file input dari luar.

Selain itu, terdapat konstanta `MAX_KEYS = 4`, yang berarti setiap node pada B+ Tree dapat menyimpan maksimal 4 kunci sebelum harus dipecah (split). Nilai ini membuat tree tetap seimbang dan sederhana untuk simulasi.

### Struktur BPlusNode

---

```cpp
const int MAX_KEYS = 4;

struct BPlusNode {
    bool cek_leaf;
    vector<int> keys;
    vector<BPlusNode*> children;
    BPlusNode* next;
    BPlusNode(bool leaf) : cek_leaf(leaf), next(nullptr) {}
};
```

Saya membuat sebuah `struct` bernama `BPlusNode` yang merepresentasikan setiap node dalam B+ Tree.  
Setiap node memiliki atribut sebagai berikut:

- `cek_leaf`: Menandakan apakah node ini adalah leaf atau bukan.
- `keys`: Daftar kunci yang disimpan.
- `children`: Pointer ke node-node anak (untuk node internal).
- `next`: Pointer ke node leaf selanjutnya, yang sangat penting untuk proses _range query_.

## Kelas BPlusTree

Saya membungkus semua fungsi dan struktur utama tree ke dalam class BPlusTree. Berikut penjelasan tiap fungsinya:

### Konstruktor `BPlusTree()`

```cpp
class BPlusTree {
public:
    BPlusTree() {
        root = new BPlusNode(true);
    }
```

Pada saat objek tree dibuat, saya langsung inisialisasi root-nya sebagai node leaf kosong. Ini karena saat awal belum ada data, dan B+ Tree dimulai dari satu node tunggal.

### Fungsi `insert()`

```cpp
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
```

Fungsi ini saya buat untuk menyisipkan kunci baru ke dalam tree. Jika root sudah penuh (MAX_KEYS), maka saya pecah terlebih dahulu dan buat root baru yang non-leaf. Selanjutnya, penyisipan dilakukan lewat fungsi bantu `insertNonFull()` yang menjamin key ditaruh di posisi yang tepat.

Saya juga menambahkan variabel `insertCnt` untuk menghitung jumlah langkah selama proses insert agar bisa dianalisis performanya nanti.

### Fungsi `insertNonFull()`

```cpp
private:
...
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
```

Fungsi ini merupakan inti dari proses penyisipan. Jika node yang dituju adalah leaf, posisi penyisipan akan dicari menggunakan `upper_bound()`, kemudian key akan dimasukkan pada posisi tersebut. Jika node bukan leaf, maka akan dicari anak yang sesuai, lalu dicek apakah anak tersebut sudah penuh atau belum. Jika penuh, anak tersebut harus di-split terlebih dahulu sebelum melanjutkan proses penyisipan. Variabel `steps` digunakan untuk menghitung seberapa dalam atau kompleks proses insert berlangsung, yang penting untuk evaluasi performa algoritma.

### Fungsi `splitChild()`

```cpp
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
```

Ketika sebuah node penuh, fungsi ini digunakan untuk membagi node tersebut menjadi dua bagian. Jika node yang dipecah adalah leaf, kunci dibagi secara merata dan node sibling dihubungkan ke dalam linked list leaf. Jika node yang dipecah adalah node internal, satu kunci tengah akan dinaikkan ke parent agar struktur tree tetap seimbang. Fungsi ini digunakan untuk menjaga B+ Tree tetap seimbang.

### Fungsi `search()`

```cpp
public:
...
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
```

Fungsi ini dibuat untuk mencari apakah suatu kunci (`key`) terdapat dalam tree atau tidak. Pencarian dimulai dari root, kemudian menavigasi ke bawah menggunakan `upper_bound()` hingga mencapai node leaf. Pada node leaf, setiap kunci dicek satu per satu. Setiap langkah pencarian dihitung melalui variabel `steps` untuk mengukur performa proses pencarian.

### Fungsi `update()`

```cpp
public:
...
    void update(int key, int& steps) {
        if (search(key, steps)) {
            steps++;
        }
    }
```

Fungsi ini sebenarnya hanya formalitas semata untuk keperluan tugas Final Project ini, saya hanya ingin mengetahui berapa langkah yang diperlukan untuk menemukan key lalu melakukan "update". Logikanya sama seperti `search()`, hanya saja setelah key ditemukan, saya tambahkan `steps++` sebagai simulasi proses update (tanpa mengubah isi key).

### Fungsi `remove()`

```cpp
public:
...
    bool remove(int key, int& steps) {
        if (search(key, steps)) {
            steps++;
            return true;
        }
        return false;
    }
```

Seperti update, fungsi ini juga dummy. Saya ingin tahu berapa langkah yang diperlukan untuk menemukan key sebelum dihapus.
Tidak ada penghapusan sesungguhnya, namun hanya menghitung beban pencarian sebelum delete dilakukan.

### Fungsi `rangeQuery()`

```cpp
public:
...
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
```

Fungsi ini saya buat khusus untuk mencari semua kunci dalam rentang `[x, y]`. Saya mulai dari root, mengarahkan pencarian ke node leaf yang pertama kali menyentuh x, lalu melanjutkan ke kanan melalui next pointer antar leaf. Setiap kunci yang berada dalam rentang tersebut langsung saya simpan ke dalam vector hasil. Karena leaf pada B+ Tree saling terhubung, range query ini dapat berjalan dengan sangat efisien.

### Fungsi `getInsertSteps()`

```cpp
int getInsertSteps() const { return insertSteps; }
```

Fungsi sederhana ini hanya mengembalikan total langkah yang digunakan untuk proses insert — digunakan untuk laporan performa.

### Fungsi loadData(const string& filename)

---

```cpp
vector<int> loadData(const string& filename) {
    ifstream file(filename);
    vector<int> data;
    int key;
    while (file >> key) data.push_back(key);
    return data;
}
```

Fungsi ini saya buat untuk membaca data input dari file. Setiap angka yang terdapat dalam file akan disimpan ke dalam `vector<int> data`. Kemudian, data ini akan digunakan sebagai input utama dalam proses penyisipan data ke dalam tree.

### Fungsi `main(int argc, char* argv[])`

---

Secara ringkas, inti dari kode ini dipaparkan di dalam _main function_. Berikut adalah penjelasan alur fungsi utama program:

1. **Validasi Argumen Input**  
   Program memeriksa apakah argumen input (nama file data) sudah diberikan. Jika tidak, program akan keluar.

2. **Membaca Data dari File**  
   Fungsi `loadData()` dipanggil untuk membaca seluruh data dari file ke dalam sebuah `vector<int>`.

3. **Inisialisasi dan Penyisipan Data ke B+ Tree**  
   Objek `BPlusTree` dibuat. Seluruh data dari file kemudian dimasukkan ke dalam tree menggunakan fungsi `insert()`. Selama proses ini, waktu eksekusi dan jumlah langkah penyisipan dihitung.

4. **Pengujian Operasi Search, Update, dan Delete**  
   Salah satu kunci (secara random, misal: `data[3]`) dipilih untuk diuji. Operasi pencarian (`search`), update (`update`), dan penghapusan (`remove`) dilakukan sebanyak `size of data` kali untuk mengukur performa dan jumlah langkah rata-rata.

5. **Pengujian Range Query**  
   Fungsi `rangeQuery()` dijalankan untuk mengukur performa pencarian data dalam rentang tertentu.

6. **Menampilkan Hasil Analisis**  
   Seluruh hasil analisis, seperti waktu eksekusi dan jumlah langkah untuk setiap operasi, ditampilkan ke terminal agar dapat dievaluasi.

## C. Implementasi Hahsmap (with Chaining)

```c
#include <iostream>
#include <vector>
#include <fstream>
#include <chrono>
#include <cstdio>
#include <cstdlib>

using namespace std;

const int TABLE_SIZE = 1001;
```

Di awal program `hashmap.cpp` disertakan beberapa include-an header yang dibutuhkan untuk dapat membuat struktur data HashMap ini,
diantaranya adalah `vector` yang digunakan untuk array hashmap, `chrono` untuk perhitungan waktu, `iostream` untuk I/O, `fstream` untuk pembacaan
input / entry dari luar, `cstdlib` untuk pembuatan linked list yang digunakan dalam HashMap teknik Chaining dan `cstdio` untuk fungsi-fungsi seperti `snprintf`.

```c
struct HashNode {
  int key;
  HashNode *next;
  HashNode(int k) : key(k), next(nullptr) {}
};

HashNode *table[TABLE_SIZE];

int hash(int key) {
    char buf[32];
    snprintf(buf, sizeof(buf), "%d", key);

char *p_buf = buf;

    unsigned long hash = 5381;

    int c;
    while ((c = *p_buf++)) {
      hash = ((hash << 5) + hash) + c;
    }

    // USING DJB2 HASH FUNCTION

    return hash % TABLE_SIZE;
  }
```

Untuk slot hashmap dibuat menggunakan HashNode

## D. Kesimpulan
