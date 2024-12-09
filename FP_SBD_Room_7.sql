CREATE DATABASE IF_enterprise;
USE IF_enterprise;

-- Table: Divisi
CREATE TABLE Divisi (
    ID char(6)  NOT NULL,
    Nama varchar(25)  NOT NULL,
    Deskripsi varchar(255)  NOT NULL,
    CONSTRAINT Divisi_pk PRIMARY KEY (ID)
);

-- Table: Mahasiswa
CREATE TABLE Mahasiswa (
    NRP varchar(20)  NOT NULL,
    Nama varchar(225)  NOT NULL,
    Departemen varchar(25)  NOT NULL,
    Universitas_ID int  NOT NULL,
    CONSTRAINT Mahasiswa_pk PRIMARY KEY (NRP)
);

-- Table: Pemagang
CREATE TABLE Pemagang (
    ID_Pemagang char(6)  NOT NULL,
    Nama varchar(50)  NOT NULL,
    Tgl_mulai_magang date  NOT NULL,
    Tgl_akhir_magang date  NOT NULL,
    Pendaftaran_ID char(6)  NOT NULL,
    Divisi_ID char(6)  NOT NULL,
    Project_ID char(6)  NOT NULL,
    CONSTRAINT Pemagang_pk PRIMARY KEY (ID_Pemagang)
);

-- Table: Pendaftaran
CREATE TABLE Pendaftaran (
    ID char(6)  NOT NULL,
    Status_penerimaan boolean  NOT NULL,
    Tgl_pendaftaran date  NOT NULL,
    Mahasiswa_NRP varchar(20)  NOT NULL,
    Staff_ID char(6)  NOT NULL,
    CONSTRAINT Pendaftaran_pk PRIMARY KEY (ID)
);

-- Table: Penilaian
CREATE TABLE Penilaian (
    ID char(6)  NOT NULL,
    Nilai_kedisiplinan int  NOT NULL,
    Nilai_komunikasi int  NOT NULL,
    Nilai_skill_yang_diimplementasikan int  NOT NULL,
    Nilai_laporan int  NOT NULL,
    Pemagang_ID char(6)  NOT NULL,
    Staff_ID char(6)  NOT NULL,
    CONSTRAINT Penilaian_pk PRIMARY KEY (ID)
);

-- Table: Project
CREATE TABLE Project (
    ID char(6)  NOT NULL,
    Judul varchar(25)  NOT NULL,
    Waktu_mulai_kerja date  NOT NULL,
    Waktu_akhir_kerja date  NOT NULL,
    Deskripsi varchar(255)  NOT NULL,
    Staff_ID char(6)  NOT NULL,
    CONSTRAINT Project_pk PRIMARY KEY (ID)
);

-- Table: Staff
CREATE TABLE Staff (
    ID char(6)  NOT NULL,
    Nama varchar(25)  NOT NULL,
    NIK char(16)  NOT NULL,
    Email varchar(25)  NOT NULL,
    No_telp varchar(20)  NOT NULL,
    Divisi_ID char(6)  NOT NULL,
    CONSTRAINT Staff_pk PRIMARY KEY (ID)
);

-- Table: Universitas
CREATE TABLE Universitas (
    ID int  NOT NULL,
    Nama varchar(50)  NOT NULL,
    Blackllist boolean  NOT NULL,
    CONSTRAINT Universitas_pk PRIMARY KEY (ID)
);

-- foreign keys
-- Reference: Mahasiswa_Universitas (table: Mahasiswa)
ALTER TABLE Mahasiswa ADD CONSTRAINT Mahasiswa_Universitas FOREIGN KEY Mahasiswa_Universitas (Universitas_ID)
    REFERENCES Universitas (ID);

-- Reference: Pemagang_Divisi (table: Pemagang)
ALTER TABLE Pemagang ADD CONSTRAINT Pemagang_Divisi FOREIGN KEY Pemagang_Divisi (Divisi_ID)
    REFERENCES Divisi (ID);

-- Reference: Pemagang_Pendaftaran (table: Pemagang)
ALTER TABLE Pemagang ADD CONSTRAINT Pemagang_Pendaftaran FOREIGN KEY Pemagang_Pendaftaran (Pendaftaran_ID)
    REFERENCES Pendaftaran (ID);

-- Reference: Pemagang_Project (table: Pemagang)
ALTER TABLE Pemagang ADD CONSTRAINT Pemagang_Project FOREIGN KEY Pemagang_Project (Project_ID)
    REFERENCES Project (ID);

-- Reference: Pendaftaran_Mahasiswa (table: Pendaftaran)
ALTER TABLE Pendaftaran ADD CONSTRAINT Pendaftaran_Mahasiswa FOREIGN KEY Pendaftaran_Mahasiswa (Mahasiswa_NRP)
    REFERENCES Mahasiswa (NRP);

-- Reference: Pendaftaran_Staff (table: Pendaftaran)
ALTER TABLE Pendaftaran ADD CONSTRAINT Pendaftaran_Staff FOREIGN KEY Pendaftaran_Staff (Staff_ID)
    REFERENCES Staff (ID);

