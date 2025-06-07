-- Last modification date: 2024-11-19 16:44:27.953

CREATE DATABASE praktikum_3_sbd24;
USE praktikum_3_sbd24;

-- tables
-- Table: fasilitas
CREATE TABLE fasilitas (
    id char(5)  NOT NULL,
    nama varchar(50)  NOT NULL,
    tipe_fasilitas varchar(10)  NOT NULL,
    deskripsi longtext  NOT NULL,
    harga_per_fasilitas DECIMAL(10,2)  NOT NULL,
    CONSTRAINT fasilitas_pk PRIMARY KEY (id)
);

-- Table: kamar
CREATE TABLE kamar (
    nomor int  NOT NULL,
    nama_kamar varchar(10)  NOT NULL,
    tipe_kamar varchar(10)  NOT NULL,
    lantai_kamar int  NOT NULL,
    harga_per_malam DECIMAL(10,2)  NOT NULL,
    status VARCHAR(20)  NOT NULL,
    CONSTRAINT kamar_pk PRIMARY KEY (nomor)
);

-- Table: kamar_fasilitas
CREATE TABLE kamar_fasilitas (
    kamar_nomor int  NOT NULL,
    fasilitas_id char(5)  NOT NULL,
    jumlah_fasilitas int  NOT NULL,
    CONSTRAINT kamar_fasilitas_pk PRIMARY KEY (kamar_nomor,fasilitas_id)
);

-- Table: order
CREATE TABLE `order` (
    id char(5)  NOT NULL,
    tanggal_order timestamp  NOT NULL,
    tanggal_checkin date  NOT NULL,
    tanggal_checkout date  NOT NULL,
    jumlah_kamar int  NOT NULL,
    pelanggan_NIK char(16)  NOT NULL,
    resepsionis_id char(5)  NOT NULL,
    CONSTRAINT order_pk PRIMARY KEY (id)
);

-- Table: order_kamar
CREATE TABLE order_kamar (
    order_id char(5)  NOT NULL,
    kamar_nomor int  NOT NULL,
    CONSTRAINT order_kamar_pk PRIMARY KEY (order_id,kamar_nomor)
);

-- Table: pelanggan
CREATE TABLE pelanggan (
    NIK char(16)  NOT NULL,
    nama_pelanggan varchar(100)  NOT NULL,
    email_pelanggan varchar(50)  NOT NULL,
    jenis_kelamin char(1)  NOT NULL,
    no_telp varchar(13)  NOT NULL,
    alamat varchar(255)  NOT NULL,
    CONSTRAINT pelanggan_pk PRIMARY KEY (NIK)
);

-- Table: pembayaran
CREATE TABLE pembayaran (
    id char(5)  NOT NULL,
    tanggal_bayar timestamp  NOT NULL,
    status VARCHAR(200)  NOT NULL,
    order_id char(5)  NOT NULL,
    CONSTRAINT pembayaran_pk PRIMARY KEY (id)
);

-- Table: resepsionis
CREATE TABLE resepsionis (
    id char(5)  NOT NULL,
    nama_resepsionis varchar(100)  NOT NULL,
    no_telp varchar(13)  NOT NULL,
    jenis_kelamin char(1)  NOT NULL,
    usia int  NOT NULL,
    tanggal_lahir date  NOT NULL,
    tanggal_bekerja date  NOT NULL,
    alamat varchar(255)  NOT NULL,
    CONSTRAINT resepsionis_pk PRIMARY KEY (id)
);

-- foreign keys
-- Reference: kamar_fasilitas_fasilitas (table: kamar_fasilitas)
ALTER TABLE kamar_fasilitas ADD CONSTRAINT kamar_fasilitas_fasilitas FOREIGN KEY kamar_fasilitas_fasilitas (fasilitas_id)
    REFERENCES fasilitas (id);

