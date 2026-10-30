create database if not exists bike;
use bike;
show tables;

-- Brands Analysis
select * from brands_cleaned;
select count(*) from brands_cleaned;
select sum(brand_id is null),sum(brand_name is null) from brands_cleaned;
select brand_id,brand_name from brands_cleaned group by brand_id,brand_name having count(*)>1;
describe brands_cleaned;
alter table brands_cleaned modify column brand_name varchar(40);
SELECT brand_id, COUNT(*)FROM brands_cleaned GROUP BY brand_id HAVING COUNT(*) > 1;

     -- Categories Analysis
select * from categories_cleaned;
select count(*) from categories_cleaned;
select sum(category_id is null),sum(category_name is null)from categories_cleaned;
select category_id,category_name from categories_cleaned group by category_id,category_name having count(*)>1;
describe categories_cleaned;
alter table categories_cleaned modify column category_name varchar(100);
select category_id,count(*) as total_category_id from categories_cleaned group by category_id having count(*)>1 ;

-- Customers Analysis
select * from customers_cleaned;
select sum(customer_id is null),sum(first_name is null),sum(last_name is null),sum(phone is null),sum(email is null),sum(street is null),
sum(city is null),sum(state is null),sum(zip_code is null) from customers_cleaned;
select customer_id,count(*)as unique_customers from customers_cleaned group by customer_id having count(*)>1;
describe customers_cleaned;
alter table customers_cleaned modify column first_name varchar(50), modify column last_name varchar(50),
 modify column phone varchar(20), modify column email varchar(100), modify column street varchar(150),
 modify column city varchar(50), modify column state varchar(10);
 select * from customers_cleaned where phone="Unknown";
 SELECT TABLE_NAME, COLUMN_NAME, DATA_TYPE FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = 'bike' AND COLUMN_NAME = 'phone';


-- orders Analysis
select count(*) from orders_cleaned;
select count(*) as missing_shipped_dates from orders_cleaned where shipped_date is null;
select sum(order_id is null),sum(customer_id is null),sum(order_status is null),sum(order_date is null),sum(required_date is null),
sum(shipped_date is null),sum(store_id is null),sum(staff_id is null) from orders_cleaned;
select order_id, count(*) as total from orders_cleaned group by order_id having count(*) > 1;
select count(*) as invalid_dates from orders_cleaned where required_date < order_date;
describe orders_cleaned;
alter table orders_cleaned modify column order_status varchar(100),modify column order_date date,modify column required_date date,
modify column shipped_date date;


-- order_items Analysis
select * from order_items_cleaned;
select sum(order_id is null),sum(item_id is null),sum(product_id is null),sum(quantity is null),sum(list_price is null),
sum(discount is null) from order_items_cleaned;
select order_id,item_id,count(*) as total from order_items_cleaned group by order_id,item_id having count(*)>1;
describe order_items_cleaned;
alter table order_items_cleaned modify column list_price decimal(10,2), modify column discount decimal(4,2);

-- products Analysis
select * from products_cleaned;
select count(*) from products_cleaned;
describe products_cleaned;
select sum(product_id is null), sum(product_name is null), sum(brand_id is null), sum(category_id is null), sum(model_year is null), 
sum(list_price is null) from products_cleaned;
select product_id,product_name,brand_id,category_id,model_year,list_price from products_cleaned group by product_id,product_name,
brand_id,category_id,model_year,list_price having count(*)>1;
describe products_cleaned;
alter table products_cleaned modify column product_name varchar(150), modify column list_price decimal(10,2);
select product_id,count(*) as unique_productid from products_cleaned group by product_id having count(*)>1;

-- staffs Analysis
select * from staffs_cleaned;
select count(*) from staffs_cleaned;
describe staffs_cleaned;
select sum(staff_id is null),sum(first_name is null),sum(last_name is null),sum(email is null),sum(phone is null),sum(active is null),
sum(store_id is null),sum(manager_id is null) from staffs_cleaned;
alter table staffs_cleaned modify column first_name varchar(100),modify column last_name varchar(100),modify column email varchar(100),modify column
phone varchar(100),modify column manager_id INT;
select sum(staff_id is null),sum(first_name is null),sum(last_name is null),sum(email is null),sum(phone is null),sum(active is null),
sum(store_id is null),sum(manager_id is null) from staffs_cleaned;
select staff_id,first_name,last_name,email,phone,active,store_id,manager_id from staffs_cleaned group by staff_id,first_name,last_name,
email,phone,active,store_id,manager_id having count(*)>1;
select staff_id,count(*)as unique_staff from staffs_cleaned group by staff_id having count(*)>1;

