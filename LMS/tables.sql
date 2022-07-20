-- LMS stands for library management system

-- Books
CREATE TABLE books (
    book_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(80),
    genre VARCHAR(20),
    date_pub DATE,
    author_id INT, -- FOREIGN KEY
    publisher_id INT -- FOREIGN KEY
);

SELECT * FROM books;

-- Authors
CREATE TABLE authors (
    author_id INT PRIMARY KEY AUTO_INCREMENT,
    author_first_name VARCHAR(40),
    author_last_name VARCHAR(40)
);

SELECT * FROM authors;

-- Changing the author id attribute in books to a foreign key, now that the author table is created
ALTER TABLE books
ADD FOREIGN KEY(author_id)
REFERENCES authors(author_id)
ON UPDATE CASCADE ON DELETE CASCADE;

-- Publishers
CREATE TABLE publishers (
    publisher_id INT PRIMARY KEY AUTO_INCREMENT,
    publisher_name VARCHAR(80),
    publisher_address VARCHAR(200)  
);

SELECT * FROM publishers;

-- Changing publisher id attribute in books to a foreign key, now that the publisher table is created
ALTER TABLE books
ADD FOREIGN KEY(publisher_id)
REFERENCES publishers(publisher_id)
ON UPDATE CASCADE ON DELETE CASCADE;

-- Branches
CREATE TABLE branches (
    branch_id INT PRIMARY KEY AUTO_INCREMENT,
    branch_name VARCHAR(40),
    location VARCHAR(60)
);

SELECT * FROM branches;

-- Book copies
CREATE TABLE copies (
    book_id INT,
    branch_id INT,
    PRIMARY KEY(book_id, branch_id),
    FOREIGN KEY(book_id) REFERENCES books(book_id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY(branch_id) REFERENCES branches(branch_id) ON UPDATE CASCADE ON DELETE CASCADE,
    num_copies INT
);

SELECT * FROM copies;

-- Borrower
CREATE TABLE clients (
    client_id INT PRIMARY KEY AUTO_INCREMENT,
    branch_id INT,
    client_first_name VARCHAR(40),
    client_last_name VARCHAR(40),
    client_dob DATE,
    client_email VARCHAR(40),
    client_phone VARCHAR(15),
    client_address VARCHAR(100),
    FOREIGN KEY(branch_id) REFERENCES branches(branch_id) ON UPDATE CASCADE
);

SELECT * FROM clients;

-- Loans
CREATE TABLE loans (
    loan_id INT PRIMARY KEY AUTO_INCREMENT,
    client_id INT,
    book_id INT,
    date_borrowed DATE,
    date_due DATE,
    date_returned DATE DEFAULT NULL,
    FOREIGN KEY(client_id) REFERENCES clients(client_id)ON UPDATE CASCADE,
    FOREIGN KEY(book_id) REFERENCES books(book_id) ON UPDATE CASCADE
);

SELECT * FROM loans;

-- Now, time to enter the data. I created TSVs containing some random data (found in data_src)
SET FOREIGN_KEY_CHECKS=0; -- Used this to allow me to import the foreign key values in tables like Books
SET sql_mode = ''; -- Used this to allow me to import blank date values into the loans table, also had to update the dates to NULL after
LOAD DATA INFILE 'file path' INTO TABLE authors (author_first_name, author_last_name); -- General import format, didn't need ID columns as they are auto-increment

-- Need to update the 0000-00-00 dates in loans to NULL
UPDATE loans
SET date_returned = NULL
WHERE date_returned = 0000-00-00;
