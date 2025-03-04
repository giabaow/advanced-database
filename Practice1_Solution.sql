--QUESTION 26 PRACTICE 1
--Make a list of employees who have received a pay rise. 
--On each line, write the employee's name, salary, previous salary and the percentage of the increase. 
--(An employee should be listed as many times as the number of times he or she has received a pay rise.)
select * from [HumanResources].[EmployeePayHistory]

with raised AS
(
select businessentityid
from [HumanResources].[EmployeePayHistory]
group by businessentityid
having count(*) > 1
)
select isnull(title + ' ','') + firstname+ ' '+lastname + isnull(' '+suffix,''), (rate*payfrequency) / 
lag(rate*payfrequency) over (partition by ep.businessentityid order by ratechangedate) 
from raised join [HumanResources].[EmployeePayHistory] ep on raised.businessentityid = ep.businessentityid
join [Person].[Person] p on p.businessentityid = ep.businessentityid

select isnull(title + ' ','') + firstname+ ' '+lastname + isnull(' '+suffix,'') from [Person].[Person]

/*Make a list of bookstores. 
Include the count of sales events, the sum of books sold, 
the total revenue of bookstores in the same state, and the Olympic-style ranking within the state.*/

select st.stor_name, state, count(*) [sales event], sum(qty)[books sold], sum(t.price*s.qty) [revenue],
sum(sum(t.price*s.qty)) over (partition by st.state) [revenue of bookstores in the same table]
from stores st join sales s on st.stor_id = s.stor_id
join titles t on s.title_id=t.title_id
group by st.stor_name, st.state

/*List the titles, include only those that have more than one author.*/
select t.title, count(*)
from titles t join titleauthor ta on t.title_id=ta.title_id
group by t.title
having count(*) > 1

/*What is the average income on different authors' books? Also include authors without income with 0.*/
select au_fname + ' ' +au_lname, avg(price*qty)
from authors a
left join titleauthor ta on a.au_id = ta.au_id
left join titles t on ta.title_id = t.title_id
left join sales s on t.title_id = s.title_id
group by au_fname + ' ' + au_lname
order by 1

/*Write a query that displays the book title, 
advance paid, book price, year-to-date sales, total revenue (price * ytd_sales), 
and the remaining amount of the advance that has not yet been covered by sales (advance - (price * ytd_sales)). 
Only display books where the advance paid is greater than the total revenue from sales.*/

select title, advance, price, ytd_sales, price*ytd_sales, price*ytd_sales - advance as profit
from titles
where advance > price * ytd_sales

/*Write a query that displays the bestselling books 
with the following details: book title, first author's lastname, book price, year-to-date sales (`ytd_sales`), and publisher's name. 
Filter the books that have sold more than 500 copies year-to-date. 
Order the result by the number of copies sold in descending order so the most popular books appear at the top.*/
select t.title, t.price, ytd_sales, p.pub_name,
(select top 1 au_lname from authors a join titleauthor ta on a.au_id = ta.au_id where ta.title_id = t.title_id
order by au_ord) 
as FirstAuthorName
from titles t join publishers p on t.pub_id=p.pub_id
where ytd_sales > 500

/*Write a query that returns the book titles, their authors' names, the book price, 
and the publisher's name from the pubs database. 
Filter the books that have a price between 15 and 20 dollars. 
Sort the result by the authors' last names in ascending order and then by the book price in descending order.*/
select title, au_fname + ' ' + au_lname, price, p.pub_name
from titles t join titleauthor ta on t.title_id = ta.title_id
join authors a on ta.au_id = a.au_id
join publishers p on t.pub_id = p.pub_id
where price between 15 and 20
order by au_lname asc, price desc 

select title, price, pub_name string_agg(au_fname + ' ' + au_lname, ',')
from titles t join titleauthor ta on t.title_id = ta.title_id
join authors a on ta.au_id = a.au_id
join publishers p on t.pub_id = p.pub_id
where price between 15 and 20
group by title, price, pub_name

--northwind
/*List the number of products for which there is a stock shortage 
(the quantity ordered but not yet delivered is greater than the stock of the product) 
and the extent of this shortage. Make the query using CTE.*/
select * 
from products

select * from [Order Details]

With orderdquantity as
(
select ProductID, sum (quantity) qty from [Orders] o join [order details] od on o.OrderID = od.OrderID
where ShippedDate is null --not yet delivered
group by ProductID
)
select * from orderdquantity as oq join Products p on oq.ProductID = p.ProductID
where p.unitsinstock < oq.qty

/* 15. Make a list of product category income, and the hypothetical income based on sales quantity and list price. 
Include the difference in a separate column and sort by this difference.*/
select * from products
select * from categories
select * from [order details]
select c.categoryname, sum(p.unitprice*p.unitsonorder) as [hypothetical income], o.unitprice*o.quantity-o.discounts as income
from products p join categories c on p.categoryID = c.categoryID
join [order details] o on o.productid = p.productid
group by c.categoryname

/* 16. Generate a quarterly sales report for the 'Beverages' category, detailing sales per quarter and comparing them to the previous quarter's sales.*/
select * from orders
select quarter(orderdate) as [quarterdate] from orders

SELECT
        YEAR(OrderDate) AS Year
        --QUARTER(OrderDate) AS Quarter
    FROM orders
    WHERE Categoryname = 'Beverages'
    GROUP BY YEAR(OrderDate)--, QUARTER(OrderDate)

/*List the discontinued products with their last order date.*/
select p.productname, max(o.orderdate) as [last order date]
from products p join [order details] od on p.productid = od.productid
join orders o on o.orderid = od.orderid 
where discontinued = 1 
group by p.productname
order by productname

/*We have a hypothesis that the unitsonorder field is redundant and equals the summarized quantity of the given product on open (not shipped) orders. 
Check this hypothesis with an SQL query.*/
select * from products












with productsinbottles as
(select * from products where quantityperunit like '%bottles%')
select * from productsinbottles 
select * from [order details] od join productsinbottles on od.productid = productsinbottles.productid

select categoryname, max(unitprice) max 
from products p join categories c on p.categoryid = c.categoryid
group by categoryname

select rank() over (order by max(unitprice)), categoryname
from products p join categories c on p.categoryid = c.categoryid
group by categoryname

select c.categoryname, rank() over (partition by p.categoryid order by unitprice)
from products p join categories c on p.categoryid = c.categoryid

select *, count(*) over (partition by country) from customers
