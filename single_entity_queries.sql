/***
These queries are single entitiy queries answering the questions posted here 
https://www.richardtwatson.com/dm6e/Reader/ClassicModels.html
**/

-- list of officess--
select officeCode, country, state, city from offices
order by country, state, city;

-- Number of employees in the company --
select COUNT(*), COUNT(distinct employeeNumber) from employees;

-- Total payments received --
select SUM(amount) from payments;

-- list product lines that contain 'Cars' --
select * from productlines where productLine like '%cars%';

-- total payments for October 28, 2004 --
select SUM(amount) from payments where paymentDate='2004-10-28';
-- to compare the above query output value --
select * from payments where paymentDate = '2004-10-28';

-- query payments greater than 100,000$ --
select * from payments where amount > 100000;

-- list products in each product line --
select productLine, productName from products order by 1;

-- how many products in each product line -
select productLine, count(*) from products group by 1 order by 1;
-- can compare your answer validation by using below query --
select productLine, productName, rank() over (partition by productLine order by productName) from products;

-- minimum payment amount received --
select min(amount) from payments;

-- list payments greater than twice the average payment --
select * from payments where amount > (select 2*avg(amount) from payments);
-- you can validate by creating a variable and check its value to compare above query having values greater than this var --
set @twice_avg := (select 2*avg(amount) from payments);
select @twice_avg;

-- avg % markup of the MSRP on buyPrice  --
select avg((MSRP-buyPrice)/buyPrice)*100 from products;

-- How many distinct products does Classicmodels sell --
select count(distinct productName),count(*) from products;

-- report the name and city of customers who don't have sales representatives? --
select customerName, city from customers where salesRepEmployeeNumber is NULL;

-- executives with a VP or manager title, report with full name - first and last --
select concat(firstName,' ',lastName), jobTitle from employees 
where jobTitle like '%vp%' or  
	  jobTitle like '%manager%';
      
-- orders with values greater than 5000 --
select orderNumber, SUM(quantityOrdered * priceEach) as order_value
from orderdetails 
group by 1
having order_value > 5000;



