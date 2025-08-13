__CREATE-ONLINE_FOOD_DELVERIY_DATABASE

CREATE DATABASE ONLINE_FOOD_DEL;
USE ONLINE_FOOD_DEL;

---CRAETE_TABLES_(CUSTOMER_RESTRAUNT_MENU_ORDER_ORDER_DETAILS)

CREATE TABLE customers
(customer_id int primary key,
customer_name varchar (60),
email varchar (60),
city varchar (60),
signup_date DATE
);

__CREATE_RESTAURANT_TABLE

CREATE TABLE restaurant
(restraunt_id int primary key,
restraunt_name varchar(60),
city varchar(60),
reg_date DATE);


__CREATE_MENU_ITEM _TABLE

CREATE TABLE menu_item
(item_id int primary key,
restraunt_id int,
item_name varchar(60),
price decimal(10,2),
constraint fk_menu_rest
foreign key (restraunt_id)
references restaurant(restraunt_id)
);

__CREATE_ORDER_TABLE

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    restraunt_id INT,
    order_date DATE
);


__CREATE ORDER_TABLE_DETAILS_

CREATE TABLE order_details (
    order_details_id INT PRIMARY KEY,
    order_id INT,
    item_id INT,
    quantity INT
);

___UNDERSTANDING_OUR_FOOD_ORDERING_QUERIES

USE Online_food_del;

_1._Find_name_and_price_of_all_food_items_costing_more_than_300/-

SELECT item_name, price
FROM menu_item
WHERE price>300; 

_2_List_Of_top_5_cheapest_food_item

SELECT item_name, price
FROM menu_item
ORDER BY price asc
LIMIT 5;

_3_List_of_all_restaurants_located_in_delhi

SELECT *
FROM restaurant
WHERE city = 'Delhi';

_4_Show_top_3_most_expensive_menu_items

SELECT *
FROM menu_item
ORDER BY price DESC
LIMIT 3;

_5_ list order IDs where quantity >2

SELECT order_id
FROM order_details
WHERE quantity > 2;

USE online_food_del;

__6_Show_all_order_along_with_the_restraunt_name_from_which_they_were_placed

SELECT order_id, restraunt_name
FROM orders o join restaurant r
on o.restraunt_id=r.restraunt_id;

__7_show_customers_names_and_orders_dates_for_orders_placed_in_january_2023

USE online_food_del;

SELECT c.customer_name ,o.order_date, o.order_id
From 
customers c join orders o
on
c.customer_id= o.customer_id
WHERE o.order_date between '2023-01-01' AND '2023-01-31';

__8_list_all_the_customers_along_with_their_city_who_placed_an_order_on_or_after_2023_1_1

SELECT DISTINCT c.customer_id, c.customer_name, c.city
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_date >= '2023-01-01';

__9_show_restraunts_names_and_orders_IDs_for_orders_placed_from_restarunts_in_mumbai

SELECT r.restraunt_name AS restaurant_name, o.order_id
FROM restaurant r
JOIN orders o ON r.restraunt_id = o.restraunt_id
WHERE r.city = 'Mumbai';

__10_Customers_who_have_orderd_from_a_specific_restraunt_Royal_Garden

SELECT DISTINCT c.customer_id, c.customer_name, c.city
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN restaurant r ON o.restraunt_id = r.restraunt_id
WHERE r.restraunt_name = 'Royal Garden';

USE online_food_del;
**_11_count how many orders_each customers has placed 

SELECT COUNT(o.order_id) as total_order,c.customer_name
From customers c
join orders o
on c.customer_id= o.customer_id
group by c.customer_name;

**_12_Show total revenue earned_from_each_city

SELECT 
    r.city, 
    SUM(m.price * od.quantity) AS total_revenue
FROM 
    restaurant r
JOIN 
    menu_item m ON r.restraunt_id = m.restraunt_id
JOIN 
    order_details od ON od.item_id = m.item_id
JOIN 
    orders o ON o.order_id = od.order_id
GROUP BY 
    r.city;

**_13_Find the toatl_number_of_times_each_food_item_was_ordered

SELECT
 m.item_name, SUM(od.quantity) AS total_times_ordered
FROM 
menu_item m
JOIN 
order_details od ON od.item_id = m.item_id
GROUP BY 
m.item_name;

**_14_calculate_the_average_order_value_for_each_customer_city
    
SELECT 
c.city, AVG(m.price * od.quantity) AS average_order_value
FROM 
customers c
JOIN 
orders o ON c.customer_id = o.customer_id
JOIN 
order_details od ON o.order_id = od.order_id
JOIN 
menu_item m ON od.item_id = m.item_id
GROUP BY c.city;