-- Reference: Penilaian_Pemagang (table: Penilaian)
ALTER TABLE Penilaian ADD CONSTRAINT Penilaian_Pemagang FOREIGN KEY Penilaian_Pemagang (Pemagang_ID)
    REFERENCES Pemagang (ID_Pemagang);

-- Reference: Penilaian_Staff (table: Penilaian)
ALTER TABLE Penilaian ADD CONSTRAINT Penilaian_Staff FOREIGN KEY Penilaian_Staff (Staff_ID)
    REFERENCES Staff (ID);

-- Reference: Project_Staff (table: Project)
ALTER TABLE Project ADD CONSTRAINT Project_Staff FOREIGN KEY Project_Staff (Staff_ID)
    REFERENCES Staff (ID);

-- Reference: Staff_Divisi (table: Staff)
ALTER TABLE Staff ADD CONSTRAINT Staff_Divisi FOREIGN KEY Staff_Divisi (Divisi_ID)
    REFERENCES Divisi (ID);

-- DROP DATABASE if_enterprise;

-- Input Data
INSERT INTO  Universitas 
VALUES 	(1, 'Universitas Indonesia', FALSE),
		(2, 'Institut Teknologi Bandung', FALSE),
		(3, 'Universitas Hang Tuah', FALSE),
		(4, 'Universitas Airlangga', FALSE),
		(5, 'Institut Teknologi Sepuluh Nopember', FALSE),
		(6, 'Universitas Gadjah Mada', FALSE),
		(7, 'Universitas Negeri Semarang', FALSE),
		(8, 'Universitas Syah Kuala', TRUE),
		(9, 'Universitas Ciputra', FALSE),
		(10, 'Universitas Ngawi', TRUE);
        
INSERT INTO Mahasiswa 
VALUES	(50251311, 'Claude Cahyadi', 'Teknik Industri', 1),
		(18414178, 'Rashad Nugraha', 'Teknik Informatika', 2),
		(87641627, 'Asep', 'Teknik Informatika', 2),
		(50272310, 'Carol Ngui', 'Sistem Informasi', 4),
		(50252188, 'Raymond Syahputra', 'Sistem Informasi', 3),
		(60226942, 'Rama Kohiby', 'Teknik Industri', 4),
		(84027508, 'Davina Shura', 'Manajemen Bisnis', 4),
		(40839792, 'Dyandra Ratna', 'Ekonomi', 1),
		(77660602, 'Jason Miles', 'Teknik Informatika', 5),
		(26602860, 'Lorem Ipsum', 'Teknologi Informasi', 5),
		(23501356, 'Anugerah Cahya', 'Teknologi Informasi', 7),
		(45288856, 'Sendok Purba', 'Manajemen Bisnis', 9),
		(84136949, 'Bambang Prayetno', 'Hukum', 6),
		(84136929, 'Lola Aprilia', 'Teknologi Informasi', 1),
		(84113929, 'Dinda Kulamasari', 'Teknik Komputer', 10);
        
INSERT INTO Divisi 
VALUES	('DIV001', 'Research and Development', 'Berperan dalam pengembangan dan riset terkait produk produk terbarukan'),
		('DIV002', 'Human Resources', 'Menangani masalah kepegawaian baik dari sisi internal maupun eksternal pegawai'),
		('DIV003', 'Finance', 'Mengatur arus keuangan perusahaan baik arus masuk dan keluar'),
		('DIV004', 'Marketing', 'Menyesuaikan pemasaran produk dan branding perusahaan kepada publik');
        
INSERT INTO Staff
VALUES	('STF001', 'Asep Cahyadi', '112612930549', 'asepkeren@gmail.com', '81172819371', 'DIV001'),
		('STF002', 'Budi Doremi', '139575693647', 'budidoo@gmail.com', '8113798711', 'DIV003'),
		('STF003', 'Dennis Caknan', '203766328193', 'Denniscakna@gmail.com', '81119478613', 'DIV002'),
		('STF004', 'Alam Ihnin', '103849202719', 'Alamihnin@gmail.com', '88961481891', 'DIV003'),
		('STF005', 'Muhammad Ali', '271903823192', 'muhammad.ali27@gmail.com', '88820004000', 'DIV004'),
		('STF006', 'Ronaldoni', '102843920845', 'DoniRonal@gmail.com', '8121831992', 'DIV002'),
		('STF007', 'Mika Afrianti', '120512934021', 'Mikafrianti@gmail.com', '81141241223', 'DIV002'),
		('STF008', 'Neli Della', '194870182319', 'Nelidela@gmail.com', '81518103173', 'DIV003'),
		('STF009', 'Endang Gayatri', '104383028493', 'Triendang@gmail.com', '83618103812', 'DIV004'),
		('STF010', 'Harsana Jinten', '103984930182', 'Harsana27@gmail.com', '88491723741', 'DIV001');
        