-- Reference: kamar_fasilitas_kamar (table: kamar_fasilitas)
ALTER TABLE kamar_fasilitas ADD CONSTRAINT kamar_fasilitas_kamar FOREIGN KEY kamar_fasilitas_kamar (kamar_nomor)
    REFERENCES kamar (nomor);

-- Reference: order_kamar_kamar (table: order_kamar)
ALTER TABLE order_kamar ADD CONSTRAINT order_kamar_kamar FOREIGN KEY order_kamar_kamar (kamar_nomor)
    REFERENCES kamar (nomor);

-- Reference: order_kamar_order (table: order_kamar)
ALTER TABLE order_kamar ADD CONSTRAINT order_kamar_order FOREIGN KEY order_kamar_order (order_id)
    REFERENCES `order` (id);

-- Reference: order_pelanggan (table: order)
ALTER TABLE `order` ADD CONSTRAINT order_pelanggan FOREIGN KEY order_pelanggan (pelanggan_NIK)
    REFERENCES pelanggan (NIK);

-- Reference: order_resepsionis (table: order)
ALTER TABLE `order` ADD CONSTRAINT order_resepsionis FOREIGN KEY order_resepsionis (resepsionis_id)
    REFERENCES resepsionis (id);

-- Reference: pembayaran_order (table: pembayaran)
ALTER TABLE pembayaran ADD CONSTRAINT pembayaran_order FOREIGN KEY pembayaran_order (order_id)
    REFERENCES `order` (id);


-- DML (Insert Data)

INSERT INTO pelanggan (NIK, nama_pelanggan, email_pelanggan, jenis_kelamin, no_telp, alamat)
VALUES
('1234567890123456', 'John Doe', 'johndoe@example.com', 'L', '081234567890', 'Jl. Merdeka No. 123, Jakarta'),
('2345678901234567', 'Jane Smith', 'janesmith@example.com', 'P', '082345678901', 'Jl. Raya No. 456, Bandung'),
('3456789012345678', 'Michael Johnson', 'michaelj@example.com', 'L', '083456789012', 'Jl. Sudirman No. 789, Surabaya'),
('4567890123456789', 'Sarah Brown', 'sarahb@example.com', 'P', '084567890123', 'Jl. Pahlawan No. 101, Yogyakarta'),
('5678901234567890', 'David Wilson', 'davidw@example.com', 'L', '085678901234', 'Jl. Jendral No. 202, Bali'),
('6789012345678901', 'Emily Davis', 'emilyd@example.com', 'P', '086789012345', 'Jl. Merdeka No. 305, Jakarta'),
('7890123456789012', 'Robert Taylor', 'robertt@example.com', 'L', '087890123456', 'Jl. Raya No. 408, Bandung'),
('8901234567890123', 'Olivia Garcia', 'oliviag@example.com', 'P', '088901234567', 'Jl. Sudirman No. 510, Surabaya'),
('9012345678901234', 'Daniel Martinez', 'danielm@example.com', 'L', '089012345678', 'Jl. Pahlawan No. 613, Yogyakarta'),
('0123456789012345', 'Sophia Rodriguez', 'sophia@example.com', 'P', '090123456789', 'Jl. Jendral No. 723, Bali'),
('1122334455667788', 'James Williams', 'jamesw@example.com', 'L', '091234567890', 'Jl. Merdeka No. 845, Jakarta'),
('2233445566778899', 'Isabella Harris', 'isabellah@example.com', 'P', '092345678901', 'Jl. Raya No. 952, Bandung'),
('3344556677889900', 'Alexander Walker', 'alexanderw@example.com', 'L', '093456789012', 'Jl. Sudirman No. 105, Surabaya'),
('4455667788990011', 'Mia Young', 'miay@example.com', 'P', '094567890123', 'Jl. Pahlawan No. 116, Yogyakarta'),
('5566778899001122', 'William King', 'williamk@example.com', 'L', '095678901234', 'Jl. Jendral No. 227, Bali');