**_15_find how many different food items were ordered per restaurant

SELECT r.restraunt_name AS restaurant_name, COUNT(DISTINCT od.item_id) AS unique_items_ordered
FROM restaurant r
JOIN menu_item m ON r.restraunt_id = m.restraunt_id
JOIN order_details od ON od.item_id = m.item_id
JOIN orders o ON o.order_id = od.order_id
GROUP BY r.restraunt_name;

**_16_Find the cities_with_more_than_5_toatl_orders

SELECT r.city, COUNT(o.order_id) AS total_orders
FROM orders o
JOIN restaurant r ON o.restraunt_id = r.restraunt_id
GROUP BY r.city
HAVING COUNT(o.order_id) > 5;


**_17_Show food items that earned more _than_1000/- Rs_in total revenue
__item_name (revenue= price*quantity)

SELECT m.item_name, SUM(m.price * od.quantity) AS revenue
FROM menu_item m
JOIN order_details od ON m.item_id = od.item_id
GROUP BY m.item_name
HAVING SUM(m.price * od.quantity) > 1000;


**_18_list of the customers who placed more than 3 orders

SELECT c.customer_id, c.customer_name, COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
HAVING COUNT(o.order_id) > 3
LIMIT 0, 1000;

**_20_display menu items that were orderd more than 2 times

SELECT m.item_name, SUM(od.quantity) AS total_quantity_ordered
FROM menu_item m
JOIN order_details od ON m.item_id = od.item_id
GROUP BY m.item_name
HAVING SUM(od.quantity) > 2;

USE online_food_del;

**_21_Show_all_the _menu_items_price_along_with_the_average_price_of_all_items _(SUB_QUERIES)

SELECT item_name, Price, (SELECT AVG (price) FROM menu_item) as AVG_price
FROM menu_item;


**_22_Show_customers_who_placed_at_least_one_order

SELECT customer_name, customer_id
FROM customers
WHERE customer_id in (select customer_id from orders);

**_23_show_each_food_item_and_how_much_more_it_costs_than_the_average

SELECT m.item_name,m.price,m.price - (SELECT AVG(price) FROM menu_item) AS price_above_average
FROM menu_item m;

**_24_list_food_items_that_costs_more_than_the_average_price

SELECT m.item_name, m.price
FROM menu_item m
WHERE m.price > (SELECT AVG(price) FROM menu_item);

**_25_show_customers_who_havent_palced_any_orders

SELECT c.customer_id, c.customer_name
FROM customers c
WHERE c.customer_id NOT IN (
    SELECT o.customer_id
    FROM orders o
);

USE online_food_del;
__Summary_Query

_1_ Total_order_per_city

SELECT r.city, COUNT(o.order_id) AS total_orders
FROM orders o
JOIN restaurant r ON o.restraunt_id = r.restraunt_id
GROUP BY r.city
ORDER BY total_orders DESC;

INSIHTS : JAIPUR _AND HYDERABAD have the heighest _number _of food _order compare _to other cities
__These cities are the _active markets
__Focus _marketing efforts,special offers
__expansion strategies
__improve operation _in other cities.

__2_Revenue_generated_by_each_food_item

SELECT m.item_name, SUM(m.price * od.quantity) AS total_revenue
FROM menu_item m
JOIN order_details od ON m.item_id = od.item_id
GROUP BY m.item_name
ORDER BY total_revenue DESC;

__INSIHTS__ Best performing food items
__Aloo Partha, fish curry _and hakka noddles are the top _3 food items generating highest revenue.
__promote it more prominently _on app.
__we can ensure _consistent availability _and faster delivery.


__3_Top_5_spending_customers

SELECT c.customer_id, c.customer_name, SUM(m.price * od.quantity) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_details od ON o.order_id = od.order_id
JOIN menu_item m ON od.item_id = m.item_id
GROUP BY c.customer_id, c.customer_name
ORDER BY total_spent DESC
LIMIT 5;

__4_Restaurant_wise_order_count

SELECT r.restraunt_name, COUNT(o.order_id) AS total_orders
FROM restaurant r
JOIN orders o ON r.restraunt_id = o.restraunt_id
GROUP BY r.restraunt_name
ORDER BY total_orders DESC;

__5_Average_order_value_by_city

SELECT r.city, AVG(m.price * od.quantity) AS average_order_value
FROM restaurant r
JOIN orders o ON r.restraunt_id = o.restraunt_id
JOIN order_details od ON o.order_id = od.order_id
JOIN menu_item m ON od.item_id = m.item_id
GROUP BY r.city
ORDER BY average_order_value DESC;

