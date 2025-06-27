## A. Pembuatan Generator Data

Berikut penjelasan mengenai program generator data dalam bahasa c. Program ini dibuat untuk menghasilkan file yang berisi data secara terurut dan random yang ukurannya bisa disesuaikan. Program ini nantinya akan digunakan dalam pengujian B+Tree dan Hashmap (with chaining).

Program ini menghasilkan dua jenis data:
- Sorted data: Angka dari 1 hingga n, dalam urutan menaik.
- Random data: Angka dari 1 hingga n, diacak menggunakan algoritma `Fisher-Yates Shuffle`.

Lalu hasilnya disimpan dalam format `.txt`.

### Fungsi sorted_data()

```c
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
```

Fungsi ini akan menuliskan angka 1 hingga n ke dalam file yang dipisahkan dengan spasi.

### Fungsi random_data()

```c
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
```

Fungsi ini akan membuat array yang isinya angka 1 hingga n. Selanjutnya akan dilakukan pengacakan dengan algoritma `Fisher-Yates Shuffle`:
- Dimulai dari indeks terakhir sampai indek ke-1.
- `rand() % (i + 1)` akan menghasilkan indeks acak dari 0 sampai i.
- Lakukan swap untuk agar data menjadi acak.

Dan yang terakhir, masukkan setiap angka hasil shuffle ke dalam file yang dipisahkan dengan spasi.

### Fungsi main

```c
int main() {
    sorted_data("sorted_100.txt", 100);
    sorted_data("sorted_500.txt", 500);
    sorted_data("sorted_1000.txt", 1000);
    random_data("random_100.txt", 100);
    random_data("random_500.txt", 500);
    random_data("random_1000.txt", 1000);
    return 0;
}
```

Di fungsi main ini akan memanggil fungsi `sorted_data()` dan `random_data()` dengan argumen nama file dan banyaknya data.

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

Fungsi sederhana ini hanya mengembalikan total langkah yang digunakan untuk proses insert pada laporan performa.

### Fungsi `loadData()`
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

```cpp
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

```cpp
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

Untuk slot hashmap dibuat menggunakan HashNode dengan banyak slot 1001 dengan metode chaining, kemudian untuk memperoleh hasil hashing dari sebuah entry, digunakan
algoritma DJB2 di fungsi hash(key) yang di modulo dengan angka 1001 agar tidak out-of-bound (pengaksesan array di luar batas). DJB2 bekerja dengan cara mengkonversi angka
menjadi string yang memuat angka yang ingin di hash, kemudian terdapat variabel `hash` yang berisi 5831 yang nanti nya akan di-shift ke kanan sebanyak 5 kali (dikali 33) dan ditambahkan dengan
nilai hash awal dan ditambahkan dengan nilai c (nilai ASCII index ke-i dari entry hash). `hash = ((hash << 5) + hash) + c`.

### Fungsi `insert()`

```cpp
void insert(int key, int &steps) {
    int index = hash(key);
    HashNode *node = table[index];
    while (node) {
      steps++;
      if (node->key == key)
        return;
      node = node->next;
    }
    steps++;
    HashNode *newNode = new HashNode(key);
    newNode->next = table[index];
    table[index] = newNode;
  }
```

Fungsi ini dibuat untuk memasukkan suatu entry kedalam hashmap dan meng-translasi key dari entry kedalam hash function yang dijadikan sebagai
index dari hashmap. Jika sudah terdapat suatu node yang memiliki hasil hash-ing yang sama, maka kami atasi dengan menggunakan teknik chaining untuk
menghindari collision dengan cara menchain nilai-nilai yang sudah ada seperti linked list dengan penambahan node berada didepan.

### Fungsi `search()`

```cpp
bool search(int key, int &steps) {
    int index = hash(key);
    HashNode *node = table[index];
    while (node) {
      steps++;
      if (node->key == key)
        return true;
      node = node->next;
    }
    return false;
  }
```

Fungsi ini dibuat untuk mencari suatu entri didalam hashmap berdasarkan hasil hash-ing. Apabila dalam index ke-i yang ditentukan oleh hashing function
tidak didapati entri yang ingin dicari maka pencarian akan diteruskan di index tersebut seperti traversal dalam linked list. Apabila ditemukan maka
dikembalikan nilai `true`, apabila tidak ditemukan dikembalikan nilai `false`.

### Fungsi `remove()`

```cpp
void update(int key, int newVal, int &steps) {
    int index = hash(key);
    HashNode *node = table[index];
    HashNode *prevNode = NULL;

    while (node) {
      steps++;
      if (node->key == key) {
        HashNode *nextNode = node->next;
        if (prevNode)
          prevNode->next = nextNode;
        else
          table[index] = nextNode;
        delete node;
        break;
      }

      prevNode = node;
      node = node->next;
    }

    insert(newVal, steps);
  }
```

Fungsi ini dibuat untuk mengupdate nilai dari suatu node yang ada di dalam hashmap menjadi nilai yang baru. Proses update dilakukan dengan prosedur
mencari terlebih dahulu lokasi hash nilai key lama kemudian menghapus node tersebut, kemudian memanggil fungsi `insert` yang sudah didefiniskan untuk membuat
dan meletakkan hash baru dari key yang baru kedalam hashmap.

### Fungsi `remove()`

```c
bool remove(int key, int &steps) {
    int index = hash(key);
    HashNode *node = table[index];
    HashNode *prev = nullptr;
    while (node) {
      steps++;
      if (node->key == key) {
        if (prev)
          prev->next = node->next;
        else
          table[index] = node->next;
        delete node;
        return true;
      }
      prev = node;
      node = node->next;
    }
    return false;
  }
```

