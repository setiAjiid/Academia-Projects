# Final Project Mata Kuliah Komputasi Numerik

## Tujuan: 
Memperkirakan Nilai Fungsi di antara titik yang sudah diketahui dengan metode interpolasi Newton-Gregory Backward (NGB)


## Nama Anggota Kelompok A09

Berikut adalah daftar anggota kelompok A09 beserta NRP masing-masing:

| No. | Nama                              | NRP           |
|-----|-----------------------------------|---------------|
| 1   | Dimas Setiaji                     | 5025241056    |
| 2   | Addien Zafriyan Al Akhsan         | 5025241058    |
| 3   | Riyan Fadli Amazzadin             | 5025241068    |
| 4   | Fauzan Hafiz Amandani             | 5025241087    |
| 5   | Nyoman Surya Hutama Andyartha     | 5025241093    |


## Soal
Buatlah program untuk memperkirakan nilai fungsi di antara titik yang sudah diketahui dengan metode interpolasi Newton-Gregory Backward (NGB) dengan deskripsi soal dan tabel fungsi sebagai berikut:

### Deskripsi Soal
Carilah nilai $f(x)$ ketika $x = 16$ dengan menggunakan metode Newton-Gregory Backward dan $y$ sebenarnya adalah $897104$. Hitung juga nilai galat sebenarnya ($E_t$) antara hasil interpolasi dan nilai sebenarnya.

### Tabel Fungsi

|   x   |     y      |  Δ f(x)  | Δ² f(x) | Δ³ f(x) | Δ⁴ f(x) |
|:-----:|:----------:|:--------:|:-------:|:-------:|:-------:|
|   3   |   -741     |          |         |         |         |
|       |            |   555    |         |         |         |
|   6   |   -186     |          | 31752   |         |         |
|       |            |  32307   |         | 88776   |         |
|   9   |   32121    |          | 120528  |         | 87480   |
|       |            |  152835  |         | 176256  |         |
|  12   |   184956   |          | 296784  |         | 116640  |
|       |            |  449619  |         | 292896  |         |
|  15   |   634575   |          | 589680  |         | 145800  |
|       |            |  1039299 |         | 438696  |         |
|  18   |  1673874   |          | 1028376 |         | 174960  |
|       |            |  2067675 |         | 613656  |         |
|  21   |  3741549   |          | 1642032 |         | 204120  |
|       |            |  3709707 |         | 817776  |         |
|  24   |  7451256   |          | 2459808 |         |         |
|       |            |  6169515 |         |         |         |
|  27   |  13620771  |          |         |         |         |


## Penjelasan Kode
Berikut adalah penjelasan kode untuk menyelesaikan soal di atas dengan metode Newton Gregory Backward (NGB):

### 1. Import Library

```python
import numpy as np
from math import factorial
```
**Penjelasan:**  

Potongan kode awal di atas dilakukan untuk mengimpor library `numpy` (disingkat dengan `np`) yang digunakan untuk operasi array numerik, seperti membuat array dan mencari indeks.

Kemudian, kami juga mengimpor `factorial` dari modul `math` yang akan digunakan untuk menghitung faktorial (misal: 3! = 3×2×1) dalam Newton-Gregory Backward .

---

### 2. Fungsi `s_product`

```python
def s_product(s, i):
    result = s
    for k in range(1, i):
        result *= (s + k)
    return round(result, 2)
```
**Penjelasan:**  

Fungsi ini menghitung hasil perkalian berurutan: $s × (s+1) × (s+2) ...$ sebanyak `i` kali. Fungsi ini digunakan untuk menghitung suku-suku pada rumus Newton Gregory Backward dan hasil akhirnya dibulatkan 2 angka di belakang koma.

---

### 3. Fungsi `NGB` (Newton Gregory Backward)

```python
def NGB(x_full, y_full, xt, h, x0):
    idx_x0 = np.where(x_full == x0)[0][0]
    x = x_full[:idx_x0 + 1]
    y = y_full[:idx_x0 + 1]
    n = len(x)
```
**Penjelasan:**  

