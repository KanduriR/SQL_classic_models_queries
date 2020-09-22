/* The queries here focus on many to many relationships */

/* For most of the questions here we can create a view that can suport the queries
   Some of the queries are created without view and some are provided with alternative solutions */

-- creating the view 
create view product_orders as 
select orderNumber, orderDate, orders.status as order_status, quantityOrdered, productName 
from orders
join orderdetails on orderdetails.orderNumber = orders.orderNumber
join products on products.productCode = orderdetails.productCode;

-- List products sold by order date. (using view)
select orderDate, productName from product_orders;

-- List the order dates in descending order for orders for the 1940 Ford Pickup Truck (using view)
select orderDate, quantityOrdered
from product_orders
where productName = '1940 Ford Pickup Truck'
order by orderDate desc;

-- List the names of customers and their corresponding order number where a particular order from that customer has a value greater than $25,000?
select orderdetails.orderNumber, cust.customerName, sum(quantityOrdered*priceEach) as order_sum
from orderdetails
join orders on orders.orderNumber = orderdetails.orderNumber
join customers as cust on cust.customerNumber = orders.customerNumber
group by 1
having order_sum >= 25000;


-- Are there any products that appear on all orders?
-- TIP: number of times a product code appears should be equal to number of unique orders
select productCode,COUNT(*) as product_counts 
from orderdetails 
group by 1
having product_counts >= (select count(*) from orders);

-- List the names of products sold at less than 80% of the MSRP.
select productName, orderNumber, priceEach, MSRP, (priceEach/MSRP)*100 as pct_MSRP
from products
right join (
select orderNumber,productCode,priceEach 
from orderdetails )temp on temp.productCode=products.productCode
having pct_MSRP <= 80
order by pct_MSRP;

-- Reports those products that have been sold with a markup of 100% or more (i.e.,  the priceEach is at least twice the buyPrice)
select productName, buyPrice, priceEach
from products
join (
select orderNumber,productCode,priceEach 
from orderdetails) temp 
on (temp.productCode=products.productCode and priceEach >= 2*buyPrice);

-- List the products ordered on a Monday (using view)
select distinct productName
from product_orders
where dayname(orderDate) = 'Monday';

-- What is the quantity on hand for products listed on 'On Hold' orders?
select productName, order_status, sum(quantityOrdered) from product_orders 
group by productName, order_status
having order_status='On Hold'
order by productName;
