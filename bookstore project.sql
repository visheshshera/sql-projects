-- Create Database
CREATE DATABASE OnlineBookstore;


-- use OnlineBookstore;

-- Create Tables
DROP TABLE IF EXISTS Books;
CREATE TABLE Books (
    Book_ID SERIAL PRIMARY KEY,
    Title VARCHAR(100),
    Author VARCHAR(100),
    Genre VARCHAR(50),
    Published_Year INT,
    Price NUMERIC(10, 2),
    Stock INT
);

DROP TABLE IF EXISTS customers;
CREATE TABLE Customers (
    Customer_ID SERIAL PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    City VARCHAR(50),
    Country VARCHAR(150)
);

DROP TABLE IF EXISTS orders;
CREATE TABLE Orders (
    Order_ID SERIAL PRIMARY KEY,
    Customer_ID INT REFERENCES Customers(Customer_ID),
    Book_ID INT REFERENCES Books(Book_ID),
    Order_Date DATE,
    Quantity INT,
    Total_Amount NUMERIC(10, 2)
);

SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;

-- 1) Retrieve all books in the "Fiction" genre:
select * from books where genre = 'fiction';


-- 2) Find books published after the year 1950:
select * from books where Published_Year>1950;


-- 3) List all customers from the Canada:
select * from customers
where Country='canada';


-- 4) Show orders placed in November 2023:
select * from orders
where Order_Date like "2023-11-%";


-- 5) Retrieve the total stock of books available:
select sum(Stock) as total_stock
from books;


-- 6) Find the details of the most expensive book:
select * from books
order by Price desc
limit 1;


-- 7) Show all customers who ordered more than 1 quantity of a book:
select * from orders
where Quantity>1;


-- 8) Retrieve all orders where the total amount exceeds $20:
select * 
from orders 
where Total_Amount>20;


-- 9) List all genres available in the Books table:
select distinct genre from books;


-- 10) Find the book with the lowest stock:
select * from books order by Stock
limit 5;


-- 11) Calculate the total revenue generated from all orders:
select sum(total_amount) from orders;


-- Advance Questions : 

-- 1) Retrieve the total number of books sold for each genre:
select books.Genre,sum(orders.Quantity)
from orders
join books on orders.Book_ID=books.Book_ID
group by books.Genre;


-- 2) Find the average price of books in the "Fantasy" genre:
SELECT AVG(price) AS Average_Price
FROM Books
WHERE Genre = 'Fantasy';


-- 3) List customers who have placed at least 2 orders:
select orders.Customer_ID,Name,count(*) as order_count from orders
join customers on orders.Customer_ID=customers.Customer_ID
group by Customer_ID
having order_count>=2
order by order_count desc;


-- 4) Find the most frequently ordered book:
SELECT o.Book_id, b.title, COUNT(o.order_id) AS ORDER_COUNT
FROM orders o
JOIN books b ON o.book_id=b.book_id
GROUP BY o.book_id, b.title
ORDER BY ORDER_COUNT DESC LIMIT 1;


-- 5) Show the top 3 most expensive books of 'Fantasy' Genre :
select * from books 
where genre="fantasy"
order by Price desc 
limit 3;


-- 6) Retrieve the total quantity of books sold by each author:
select author,sum(Quantity) from orders
join books on books.Book_ID=orders.Book_ID
group by Author;


-- 7) List the cities where customers who spent over $30 are located:
SELECT DISTINCT c.city, total_amount
FROM orders o
JOIN customers c ON o.customer_id=c.customer_id
WHERE o.total_amount > 30;


-- 8) Find the customer who spent the most on orders:
select customers.Customer_ID, Name,sum(Total_Amount) as amount_spend from customers join orders on orders.Customer_ID=customers.Customer_ID
group by(customers.Customer_ID)
order by sum(Total_Amount) desc
limit 1;


-- 9) Calculate the stock remaining after fulfilling all orders:
SELECT b.book_id, b.title, b.stock, COALESCE(SUM(o.quantity),0) AS Order_quantity,  
	b.stock- COALESCE(SUM(o.quantity),0) AS Remaining_Quantity
FROM books b
LEFT JOIN orders o ON b.book_id=o.book_id
GROUP BY b.book_id ORDER BY b.book_id;