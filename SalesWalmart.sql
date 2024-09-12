CREATE DATABASE IF NOT EXISTS salesDataWalmart;
CREATE TABLE IF NOT EXISTS sales(
	invoice_id varchar(50) not null primary key,
	branch varchar(5) not null,
    city varchar(30) not null,
    customer_type varchar(30) not null,
    gender varchar(10) not null,
    product_line varchar(100) not null,
    unit_price decimal(10,2) not null,
    quantity int not null,
    vat float(6,4) not null,
    total decimal(12,4) not null,
    date datetime not null,
    time time not null,
    payment varchar(15) not null,
    cogs decimal(10,2) not null,
    gross_margin_pct float(11,9),
    gross_income decimal(12,4) not null,
    rating float(2,1) 
);

-- -----FEATURE ENGINEERING-----------
alter table sales add column time_of_day varchar(20);
update sales 
set time_of_day=(
	case 
		when 'time' between "00:00:00" and "12:00:00" then "Morning"
		when 'time' between "12:01:00" and "16:00:00" then "Afternoon"
		else "Evening"
	END
);

alter table sales add column day_name varchar(20);
update sales set day_name = dayname(date);

alter table sales add column month_name varchar(20);
update sales set month_name = monthname(date);

-- ---------EXPLORATORY DATA ANALYSIS-----------------

-- How unique cities does the data have ?
select distinct city from sales;

-- In which city each branch is present ?
select distinct city,branch from sales;

-- Unique product lines
select count(distinct product_line) from sales;

-- Most common payment method
select payment, count(payment) as count from sales group by payment order by count desc;

-- Most selling product line 
select product_line, count(product_line) as cnt from sales group by product_line order by cnt desc;

-- Total revenue by month
select month_name, sum(total) as tot from sales group by month_name ;

-- Average rating of product line
select product_line, avg(rating) as average from sales group by product_line;

-- Which of the customer types brings the most revenue?
SELECT customer_type, SUM(total) AS total_revenue FROM sales GROUP BY customer_type ORDER BY total_revenue;

-- Which of the customer types brings the most revenue?
SELECT customer_type, SUM(total) AS total_revenue FROM sales GROUP BY customer_type ORDER BY total_revenue desc;

-- How many unique customer types does the data have?
SELECT DISTINCT customer_type FROM sales;

-- How many unique payment methods does the data have?
SELECT DISTINCT payment FROM sales;

-- Which day of the week has the best average ratings per branch?
SELECT 
	day_name,
	COUNT(day_name) total_sales
FROM sales
WHERE branch = "C"
GROUP BY day_name
ORDER BY total_sales DESC;

-- Which time of the day do customers give most ratings per branch?
SELECT
	time_of_day,
	AVG(rating) AS avg_rating
FROM sales
WHERE branch = "A"
GROUP BY time_of_day
ORDER BY avg_rating DESC;

-- What is the most common customer type?
SELECT customer_type, count(*) as count FROM sales GROUP BY customer_type ORDER BY count DESC;

-- Which customer type buys the most?
SELECT customer_type, COUNT(*)FROM sales GROUP BY customer_type;

-- What is the gender of most of the customers?
SELECT gender,COUNT(*) as gender_cnt FROM salesGROUP BY gender ORDER BY gender_cnt DESC;





 