-- How many loans does X borrower have? X = 3
SELECT COUNT(loan_id) loan_count FROM loans
WHERE client_id = 3;

-- How many of X borrowers books are overdue? X = 5, NULL value is considered overdue as it is not yet returned & the due date has passed
SELECT * FROM loans
WHERE client_id = 5 AND (date_returned IS NULL OR date_due - date_returned < 0);

-- How many books does X branch have total? X = 2
SELECT SUM(num_copies) total_copies FROM copies
WHERE branch_id = 2;

-- Which branch is most popular? We'll rate popularity based on number of loans 
SELECT COUNT(loans.loan_id) loan_count, clients.branch_id
FROM loans
JOIN clients
ON loans.client_id = clients.client_id
GROUP BY branch_id
HAVING COUNT (loans.loan_id)=
(SELECT MAX (loan_count)
FROM (SELECT COUNT(loans.loan_id) loan_count, clients.branch_id
FROM loans
JOIN clients
ON loans.client_id = clients.client_id
GROUP BY branch_id) AS popular);

-- Which book is most popular? Is it a different book for each branch? We'll do this based on loans again
-- Overall most popular
SELECT book_id, COUNT(loan_id) max_loans
FROM loans GROUP BY book_id
HAVING COUNT(loan_id)=(
SELECT MAX (counter)
FROM (SELECT COUNT(loan_id) counter, book_id
FROM loans
GROUP BY book_id) as count_tab);

-- Most popular per branch
SELECT COUNT(loans.loan_id) counter, loans.book_id, clients.branch_id
FROM loans
JOIN clients
ON loans.client_id = clients.client_id
GROUP BY book_id, branch_id; 
-- This query shows the counts for each book per branch

-- Now we see the summary, branch 3 doesn't have a max so it doesn't really work for that one 
SELECT F.counter max_loans, F.book, F.branch
FROM
(SELECT count_tab.counter, count_tab.book, count_tab.branch, ROW_NUMBER() OVER (PARTITION BY count_tab.branch ORDER BY count_tab.counter DESC, count_tab.book) row_num
FROM
(SELECT COUNT(loans.loan_id) counter, loans.book_id book, clients.branch_id branch
FROM loans
JOIN clients
ON loans.client_id = clients.client_id
GROUP BY book_id, branch_id) AS count_tab) AS F
WHERE F.row_num = 1;

-- How many books does X author have at the library? Not very exciting as most only have one so we'll go with X = 3
SELECT authors.author_first_name, authors.author_last_name, COUNT(books.book_id) books
FROM authors
JOIN books
ON authors.author_id = books.author_id
WHERE authors.author_id = 3;

-- Group authors and their publishers
SELECT T.author_first_name, T.author_last_name, publishers.publisher_name
FROM
(SELECT authors.author_first_name, authors.author_last_name, books.publisher_id
FROM authors
JOIN books
ON authors.author_id = books.author_id) AS T
JOIN publishers
ON publishers.publisher_id = T.publisher_id;

-- How many different authors has X publisher worked with (in terms of books at the library). Not very exciting as there aren't any duplicates but we'll do X = 6
SELECT COUNT(T.author_id) author_count, publishers.publisher_name
FROM
(SELECT authors.author_id, books.publisher_id
FROM authors
JOIN books
ON authors.author_id = books.author_id) AS T
JOIN publishers
ON publishers.publisher_id = T.publisher_id
WHERE publishers.publisher_id = 6;

-- What is the latest a book has been returned? In other words, the highest number of days overdue (ignoring null values)
SELECT loans.*, date_returned - date_due days_overdue
FROM loans
HAVING (days_overdue)=(
SELECT MAX(overdue)
FROM (SELECT *, date_returned - date_due overdue
FROM loans) AS T);

-- How many overdue books are there in general?
SELECT COUNT(loan_id) num_overdue
FROM loans
WHERE loan_id IN (
SELECT loan_id
FROM loans
WHERE date_returned - date_due > 0);