Fungsi ini akan menghapus sebuah node entry dari hashmap dengan key yang dicari. Pencarian key dilakukan dengan mencari terlebih dahulu
hasil hash dari key yang akan dihapus. Apabila dalam hashmap tidak ditemukan key dengan hasil hash yang dimaksud, maka fungsi akan
mengembalikan nilai false. Namun apabila ditemukan maka akan mencari node yang dimaksud dengan meng-iterasi setiap node yang terdapat di lokasi
hash tersebut sampai menemukan node yang dimaksud dan menghapus node tersebut.

### Fungsi `loadData()`

```cpp
vector<int> loadData(const string &filename) {
  ifstream file(filename);
  vector<int> data;
  int key;
  while (file >> key)
    data.push_back(key);
  return data;
}
```

Fungsi ini dibuat untuk membaca data input dari file. Setiap angka yang terdapat dalam file akan disimpan ke dalam `vector<int> data`. Kemudian, data ini akan
digunakan sebagai input utama dalam proses penyisipan data ke dalam hashmap.

### Fungsi `main(int argc, char* argv[])`

Secara garis besar, saat menjalankan program setidaknya satu buah argumen dicantumkan yang dimana argumen ini berisikan path file yang digunakan
untuk memasukkan data kedalam hashmap. Kemudian dilakukan load data dari file yang sudah diberikan di argumen dan memasukkan satu-per-satu entry yang ada dalam file kedalam vector data
yang nantinya akan digunakan dalam proses insertion kedalam hashmap menggunakan fungsi `loadData`.

Untuk peng-inputan data kedalam hashmap digunakan fungsi `insert` yang memasukkan satu-per-satu data yang ada didalam vector. Kemudian saat melakukan proses insertion
juga dicatat berapa banyak step atau langkah yang diperlukan untuk prosedur ini dan juga waktu yang diperlukan untuk seluruh data dimasukkan kedalam hashmap menggunakan bantuan
library `chrono`.

Kemudian hal serupa juga dilakukan pada prosedur searching, update, dan juga delete yang masing-masing juga mencatat banyaknya step atau langkah yang diperlukan
dan juga waktu yang dibutuhkan setiap prosedur sampai selesai menggunakan library `chrono`.

Di akhir, diberikan seluruh hasil analisis mulai dari prosedur insert sampai delete yang disajikan dalam rata-rata waktu dan langkah relatif terhadap banyaknya data awal.

## D. Hasil Perbandingan

Berikut merupakan hasil perbandingan yang dilakukan dengan jumlah perlakuan sebanyak 5 kali di setiap percobaan yang dilakukan pada masing-masing data:

<table><tr><th colspan="1" valign="top"><b>Algoritma</b></th><th colspan="1" valign="top"><b>Jenis Data</b></th><th colspan="1" valign="top"><b>Jumlah Data</b></th><th colspan="1" valign="top"><b>Percobaan ke-</b></th><th colspan="1" valign="top"><b>Tolak Ukur Perbandingan</b></th><th colspan="1" valign="top"><b>Insert</b></th><th colspan="1" valign="top"><b>Search</b></th><th colspan="1" valign="top"><b>Update</b></th><th colspan="1" valign="top"><b>Delete</b></th><th colspan="1" valign="top"><b>Range Query</b></th></tr>
<tr><td colspan="1" rowspan="60">Hash Map</td><td colspan="1" rowspan="30">Random Data</td><td colspan="1" rowspan="10">100</td><td colspan="1" valign="top">1</td><td colspan="1" valign="top">Waktu</td><td colspan="1" valign="top">0 ms</td><td colspan="1" valign="top">1213 ns</td><td colspan="1" valign="top">0 ns</td><td colspan="1" valign="top">0 ns</td><td colspan="1" valign="top">-</td></tr>
<tr><td colspan="1" valign="top"></td><td colspan="1" valign="top">Step</td><td colspan="1" valign="top">101</td><td colspan="1" valign="top">1</td><td colspan="1" valign="top">1</td><td colspan="1" valign="top">1</td><td colspan="1" valign="top">-</td></tr>
<tr><td colspan="1" valign="top">2</td><td colspan="1" valign="top">Waktu</td><td colspan="1" valign="top">0 ms</td><td colspan="1" valign="top">0 ns</td><td colspan="1" valign="top">0 ns</td><td colspan="1" valign="top">0 ns</td><td colspan="1" valign="top">-</td></tr>
<tr><td colspan="1" valign="top"></td><td colspan="1" valign="top">Step</td><td colspan="1" valign="top">101</td><td colspan="1" valign="top">1</td><td colspan="1" valign="top">1</td><td colspan="1" valign="top">1</td><td colspan="1" valign="top">-</td></tr>
<tr><td colspan="1" valign="top">3</td><td colspan="1" valign="top">Waktu</td><td colspan="1" valign="top">0 ms</td><td colspan="1" valign="top">0 ns</td><td colspan="1" valign="top">0 ns</td><td colspan="1" valign="top">0 ns</td><td colspan="1" valign="top">-</td></tr>
<tr><td colspan="1" valign="top"></td><td colspan="1" valign="top">Step</td><td colspan="1" valign="top">101</td><td colspan="1" valign="top">1</td><td colspan="1" valign="top">1</td><td colspan="1" valign="top">1</td><td colspan="1" valign="top">-</td></tr>
<tr><td colspan="1" valign="top">4</td><td colspan="1" valign="top">Waktu</td><td colspan="1" valign="top">0 ms</td><td colspan="1" valign="top">0 ns</td><td colspan="1" valign="top">0 ns</td><td colspan="1" valign="top">0 ns</td><td colspan="1" valign="top">-</td></tr>
<tr><td colspan="1" valign="top"></td><td colspan="1" valign="top">Step</td><td colspan="1" valign="top">100</td><td colspan="1" valign="top">1</td><td colspan="1" valign="top">1</td><td colspan="1" valign="top">1</td><td colspan="1" valign="top">-</td></tr>
<tr><td colspan="1" valign="top">5</td><td colspan="1" valign="top">Waktu</td><td colspan="1" valign="top">0 ms</td><td colspan="1" valign="top">0 ns</td><td colspan="1" valign="top">1024 ns</td><td colspan="1" valign="top">0 ns</td><td colspan="1" valign="top">-</td></tr>
<tr><td colspan="1" valign="top"></td><td colspan="1" valign="top">Step</td><td colspan="1" valign="top">101</td><td colspan="1" valign="top">1</td><td colspan="1" valign="top">1</td><td colspan="1" valign="top">1</td><td colspan="1" valign="top">-</td></tr>
<tr><td colspan="1" rowspan="10">500</td><td colspan="1" valign="top">1</td><td colspan="1" valign="top">Waktu</td><td colspan="1" valign="top">0 ms</td><td colspan="1" valign="top">0 ns</td><td colspan="1" valign="top">0 ns</td><td colspan="1" valign="top">0 ns</td><td colspan="1" valign="top">-</td></tr>
<tr><td colspan="1" valign="top"></td><td colspan="1" valign="top">Step</td><td colspan="1" valign="top">601</td><td colspan="1" valign="top">2</td><td colspan="1" valign="top">2</td><td colspan="1" valign="top">1</td><td colspan="1" valign="top">-</td></tr>
<tr><td colspan="1" valign="top">2</td><td colspan="1" valign="top">Waktu</td><td colspan="1" valign="top">0 ms</td><td colspan="1" valign="top">0 ns</td><td colspan="1" valign="top">0 ns</td><td colspan="1" valign="top">0 ns</td><td colspan="1" valign="top">-</td></tr>
<tr><td colspan="1" valign="top"></td><td colspan="1" valign="top">Step</td><td colspan="1" valign="top">601</td><td colspan="1" valign="top">2</td><td colspan="1" valign="top">2</td><td colspan="1" valign="top">1</td><td colspan="1" valign="top">-</td></tr>
<tr><td colspan="1" valign="top">3</td><td colspan="1" valign="top">Waktu</td><td colspan="1" valign="top">1162 ms</td><td colspan="1" valign="top">0 ns</td><td colspan="1" valign="top">0 ns</td><td colspan="1" valign="top">1212 ns</td><td colspan="1" valign="top">-</td></tr>
<tr><td colspan="1" valign="top"></td><td colspan="1" valign="top">Step</td><td colspan="1" valign="top">601</td><td colspan="1" valign="top">1</td><td colspan="1" valign="top">1</td><td colspan="1" valign="top">1</td><td colspan="1" valign="top">-</td></tr>
<tr><td colspan="1" valign="top">4</td><td colspan="1" valign="top">Waktu</td><td colspan="1" valign="top">0 ms</td><td colspan="1" valign="top">0 ns</td><td colspan="1" valign="top">0 ns</td><td colspan="1" valign="top">0 ns</td><td colspan="1" valign="top">-</td></tr>
<tr><td colspan="1" valign="top"></td><td colspan="1" valign="top">Step</td><td colspan="1" valign="top">601</td><td colspan="1" valign="top">1</td><td colspan="1" valign="top">1</td><td colspan="1" valign="top">1</td><td colspan="1" valign="top">-</td></tr>
<tr><td colspan="1" valign="top">5</td><td colspan="1" valign="top">Waktu</td><td colspan="1" valign="top">0 ms</td><td colspan="1" valign="top">0 ns</td><td colspan="1" valign="top">0 ns</td><td colspan="1" valign="top">0 ns</td><td colspan="1" valign="top">-</td></tr>
<tr><td colspan="1" valign="top"></td><td colspan="1" valign="top">Step</td><td colspan="1" valign="top">601</td><td colspan="1" valign="top">1</td><td colspan="1" valign="top">1</td><td colspan="1" valign="top">1</td><td colspan="1" valign="top">-</td></tr>
<tr><td colspan="1" rowspan="10" valign="top">1000</td><td colspan="1" valign="top">1</td><td colspan="1" valign="top">Waktu</td><td colspan="1" valign="top">0 ms</td><td colspan="1" valign="top">0 ns</td><td colspan="1" valign="top">0 ns</td><td colspan="1" valign="top">0 ns</td><td colspan="1" valign="top">-</td></tr>
<tr><td colspan="1" valign="top"></td><td colspan="1" valign="top">Step</td><td colspan="1" valign="top">1240</td><td colspan="1" valign="top">1</td><td colspan="1" valign="top">1</td><td colspan="1" valign="top">1</td><td colspan="1" valign="top">-</td></tr>
<tr><td colspan="1" valign="top">2</td><td colspan="1" valign="top">Waktu</td><td colspan="1" valign="top">0 ms</td><td colspan="1" valign="top">0 ns</td><td colspan="1" valign="top">0 ns</td><td colspan="1" valign="top">0 ns</td><td colspan="1" valign="top">-</td></tr>
<tr><td colspan="1" valign="top"></td><td colspan="1" valign="top">Step</td><td colspan="1" valign="top">1240</td><td colspan="1" valign="top">1</td><td colspan="1" valign="top">2</td><td colspan="1" valign="top">1</td><td colspan="1" valign="top">-</td></tr>
<tr><td colspan="1" valign="top">3</td><td colspan="1" valign="top">Waktu</td><td colspan="1" valign="top">0 ms</td><td colspan="1" valign="top">0 ns</td><td colspan="1" valign="top">0 ns</td><td colspan="1" valign="top">0 ns</td><td colspan="1" valign="top">-</td></tr>
<tr><td colspan="1" valign="top"></td><td colspan="1" valign="top">Step</td><td colspan="1" valign="top">1240</td><td colspan="1" valign="top">1</td><td colspan="1" valign="top">2</td><td colspan="1" valign="top">1</td><td colspan="1" valign="top">-</td></tr>
<tr><td colspan="1" valign="top">4</td><td colspan="1" valign="top">Waktu</td><td colspan="1" valign="top">0 ms</td><td colspan="1" valign="top">0 ns</td><td colspan="1" valign="top">0 ns</td><td colspan="1" valign="top">0 ns</td><td colspan="1" valign="top">-</td></tr>
<tr><td colspan="1" valign="top"></td><td colspan="1" valign="top">Step</td><td colspan="1" valign="top">1240</td><td colspan="1" valign="top">1</td><td colspan="1" valign="top">1</td><td colspan="1" valign="top">1</td><td colspan="1" valign="top">-</td></tr>
<tr><td colspan="1" valign="top">5</td><td colspan="1" valign="top">Waktu</td><td colspan="1" valign="top">0 ms</td><td colspan="1" valign="top">0 ns</td><td colspan="1" valign="top">0 ns</td><td colspan="1" valign="top">0 ns</td><td colspan="1" valign="top">-</td></tr>
<tr><td colspan="1" valign="top"></td><td colspan="1" valign="top">Step</td><td colspan="1" valign="top">1240</td><td colspan="1" valign="top">1</td><td colspan="1" valign="top">1</td><td colspan="1" valign="top">1</td><td colspan="1" valign="top">-</td></tr>
<tr><td colspan="1" rowspan="30">Sorted Data</td><td colspan="1" rowspan="10">100</td><td colspan="1">1</td><td colspan="1">Waktu</td><td colspan="1" valign="top">0 ms</td><td colspan="1" valign="top">0 ns</td><td colspan="1" valign="top">1052 ns</td><td colspan="1" valign="top">0 ns</td><td colspan="1">-</td></tr>
<tr><td colspan="1"></td><td colspan="1">Step</td><td colspan="1" valign="top">101</td><td colspan="1" valign="top">1</td><td colspan="1" valign="top">1</td><td colspan="1" valign="top">1</td><td colspan="1">-</td></tr>
<tr><td colspan="1">2</td><td colspan="1">Waktu</td><td colspan="1" valign="top">0 ms</td><td colspan="1" valign="top">0 ns</td><td colspan="1" valign="top">0 ns</td><td colspan="1" valign="top">0 ns</td><td colspan="1">-</td></tr>
<tr><td colspan="1"></td><td colspan="1">Step</td><td colspan="1" valign="top">101</td><td colspan="1" valign="top">1</td><td colspan="1" valign="top">1</td><td colspan="1" valign="top">1</td><td colspan="1">-</td></tr>
<tr><td colspan="1">3</td><td colspan="1">Waktu</td><td colspan="1" valign="top">0 ms</td><td colspan="1" valign="top">0 ns</td><td colspan="1" valign="top">1062 ns</td><td colspan="1" valign="top">0 ns</td><td colspan="1">-</td></tr>
<tr><td colspan="1"></td><td colspan="1">Step</td><td colspan="1" valign="top">101</td><td colspan="1" valign="top">1</td><td colspan="1" valign="top">1</td><td colspan="1" valign="top">1</td><td colspan="1">-</td></tr>
<tr><td colspan="1">4</td><td colspan="1">Waktu</td><td colspan="1" valign="top">0 ms</td><td colspan="1" valign="top">0 ns</td><td colspan="1" valign="top">0 ns</td><td colspan="1" valign="top">0 ns</td><td colspan="1">-</td></tr>
<tr><td colspan="1"></td><td colspan="1">Step</td><td colspan="1" valign="top">100</td><td colspan="1" valign="top">1</td><td colspan="1" valign="top">1</td><td colspan="1" valign="top">1</td><td colspan="1">-</td></tr>
<tr><td colspan="1">5</td><td colspan="1">Waktu</td><td colspan="1" valign="top">0 ms</td><td colspan="1" valign="top">0 ns</td><td colspan="1" valign="top">0 ns</td><td colspan="1" valign="top">1143 ns</td><td colspan="1">-</td></tr>
<tr><td colspan="1"></td><td colspan="1">Step</td><td colspan="1" valign="top">101</td><td colspan="1" valign="top">1</td><td colspan="1" valign="top">1</td><td colspan="1" valign="top">1</td><td colspan="1">-</td></tr>
<tr><td colspan="1" rowspan="10">500</td><td colspan="1">1</td><td colspan="1">Waktu</td><td colspan="1" valign="top">0 ms</td><td colspan="1" valign="top">0 ns</td><td colspan="1" valign="top">0 ns</td><td colspan="1" valign="top">0 ns</td><td colspan="1">-</td></tr>
<tr><td colspan="1"></td><td colspan="1">Step</td><td colspan="1" valign="top">601</td><td colspan="1" valign="top">1</td><td colspan="1" valign="top">2</td><td colspan="1" valign="top">1</td><td colspan="1">-</td></tr>
<tr><td colspan="1">2</td><td colspan="1">Waktu</td><td colspan="1" valign="top">0 ms</td><td colspan="1" valign="top">0 ns</td><td colspan="1" valign="top">0 ns</td><td colspan="1" valign="top">0 ns</td><td colspan="1">-</td></tr>
<tr><td colspan="1"></td><td colspan="1">Step</td><td colspan="1" valign="top">601</td><td colspan="1" valign="top">2</td><td colspan="1" valign="top">2</td><td colspan="1" valign="top">1</td><td colspan="1">-</td></tr>
<tr><td colspan="1">3</td><td colspan="1">Waktu</td><td colspan="1" valign="top">1000 ms</td><td colspan="1" valign="top">1000 ns</td><td colspan="1" valign="top">0 ns</td><td colspan="1" valign="top">0 ns</td><td colspan="1">-</td></tr>
<tr><td colspan="1"></td><td colspan="1">Step</td><td colspan="1" valign="top">601</td><td colspan="1" valign="top">2</td><td colspan="1" valign="top">2</td><td colspan="1" valign="top">1</td><td colspan="1">-</td></tr>
<tr><td colspan="1">4</td><td colspan="1">Waktu</td><td colspan="1" valign="top">0 ms</td><td colspan="1" valign="top">0 ns</td><td colspan="1" valign="top">0 ns</td><td colspan="1" valign="top">0 ns</td><td colspan="1">-</td></tr>
<tr><td colspan="1"></td><td colspan="1">Step</td><td colspan="1" valign="top">601</td><td colspan="1" valign="top">1</td><td colspan="1" valign="top">1</td><td colspan="1" valign="top">1</td><td colspan="1">-</td></tr>
<tr><td colspan="1">5</td><td colspan="1">Waktu</td><td colspan="1" valign="top">0 ms</td><td colspan="1" valign="top">0 ns</td><td colspan="1" valign="top">0 ns</td><td colspan="1" valign="top">1013 ns</td><td colspan="1">-</td></tr>
<tr><td colspan="1"></td><td colspan="1">Step</td><td colspan="1" valign="top">601</td><td colspan="1" valign="top">1</td><td colspan="1" valign="top">1</td><td colspan="1" valign="top">1</td><td colspan="1">-</td></tr>
<tr><td colspan="1" rowspan="10">1000</td><td colspan="1">1</td><td colspan="1">Waktu</td><td colspan="1" valign="top">0 ms</td><td colspan="1" valign="top">0 ns</td><td colspan="1" valign="top">`	`1000 ns</td><td colspan="1" valign="top">0 ns</td><td colspan="1">-</td></tr>
<tr><td colspan="1"></td><td colspan="1">Step</td><td colspan="1" valign="top">1240</td><td colspan="1" valign="top">2</td><td colspan="1" valign="top">2</td><td colspan="1" valign="top">1</td><td colspan="1">-</td></tr>
<tr><td colspan="1">2</td><td colspan="1">Waktu</td><td colspan="1" valign="top">0 ms</td><td colspan="1" valign="top">0 ns</td><td colspan="1" valign="top">0 ns</td><td colspan="1" valign="top">0 ns</td><td colspan="1">-</td></tr>
<tr><td colspan="1"></td><td colspan="1">Step</td><td colspan="1" valign="top">1240</td><td colspan="1" valign="top">1</td><td colspan="1" valign="top">1</td><td colspan="1" valign="top">1</td><td colspan="1">-</td></tr>
<tr><td colspan="1">3</td><td colspan="1">Waktu</td><td colspan="1" valign="top">0 ms</td><td colspan="1" valign="top">0 ns</td><td colspan="1" valign="top">0 ns</td><td colspan="1" valign="top">0 ns</td><td colspan="1">-</td></tr>
<tr><td colspan="1"></td><td colspan="1">Step</td><td colspan="1" valign="top">1240</td><td colspan="1" valign="top">1</td><td colspan="1" valign="top">1</td><td colspan="1" valign="top">1</td><td colspan="1">-</td></tr>
<tr><td colspan="1">4</td><td colspan="1">Waktu</td><td colspan="1" valign="top">0 ms</td><td colspan="1" valign="top">0 ns</td><td colspan="1" valign="top">0 ns</td><td colspan="1" valign="top">0 ns</td><td colspan="1">-</td></tr>
<tr><td colspan="1"></td><td colspan="1">Step</td><td colspan="1" valign="top">1240</td><td colspan="1" valign="top">1</td><td colspan="1" valign="top">2</td><td colspan="1" valign="top">1</td><td colspan="1">-</td></tr>
<tr><td colspan="1">5</td><td colspan="1">Waktu</td><td colspan="1" valign="top">0 ms</td><td colspan="1" valign="top">0 ns</td><td colspan="1" valign="top">0 ns</td><td colspan="1" valign="top">0 ns</td><td colspan="1">-</td></tr>
<tr><td colspan="1"></td><td colspan="1">Step</td><td colspan="1" valign="top">1240</td><td colspan="1" valign="top">1</td><td colspan="1" valign="top">1</td><td colspan="1" valign="top">1</td><td colspan="1">-</td></tr>
<tr><td colspan="1" rowspan="60">B+ Tree</td><td colspan="1" rowspan="30">Random Data</td><td colspan="1" rowspan="10">100</td><td colspan="1">1</td><td colspan="1">Waktu</td><td colspan="1">0 ms</td><td colspan="1">0 ns</td><td colspan="1">0 ns</td><td colspan="1">0 ns</td><td colspan="1">0 ms</td></tr>
<tr><td colspan="1"></td><td colspan="1">Step</td><td colspan="1">343</td><td colspan="1">5</td><td colspan="1">6</td><td colspan="1">6</td><td colspan="1">76</td></tr>
<tr><td colspan="1">2</td><td colspan="1">Waktu</td><td colspan="1">0 ms</td><td colspan="1">0 ns</td><td colspan="1">0 ns</td><td colspan="1">0 ns</td><td colspan="1">0 ms</td></tr>
<tr><td colspan="1"></td><td colspan="1">Step</td><td colspan="1">343</td><td colspan="1">5</td><td colspan="1">6</td><td colspan="1">6</td><td colspan="1">76</td></tr>
<tr><td colspan="1">3</td><td colspan="1">Waktu</td><td colspan="1">0 ms</td><td colspan="1">0 ns</td><td colspan="1">0 ns</td><td colspan="1">0 ns</td><td colspan="1">0 ms</td></tr>
<tr><td colspan="1"></td><td colspan="1">Step</td><td colspan="1">343</td><td colspan="1">4</td><td colspan="1">5</td><td colspan="1">5</td><td colspan="1">76</td></tr>
<tr><td colspan="1">4</td><td colspan="1">Waktu</td><td colspan="1">0 ms</td><td colspan="1">0 ns</td><td colspan="1">0 ns</td><td colspan="1">0 ns</td><td colspan="1">0 ms</td></tr>
<tr><td colspan="1"></td><td colspan="1">Step</td><td colspan="1">343</td><td colspan="1">5</td><td colspan="1">6</td><td colspan="1">6</td><td colspan="1">76</td></tr>
<tr><td colspan="1">5</td><td colspan="1">Waktu</td><td colspan="1">0 ms</td><td colspan="1">0 ns</td><td colspan="1">0 ns</td><td colspan="1">0 ns</td><td colspan="1">0 ms</td></tr>
<tr><td colspan="1"></td><td colspan="1">Step</td><td colspan="1">343</td><td colspan="1">5</td><td colspan="1">6</td><td colspan="1">6</td><td colspan="1">76</td></tr>
<tr><td colspan="1" rowspan="10">500</td><td colspan="1">1</td><td colspan="1">Waktu</td><td colspan="1">1240 ms</td><td colspan="1">1015 ns</td><td colspan="1">0 ns</td><td colspan="1">1017 ns</td><td colspan="1">0 ms</td></tr>
<tr><td colspan="1"></td><td colspan="1">Step</td><td colspan="1">2477</td><td colspan="1">8</td><td colspan="1">9</td><td colspan="1">9</td><td colspan="1">19</td></tr>
<tr><td colspan="1">2</td><td colspan="1">Waktu</td><td colspan="1">0 ms</td><td colspan="1">0 ns</td><td colspan="1">0 ns</td><td colspan="1">0 ns</td><td colspan="1">0 ms</td></tr>
<tr><td colspan="1"></td><td colspan="1">Step</td><td colspan="1">2477</td><td colspan="1">8</td><td colspan="1">9</td><td colspan="1">9</td><td colspan="1">19</td></tr>
<tr><td colspan="1">3</td><td colspan="1">Waktu</td><td colspan="1">1162 ms</td><td colspan="1">0 ns</td><td colspan="1">0 ns</td><td colspan="1">1212 ns</td><td colspan="1">0 ms</td></tr>
<tr><td colspan="1"></td><td colspan="1">Step</td><td colspan="1">2477</td><td colspan="1">7</td><td colspan="1">8</td><td colspan="1">8</td><td colspan="1">19</td></tr>
<tr><td colspan="1">4</td><td colspan="1">Waktu</td><td colspan="1">3116 ms</td><td colspan="1">0 ns</td><td colspan="1">0 ns</td><td colspan="1">0 ns</td><td colspan="1">0 ms</td></tr>
<tr><td colspan="1"></td><td colspan="1">Step</td><td colspan="1">2477</td><td colspan="1">6</td><td colspan="1">7</td><td colspan="1">7</td><td colspan="1">19</td></tr>
<tr><td colspan="1">5</td><td colspan="1">Waktu</td><td colspan="1">1047 ms</td><td colspan="1">0 ns</td><td colspan="1">2610 ns</td><td colspan="1">0 ns</td><td colspan="1">0 ms</td></tr>
<tr><td colspan="1"></td><td colspan="1">Step</td><td colspan="1">2477</td><td colspan="1">7</td><td colspan="1">8</td><td colspan="1">8</td><td colspan="1">19</td></tr>
<tr><td colspan="1" rowspan="10">1000</td><td colspan="1">1</td><td colspan="1">Waktu</td><td colspan="1">2681 ms</td><td colspan="1">0 ns</td><td colspan="1">0 ns</td><td colspan="1">0 ns</td><td colspan="1">0 ms</td></tr>
<tr><td colspan="1"></td><td colspan="1">Step</td><td colspan="1">5446</td><td colspan="1">8</td><td colspan="1">9</td><td colspan="1">9</td><td colspan="1">285</td></tr>
<tr><td colspan="1">2</td><td colspan="1">Waktu</td><td colspan="1">1990 ms</td><td colspan="1">0 ns</td><td colspan="1">1190 ns</td><td colspan="1">0 ns</td><td colspan="1">0 ms</td></tr>
<tr><td colspan="1"></td><td colspan="1">Step</td><td colspan="1">5446</td><td colspan="1">6</td><td colspan="1">7</td><td colspan="1">7</td><td colspan="1">285</td></tr>
<tr><td colspan="1">3</td><td colspan="1">Waktu</td><td colspan="1">2581 ms</td><td colspan="1">0 ns</td><td colspan="1">992 ns</td><td colspan="1">0 ns</td><td colspan="1">0 ms</td></tr>
<tr><td colspan="1"></td><td colspan="1">Step</td><td colspan="1">5446</td><td colspan="1">9</td><td colspan="1">10</td><td colspan="1">10</td><td colspan="1">285</td></tr>
<tr><td colspan="1">4</td><td colspan="1">Waktu</td><td colspan="1">2035 ms</td><td colspan="1">1502 ns</td><td colspan="1">1009 ns</td><td colspan="1">0 ns</td><td colspan="1">0 ms</td></tr>
<tr><td colspan="1"></td><td colspan="1">Step</td><td colspan="1">5446</td><td colspan="1">7</td><td colspan="1">8</td><td colspan="1">8</td><td colspan="1">285</td></tr>
<tr><td colspan="1">5</td><td colspan="1">Waktu</td><td colspan="1">1381 ms</td><td colspan="1">998 ns</td><td colspan="1">0 ns</td><td colspan="1">1496 ns</td><td colspan="1">0 ms</td></tr>
<tr><td colspan="1"></td><td colspan="1">Step</td><td colspan="1">5446</td><td colspan="1">6</td><td colspan="1">7</td><td colspan="1">7</td><td colspan="1">285</td></tr>
<tr><td colspan="1" rowspan="30">Sorted Data</td><td colspan="1" rowspan="10">100</td><td colspan="1">1</td><td colspan="1">Waktu</td><td colspan="1">0 ms</td><td colspan="1">0 ns</td><td colspan="1">0 ns</td><td colspan="1">0 ns</td><td colspan="1">0 ms</td></tr>
<tr><td colspan="1"></td><td colspan="1">Step</td><td colspan="1">370</td><td colspan="1">5</td><td colspan="1">6</td><td colspan="1">6</td><td colspan="1">46</td></tr>
<tr><td colspan="1">2</td><td colspan="1">Waktu</td><td colspan="1">1091 ms</td><td colspan="1">0 ns</td><td colspan="1">0 ns</td><td colspan="1">0 ns</td><td colspan="1">0 ms</td></tr>
<tr><td colspan="1"></td><td colspan="1">Step</td><td colspan="1">370</td><td colspan="1">5</td><td colspan="1">6</td><td colspan="1">6</td><td colspan="1">46</td></tr>
<tr><td colspan="1">3</td><td colspan="1">Waktu</td><td colspan="1">0 ms</td><td colspan="1">0 ns</td><td colspan="1">0 ns</td><td colspan="1">0 ns</td><td colspan="1">0 ms</td></tr>
<tr><td colspan="1"></td><td colspan="1">Step</td><td colspan="1">370</td><td colspan="1">6</td><td colspan="1">7</td><td colspan="1">7</td><td colspan="1">46</td></tr>
<tr><td colspan="1">4</td><td colspan="1">Waktu</td><td colspan="1">1000 ms</td><td colspan="1">0 ns</td><td colspan="1">0 ns</td><td colspan="1">10027 ns</td><td colspan="1">0 ms</td></tr>
<tr><td colspan="1"></td><td colspan="1">Step</td><td colspan="1">370</td><td colspan="1">7</td><td colspan="1">8</td><td colspan="1">8</td><td colspan="1">46</td></tr>
<tr><td colspan="1">5</td><td colspan="1">Waktu</td><td colspan="1">0 ms</td><td colspan="1">0 ns</td><td colspan="1">0 ns</td><td colspan="1">0 ns</td><td colspan="1">0 ms</td></tr>
<tr><td colspan="1"></td><td colspan="1">Step</td><td colspan="1">370</td><td colspan="1">5</td><td colspan="1">6</td><td colspan="1">6</td><td colspan="1">46</td></tr>
<tr><td colspan="1" rowspan="10">500</td><td colspan="1">1</td><td colspan="1">Waktu</td><td colspan="1">1000 ms</td><td colspan="1">0 ns</td><td colspan="1">0 ns</td><td colspan="1">0 ns</td><td colspan="1">0 ms</td></tr>
<tr><td colspan="1"></td><td colspan="1">Step</td><td colspan="1">2622</td><td colspan="1">6</td><td colspan="1">7</td><td colspan="1">7</td><td colspan="1">47</td></tr>
<tr><td colspan="1">2</td><td colspan="1">Waktu</td><td colspan="1">1417 ms</td><td colspan="1">0 ns</td><td colspan="1">0 ns</td><td colspan="1">0 ns</td><td colspan="1">0 ms</td></tr>
<tr><td colspan="1"></td><td colspan="1">Step</td><td colspan="1">2622</td><td colspan="1">6</td><td colspan="1">7</td><td colspan="1">7</td><td colspan="1">47</td></tr>
<tr><td colspan="1">3</td><td colspan="1">Waktu</td><td colspan="1">1012 ms</td><td colspan="1">0 ns</td><td colspan="1">0 ns</td><td colspan="1">0 ns</td><td colspan="1">0 ms</td></tr>
<tr><td colspan="1"></td><td colspan="1">Step</td><td colspan="1">2622</td><td colspan="1">6</td><td colspan="1">7</td><td colspan="1">7</td><td colspan="1">47</td></tr>
<tr><td colspan="1">4</td><td colspan="1">Waktu</td><td colspan="1">0 ms</td><td colspan="1">0 ns</td><td colspan="1">0 ns</td><td colspan="1">0 ns</td><td colspan="1">0 ms</td></tr>
<tr><td colspan="1"></td><td colspan="1">Step</td><td colspan="1">2622</td><td colspan="1">7</td><td colspan="1">8</td><td colspan="1">8</td><td colspan="1">47</td></tr>
<tr><td colspan="1">5</td><td colspan="1">Waktu</td><td colspan="1">1000 ms</td><td colspan="1">0 ns</td><td colspan="1">0 ns</td><td colspan="1">0 ns</td><td colspan="1">0 ms</td></tr>
<tr><td colspan="1" valign="top"></td><td colspan="1" valign="top">Step</td><td colspan="1">2622</td><td colspan="1">7</td><td colspan="1">8</td><td colspan="1">8</td><td colspan="1">47</td></tr>
<tr><td colspan="1" rowspan="10" valign="top">1000</td><td colspan="1" valign="top">1</td><td colspan="1" valign="top">Waktu</td><td colspan="1" valign="top">1692 ms</td><td colspan="1" valign="top">0 ns</td><td colspan="1" valign="top">`	`0 ns</td><td colspan="1" valign="top">0 ns</td><td colspan="1" valign="top">0 ms</td></tr>
<tr><td colspan="1" valign="top"></td><td colspan="1" valign="top">Step</td><td colspan="1" valign="top">5887</td><td colspan="1" valign="top">8</td><td colspan="1" valign="top">9</td><td colspan="1" valign="top">9</td><td colspan="1" valign="top">48</td></tr>
<tr><td colspan="1" valign="top">2</td><td colspan="1" valign="top">Waktu</td><td colspan="1" valign="top">0 ms</td><td colspan="1" valign="top">0 ns</td><td colspan="1" valign="top">`	`0 ns</td><td colspan="1" valign="top">0 ns</td><td colspan="1" valign="top">0 ms</td></tr>
<tr><td colspan="1" valign="top"></td><td colspan="1" valign="top">Step</td><td colspan="1" valign="top">5887</td><td colspan="1" valign="top">7</td><td colspan="1" valign="top">8</td><td colspan="1" valign="top">8</td><td colspan="1" valign="top">48</td></tr>
<tr><td colspan="1" valign="top">3</td><td colspan="1" valign="top">Waktu</td><td colspan="1" valign="top">1152 ms</td><td colspan="1" valign="top">1039 ns</td><td colspan="1" valign="top">`	`1038 ns</td><td colspan="1" valign="top">0 ns</td><td colspan="1" valign="top">0 ms</td></tr>
<tr><td colspan="1" valign="top"></td><td colspan="1" valign="top">Step</td><td colspan="1" valign="top">5887</td><td colspan="1" valign="top">7</td><td colspan="1" valign="top">8</td><td colspan="1" valign="top">8</td><td colspan="1" valign="top">48</td></tr>
<tr><td colspan="1" valign="top">4</td><td colspan="1" valign="top">Waktu</td><td colspan="1" valign="top">2015 ms</td><td colspan="1" valign="top">0 ns</td><td colspan="1" valign="top">`	`1016 ns</td><td colspan="1" valign="top">1014 ns</td><td colspan="1" valign="top">0 ms</td></tr>
<tr><td colspan="1" valign="top"></td><td colspan="1" valign="top">Step</td><td colspan="1" valign="top">5887</td><td colspan="1" valign="top">7</td><td colspan="1" valign="top">8</td><td colspan="1" valign="top">8</td><td colspan="1" valign="top">48</td></tr>
<tr><td colspan="1" valign="top">5</td><td colspan="1" valign="top">Waktu</td><td colspan="1" valign="top">3112 ms</td><td colspan="1" valign="top">0 ns</td><td colspan="1" valign="top">`	`4762 ns</td><td colspan="1" valign="top">0 ns</td><td colspan="1" valign="top">0 ms</td></tr>
<tr><td colspan="1" valign="top"></td><td colspan="1" valign="top">Step</td><td colspan="1" valign="top">5887</td><td colspan="1" valign="top">7</td><td colspan="1" valign="top">8</td><td colspan="1" valign="top">8</td><td colspan="1" valign="top">48</td></tr>
</table>

