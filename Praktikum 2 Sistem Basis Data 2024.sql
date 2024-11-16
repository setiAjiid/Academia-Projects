CREATE DATABASE library;
USE library;

CREATE TABLE members(
	id CHAR(5) NOT NULL,
    nama VARCHAR(50) NOT NULL,
    email VARCHAR(50) NOT NULL,
    gender CHAR(1) NOT NULL,
    address VARCHAR(100) NOT NULL,
    PRIMARY KEY (id),
    UNIQUE (email)
);

CREATE TABLE genres (
	id CHAR(5) NOT NULL,
    genre_name VARCHAR(50) NOT NULL,
    descriptions VARCHAR(255) NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE positions (
	id CHAR(5) NOT NULL,
    position_name VARCHAR(50) NOT NULL,
    admin_access BOOLEAN NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE employees (
	id CHAR(5) NOT NULL,
    nama VARCHAR(50) NOT NULL,
    email VARCHAR(50) NOT NULL,
    gender CHAR(1) NOT NULL,
    address VARCHAR(100) NOT NULL,
    positions_id CHAR(5) NOT NULL,
    PRIMARY KEY (id),
    UNIQUE (email),
    CONSTRAINT fk_employees_positions
		FOREIGN KEY (positions_id) REFERENCES positions(id) 
			ON UPDATE CASCADE ON DELETE CASCADE
);	

CREATE TABLE phone_numbers (
	phone_number VARCHAR(13) NOT NULL,
    member_id CHAR(5) NOT NULL,
    employee_id CHAR(5) NOT NULL,
    PRIMARY KEY (phone_number),
    CONSTRAINT fk_phone_number_members
		FOREIGN KEY (member_id) REFERENCES members(id) 
			ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT fk_phone_number_employees
		FOREIGN KEY (employee_id) REFERENCES employees(id) 
			ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE borrows (
	id CHAR(5) NOT NULL,
    borrow_date DATE NOT NULL,
    return_date DATE,
    due_date DATE NOT NULL,
    fine DECIMAL(10, 2),
    member_id CHAR(5) NOT NULL,
    employee_id CHAR(5) NOT NULL,
    PRIMARY KEY (id),
    CONSTRAINT fk_borrows_members
		FOREIGN KEY (member_id) REFERENCES members(id) 
			ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT fk_borrows_employees
		FOREIGN KEY (employee_id) REFERENCES employees(id) 
			ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE books (
	id CHAR(5) NOT NULL,
    isbn CHAR(13) NOT NULL,
    title VARCHAR(100) NOT NULL,
    author_name VARCHAR(50) NOT NULL,
    year_publisher YEAR NOT NULL,
    synopsis VARCHAR(255) NOT NULL,
    stock INT NOT NULL,
    genres_id CHAR(5) NOT NULL,
    PRIMARY KEY (id),
    CONSTRAINT fk_books_genres
		FOREIGN KEY (genres_id) REFERENCES genres(id) 
			ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE books_borrows(
	book_id CHAR(5),
    borrow_id CHAR(5),
    PRIMARY KEY (book_id, borrow_id),
    CONSTRAINT fk_books_borrows_books
		FOREIGN KEY (book_id) REFERENCES books(id) 
			ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT fk_books_borrows_borrows
		FOREIGN KEY (borrow_id) REFERENCES borrows(id) 
			ON UPDATE CASCADE ON DELETE CASCADE
);

-- Perintah no 2
ALTER TABLE books
DROP author_name;

CREATE TABLE authors (
	id CHAR(5) NOT NULL,
    author_name VARCHAR(50) NOT NULL,
    nationality VARCHAR(30) NOT NULL,
    birthdate DATE NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE publishers (
    id CHAR(5),
    nama VARCHAR(50) NOT NULL,
    address VARCHAR(100) NOT NULL,
    country VARCHAR(30) NOT NULL,
    email VARCHAR(50) NOT NULL,
    PRIMARY KEY (id),
    UNIQUE (email)
);


ALTER TABLE books 
ADD authors_id CHAR(5) NOT NULL,
ADD publishers_id CHAR(5) NOT NULL, 
ADD CONSTRAINT fk_books_authors
		FOREIGN KEY (authors_id) REFERENCES authors(id)
			ON UPDATE CASCADE ON DELETE CASCADE,
ADD CONSTRAINT fk_books_publishers
		FOREIGN KEY (publishers_id) REFERENCES publishers(id)
			ON UPDATE CASCADE ON DELETE CASCADE;
            
-- Perintah No.3
-- drop FK di phone_numbers
ALTER TABLE phone_numbers
DROP FOREIGN KEY fk_phone_number_members;

-- drop FK di borrows
ALTER TABLE borrows
DROP FOREIGN KEY fk_borrows_members;

-- drop PK
ALTER TABLE members
DROP PRIMARY KEY;

-- Ganti id jadi NIK
ALTER TABLE members
DROP id,
ADD NIK CHAR(16) NOT NULL,
ADD PRIMARY KEY (NIK);

-- Kembalikan FK pada msing2 tabel
-- tambah FK di phone_numbers
ALTER TABLE phone_numbers
DROP member_id,
ADD member_NIK CHAR(16) NOT NULL,
ADD CONSTRAINT fk_phone_number_members
		FOREIGN KEY (member_NIK) REFERENCES members(NIK)
			ON UPDATE CASCADE ON DELETE CASCADE;
-- tambah FK di borrows
ALTER TABLE borrows
DROP member_id,
ADD member_NIK CHAR(16) NOT NULL,
ADD CONSTRAINT fk_borrows_members
		FOREIGN KEY (member_NIK) REFERENCES members(NIK)
			ON UPDATE CASCADE ON DELETE CASCADE;
            
-- Perintah No.4
-- Hapus tabel phone_numbers
DROP TABLE phone_numbers;

-- tambah attribut phone number di tabel member
ALTER TABLE members
ADD phone_number VARCHAR(13) NOT NULL;

-- tambah attribut phone number di tabel employees
ALTER TABLE employees
ADD phone_number VARCHAR(13) NOT NULL;

-- Perintah No. 5
INSERT INTO genres
VALUES
("GR001","Sejarah","Buku yang mengulas peristiwa atau era tertentu, memberikan wawasan tentang masa lalu dan dampaknya pada masa kini. Biasanya disertai data, analisis, dan narasi historis yang mendalam."),
("GR002","Fiksi", "Cerita imajinatif yang dibuat oleh penulis, tidak didasarkan pada fakta nyata. Genre ini mencakup subgenre seperti roman, fantasi, dan petualangan, dengan fokus pada karakter dan alur cerita."),
("GR003", "Pengembangan Diri", "Buku yang memberikan panduan untuk meningkatkan kualitas hidup atau keterampilan pembacanya. Menyajikan saran praktis tentang topik seperti motivasi, manajemen waktu, dan pemecahan masalah pribadi."),
("GR004", "Biografi", "Menceritakan kehidupan seseorang dengan detail dari lahir hingga akhir hidupnya atau saat ini. Disusun berdasarkan fakta, kisah ini menggambarkan pengalaman, perjuangan, dan prestasi tokoh tersebut."),
("GR005", "Referensi", "Buku yang berfungsi sebagai sumber rujukan lengkap, seperti kamus, ensiklopedia, atau handbook. Memuat data, definisi, atau konsep yang dapat diakses sesuai kebutuhan, tanpa harus dibaca secara berurutan.");

INSERT INTO authors
VALUES
("AU001", "Michael Brown", "Amerika", "1990-03-30"),
("AU002", "Andi Saputra", "Indonesia", "1988-10-02"),
("AU003", "Yuki Nakamura", "Jepang", "1973-01-22"),
("AU004", "Kim Min Joon", "Korea Selatan", "1982-04-18"),
("AU005", "James Williams", "Inggris", "1962-12-04");

INSERT INTO publishers
VALUES
("PB001", "Silver Oak Publishing", "1234 Elm Street", "Amerika Serikat", "silveroak1234@gmail.com"),
("PB002", "Blue Sky Books", "9012 Pine Road", "Jepang", "bluesky9012@gmail.com"),
("PB003", "Green Leaf Press", "5678 Maple Avenue", "Indonesia", "greenleaf5678@gmail.com"),
("PB004", "Golden Dragon Publishing", "3456 Bamboo Lane", "China", "goldendragon3456@gmail.com"),
("PB005", "Red River Press", "7890 Cherry Blossom Drive", "Perancis", "redriver7890@gmail.com");

INSERT INTO books
VALUES
("BK001", "9780123456789", "Jejak Peradaban: Kisah Perjalanan Sejarah Indonesia", 2010, "Menggali sejarah Indonesia, buku ini menyajikan peristiwa penting dan tokoh berpengaruh yang membentuk peradaban bangsa, membawa pembaca memahami akar budaya dan identitas Indonesia.", 
5, "GR001", "AU002", "PB003"),
("BK002", "9781234567890", "Small Steps, Big Changes: Building Positive Habits", 2005, "Temukan kekuatan dari kebiasaan kecil yang berdampak besar. Buku ini memberikan strategi praktis untuk membangun kebiasaan positif yang dapat mengubah hidup dan meningkatkan kesejahteraan secara keseluruhan.",
3, "GR003", "AU003", "PB002"),
("BK003", "9782345678901", "Complete Dictionary of Information Technology Terms", 2020, "Panduan lengkap untuk istilah-istilah teknologi informasi, buku ini menjelaskan konsep-konsep dasar hingga istilah teknis yang kompleks, menjadikannya sumber referensi yang berguna bagi pelajar dan profesional.",
7, "GR005", "AU001", "PB001"),
("BK004", "9783456789012", "Breaking Barriers: The Inspiring Story of Nelson Mandela", 2018, "Kisah luar biasa Nelson Mandela, seorang pejuang kebebasan yang mengatasi rintangan untuk memperjuangkan kesetaraan dan keadilan. Sebuah perjalanan inspiratif tentang keberanian, pengorbanan, dan harapan.",
2, "GR004", "AU005", "PB001"),
("BK005", "9784567890123", "Light at the End of the Road: A Story of Hope", 2024, "Dalam perjalanan penuh tantangan, seorang tokoh menemukan kekuatan dari harapan dan persahabatan. Novel ini mengajak pembaca merenungkan arti kehidupan dan pentingnya percaya pada masa depan yang lebih baik.",
4, "GR002", "AU004", "PB004");

INSERT INTO positions
VALUES
("PS001", "Pustakawan", True),
("PS002", "Kebersihan", False), 
("PS003", "Keamanan", False);

INSERT INTO employees
VALUES 
("EM001", "Andi Gading", "andi@gmail.com", 'P', "Jl. Merdeka No.10", "PS001", "081628492610"),
("EM002", "Budi Sitombing", "budi@gmail.com", 'L', "Jl. Sukun Raya No.25", "PS003", "085864927581"),
("EM003", "Jennifer Tina", "tina@gmail.com", 'P', "Jl. Pahlawan No.5", "PS001", "089603471812"),
("EM004", "Lili Sari", "lili@gmail.com", 'P', "Jl. Cendana No.8", "PS002", "088385793136"),
("EM005", "Alexander Agus", "agus@gmail.com", 'L', "Jl. Bunga No.12", "PS001", "088273659814");

INSERT INTO members
VALUES 
("Citra Kirana", "citra@gmail.com", 'P', "Jl. Cinta No.45", "3326162409040002", "088374628921"),
("Jasmine Neroli", "jasmine@gmail.com", 'P', "Jl. Melati No.9", "3525017006950028", "083285716164"), 
("Nico Parto", "nico@gmail.com", "L", "Jl. Kenanga No.33", "3525017006520020", "089675329117"), 
("Teddy Widodo", "teddy@gmail.com", "L", "Jl. Anggrek No.17","3305040901072053", "085782306818"), 
("Beni Soeharti", "beni@gmail.com", "L", "Jl. Raya No.56",  "3326161509700004", "0812345678919");

INSERT INTO borrows
VALUES 
("BR001", "2024-05-06", "2024-05-20", "2024-05-20", NULL, "EM004", "3326162409040002"),
("BR002", "2024-07-14", "2024-07-29", "2024-07-28", 5000.00, "EM001", "3525017006950028"),
("BR003", "2024-09-22", "2024-09-08", "2024-09-06", 10000.00, "EM003", "3525017006520020"),
("BR004", "2024-10-03", "2024-10-20", "2024-10-17", 15000.00, "EM002", "3305040901072053"),
("BR005", "2024-11-02", NULL, "2024-11-16", NULL, "EM005", "3326161509700004");

INSERT INTO books_borrows
VALUES
("BK001", "BR001"),
("BK003", "BR002"),
("BK001", "BR002"),
("BK004", "BR003"),
("BK005", "BR004"),
("BK002", "BR005");


-- Perintah No.6 
-- Ubah id di tabel borrow jadi INT AUTO_INCREMENT
-- Drop FK pada tabel books_borrows
ALTER TABLE books_borrows
DROP FOREIGN KEY fk_books_borrows_borrows;

-- Drop pk + add kembali id dengan tipe data baru dan jadikan PK
ALTER TABLE borrows
DROP PRIMARY KEY,
DROP id,
ADD id INT AUTO_INCREMENT FIRST,
ADD PRIMARY KEY(id);

-- drop FK books_id dan drop PK kompositnya +
-- drop PK komposit dan drop borrow_id lalu masukkan kembali dgn tipe baru
ALTER TABLE books_borrows
DROP FOREIGN KEY fk_books_borrows_books,
DROP PRIMARY KEY,
DROP borrow_id,
ADD borrow_id INT NOT NULL;

-- Hapus seluruh isi data pada tabel
TRUNCATE books_borrows;

-- tambahkan PK komposit dan FK"-nya
ALTER TABLE books_borrows
ADD PRIMARY KEY(book_id, borrow_id),
ADD CONSTRAINT fk_books_borrows_borrows
	FOREIGN KEY (borrow_id) REFERENCES borrows(id)
		ON UPDATE CASCADE ON DELETE CASCADE,
ADD CONSTRAINT fk_books_borrows_books
	FOREIGN KEY (book_id) REFERENCES books(id)
		ON UPDATE CASCADE ON DELETE CASCADE;

-- isi kembali data dengan borrow_id sudah menjadi INT
INSERT INTO books_borrows
VALUES
("BK001", 1),
("BK003", 2),
("BK001", 2),
("BK004", 3),
("BK005", 4),
("BK002", 5);

-- Perintah No.7
UPDATE borrows
SET return_date = CURRENT_DATE()
WHERE member_NIK = "3326161509700004";

-- Perintah No. 8
UPDATE borrows
SET fine = null
WHERE member_NIK IN ("3525017006520020", "3305040901072053");

-- Perintah No.9
SELECT NIK FROM members WHERE nama = "Beni Soeharti"; -- 3326161509700004
SELECT id FROM employees WHERE nama = "Alexander Agus"; -- EM005
INSERT INTO borrows(borrow_date, return_date, due_date, fine, member_NIK, employee_id)
VALUES ("2024-11-03", NULL, borrow_date+14, NULL, "3326161509700004", "EM005");

SELECT * FROM books;
UPDATE books
SET stock = stock-1
WHERE title = "Complete Dictionary of Information Technology Terms";

SELECT id FROM books WHERE title = "Complete Dictionary of Information Technology Terms"; -- BK003
SELECT * FROM borrows; -- 6
INSERT INTO books_borrows
VALUES 	("BK003", 6);

-- Perintah No. 10
SELECT id FROM positions WHERE position_name = "Pustakawan";
INSERT INTO employees
VALUES ("EM006", "Aspas Gata", "aspasgata@gmail.com", 'L', "Jl. Badut No.62", "PS001", "0895323390308"); 

-- Perintah No. 11
UPDATE employees
SET nama = "Andi Haki", gender = 'L', phone_number = "081628492611"
WHERE nama = "Andi Gading";

-- Perintah No. 12
DELETE FROM members WHERE nama = "Jasmine Neroli";
DELETE FROM employees WHERE nama = "Aspas Gata";