INSERT INTO resepsionis (id, nama_resepsionis, no_telp, jenis_kelamin, usia, tanggal_lahir, tanggal_bekerja, alamat)
VALUES
('RS001', 'Alice Green', '081234567890', 'P', 25, '1999-05-10', '2023-01-01', 'Jl. Merdeka No. 101, Jakarta'),
('RS002', 'Bob White', '082345678901', 'L', 30, '1994-03-15', '2022-05-01', 'Jl. Raya No. 202, Bandung'),
('RS003', 'Charlie Black', '083456789012', 'L', 28, '1996-07-20', '2021-07-15', 'Jl. Sudirman No. 303, Surabaya'),
('RS004', 'Diana Blue', '084567890123', 'P', 32, '1992-11-25', '2020-12-12', 'Jl. Pahlawan No. 404, Yogyakarta'),
('RS005', 'Ethan Red', '085678901234', 'L', 26, '1998-06-05', '2022-09-10', 'Jl. Jendral No. 505, Bali'),
('RS006', 'Fiona Yellow', '086789012345', 'P', 29, '1995-04-30', '2021-02-20', 'Jl. Raya No. 606, Jakarta'),
('RS007', 'George Brown', '087890123456', 'L', 34, '1990-08-12', '2019-05-25', 'Jl. Merdeka No. 707, Bandung');

INSERT INTO kamar (nomor, nama_kamar, tipe_kamar, lantai_kamar, harga_per_malam, status)
VALUES
(101, 'Melati', 'Standard', 1, 500123.45, 'Tidak Tersedia'),
(102, 'Melati', 'Deluxe', 1, 750543.21, 'Tidak Tersedia'),
(103, 'Melati', 'Suite', 1, 100987.65, 'Tersedia'),
(104, 'Melati', 'Standard', 1, 500876.45, 'Tersedia'),
(105, 'Melati', 'Deluxe', 1, 750321.09, 'Tidak Tersedia'),
(106, 'Melati', 'Suite', 1, 100543.78, 'Tersedia'),
(107, 'Melati', 'Standard', 1, 500543.89, 'Tersedia'),
(108, 'Melati', 'Deluxe', 1, 750654.23, 'Tidak Tersedia'),
(109, 'Melati', 'Suite', 1, 1000876.12, 'Tidak Tersedia'),
(110, 'Melati', 'Standard', 1, 500223.77, 'Tersedia'),
(201, 'Mawar', 'Standard', 2, 500423.67, 'Tersedia'),
(202, 'Mawar', 'Deluxe', 2, 750865.33, 'Tidak Tersedia'),
(203, 'Mawar', 'Suite', 2, 1000987.45, 'Tidak Tersedia'),
(204, 'Mawar', 'Standard', 2, 500678.45, 'Tersedia'),
(205, 'Mawar', 'Deluxe', 2, 750456.87, 'Tersedia'),
(206, 'Mawar', 'Suite', 2, 1000678.12, 'Tersedia'),
(207, 'Mawar', 'Standard', 2, 500345.67, 'Tersedia'),
(208, 'Mawar', 'Deluxe', 2, 750876.89, 'Tersedia'),
(209, 'Mawar', 'Suite', 2, 1000543.32, 'Tersedia'),
(210, 'Mawar', 'Standard', 2, 500432.09, 'Tidak Tersedia'),
(301, 'Anggrek', 'Standard', 3, 500876.78, 'Tersedia'),
(302, 'Anggrek', 'Deluxe', 3, 750234.56, 'Tersedia'),
(303, 'Anggrek', 'Suite', 3, 1000543.89, 'Tersedia'),
(304, 'Anggrek', 'Standard', 3, 500123.78, 'Tidak Tersedia'),
(305, 'Anggrek', 'Deluxe', 3, 750654.12, 'Tidak Tersedia'),
(306, 'Anggrek', 'Suite', 3, 1000876.67, 'Tidak Tersedia'),
(307, 'Anggrek', 'Standard', 3, 500987.33, 'Tersedia'),
(308, 'Anggrek', 'Deluxe', 3, 750432.11, 'Tersedia'),
(309, 'Anggrek', 'Suite', 3, 1000765.54, 'Tersedia'),
(310, 'Anggrek', 'Standard', 3, 500543.89, 'Tersedia'),
(401, 'Cempaka', 'Standard', 4, 500654.34, 'Tidak Tersedia'),
(402, 'Cempaka', 'Deluxe', 4, 750876.32, 'Tidak Tersedia'),
(403, 'Cempaka', 'Suite', 4, 1000432.87, 'Tersedia'),
(404, 'Cempaka', 'Standard', 4, 500987.23, 'Tersedia'),
(405, 'Cempaka', 'Deluxe', 4, 750765.34, 'Tidak Tersedia'),
(406, 'Cempaka', 'Suite', 4, 1000876.54, 'Tersedia'),
(407, 'Cempaka', 'Standard', 4, 500432.67, 'Tersedia'),
(408, 'Cempaka', 'Deluxe', 4, 750654.78, 'Tersedia'),
(409, 'Cempaka', 'Suite', 4, 1000321.87, 'Tidak Tersedia'),
(410, 'Cempaka', 'Standard', 4, 500345.67, 'Tersedia'),
(501, 'Lili', 'Standard', 5, 500987.12, 'Tidak Tersedia'),
(502, 'Lili', 'Deluxe', 5, 750456.54, 'Tidak Tersedia'),
(503, 'Lili', 'Suite', 5, 1000678.23, 'Tersedia'),
(504, 'Lili', 'Standard', 5, 500765.34, 'Tersedia'),
(505, 'Lili', 'Deluxe', 5, 750987.67, 'Tersedia'),
(506, 'Lili', 'Suite', 5, 1000543.78, 'Tersedia'),
(507, 'Lili', 'Standard', 5, 500432.98, 'Tidak Tersedia'),
(508, 'Lili', 'Deluxe', 5, 750654.67, 'Tidak Tersedia'),
(509, 'Lili', 'Suite', 5, 1000876.12, 'Tersedia'),
(510, 'Lili', 'Standard', 5, 500876.56, 'Tersedia');


