CREATE DATABASE bandara_horizon_air;
USE bandara_horizon_air;

CREATE TABLE bandara (
	id INT,
    nama VARCHAR(255) NOT NULL,
    kota VARCHAR(255) NOT NULL,
    negara VARCHAR(255) NOT NULL,
    kode_IATA CHAR(3) NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE bagasi(
	id INT, 
    berat INT NOT NULL, 
    ukuran VARCHAR(5) NOT NULL,
    warna VARCHAR(255) NOT NULL,
    jenis VARCHAR(255) NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE maskapai(
	id CHAR(6), 
    nama VARCHAR(255) NOT NULL,
    negara_asal VARCHAR(255) NOT NULL,
    PRIMARY KEY (id)
);

-- many to one: pesawat to maskapai
CREATE TABLE pesawat (
	id CHAR(6),
    model VARCHAR(255) NOT NULL,
    kapasitas INT NOT NULL, 
	tahun_produksi CHAR(4) NOT NULL, 
    status_pesawat VARCHAR(50) NOT NULL,
    maskapai_id CHAR(6) NOT NULL,
    PRIMARY KEY (id),
    CONSTRAINT fk_pesawat_maskapai
		FOREIGN KEY (maskapai_id) REFERENCES maskapai(id)
			ON DELETE CASCADE ON UPDATE CASCADE
);

-- many to one : penerbangan to pesawat
CREATE TABLE penerbangan (
	id CHAR(6),
    waktu_keberangkatan DATETIME NOT NULL,
    waktu_sampai DATETIME NOT NULL,
    status_penerbangan VARCHAR(50) NOT NULL,
    pesawat_id CHAR(6) NOT NULL,
    PRIMARY KEY (id),
    CONSTRAINT fk_penerbangan_pesawat
		FOREIGN KEY (pesawat_id) REFERENCES pesawat(id)
			ON UPDATE CASCADE ON DELETE CASCADE
);

-- bandara_penerbangan = tabel detail many to many : bandara to penerbangan
CREATE TABLE bandara_penerbangan (
	bandara_id INT,
    penerbangan_id CHAR(6),
    PRIMARY KEY (bandara_id, penerbangan_id),
    CONSTRAINT fk_bandara_penerbangan_bandara
		FOREIGN KEY (bandara_id) REFERENCES bandara(id)
			ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT fk_bandara_penerbangan_penerbangan
		FOREIGN KEY (penerbangan_id) REFERENCES penerbangan(id)
			ON UPDATE CASCADE ON DELETE CASCADE
);

-- one (penuh) to one (parsial): penumpang to bagasi
CREATE TABLE penumpang(
	NIK CHAR(16),
    nama VARCHAR(255) NOT NULL,
    tanggal_lahir DATE NOT NULL,
    alamat VARCHAR(255) NOT NULL,
    no_telepon VARCHAR(13) NOT NULL,
    jenis_kelamin CHAR(1) NOT NULL,
    kewarganegaraan VARCHAR(255) NOT NULL,
    bagasi_id INT NOT NULL,
    PRIMARY KEY (NIK),
    CONSTRAINT fk_penumpang_bagasi
		FOREIGN KEY (bagasi_id) REFERENCES bagasi(id)
			ON UPDATE CASCADE ON DELETE CASCADE
);


-- many to one : tiket to penerbangan
-- many to one tiket to penumpang
CREATE TABLE tiket(
	id CHAR(6),
    nomor_kursi CHAR(3) NOT NULL,
    harga INT NOT NULL,
    waktu_pembelian DATETIME NOT NULL,
    kelas_penerbangan VARCHAR(50) NOT NULL,
    penumpang_NIK CHAR(16) NOT NULL,
    penerbangan_id CHAR(6) NOT NULL,
    PRIMARY KEY (id),
    CONSTRAINT fk_tiket_penumpang
		FOREIGN KEY (penumpang_NIK) REFERENCES penumpang(NIK)
			ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT fk_tiket_penerbangan
		FOREIGN KEY (penerbangan_id) REFERENCES penerbangan(id)
			ON UPDATE CASCADE ON DELETE CASCADE
);

-- akhir pembuatan tabel

-- awal input data
INSERT INTO bandara
VALUES	(1, "Soekarno-Hatta", "Jakarta", "Indonesia", "CGK"),
		(2, "Ngurah Rai", "Denpasar", "Indonesia", "DPS"),
        (3, "Changi", "Singapore", "Singapore", "SIN"),
        (4, "Haneda", "Tokyo", "Japan", "HND");
        
INSERT INTO bagasi 
VALUES	(1, 20, 'M', "Hitam", "Koper"),
		(2, 15, 'S', "Merah", "Ransel"),
        (3, 25, 'L', "Biru", "Koper"),
        (4, 10, 'S', "Hijau", "Ransel");
        
INSERT INTO maskapai
VALUES	("GA123", "Garuda Indonesia", "Indonesia"),
		("SQ456", "Singapore Airlines", "Singapore"),
		("JL789", "Japan Airlines", "Japan"),
		("QZ987", "AirAsia", "Malaysia");
        
INSERT INTO penumpang 
VALUES	("3201123456789012", "Budi Santoso", "1990-04-15", "Jl. Merdeka No.1", "081234567890", 'L', "Indonesia", 1),
		("3302134567890123", "Siti Aminah", "1985-08-20", "Jl. Kebangsaan No.2", "081298765432", 'P', "Indonesia", 2),
		("3403145678901234", "John Tanaka", "1992-12-05", "Shibuya, Tokyo", "080123456789", 'L', "Japan", 3),
		("3504156789012345", "Li Wei", "1995-03-10", "Orchard Rd, Singapore", "0658123456789", 'L', "Singapore", 4);
        
INSERT INTO pesawat 
VALUES	("PKABC1", "Boeing 737", 180, "2018", "Aktif", "GA123"),
		("PKDEF2", "Airbus A320", 150, "2020", "Aktif", "SQ456"),
		("PKGHI3", "Boeing", 250, "2019", "Dalam Perawatan", "JL789"),
		("PKJKL4", "Airbus A330", 280, "2021", "Aktif", "QZ987");
        
INSERT INTO penerbangan 
VALUES	("FL0001", '2024-12-15 10:00:00', '2024-12-15 12:30:00', "Jadwal", "PKABC1"),
		("FL0002", '2024-12-16 08:00:00', '2024-12-16 10:45:00', "Jadwal", "PKDEF2"),
		("FL0003", '2024-12-17 14:00:00', '2024-12-17 16:30:00', "Ditunda", "PKGHI3"),
		("FL0004", '2024-12-18 18:00:00', '2024-12-18 20:30:00', "Jadwal", "PKJKL4");
        
INSERT INTO bandara_penerbangan
VALUES	(1, "FL0001"),
		(2, "FL0002"),
		(3, "FL0003"),
		(4, "FL0004");
        
INSERT INTO tiket
VALUES ("TIK001", "12A", 1200000, '2024-11-01 08:00:00', "Ekonomi", "3201123456789012", "FL0001"),
		("TIK002", "14B", 1500000, '2024-11-02 09:30:00', "Bisnis", "3302134567890123", "FL0002"),
		("TIK003", "16C", 2000000, '2024-11-03 10:15:00', "Ekonomi", "3403145678901234", "FL0003"),
		("TIK004", "18D", 1000000, '2024-11-04 11:45:00', "Ekonomi", "3504156789012345", "FL0004");
        
-- akhir input data

-- Perintah no.3
ALTER TABLE penumpang
ADD COLUMN email VARCHAR(255),
ADD CONSTRAINT email_unique UNIQUE (email);

-- Perintah no.4
ALTER TABLE bagasi
MODIFY jenis VARCHAR(50);

-- Perintah no.5

-- drop data yang ada pada tabel bandara_penerbangan sebab kita ingin mengupdate PK dan FK yang ada pada tabel bandara_penerbangan 
-- sehingga hal ini juga bisa menjadikan kita terhindar dari error yang tidak diinginkan
DELETE FROM bandara_penerbangan WHERE bandara_id IN (1, 2, 3, 4);

-- hapus constraint FK dan PK pada tabel bandara_penerbangan agar tidak terjadi error ketika menambahkan PK baru dari tabel penerbangan
ALTER TABLE bandara_penerbangan
DROP FOREIGN KEY fk_bandara_penerbangan_bandara,
DROP FOREIGN KEY fk_bandara_penerbangan_penerbangan,
DROP PRIMARY KEY;

-- Drop PK pada tabel bandara agar tidak terjadi error ketika dibuat menjadi PK baru dengan dua kolom (PK Komposit)
ALTER TABLE bandara
DROP PRIMARY KEY;
-- Buat PK baru dengan dua kolom yakni kolom id (PK yg sebelumnya) dan kolom kode_IATA (PK baru) di tabel bandara
ALTER TABLE bandara
ADD PRIMARY KEY (id, kode_IATA);

-- Karena di sini kode_IATA adalah PK baru, maka kita perlu membuat kolom kode_IATA di tabel bandara_penerbangan
ALTER TABLE bandara_penerbangan
ADD bandara_kode_IATA CHAR(3) NOT NULL;
        
-- Masukkan PK yang ada pada tabel bandara ke tabel bandara_penerbangan menjadi 'PK sekaligus FK' di tabel tersebut (sebagai akibat relasi
-- many to many dari tabel bandara dengan tabel penerbangan). Jadi akan ada 3 PK/FK di tabel bandara_penerbangan
-- yakni, bandara_id, bandara_kode_IATA, dan penerbangan_id
ALTER TABLE bandara_penerbangan
ADD PRIMARY KEY (bandara_id, bandara_kode_IATA, penerbangan_id),
ADD CONSTRAINT fk_bandara_penerbangan_penerbangan
	FOREIGN KEY (penerbangan_id) REFERENCES penerbangan(id)
		ON UPDATE CASCADE ON DELETE CASCADE,
ADD CONSTRAINT fk_bandara_penerbangan_bandara
	FOREIGN KEY (bandara_id, bandara_kode_IATA) REFERENCES bandara(id, kode_IATA)
		ON UPDATE CASCADE ON DELETE CASCADE;

-- masukkan data kembali sebagai akibat dari perubahan PK dan FK yang ada
INSERT INTO bandara_penerbangan
VALUES	(1, "FL0001", "CGK"),
		(2, "FL0002", "DPS"),
		(3, "FL0003", "SIN"),
		(4, "FL0004", "HND");

-- Perintah no.6
ALTER TABLE penumpang
DROP email;

-- Perintah no.7
UPDATE penerbangan
SET waktu_keberangkatan =  '2024-12-15 11:00:00',
	waktu_sampai = '2024-12-15 13:30:00'
WHERE id = "FL0001";

-- Perintah No.8
UPDATE penumpang
SET no_telepon = "081223344556"
WHERE NIK = "3302134567890123";

-- Perintah No.9
UPDATE pesawat
SET status_pesawat = "Aktif"
WHERE id = "PKGHI3";

SELECT * FROM penerbangan;
-- Perintah No.10
DELETE FROM tiket
WHERE penumpang_NIK = "3504156789012345";

-- Perintah No.11
DELETE FROM bagasi
WHERE id = 2;

-- Perintah No.12
SET SQL_SAFE_UPDATES = 0; -- untuk menonaktifkan safe mode pada mySQL
DELETE FROM penerbangan
WHERE status_penerbangan = "Ditunda";
SET SQL_SAFE_UPDATES = 1; -- mengaktifkan kembali safe mode sebagai langkah pencegah jika secara tidak sengaja menghapus suatu data tanpa melalui PK



        

        
 