## E. Kesimpulan

Berdasarkan hasil percobaan yang telah dilakukan, dapat disimpulkan bahwa struktur data Hash Map menunjukkan performa waktu yang secara signifikan lebih unggul dibandingkan dengan B+ Tree dalam operasi dasar seperti Create/insert, Read/search, Update, dan Delete (CRUD). Hash Map mampu menyelesaikan operasi tersebut dengan waktu rata-rata mendekati 0 ms, dan latensi sangat kecil (sekitar 0–1200 ns), baik pada data acak maupun data terurut. Sebaliknya, B+ Tree mengalami perlambatan terutama saat melakukan insert pada jumlah data yang besar (500–1000 item), di mana waktu prosesnya dapat mencapai lebih dari 1000 ms, khususnya pada data yang telah terurut. Hal ini menunjukkan adanya degradasi performa akibat proses balancing dan rekursi internal yang lebih kompleks.

Dari segi efisiensi langkah atau jumlah operasi internal (step count), algoritma Hash Map juga menunjukkan hasil yang lebih konsisten dan efisien. Sebagai contoh, untuk 1000 data acak, Hash Map membutuhkan sekitar 1240 langkah saat melakukan insert, sedangkan B+ Tree memerlukan hingga 5446 langkah. Untuk operasi lainnya seperti search, update, dan delete, Hash Map umumnya hanya memerlukan 1 hingga 2 langkah, sementara B+ Tree dapat memerlukan 6 hingga 10 langkah. Walaupun langkah pada Hash Map dapat meningkat bila terjadi collision, proses penanganannya tetap efisien karena traversal hanya dilakukan pada linked list pendek dalam satu bucket.