INSERT INTO fasilitas (id, nama, tipe_fasilitas, deskripsi, harga_per_fasilitas)
VALUES
('FS001', 'Kolam Renang', 'free', 'Kolam renang outdoor yang dapat digunakan oleh tamu hotel untuk berenang atau berjemur.', 0.00),
('FS002', 'Wi-Fi', 'free', 'Akses Wi-Fi gratis yang tersedia di seluruh area hotel, termasuk di kamar dan fasilitas umum.', 0.00),
('FS003', 'Sabun dan Handuk', 'free', 'Setiap kamar dilengkapi dengan sabun, shampoo, dan handuk bersih yang disediakan oleh hotel.', 0.00),
('FS004', 'Layanan Kamar', 'paid', 'Layanan kamar 24 jam yang menyajikan berbagai menu makanan dan minuman ke kamar Anda.', 150000.00),
('FS005', 'Spa', 'paid', 'Layanan spa lengkap dengan berbagai pilihan perawatan tubuh dan relaksasi untuk tamu hotel.', 300000.00),
('FS006', 'Karaoke', 'paid', 'Ruangan karaoke yang dapat digunakan untuk hiburan dengan pilihan lagu internasional dan lokal.', 200000.00),
('FS007', 'Parkir', 'free', 'Tempat parkir luas dan aman untuk kendaraan tamu hotel, tersedia untuk kendaraan pribadi atau taksi.', 0.00),
('FS008', 'Restoran', 'paid', 'Restoran dengan menu internasional dan lokal yang menyajikan masakan khas dari berbagai daerah.', 100000.00),
('FS009', 'Gym', 'free', 'Fasilitas gym dengan peralatan lengkap yang dapat digunakan oleh tamu hotel untuk olahraga dan kebugaran.', 0.00),
('FS010', 'Transportasi ke Bandara', 'paid', 'Layanan transportasi antar hotel dan bandara dengan menggunakan kendaraan hotel yang nyaman.', 250000.00),
('FS011', 'Sauna', 'paid', 'Fasilitas sauna untuk relaksasi dan detoksifikasi tubuh, tersedia dengan biaya tambahan.', 150000.00),
('FS012', 'Meeting Room', 'paid', 'Ruang pertemuan atau rapat dengan fasilitas multimedia untuk acara bisnis atau seminar.', 500000.00),
('FS013', 'Laundry', 'paid', 'Layanan laundry untuk mencuci pakaian dengan harga berdasarkan berat atau jenis pakaian.', 50000.00),
('FS014', 'Fasilitas Pijat', 'paid', 'Layanan pijat tradisional untuk relaksasi tubuh setelah seharian beraktivitas.', 200000.00),
('FS015', 'Business Center', 'paid', 'Business center dengan fasilitas komputer dan printer yang dapat digunakan oleh tamu untuk keperluan bisnis.', 100000.00),
('FS016', 'ATM', 'free', 'ATM yang tersedia di area hotel untuk memudahkan tamu melakukan transaksi keuangan kapan saja.', 0.00),
('FS017', 'Concierge', 'free', 'Layanan concierge untuk membantu tamu dalam pemesanan tiket, tur, atau rekomendasi restoran.', 0.00),
('FS018', 'Tennis Court', 'paid', 'Lapangan tenis yang dapat digunakan untuk olahraga dengan biaya sewa per jam.', 100000.00),
('FS019', 'Outdoor Lounge', 'free', 'Area lounge luar ruangan dengan pemandangan indah, tempat yang ideal untuk bersantai atau bersosialisasi.', 0.00),
('FS020', 'Room Service', 'paid', 'Layanan pemesanan makanan dan minuman langsung ke kamar hotel dengan biaya tambahan.', 50000.00);