-- stocks Analysis
select * from stocks_cleaned;
describe stocks_cleaned;
select sum(store_id is null),sum(product_id is null),sum(quantity is null) from stocks_cleaned ;
select store_id,product_id,count(*) as total from stocks_cleaned group by store_id,product_id having count(*)>1;

-- stores Analysis
select * from stores_cleaned;
describe stores_cleaned;
alter table stores_cleaned modify column store_name varchar(50),modify column phone varchar(100),modify column email varchar(100),
modify column street varchar(100),modify column city varchar(100),modify column state varchar(100);
select sum(store_id is null),sum(store_name is null),sum(phone is null),sum(email is null),sum(street is null),sum(city is null),
sum(state is null),sum(zip_code is null) from stores_cleaned;
select store_id,store_name,phone,email,street,city,state,zip_code from stores_cleaned group by store_id,store_name,phone,email,street,city,
state,zip_code having count(*)>1;

-- BUSINESS INSIGHTS
     -- TOTAL ORDERS
select count(distinct order_id) as total_orders
from orders_cleaned
where order_status <> 'Rejected';

-- TOTAL UNITS SOLD
    select sum(oi.quantity) as total_units_sold
from order_items_cleaned oi
join orders_cleaned o on oi.order_id = o.order_id
where o.order_status <> 'Rejected';
    
-- TOTAL REVENUE
select round(sum(oi.quantity*oi.list_price*(1-oi.discount)),2) as total_revenue
from order_items_cleaned oi
join orders_cleaned o on oi.order_id = o.order_id
where o.order_status <> 'Rejected';

-- MONTHLY ORDER TRENDS
    select year(order_date) as year, month(order_date) as month, count(distinct order_id) as total_orders from 
    orders_cleaned group by year(order_date), month(order_date) order by year, month;
    
-- TOP 10 BEST SELLING PRODUCTS
    select p.product_name, sum(oi.quantity) as total_quantity_sold
from products_cleaned p
join order_items_cleaned oi on p.product_id = oi.product_id
join orders_cleaned o on oi.order_id = o.order_id
where o.order_status <> 'Rejected'
group by p.product_name
order by total_quantity_sold desc limit 10;

-- CUSTOMER ORDER DETAILS
    select o.order_id, c.customer_id, c.first_name, c.last_name from orders_cleaned o inner join customers_cleaned c on o.customer_id = c.customer_id;
    select c.customer_id, c.first_name, c.last_name, o.order_id from customers_cleaned c left join orders_cleaned o on c.customer_id = o.customer_id;

-- CATEGORY REVENUE
    select c.category_name,
round(sum(oi.quantity * oi.list_price * (1 - oi.discount)), 2) as total_revenue
from categories_cleaned c
join products_cleaned p on c.category_id = p.category_id
join order_items_cleaned oi on p.product_id = oi.product_id
join orders_cleaned o on oi.order_id = o.order_id
where o.order_status <> 'Rejected'
group by c.category_id, c.category_name
order by total_revenue desc;

-- BRAND REVENUE
    select b.brand_name,
round(sum(oi.quantity * oi.list_price * (1 - oi.discount)), 2) as total_revenue
from brands_cleaned b
join products_cleaned p on b.brand_id = p.brand_id
join order_items_cleaned oi on p.product_id = oi.product_id
join orders_cleaned o on oi.order_id = o.order_id
where o.order_status <> 'Rejected'
group by b.brand_id, b.brand_name
order by total_revenue desc;

    -- STORE REVENUE
    select s.store_id, s.store_name,
round(sum(oi.quantity * oi.list_price * (1 - oi.discount)), 2) as total_revenue
from stores_cleaned s
join orders_cleaned o on s.store_id = o.store_id
join order_items_cleaned oi on o.order_id = oi.order_id
where o.order_status <> 'Rejected'
group by s.store_id, s.store_name
order by total_revenue desc;

    -- CUSTOMER REVENUE
    select c.customer_id, c.first_name, c.last_name,
round(sum(oi.quantity * oi.list_price * (1 - oi.discount)), 2) as total_spending
from customers_cleaned c
join orders_cleaned o on c.customer_id = o.customer_id
join order_items_cleaned oi on o.order_id = oi.order_id
where o.order_status <> 'Rejected'
group by c.customer_id, c.first_name, c.last_name
order by total_spending desc limit 10;