Di dalam fungsi `NGB`, ada beberapa variabel yang harus diinisialisasi terlebih dahulu dengan rincian sebagai berikut:
- `x_full` dan `y_full` adalah array semua data x dan y.
- `xt` adalah titik x yang ingin diinterpolasi.
- `h` adalah jarak antar x (selisih tetap).
- `x0` adalah titik basis (paling belakang) untuk backward.
- `idx_x0` mencari indeks di mana x = x0.
- `x` dan `y` adalah array yang hanya berisi data sampai x0.
- `n` adalah jumlah data yang digunakan untuk interpolasi (jumlah elemen di x).

Kemudian, hanya data sampai x0 yang diambil untuk proses _backward_.

---

```python
    diff = np.zeros((n, n))
    diff[:, 0] = y
```
**Penjelasan:**  

Lalu, kami membuat tabel selisih (_difference table_) berukuran n×n dan diinisialisasikan dengan nol. Kemudian, bagian kolom pertama diisi dengan nilai y (data asli).

---

```python
    print("\nPerhitungan untuk setiap selisih nilai fungsi/delta:\n")
    for i in range(1, n):
        for j in range(n - 1, i - 1, -1):
            diff[j, i] = round(diff[j, i - 1] - diff[j - 1, i - 1], 2)
            print(f"Δ^{i}y[{j}] = {diff[j, i]:.2f}")
```
**Penjelasan:**  

Selanjutnya, tabel selisih diisi hingga orde ke-`n`. Pada setiap iterasi, selisih dihitung secara mundur (dari baris `n - 1` hingga `i - 1`) dengan menggunakan rumus _backward difference_ untuk menghitung selisih ke-$i$ pada baris ke-$j$:
```math
\Delta^i y_j = \Delta^{i-1} y_j - \Delta^{i-1} y_{j-1}
```

, di mana:
- $\Delta^i y_j$ adalah selisih ke-$i$ pada baris ke-$j$,
- $\Delta^{i-1} y_j$ adalah selisih ke-$(i-1)$ pada baris ke-$j$,
- $\Delta^{i-1} y_{j-1}$ adalah selisih ke-$(i-1)$ pada baris ke-$(j-1)$.

Lalu, setiap hasil perhitungan dicetak agar proses pembentukan tabel selisih dapat terlihat dengan jelas.

---

```python
    print("\nPerhitungan untuk NGB:\n")
    s = round((xt - x0) / h, 2)
    print(f"s = {s:.2f}")
```
**Penjelasan:**  

Lalu, kami menghitung nilai `s` sebagai parameter pada rumus Newton Gregory Backward: `s = (xt - x0) / h`. Dan, dicetak hasilnya agar bisa dilihat nilainya.

---

```python
    result = round(diff[-1, 0], 2)
```
**Penjelasan:**
  
Kode di atas dibuat untuk menginisialisasi hasil dengan y pada x0 (nilai terakhir di kolom pertama).

---

```python
    for i in range(1, n):
        s_term = round(s_product(s, i) / factorial(i), 2)
        term = round(s_term * diff[n - 1, i], 2)
        print(f"Term for i={i}: {term:.2f} (s_term={s_term:.2f}, Δ^{i}y={diff[n - 1, i]:.2f})")
        result = round(result + term, 2)
```
**Penjelasan:**

Bagian kode di atas adalah rumus dari interpolasi Newton-Gregory Backward. Variabel `s_term` akan menyimpan nilai yang dikembalikan oleh fungsi `s_product`, lalu nilai tersebut akan dibagi dengan `faktorial i`. Secara matematis dirumuskan sebagai berikut:

```math
s\_term = \frac{s(s+1)(s+2)...(s+i-1)}{i!} 
```

Nilai dari `s_term` kemudian digunakan pada variabel `term` dengan mengalikannya sesuai dengan selisih diferensial yang ada (`diff[n - 1, i]`). Secara matematis dirumuskan sebagai berikut:

```math
term = s\_term \cdot \Delta^i y_{n-1}
```

Variabel `term` akan ditambahkan ke variabel `result` untuk kemudian mengetahui hasil dari interpolasinya. Setiap langkah akan mencetak berapa `term` dan `s_term` yang dimiliki dengan pembulatan dua angka di belakang koma (`round(_variabel_, 2)`). Secara matematis dirumuskan sebagai berikut:

```math
\text{result} = \sum_{i=1}^{n-1} \text{term}_i + y_{x_0}
```

---

```python
    print(f"\nHasil Akhir dari Newton Gregory Backward: {result:.2f}")
    return result
```
**Penjelasan:**  

Kode ini akan menampilkan hasil (yang disimpan di variabel `result`) dari interpolasi Newton-Gregory Backward dengan ketelitian dua angka di belakang koma. 

---

### 4. Data dan Eksekusi 

```python
x = np.array([3, 6, 9, 12, 15, 18, 21, 24, 27], dtype=float)
y = np.array([-741, -186, 32121, 184956, 634575, 1673874, 3741549, 7451256, 13620771], dtype=float)

xt = 16        # Titik yang ingin diinterpolasi
yt = 897103    # Nilai y sebenarnya
x0 = 15        # Basis backward
h = 3          # Selisih antar x
```
**Penjelasan:**  

Pada potongan kode ini, data `x` dan `y` didefinisikan dan diinisialisasi sebagai `array` yang akan menampung tipe data `float`. Terdapat juga beberapa inisialisasi variabel lain seperti titik yang ingin diinterpolasi (`xt`), nilai y sebenarnya (`yt`), basis _backward_ (`x0`), dan selisih antar `x` (`h`).

---

```python
f16 = NGB(x, y, xt, h, x0)
```
**Penjelasan:**  

Bagian ini akan memanggil fungsi `NGB` yang akan menghitung hasil dari interpolasi Newton-Gregory Backward

---

```python
Et = round(abs((yt - f16) / yt) * 100, 2)
print(f"\nEt (Error True) = {Et:.2f}")
```
**Penjelasan:**  

Setelah semua tahap berhasil dijalankan, maka program akan menghitung _Error true_ (Et) sebagai persentase selisih antara nilai sebenarnya dan hasil interpolasi. Nilai _error_ tersebut akan dicetak dengan ketelitian dua angka di belakang koma. 

---
### 5. Hasil Keluaran (_Output_)

```python
Perhitungan untuk setiap selisih nilai fungsi/delta:

Δ^1y[4] = 449619.00
Δ^1y[3] = 152835.00
Δ^1y[2] = 32307.00
Δ^1y[1] = 555.00
Δ^2y[4] = 296784.00
Δ^2y[3] = 120528.00
Δ^2y[2] = 31752.00
Δ^3y[4] = 176256.00
Δ^3y[3] = 88776.00
Δ^4y[4] = 87480.00

Perhitungan untuk NGB:

s = 0.33
Term for i=1: 148374.27 (s_term=0.33, Δ^1y=449619.00)
Term for i=2: 65292.48 (s_term=0.22, Δ^2y=296784.00)
Term for i=3: 29963.52 (s_term=0.17, Δ^3y=176256.00)
Term for i=4: 12247.20 (s_term=0.14, Δ^4y=87480.00)

Hasil Akhir dari Newton Gregory Backward: 890452.47

Et (Error True) = 0.74
```

## Kesimpulan

Berdasarkan penjelasan di atas, kami telah berhasil mengimplementasikan metode interpolasi Newton-Gregory Backward (NGB) untuk memperkirakan nilai fungsi di antara titik yang sudah diketahui. Dengan menggunakan data yang diberikan, kami mendapatkan estimasi  nilai f(x)  ketika x = 16 adalah `890452,47`. Jika dibandingkan dengan nilai sebenarnya, yaitu `897104`, maka diperoleh hasil nilai _error true_ yang didapatkan yakni sebesar `0,74%`.