INSERT INTO kamar_fasilitas (kamar_nomor, fasilitas_id, jumlah_fasilitas)
VALUES
('101', 'FS001', 1),
('101', 'FS002', 1),
('101', 'FS003', 2),
('101', 'FS004', 1),
('102', 'FS005', 1),
('102', 'FS006', 1),
('102', 'FS007', 1),
('102', 'FS008', 1),
('103', 'FS009', 1),
('103', 'FS010', 1),
('103', 'FS011', 1),
('103', 'FS012', 1),
('105', 'FS002', 1),  
('105', 'FS004', 1),  
('105', 'FS009', 1),
('108', 'FS010', 1),
('108', 'FS014', 1),
('108', 'FS017', 1),
('201', 'FS001', 1),
('201', 'FS002', 1),
('201', 'FS003', 2),
('201', 'FS004', 1),
('202', 'FS005', 1),
('202', 'FS006', 1),
('202', 'FS007', 1),
('202', 'FS008', 1),
('203', 'FS009', 1),
('203', 'FS010', 1),
('203', 'FS011', 1),
('203', 'FS012', 1),
('205', 'FS004', 1),
('205', 'FS007', 1),
('205', 'FS016', 1),
('205', 'FS010', 1),
('208', 'FS017', 1),
('208', 'FS003', 1),
('208', 'FS009', 1),
('208', 'FS018', 1),
('301', 'FS001', 1),
('301', 'FS002', 1),
('301', 'FS003', 2),
('301', 'FS004', 1),
('302', 'FS005', 1),
('302', 'FS006', 1),
('302', 'FS007', 1),
('302', 'FS008', 1),
('302', 'FS002', 1),
('302', 'FS009', 1),
('303', 'FS009', 1),
('303', 'FS010', 1),
('303', 'FS012', 1),
('303', 'FS011', 1);

