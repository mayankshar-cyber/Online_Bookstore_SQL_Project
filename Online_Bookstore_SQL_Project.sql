drop table if exists Customers;
create table Customers(
Customer_ID serial primary key,
Name varchar(100),
Email varchar(100),
Phone varchar(15),
City varchar(50),
Country varchar(100)
);

drop table if exists Books;
create table Books(
Book_ID serial primary key,
Title varchar(100),
Author varchar(100),
Genre varchar(100),
Published_Year int,
Price numeric(10,2),
Stock int
);

drop table if exists Orders;
create table Orders(
Order_ID serial primary key,
Customer_ID int references Customers(Customer_ID),
Book_ID int references Books(Book_ID),
Order_Date date,
Quantity int,
Total_Amount numeric(10,2)
);

/* As part of this SQL project, three datasets — Customers, Books, and Orders — were integrated into the database.
For the data import process, the built-in import functionality of 
pgAdmin was used to load CSV files into respective tables. 
This helped save time and avoided manual SQL coding for bulk data insertion.*/

select * from Customers;
select * from Books;
select * from Orders;

--1) retrieve all books in the 'fiction genre':
select * from Books
where Genre='Fiction';

--2) find books published after the year 1950;
select title,author,genre,published_year
from Books
where Published_year>1950;

--3) list all the customers from canada
select * from Customers
where country = 'Canada';

--4) show orders placed in november 2023:
select * from Orders
where Order_Date>'2023-10-31' and Order_Date<'2023-12-01';
--another method
select * from Orders
where Order_Date between '2023-11-01' and '2023-11-30';

--5) retrieve the total stock of books available:
select sum(stock) as total_stock
from Books;

--6) find the details of most expensive book
select * from Books order by price desc limit 1;

--7) show all customers who ordered more than 1 quantity of book;
select*from Orders
where quantity>1;

--8) retrieve all orders where the total amount exceeds $20:
select * from Orders
where total_amount>20;

--9) list all genre available in the books table:
select distinct genre from Books;

--10) find the book with lowest stock:
select * from Books order by stock limit 1;

--11) calculate the total revenue generated from all orders:
select sum(total_amount) as total_revenue 
from Orders;


--advance queries
--1) retrieve the total numbers of books sold for each genre:


select b.genre,sum(O.quantity) as total_books_sold
from Orders o 
Join Books b on o.Book_ID=B.Book_ID
group by b.genre;

--2) find the average price of books in 'fantasy 'genre:
select*from Books;

select avg(price) as average_price
from Books
where genre='Fantasy';

--3) list customers who placed at least 2 orders
select * from Orders;
select * from Customers;


select c.customer_id,c.name,count(o.order_id) as order_count
from orders o
join customers c on o.customer_id=c.customer_id
group by c.customer_id,c.name
having count(order_id)>=2;

--4) find the most frequently ordered book
select * from books;
select * from orders;

select b.title,o.book_id, count(o.order_id) as order_count
from orders o
join books b on o.book_id=b.book_id
group by o.book_id,b.title
order by count(o.order_id) desc limit 1


--5) show the top 3 most expensive books of 'fantasy genre';
select * from books;

select title,genre,price
from books
where genre='Fantasy'
order by price desc limit 3

--6) retrieve the total quantity books sold by each author:
select * from books;
select * from orders;

select (b.author),sum(o.quantity) as quantity_sold
from books b
join orders o on b.book_id=o.book_id
group by (b.author);

--7)list the cities where customers who spent over $30 are located:
select * from customers;
select * from orders;

select distinct c.city,o.total_amount
from customers c
join orders o on c.customer_id=o.customer_id
where o.total_amount>30

--8) find the customer who spent most on the orders:
select * from customers;
select * from orders;

select c.customer_id,c.name,sum(o.total_amount) as total_spent
from orders o 
join customers c on c.customer_id=o.customer_id
group by c.customer_id,c.name
order by total_spent desc limit 1;

--9) calculate the stock remaining after fulfiling all orders;
select * from books;
select * from orders;

select b.book_id,b.title,b.stock,coalesce(sum(o.quantity),0) as order_quantity,
b.stock-coalesce(sum(o.quantity),0) as remaining_quantity
from books b
left join orders o on o.book_id=b.book_id
group by b.book_id
order by b.book_id ;