Dalam hal sensitivitas terhadap jenis data, Hash Map menunjukkan ketahanan performa yang baik, tidak terlalu dipengaruhi apakah data yang diolah bersifat acak atau terurut. Hal ini disebabkan oleh fungsi hashing yang mendistribusikan key secara merata ke berbagai bucket. Sebaliknya, B+ Tree menunjukkan performa yang lebih stabil ketika menangani data acak dibandingkan data terurut. Data yang sudah tersortir dapat memicu lebih banyak proses balancing internal, sehingga menambah kompleksitas dan jumlah langkah operasional.

Satu keunggulan utama B+ Tree dibanding Hash Map adalah dukungannya terhadap range query. Hash Map tidak mendukung operasi ini secara langsung karena tidak mempertahankan urutan data. Sebaliknya, B+ Tree secara eksplisit mendukung range query berkat sifatnya yang menjaga keterurutan data dan keterhubungan antar node. Jumlah langkah yang diperlukan untuk melakukan range query pada B+ Tree relatif stabil, berkisar antara 19 hingga 285 langkah tergantung pada ukuran data.

Dengan demikian, pemilihan antara Hash Map dan B+ Tree sebaiknya disesuaikan dengan kebutuhan spesifik aplikasi. Hash Map lebih sesuai untuk aplikasi yang membutuhkan performa tinggi pada operasi dasar dan tidak memerlukan urutan data, sedangkan B+ Tree lebih tepat digunakan pada kasus yang memerlukan pengurutan data serta pencarian dalam rentang nilai tertentu (range query).