INSERT INTO `order` (id, tanggal_order, tanggal_checkin, tanggal_checkout, jumlah_kamar, pelanggan_NIK, resepsionis_id)
VALUES
('OR001', '2024-11-01 10:30:00', '2024-11-05', '2024-11-07', 2, '1234567890123456', 'RS001'),
('OR002', '2024-11-02 12:00:00', '2024-11-06', '2024-11-08', 1, '2345678901234567', 'RS002'),
('OR003', '2024-11-03 14:15:00', '2024-11-07', '2024-11-10', 3, '3456789012345678', 'RS003'),
('OR004', '2024-11-04 09:45:00', '2024-11-10', '2024-11-12', 1, '4567890123456789', 'RS004'),
('OR005', '2024-11-05 11:30:00', '2024-11-12', '2024-11-15', 2, '5678901234567890', 'RS005'),
('OR006', '2024-11-06 13:20:00', '2024-11-13', '2024-11-14', 1, '6789012345678901', 'RS006'),
('OR007', '2024-11-07 08:00:00', '2024-11-14', '2024-11-17', 2, '7890123456789012', 'RS007'),
('OR008', '2024-11-08 15:00:00', '2024-11-15', '2024-11-18', 1, '8901234567890123', 'RS001'),
('OR009', '2024-11-09 16:30:00', '2024-11-16', '2024-11-20', 3, '9012345678901234', 'RS002'),
('OR010', '2024-11-10 17:45:00', '2024-11-17', '2024-11-19', 2, '0123456789012345', 'RS003'),
('OR011', '2024-11-11 10:30:00', '2024-11-18', '2024-11-20', 2, '1122334455667788', 'RS004'),
('OR012', '2024-11-12 12:15:00', '2024-11-19', '2024-11-22', 1, '2233445566778899', 'RS005'),
('OR013', '2024-11-13 13:45:00', '2024-11-20', '2024-11-23', 3, '3344556677889900', 'RS006'),
('OR014', '2024-11-14 14:20:00', '2024-11-21', '2024-11-24', 1, '4455667788990011', 'RS007'),
('OR015', '2024-11-15 15:10:00', '2024-11-22', '2024-11-25', 2, '5566778899001122', 'RS001');

INSERT INTO `order_kamar` (order_id, kamar_nomor)
VALUES
('OR001', '101'),
('OR001', '102'),
('OR002', '201'),
('OR003', '301'),
('OR003', '302'),
('OR003', '303'),
('OR004', '401'),
('OR005', '501'),
('OR005', '502'),
('OR006', '510'),
('OR007', '105'),
('OR007', '108'),
('OR008', '306'),
('OR009', '402'),
('OR009', '304'),
('OR009', '305'),
('OR010', '409'),
('OR010', '405'),
('OR011', '410'),
('OR011', '107'),
('OR012', '109'),
('OR013', '202'),
('OR013', '203'),
('OR013', '210'),
('OR014', '310'),
('OR015', '507'),
('OR015', '508');

INSERT INTO `pembayaran` (id, tanggal_bayar, status, order_id)
VALUES
('PB001', '2024-11-01 15:00:00', 'Lunas', 'OR001'),
('PB002', '2024-11-02 16:30:00', 'Lunas', 'OR002'),
('PB003', '2024-11-03 18:45:00', 'Belum Lunas', 'OR003'),
('PB004', '2024-11-04 10:00:00', 'Lunas', 'OR004'),
('PB005', '2024-11-05 14:00:00', 'Lunas', 'OR005'),
('PB006', '2024-11-06 11:00:00', 'Belum Lunas', 'OR006'),
('PB007', '2024-11-07 13:00:00', 'Lunas', 'OR007'),
('PB008', '2024-11-08 15:30:00', 'Lunas', 'OR008'),
('PB009', '2024-11-09 17:00:00', 'Lunas', 'OR009'),
('PB010', '2024-11-10 19:00:00', 'Lunas', 'OR010'),
('PB011', '2024-11-11 09:30:00', 'Belum Lunas', 'OR011'),
('PB012', '2024-11-12 12:00:00', 'Lunas', 'OR012'),
('PB013', '2024-11-13 13:30:00', 'Lunas', 'OR013'),
('PB014', '2024-11-14 14:00:00', 'Belum Lunas', 'OR014'),
('PB015', '2024-11-15 15:00:00', 'Lunas', 'OR015');