INSERT INTO Pendaftaran
VALUES	('DFT001', FALSE, '2024-11-25', '50251311', 'STF003'),
		('DFT002', TRUE, '2024-11-25', '18414178', 'STF003'),
		('DFT003', TRUE, '2024-11-25', '87641627', 'STF003'),
		('DFT004', FALSE, '2024-11-26', '50272310', 'STF003'),
		('DFT005', TRUE, '2024-11-26', '50252188', 'STF003'),
		('DFT006', TRUE, '2024-11-27', '60226942', 'STF007'),
		('DFT007', TRUE, '2024-11-28', '84027508', 'STF007'),
		('DFT008', TRUE, '2024-11-28', '40839792', 'STF007'),
		('DFT009', FALSE, '2024-11-28', '77660602', 'STF007'),
		('DFT010', TRUE, '2024-12-02', '26602860', 'STF006'),
		('DFT011', FALSE, '2024-12-02', '23501356', 'STF006'),
		('DFT012', TRUE, '2024-12-02', '45288856', 'STF006'),
		('DFT013', FALSE, '2024-12-02', '84136949', 'STF006'),
		('DFT014', TRUE, '2024-12-03', '84136929', 'STF006'),
		('DFT015', TRUE, '2024-12-03', '84113929', 'STF006');
        
INSERT INTO Project
VALUES	('PRJ001', 'Front-End Website', '2025-02-24', '2025-06-03', 'Pengembangan dan penyempurnaan antarmuka pengguna website menggunakan HTML, CSS, dan JavaScript, memastikan tampilan responsif dan pengalaman pengguna yang optimal', 'STF010'),
		('PRJ002', 'Social Media Campaign', '2025-02-24', '2025-05-19', 'Merancang strategi pemasaran digital melalui media sosial untuk meningkatkan brand awareness, melibatkan desain konten, jadwal posting, dan analisis metrik keterlibatan.', 'STF005'),
		('PRJ003', 'Internalisasi Data', '2025-03-03', '2025-06-05', 'Mengintegrasikan dan memvalidasi data internal perusahaan ke dalam sistem pusat, memastikan akurasi, keamanan, dan kemudahan akses untuk analisis lanjutan.', 'STF003'),
		('PRJ004', 'IoT Device Testing', '2025-03-03', '2025-06-02', 'Pengujian fungsionalitas perangkat IoT untuk memastikan kinerja, konektivitas, dan keamanannya sesuai spesifikasi serta mendukung implementasi yang lancar.', 'STF010'),
		('PRJ005', 'Financial Data Analysis', '2025-03-03', '2025-06-09', 'Menganalisis data keuangan untuk mengidentifikasi tren, membuat laporan, dan memberikan wawasan guna mendukung pengambilan keputusan strategis perusahaan.', 'STF009');

INSERT INTO Pemagang 
VALUES	('PMG001', 'Rashad Nugraha', '2025-02-10', '2025-06-10', 'DFT002', 'DIV001', 'PRJ001'),
		('PMG002', 'Asep', '2025-02-10', '2025-06-09', 'DFT003', 'DIV001', 'PRJ004'),
		('PMG003', 'Raymond Syahputra', '2025-02-10', '2025-05-26', 'DFT005', 'DIV004', 'PRJ002'),
		('PMG004', 'Rama Kohiby', '2025-02-10', '2025-06-12', 'DFT006', 'DIV002', 'PRJ003'),
		('PMG005', 'Davina Shura', '2025-02-10', '2025-05-26', 'DFT007', 'DIV004', 'PRJ002'),
		('PMG006', 'Dyandra Ratna', '2025-02-10', '2025-06-16', 'DFT008', 'DIV003', 'PRJ005'),
		('PMG007', 'Lorem Ipsum', '2025-02-17', '2025-06-12', 'DFT010', 'DIV002', 'PRJ003'),
		('PMG008', 'Sendok Purba', '2025-02-17', '2025-06-16', 'DFT012', 'DIV003', 'PRJ005'),
		('PMG009', 'Lola Aprilia', '2025-02-17', '2025-06-10', 'DFT014', 'DIV001', 'PRJ001'),
		('PMG010', 'Dinda Kulamasari', '2025-02-17', '2025-06-09', 'DFT015', 'DIV001', 'PRJ004');
        
INSERT INTO Penilaian
VALUES	('PNL001', 85, 90, 88, 92, 'PMG001', 'STF010'),
		('PNL002', 80, 85, 87, 90, 'PMG002', 'STF010'),
		('PNL003', 75, 80, 82, 84, 'PMG003', 'STF005'),
		('PNL004', 75, 57, 80, 97, 'PMG004', 'STF003'),
		('PNL005', 80, 86, 90, 85, 'PMG005', 'STF005'),
		('PNL006', 92, 66, 98, 79, 'PMG006', 'STF004'),
		('PNL007', 73, 75, 79, 69, 'PMG007', 'STF003'),
		('PNL008', 70, 90, 80, 91, 'PMG008', 'STF004'),
		('PNL009', 80, 63, 78, 80, 'PMG009', 'STF010'),
		('PNL010', 66, 79, 75, 45, 'PMG010', 'STF010');

-- End








