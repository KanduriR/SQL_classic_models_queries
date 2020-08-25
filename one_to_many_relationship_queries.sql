/** Queries based on one to many relationships of the sample database **/

-- Q.query account representatives for each customer --
select cust.customerName, CONCAT(emp.firstName,' ',emp.lastName) as account_rep
from customers as cust
join employees as emp on emp.employeeNumber = cust.salesRepEmployeeNumber;

-- Q.total payments for Atelier graphique --
-- this is without a join, this query can help for when making application based queries --
set @custname := 'Atelier graphique';
select @custname, SUM(amount) from payments 
where customerNumber = (select customerNumber from customers 
                        where customerName = @custname);
                        
-- Q.report total payments by date --
select paymentDate as Date, SUM(amount) from payments
group by 1 order by 1;

-- Q.report the products that have not been sold --
select productName from products 
where productCode not in (select distinct productCode from orderdetails);  
-- way to validate with a join statement --
select * from products 
left join orderdetails on products.productCode = orderdetails.productCode 
where orderNumber is NULL;

-- Q.list the amount paid by each customer --
select cust.customerName, sum(payments.amount) as tot_amount 
from customers cust
join payments on payments.customerNumber = cust.customerNumber
group by 1 order by 1;

-- Q.how many orders are placed by Herkku Gifts --
/* Here I am creating without a join considering a case where your 
  query is being run by an application. Here we take advantage of the indexed columns (PK , FK) 
  for faster retrieval. I've also validated this with a join statement */
/* The below settings are to explore about which query performs faster. My asumption was the 1st one since 
where with a specific number is a faster search than join.
My profiling output shows otherwise. One possibility could be that in customers itself we 
didnt make customerName indexed for faster search. This can result in more search time when compared with join
select @@profiling;
SET profiling =1; */

set @custname := 'Herkku Gifts';
select @custname, count(*) as num_orders
from orders 
where customerNumber = (select customerNumber from customers where customerName= @custname);

-- another way to do and validate the above query result --
set @custname:= 'Herkku Gifts';
select cust.customerName, count(orders.orderNumber) from customers cust
join orders on (orders.customerNumber = cust.customerNumber and customerName=@custname);

-- SHOW PROFILES;

-- Q. who are the employees in Boston --
set @citychoice:= 'Boston';
select concat(emp.firstName, emp.lastName) as emp_names
from employees as emp 
where emp.officeCode in (select officeCode from offices where city=@citychoice);

-- Q.report payments > 100000. Sort them by customer who paid highest payment --
select cust.customerName, sum(payments.amount) as tot_payments 
from customers as cust 
join payments on payments.customerNumber = cust.customerNumber
group by 1
having tot_payments > 100000
order by 2 desc;

-- Q. list the total value of 'On hold' orders -- 'On Hold'
select sum(quantityOrdered*priceEach) from orderdetails
where orderNumber in (select orderNumber from orders where status='On Hold');

-- need to do profiling to see if join or this would be faster. May be hard to say cos of small tables --
select sum(quantityOrdered*priceEach) from orderdetails
join orders on (orders.orderNumber = orderdetails.orderNumber and orders.status='On Hold');


-- Q. report the number of orders "On hold" for each customer -- 
set @status:= 'On Hold';
select customerName, count(orderNumber) as num_orders
from customers 
join orders on (orders.customerNumber = customers.customerNumber and orders.status=@status)
group by 1;