-- End of file.


-- Queury 
-- No. 1
SELECT nama_resepsionis, usia, alamat
FROM resepsionis
WHERE usia = (SELECT MIN(usia) FROM resepsionis WHERE jenis_kelamin = 'L');

-- No. 2
SELECT p.nama_pelanggan, o.jumlah_kamar, k.nama_kamar
FROM pelanggan p
JOIN `order` o ON o.pelanggan_NIK = p.NIK 
JOIN order_kamar ok ON ok.order_id = o.id
JOIN kamar k ON k.nomor = ok.kamar_nomor
WHERE p.nama_pelanggan = "Daniel Martinez";



--
SELECT * FROM resepsionis r
JOIN `order` AS o ON o.resepsionis_id = r.id;
--

-- No. 3
SELECT r.*
FROM resepsionis AS r
JOIN `order` AS o ON o.resepsionis_id = r.id
WHERE o.jumlah_kamar > 2;

-- No. 4
SELECT DISTINCT k.*, kf.jumlah_fasilitas, f.*
FROM kamar k
JOIN kamar_fasilitas kf ON kf.kamar_nomor = k.nomor
JOIN fasilitas f ON f.id = kf.fasilitas_id
WHERE status = "Tersedia";

-- No. 5
SELECT k.nomor, k.nama_kamar, k.tipe_kamar
FROM kamar k
JOIN kamar_fasilitas kf ON kf.kamar_nomor = k.nomor
JOIN fasilitas f ON f.id = kf.fasilitas_id
WHERE f.nama = "Wi-Fi";

-- No. 6
SELECT SUM(DATEDIFF(o.tanggal_checkout, o.tanggal_checkin)*(k.harga_per_malam + f.harga_per_fasilitas)) total, 
SUM(DATEDIFF(o.tanggal_checkout, o.tanggal_checkin)*(k.harga_per_malam + f.harga_per_fasilitas))/(COUNT(o.id)) rata2
FROM kamar k 
JOIN order_kamar ok ON ok.kamar_nomor = k.nomor
JOIN `order` o ON ok.order_id = o.id
JOIN kamar_fasilitas kf ON kf.kamar_nomor = k.nomor
JOIN fasilitas f ON f.id = kf.fasilitas_id;

-- No. 7
SELECT p.NIK, p.nama_pelanggan, p.no_telp, k.nomor, k.nama_kamar, k.tipe_kamar
FROM pelanggan p
JOIN `order` o ON o.pelanggan_NIK = p.NIK 
JOIN pembayaran pb ON pb.order_id = o.id
JOIN order_kamar ok ON ok.order_id = o.id
JOIN kamar k ON k.nomor = ok.kamar_nomor
WHERE pb.status = "Belum Lunas";

-- No. 8
SELECT DISTINCT f.*
FROM fasilitas f
JOIN kamar_fasilitas kf ON kf.fasilitas_id = f.id
JOIN kamar k ON k.nomor = kf.kamar_nomor
WHERE k.tipe_kamar = "Deluxe";

-- No. 9
SELECT f.*, SUM(kf.jumlah_fasilitas) jmlh
FROM fasilitas f
JOIN kamar_fasilitas kf ON kf.fasilitas_id = f.id
GROUP BY f.id
ORDER BY jmlh DESC;

-- No. 10
SELECT *
FROM pelanggan
WHERE NIK LIKE "12%";



