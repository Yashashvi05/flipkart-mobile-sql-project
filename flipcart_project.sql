
-- =========================================
-- DATABASE SETUP
-- Project Name : Flipkart Mobile Data Cleaning & Analysis
-- =========================================

-- =========================================
-- TASK 1 : CREATE DATABASE
-- Purpose:
-- Create a separate database for the project
-- =========================================

CREATE DATABASE flipkart_project;

-- =========================================
-- TASK 2 : USE DATABASE
-- Purpose:
-- Select the project database to work on
-- =========================================

USE flipkart_project;

-- =========================================
-- TASK 3 : CHECK IMPORTED RAW TABLE
-- Purpose:
-- Verify whether the CSV data is imported properly
-- Display first 5 records from raw dataset
-- =========================================

select * from flipkart_mobile limit 5;

-- =========================================
-- TASK 4 : CREATE CLEANED TABLE
-- Purpose:
-- Create a duplicate table for data cleaning
-- Raw data should always remain unchanged
-- =========================================

create table flipkart_mobile_cleaned as select * from flipkart_mobile;

-- =========================================
-- TASK 5 : CHECK CLEANED TABLE
-- Purpose:
-- Verify duplicate/cleaned table creation
-- =========================================

select * from flipkart_mobile_cleaned limit 5;

-- =========================================
-- TASK 6 : RENAME COLUMNS
-- Purpose:
-- Rename columns into SQL-friendly format
-- Remove spaces from column names
-- =========================================

ALTER TABLE flipkart_mobile_cleaned
RENAME COLUMN `Model Name` TO model_name;

ALTER TABLE flipkart_mobile_cleaned
RENAME COLUMN `Price` TO price;

ALTER TABLE flipkart_mobile_cleaned
RENAME COLUMN `Discount` TO discount;

ALTER TABLE flipkart_mobile_cleaned
RENAME COLUMN `Avg Rating` TO avg_rating;

ALTER TABLE flipkart_mobile_cleaned
RENAME COLUMN `Rating Count` TO rating_count;

ALTER TABLE flipkart_mobile_cleaned
RENAME COLUMN `Review Count` TO review_count;

ALTER TABLE flipkart_mobile_cleaned
RENAME COLUMN `Memory Details` TO memory_details;

ALTER TABLE flipkart_mobile_cleaned
RENAME COLUMN `Screen Dimention` TO screen_dimension;

ALTER TABLE flipkart_mobile_cleaned
RENAME COLUMN `Lens Detail` TO lens_details;

ALTER TABLE flipkart_mobile_cleaned
RENAME COLUMN `Battery Capacity` TO battery_capacity;

ALTER TABLE flipkart_mobile_cleaned
RENAME COLUMN `Processor` TO processor;

ALTER TABLE flipkart_mobile_cleaned
RENAME COLUMN `Warranty` TO warranty;

-- =========================================
-- TASK 7 : CHECK TABLE STRUCTURE
-- Purpose:
-- View updated column names and datatypes
-- =========================================

DESC flipkart_mobile_cleaned;

-- =========================================
-- TASK 8 : CHECK NULL VALUES
-- Purpose:
-- Identify missing values in important columns
-- =========================================

select * from flipkart_mobile_cleaned where model_name is null;
select * from flipkart_mobile_cleaned where price is null;
select * from flipkart_mobile_cleaned where discount is null;
select * from flipkart_mobile_cleaned where avg_rating is null;
select * from flipkart_mobile_cleaned where rating_count is null;
select * from flipkart_mobile_cleaned where review_count is null;
select * from flipkart_mobile_cleaned where memory_details is null;
select * from flipkart_mobile_cleaned where screen_dimension is null;
select * from flipkart_mobile_cleaned where lens_details is null;
select * from flipkart_mobile_cleaned where battery_capacity is null;
select * from flipkart_mobile_cleaned where processor is null;
select * from flipkart_mobile_cleaned where warranty is null;

-- =========================================
-- TASK 9 : COUNT NULL VALUES
-- Purpose:
-- Count total missing values in each column
-- =========================================

SELECT
COUNT(*) AS total_rows,
COUNT(model_name) AS model_name_count,
COUNT(price) AS price_count,
COUNT(discount) AS discount_count,
COUNT(avg_rating) AS avg_rating_count,
COUNT(rating_count) AS rating_count_count,
COUNT(review_count) AS review_count_count,
COUNT(memory_details) AS memory_details_count,
COUNT(screen_dimension) AS screen_dimension_count,
COUNT(lens_details) AS lens_details_count,
COUNT(battery_capacity) AS battery_capacity_count,
COUNT(processor) AS processor_count,
COUNT(warranty) AS warranty_count
FROM flipkart_mobile_cleaned;

-- =========================================
-- TASK 10 : REMOVE UNWANTED COLUMN
-- Purpose:
-- Remove unnecessary index column imported from CSV
-- =========================================

ALTER TABLE flipkart_mobile_cleaned
DROP COLUMN `Unnamed: 0`;

SHOW COLUMNS
FROM flipkart_mobile_cleaned;

-- =========================================
-- TASK 11 : FIND DUPLICATE RECORDS
-- Purpose:
-- Identify duplicate mobile models
-- =========================================

SELECT
model_name,
COUNT(*) AS duplicate_count
FROM flipkart_mobile_cleaned
GROUP BY model_name
HAVING COUNT(*) > 1;

-- =========================================
-- TASK 12 : CHECK SPECIAL CHARACTERS
-- Purpose:
-- Detect unwanted special characters
-- in numeric columns
-- =========================================

SELECT rating_count
FROM flipkart_mobile_cleaned
WHERE rating_count LIKE '%Â%';

-- =========================================
-- TASK 13 : CLEAN RATING COUNT COLUMN
-- Purpose:
-- Remove text, commas and special characters
-- from rating_count column
-- =========================================

-- Disable safe update mode
set sql_safe_updates = 0;

-- Remove word "Ratings"
update flipkart_mobile_cleaned
set rating_count =
replace(rating_count, ' Ratings', '');

-- Remove commas from values
update flipkart_mobile_cleaned
set rating_count =
replace(rating_count, ',', '');

-- Remove special character Â
update flipkart_mobile_cleaned
set rating_count =
replace(rating_count, 'Â', '');

-- Remove leading and trailing spaces
update flipkart_mobile_cleaned
set rating_count = trim(rating_count);

-- Convert blank values into NULL
update flipkart_mobile_cleaned
set rating_count = null
where rating_count = '';

-- Remove any remaining non-numeric characters
update flipkart_mobile_cleaned
set rating_count =
REGEXP_REPLACE(rating_count, '[^0-9]', '');

-- Verify cleaned values
select rating_count from flipkart_mobile_cleaned limit 10;

-- Convert datatype into INTEGER
alter table flipkart_mobile_cleaned modify rating_count INT;

-- =========================================
-- TASK 14 : CLEAN REVIEW COUNT COLUMN
-- Purpose:
-- Remove unwanted text and symbols
-- from review_count column
-- =========================================

-- Remove word "Reviews"
update flipkart_mobile_cleaned
set review_count =
replace(review_count, ' Reviews', '');

-- Remove commas
update flipkart_mobile_cleaned
set review_count =
replace(review_count, ',', '');

-- Remove special character Â
update flipkart_mobile_cleaned
set review_count =
replace(review_count, 'Â', '');

-- Remove extra spaces
update flipkart_mobile_cleaned
set review_count = trim(review_count);

-- Convert blank values into NULL
update flipkart_mobile_cleaned
set review_count = null
where review_count = '';

-- Remove non-numeric characters
update flipkart_mobile_cleaned
set review_count =
REGEXP_REPLACE(review_count, '[^0-9]', '');

-- Verify cleaned values
select review_count from flipkart_mobile_cleaned limit 10;

-- Convert datatype into INTEGER
alter table flipkart_mobile_cleaned modify review_count int;

-- =========================================
-- TASK 15 : CLEAN PRICE COLUMN
-- Purpose:
-- Remove ₹ symbol and commas
-- from price column
-- =========================================

-- Remove ₹ symbol
update flipkart_mobile_cleaned
set price =
replace(price, '₹', '');

-- Remove commas
update flipkart_mobile_cleaned
set price =
replace(price, ',', '');

-- Remove extra spaces
update flipkart_mobile_cleaned
set price = trim(price);

-- Convert blank values into NULL
update flipkart_mobile_cleaned
set price = NULL
where price = '';

-- Verify cleaned values
select price from flipkart_mobile_cleaned limit 10;

-- Convert datatype into INTEGER
alter table flipkart_mobile_cleaned modify price int;

-- =========================================
-- TASK 16 : CONVERT DATATYPES
-- Purpose:
-- Convert cleaned columns into proper datatypes
-- =========================================

-- Remove extra spaces
update flipkart_mobile_cleaned
set avg_rating = trim(avg_rating);

-- Convert blank values into NULL
update flipkart_mobile_cleaned
set avg_rating = NULL
where avg_rating = '';

-- Verify values
select avg_rating from flipkart_mobile_cleaned limit 10;

-- Convert datatype into DECIMAL
alter table flipkart_mobile_cleaned modify avg_rating decimal(2,1);

-- =========================================
-- TASK 17 : VERIFY CLEANED DATA
-- Purpose:
-- Check whether data cleaning completed properly
-- =========================================

-- Display cleaned data
select * from flipkart_mobile_cleaned ;

-- Check updated table structure
DESC flipkart_mobile_cleaned;

-- =========================================
-- EXPLORATORY DATA ANALYSIS(EDA)
-- =========================================

-- =========================================
-- TASK 18 : COUNT TOTAL RECORDS
-- Purpose:
-- Find total number of mobiles available
-- in the dataset
-- =========================================

select COUNT(*) AS total_mobiles from flipkart_mobile_cleaned;

-- =========================================
-- TASK 19 : COUNT UNIQUE MOBILE MODELS
-- Purpose:
-- Identify total unique mobile models
-- =========================================

select count(distinct model_name) as unique_models from flipkart_mobile_cleaned;

-- =========================================
-- TASK 20 : FIND MINIMUM AND MAXIMUM PRICE
-- Purpose:
-- Identify cheapest and most expensive mobiles
-- =========================================

select min(price) as minimum_price, max(price) as maximum_price from flipkart_mobile_cleaned;

-- =========================================
-- TASK 21 : FIND AVERAGE MOBILE PRICE
-- Purpose:
-- Calculate average price of mobiles
-- =========================================

select round(avg(price),2) average_price from flipkart_mobile_cleaned;

-- =========================================
-- TASK 22 : FIND AVERAGE RATING
-- Purpose:
-- Calculate average customer rating
-- =========================================

select round(avg(avg_rating),2) as average_rating from flipkart_mobile_cleaned;

-- =========================================
-- TASK 23 : FIND TOTAL REVIEWS
-- Purpose:
-- Calculate total customer reviews
-- =========================================

select sum(review_count) as total_reviews from flipkart_mobile_cleaned;

-- =========================================
-- TASK 24 : FIND TOTAL RATINGS
-- Purpose:
-- Calculate total customer ratings
-- =========================================

select sum(rating_count) as total_ratings from flipkart_mobile_cleaned;

-- =========================================
-- TASK 25 : CHECK MISSING SPECIFICATIONS
-- Purpose:
-- Identify mobiles with missing specifications
-- =========================================

select * from flipkart_mobile_cleaned where memory_details is null or processor is null or battery_capacity is null;

-- =========================================
-- TASK 26 : FIND DISTINCT PROCESSORS
-- Purpose:
-- Identify different processor types available
-- =========================================

select distinct processor from flipkart_mobile_cleaned;

update flipkart_mobile_cleaned
set processor = null
where processor = '';

-- =========================================
-- TASK 27 : FIND DISTINCT SCREEN SIZES
-- Purpose:
-- Identify different screen dimensions
-- =========================================

select distinct screen_dimension from flipkart_mobile_cleaned;

-- =========================================
-- TASK 28 : FIND DISTINCT MEMORY VARIANTS
-- Purpose:
-- Identify different RAM and storage combinations
-- =========================================

select distinct memory_details from flipkart_mobile_cleaned;

-- =========================================
-- BASIC ANALYSIS
-- =========================================

-- =========================================
-- TASK 29 : TOP 10 MOST EXPENSIVE MOBILES
-- Purpose:
-- Identify highest priced mobiles
-- =========================================

select model_name, price
from flipkart_mobile_cleaned
order by  price desc limit 10;

-- =========================================
-- TASK 30 : TOP 10 CHEAPEST MOBILES
-- Purpose:
-- Identify lowest priced mobiles
-- =========================================

select model_name, price
from flipkart_mobile_cleaned 
order by price asc limit 10;

-- =========================================
-- TASK 31 : FIND HIGHEST RATED MOBILES
-- Purpose:
-- Identify mobiles with highest ratings
-- =========================================

select model_name, avg_rating
from flipkart_mobile_cleaned 
order by avg_rating desc limit 10;

-- =========================================
-- TASK 32 : FIND LOWEST RATED MOBILES
-- Purpose:
-- Identify mobiles with lowest ratings
-- =========================================

select model_name, avg_rating
from flipkart_mobile_cleaned
order by avg_rating asc ;

-- =========================================
-- TASK 33 : FIND MOST REVIEWED MOBILES
-- Purpose:
-- Identify mobiles with highest customer reviews
-- =========================================

select model_name, review_count
from flipkart_mobile_cleaned
order by review_count desc limit 10;

-- =========================================
-- TASK 34 : FIND MOST RATED MOBILES
-- Purpose:
-- Identify mobiles with highest ratings count
-- =========================================

select model_name, rating_count
from flipkart_mobile_cleaned
order by rating_count desc limit 10;

-- =========================================
-- TASK 35 : FIND MOBILES ABOVE ₹50,000
-- Purpose:
-- Identify premium smartphones
-- =========================================

select model_name, price
from flipkart_mobile_cleaned
where price > 50000
order by  price desc;

-- =========================================
-- TASK 36 : FIND MOBILES BETWEEN ₹10,000 AND ₹20,000
-- Purpose:
-- Identify mid-range smartphones
-- =========================================

select model_name, price
from flipkart_mobile_cleaned
where price between 10000 and 20000 order by price;

-- =========================================
-- TASK 37 : FIND MOBILES WITH RATING ABOVE 4.5
-- Purpose:
-- Identify highly rated smartphones
-- =========================================

select model_name, avg_rating
from flipkart_mobile_cleaned
where avg_rating >= 4.5
order by avg_rating desc;

-- =========================================
-- TASK 38 : FIND MOBILES WITH LOW RATINGS
-- Purpose:
-- Identify poorly rated smartphones
-- =========================================

select model_name, avg_rating
from flipkart_mobile_cleaned
where avg_rating <= 3.5
order by avg_rating;

-- =========================================
-- TASK 39 : FIND MOBILES WITH HIGHEST DISCOUNT
-- Purpose:
-- Identify mobiles with best discounts
-- =========================================

select model_name, discount
from flipkart_mobile_cleaned
order by discount desc;

-- =========================================
-- TASK 40 : FIND PHONES WITH 5G SUPPORT
-- Purpose:
-- Identify mobiles supporting 5G connectivity
-- =========================================

select  model_name, memory_details
from flipkart_mobile_cleaned
where model_name like '%4G%';

-- =========================================
-- TASK 41 : FIND APPLE MOBILES
-- Purpose:
-- Identify all Apple smartphones
-- =========================================

select *
from flipkart_mobile_cleaned
where model_name like '%Apple%';

-- =========================================
-- TASK 42 : FIND SAMSUNG MOBILES
-- Purpose:
-- Identify all Samsung smartphones
-- =========================================

select *
from flipkart_mobile_cleaned
where model_name like '%SAMSUNG%';

-- =========================================
-- INTERMEDIATE ANALYSIS
-- =========================================

-- =========================================
-- TASK 43 : COUNT MOBILES BY BRAND
-- Purpose:
-- Identify how many mobiles each brand offers
-- =========================================

select substring_index(model_name,' ',1) AS brand_name,
count(*) as total_mobiles
from flipkart_mobile_cleaned
group by brand_name
order by total_mobiles desc;

-- =========================================
-- TASK 44 : AVERAGE PRICE BY BRAND
-- Purpose:
-- Calculate average mobile price by brand
-- =========================================

select substring_index(model_name, ' ', 1) AS brand_name,
round(avg(price),2) as average_price
from flipkart_mobile_cleaned
group by brand_name
order by average_price desc;

-- =========================================
-- TASK 45 : AVERAGE RATING BY BRAND
-- Purpose:
-- Identify brands with highest average ratings
-- =========================================

select substring_index(model_name, ' ', 1) AS brand_name,
round(avg(avg_rating),2) as average_rating
from flipkart_mobile_cleaned
group by brand_name
order by average_rating desc;

-- =========================================
-- TASK 46 : TOTAL REVIEWS BY BRAND
-- Purpose:
-- Identify brands with highest customer engagement
-- =========================================

select substring_index(model_name, ' ', 1) AS brand_name,
sum(review_count) AS total_reviews
from flipkart_mobile_cleaned
group by brand_name
order by total_reviews desc ;

-- =========================================
-- TASK 47 : TOTAL RATINGS BY BRAND
-- Purpose:
-- Identify brands with highest rating counts
-- =========================================

select substring_index(model_name, ' ', 1) as brand_name,
sum(rating_count) as total_ratings
from flipkart_mobile_cleaned
group by brand_name
order by total_ratings desc ;

-- =========================================
-- TASK 48 : COUNT MOBILES BY PROCESSOR
-- Purpose:
-- Identify most commonly used processors
-- =========================================

select processor, count(*) as total_mobiles
from flipkart_mobile_cleaned
group by processor
order by total_mobiles desc;

-- =========================================
-- TASK 49 : AVERAGE RATING BY PROCESSOR
-- Purpose:
-- Compare processor performance using ratings
-- =========================================

select processor, round(avg(avg_rating),2) as average_rating
from flipkart_mobile_cleaned
group by processor
order by average_rating desc;

-- =========================================
-- TASK 50 : AVERAGE PRICE BY PROCESSOR
-- Purpose:
-- Identify processors used in premium mobiles
-- =========================================

select processor, round(avg(price),2) as average_price
from flipkart_mobile_cleaned
group by processor 
order by average_price DESC;

-- =========================================
-- TASK 51 : FIND BRANDS WITH MORE THAN 50 MOBILES
-- Purpose:
-- Identify brands dominating the marketplace
-- =========================================

select substring_index(model_name, ' ', 1) AS brand_name,
COUNT(*) AS total_mobiles
from flipkart_mobile_cleaned
group by brand_name
having count(*) > 50
order by total_mobiles desc;

-- =========================================
-- TASK 52 : FIND PROCESSORS WITH AVG RATING ABOVE 4.3
-- Purpose:
-- Identify top performing processors
-- =========================================

select processor, round(avg(avg_rating),1) as average_rating
from flipkart_mobile_cleaned
group by processor
having avg(avg_rating) > 4.3
order by average_rating desc;

-- =========================================
-- TASK 53 : FIND PREMIUM BRANDS
-- Purpose:
-- Identify brands with high average selling price
-- =========================================

select substring_index(model_name, ' ', 1) AS brand_name,
avg(price) as average_price
from flipkart_mobile_cleaned
group by brand_name
having avg(price) > 50000
order by average_price desc;

-- =========================================
-- TASK 54 : FIND HIGHLY REVIEWED PREMIUM MOBILES
-- Purpose:
-- Identify expensive mobiles with strong customer engagement
-- =========================================

select model_name, price, review_count
from flipkart_mobile_cleaned
where price > 50000
and review_count > 1000
order by review_count desc;

-- =========================================
-- ADVANCED SQL ANALYSIS
-- =========================================

-- =========================================
-- TASK 55 : FIND MOST POPULAR PRICE RANGE
-- Purpose:
-- Categorize mobiles into price segments
-- =========================================

select
case
    when price < 10000 then 'Budget'
    when price between 10000 and 30000 then 'Mid-Range'
    else 'Premium'
end as price_category,
count(*) as total_mobiles
from flipkart_mobile_cleaned
group by price_category
order by total_mobiles DESC;

-- =========================================
-- TASK 56 : CATEGORIZE MOBILES USING CASE WHEN
-- Purpose:
-- Categorize mobiles based on price range
-- =========================================

select model_name, price,
case
    when price < 15000 then 'low - Budget'
    when price between 10000 and 30000 then 'Mid-Range'
    else 'Premium'
end as mobile_category
from flipkart_mobile_cleaned;

-- =========================================
-- TASK 57 : FIND MOBILES PRICED ABOVE AVERAGE
-- Purpose:
-- Identify mobiles priced above overall average
-- using subquery
-- =========================================

select model_name, price
from flipkart_mobile_cleaned
where price > (
    select avg(price)
    from flipkart_mobile_cleaned
)order by price desc;

-- =========================================
-- TASK 58 : FIND BRANDS WITH ABOVE AVERAGE RATINGS
-- Purpose:
-- Identify brands performing better than
-- overall market rating
-- =========================================

select substring_index(model_name, ' ', 1) AS brand_name,
round(avg(avg_rating),1) AS average_rating
FROM flipkart_mobile_cleaned
group by brand_name
having avg(avg_rating) > (
    select avg(avg_rating)
    from flipkart_mobile_cleaned
)order by average_rating desc;

-- =========================================
-- TASK 59 : RANK MOBILES BY PRICE
-- Purpose:
-- Assign ranking based on mobile prices
-- using window function
-- =========================================

select model_name,price,
rank() over ( order by price desc ) as price_rank
from flipkart_mobile_cleaned;

-- =========================================
-- TASK 60 : DENSE RANK MOBILES BY RATING
-- Purpose:
-- Rank mobiles based on ratings
-- without skipping ranks
-- =========================================

select model_name,avg_rating,
dense_rank() over (order by avg_rating desc) as rating_rank
from flipkart_mobile_cleaned;

-- =========================================
-- TASK 61 : TOP 3 MOST EXPENSIVE MOBILES IN EACH BRAND
-- Purpose:
-- Identify premium mobiles brand-wise
-- using partition window function
-- =========================================

select * from (
    select model_name,price, substring_index(model_name, ' ', 1) as brand_name,
    rank() over (partition by substring_index(model_name, ' ', 1) order by price desc) as brand_rank
    from flipkart_mobile_cleaned
) as ranked_mobiles
where brand_rank <= 3;

-- =========================================
-- TASK 62 : CREATE CTE FOR PREMIUM MOBILES
-- Purpose:
-- Use Common Table Expression (CTE)
-- to analyze premium smartphones
-- =========================================

with premium_mobiles as (
    select model_name, price, avg_rating	
    from flipkart_mobile_cleaned
    where price > 50000
)
SELECT * FROM premium_mobiles;

-- =========================================
-- TASK 63 : FIND HIGHLY RATED PREMIUM MOBILES USING CTE
-- Purpose:
-- Identify premium mobiles with high ratings
-- =========================================

with premium_mobiles as(
    select model_name, price,avg_rating
    from flipkart_mobile_cleaned
    where price > 50000
)
select * from premium_mobiles where avg_rating > 4.5;

-- =========================================
-- TASK 64 : FIND BEST VALUE-FOR-MONEY MOBILES
-- Purpose:
-- Identify affordable mobiles with high ratings
-- =========================================

select model_name,price,avg_rating
from flipkart_mobile_cleaned
where price < 20000 and avg_rating > 4.3
order by avg_rating desc;

-- =========================================
-- TASK 65 : FIND MOBILES WITH HIGH ENGAGEMENT
-- Purpose:
-- Identify mobiles having high ratings and reviews
-- =========================================

select model_name, rating_count, review_count
from flipkart_mobile_cleaned
where rating_count > 50000 and review_count > 5000
order by rating_count desc;

-- =========================================
-- TASK 66 : FIND MOST TRUSTED BRANDS
-- Purpose:
-- Identify brands with high average ratings
-- and customer engagement
-- =========================================

select substring_index(model_name, ' ', 1) as brand_name,
avg(avg_rating) as average_rating, sum(review_count) as total_reviews
from flipkart_mobile_cleaned
group by brand_name
having avg(avg_rating) > 4.2
order by  average_rating desc, total_reviews desc;
         
-- =========================================
-- TASK 67 : FIND DOMINATING PREMIUM BRANDS
-- Purpose:
-- Identify brands dominating premium segment
-- =========================================

select substring_index(model_name, ' ', 1) as brand_name, count(*) as premium_mobiles
from flipkart_mobile_cleaned
where price > 50000
group by brand_name
order by premium_mobiles desc;

-- =========================================
-- TASK 68 : FIND MOST COMMON PRICE CATEGORY
-- Purpose:
-- Identify which price category contains
-- most smartphones
-- =========================================

select
case
    when price < 15000 then 'Low - Budget'
    when price between 10000 and 30000 then 'Mid-Range'
    else 'Premium'
end as price_category,
count(*) as total_mobiles
from flipkart_mobile_cleaned
group by price_category
order by total_mobiles desc;


-- =========================================
-- TABLE NORMALIZATION
-- =========================================

-- =========================================
-- TASK 69 : CREATE BRANDS TABLE
-- Purpose:
-- Store unique mobile brand names separately
-- =========================================

create table brands
(
    brand_id int auto_increment primary key,
    brand_name varchar(100)
);

-- =========================================
-- TASK 70 : INSERT BRAND DATA
-- Purpose:
-- Extract and store unique brand names
-- =========================================

insert into brands (brand_name)
select distinct
substring_index(model_name, ' ', 1) as brand_name
from flipkart_mobile_cleaned;

-- =========================================
-- TASK 71 : CREATE MOBILE SPECIFICATIONS TABLE
-- Purpose:
-- Store mobile technical specifications separately
-- =========================================



create table mobile_specs
(
	spec_id int auto_increment primary key,
	model_name varchar(255),
	memory_details varchar(255),
	screen_dimension varchar(100),
	battery_capacity varchar(100),
	processor varchar(255),
	lens_details varchar(255)
);

-- =========================================
-- TASK 72 : INSERT MOBILE SPECIFICATIONS DATA
-- Purpose:
-- Insert technical specifications into table
-- =========================================

insert into mobile_specs
(
model_name, memory_details, screen_dimension, battery_capacity, processor, lens_details
)
select
model_name, memory_details, screen_dimension, battery_capacity, processor, lens_details
from flipkart_mobile_cleaned;

-- =========================================
-- TASK 73 : CREATE MOBILE SALES TABLE
-- Purpose:
-- Store pricing and rating information separately
-- =========================================

create table mobile_sales
(
    sale_id int auto_increment primary key,
    model_name varchar(255),
    price int,
    discount varchar(50),
    avg_rating decimal(2,1),
    rating_count int,
    review_count int
);

-- =========================================
-- TASK 74 : INSERT MOBILE SALES DATA
-- Purpose:
-- Insert sales and customer engagement data
-- =========================================

insert into mobile_sales
(
    model_name, price, discount, avg_rating, rating_count, review_count
)
select
model_name, price, discount, avg_rating, rating_count, review_count
from flipkart_mobile_cleaned;

-- =========================================
-- TASK 75 : CREATE WARRANTY TABLE
-- Purpose:
-- Store warranty information separately
-- =========================================

create table warranty_details (
    warranty_id int auto_increment primary key,
    model_name varchar(255),
    warranty text
);

-- =========================================
-- TASK 76 : INSERT WARRANTY DATA
-- Purpose:
-- Insert warranty details into table
-- =========================================

insert into warranty_details
(
    model_name, warranty
)
select
model_name,warranty
from flipkart_mobile_cleaned;

-- =========================================
-- TASK 77 : JOIN SALES WITH SPECIFICATIONS
-- Purpose:
-- Combine sales and technical specification data
-- =========================================

select m.model_name,m.price,m.avg_rating,s.processor,s.battery_capacity
from mobile_sales m
inner join mobile_specs s
on m.model_name = s.model_name;

-- =========================================
-- TASK 78 : JOIN SALES WITH WARRANTY DETAILS
-- Purpose:
-- Combine sales information with warranty data
-- =========================================

select m.model_name, m.price, m.avg_rating, w.warranty
from mobile_sales m
inner join warranty_details w
on m.model_name = w.model_name;

-- =========================================
-- TASK 79 : FIND PREMIUM MOBILES WITH WARRANTY
-- Purpose:
-- Identify premium mobiles having warranty support
-- =========================================

select m.model_name, m.price, w.warranty 
from mobile_sales m
inner join warranty_details w
on m.model_name = w.model_name
where m.price > 50000;

-- =========================================
-- TASK 80 : FIND BEST PROCESSORS USING JOINS
-- Purpose:
-- Analyze processor performance using joins
-- =========================================

select s.processor,
round(avg(m.avg_rating),1) AS average_rating
from mobile_sales m
inner join mobile_specs s
on m.model_name = s.model_name
group by s.processor
order by average_rating desc;

-- =========================================
-- TASK 81 : COMPLETE MOBILE INFORMATION USING MULTIPLE JOINS
-- Purpose:
-- Combine sales, specifications and warranty
-- information into one result
-- =========================================

select m.model_name, m.price, m.avg_rating, m.review_count, s.processor, s.memory_details, s.battery_capacity, w.warranty
from mobile_sales m
inner join mobile_specs s
on m.model_name = s.model_name
inner join warranty_details w
on m.model_name = w.model_name;

-- =========================================
-- BUSINESS INSIGHTS & FINAL CONCLUSION
-- =========================================

-- =========================================
-- TASK 82 : IDENTIFY TOP SELLING BRANDS
-- Purpose:
-- Find brands having highest number of mobiles
-- in the marketplace
-- =========================================

select substring_index(model_name, ' ', 1) as brand_name,
count(*) as total_mobiles
from flipkart_mobile_cleaned
group by brand_name
order by total_mobiles desc;

-- =========================================
-- TASK 83 : IDENTIFY BEST RATED BRANDS
-- Purpose:
-- Find brands with highest customer satisfaction
-- =========================================

select substring_index(model_name, ' ', 1) as brand_name,
round(avg(avg_rating),1) as average_rating
from flipkart_mobile_cleaned
group by brand_name
order by average_rating desc;

-- =========================================
-- TASK 84 : IDENTIFY MOST POPULAR MOBILES
-- Purpose:
-- Find mobiles with highest customer engagement
-- =========================================

select model_name, rating_count, review_count
from flipkart_mobile_cleaned
order by rating_count desc, review_count desc limit 10;

-- =========================================
-- TASK 85 : IDENTIFY BEST VALUE-FOR-MONEY MOBILES
-- Purpose:
-- Find affordable mobiles with high ratings
-- =========================================

select model_name, price, avg_rating
from flipkart_mobile_cleaned
where price < 20000 and avg_rating > 4.3
order by avg_rating desc, price asc;
         
-- =========================================
-- TASK 86 : IDENTIFY PREMIUM MARKET LEADERS
-- Purpose:
-- Find brands dominating premium smartphone market
-- =========================================

select substring_index(model_name, ' ', 1) as brand_name,
count(*) as premium_models
from flipkart_mobile_cleaned
where price > 50000
group by brand_name
order by premium_models desc;

-- =========================================
-- TASK 87 : IDENTIFY MOST TRUSTED PROCESSORS
-- Purpose:
-- Find processors having highest average ratings
-- =========================================

select processor, round(avg(avg_rating),1) as average_rating
from flipkart_mobile_cleaned
group by processor
order by average_rating desc;

-- =========================================
-- TASK 88 : IDENTIFY HIGHLY REVIEWED PREMIUM PHONES
-- Purpose:
-- Find premium smartphones with strong customer engagement
-- =========================================

select model_name, price, review_count
from flipkart_mobile_cleaned
where price > 50000 and review_count > 5000
order by review_count desc;

-- =========================================
-- TASK 89 : IDENTIFY MARKET PRICE DISTRIBUTION
-- Purpose:
-- Analyze how mobiles are distributed
-- across price categories
-- =========================================

select
case
    when price < 15000 then 'Low-Budget'
    when price between 10000 and 30000 then 'Mid-Range'
    else 'Premium'
end as price_category,
count(*) as total_mobiles
from flipkart_mobile_cleaned
group by price_category
order by total_mobiles desc;

-- =========================================
-- TASK 90 : IDENTIFY TOP 5 MOST EXPENSIVE MOBILES
-- Purpose:
-- Find highest priced smartphones
-- =========================================

select model_name, price
from flipkart_mobile_cleaned
order by price desc;

-- =========================================
-- TASK 91 : IDENTIFY TOP 5 HIGHEST RATED MOBILES
-- Purpose:
-- Find mobiles with best customer ratings
-- =========================================

select model_name, avg_rating
from flipkart_mobile_cleaned
order by avg_rating desc
limit 5;

-- =========================================
-- TASK 92 : FINAL DATA VERIFICATION
-- Purpose:
-- Verify cleaned and analyzed dataset
-- before project completion
-- =========================================

select * from flipkart_mobile_cleaned limit  20;
DESC flipkart_mobile_cleaned;

-- =========================================
-- VIEWS & OPTIMIZATION
-- =========================================
-- =========================================
-- TASK 93 : CREATE VIEW FOR PREMIUM MOBILES
-- Purpose:
-- Create reusable virtual table for premium mobiles
-- =========================================

create view premium_mobiles as
select model_name, price, avg_rating 
from mobile_sales
where price > 50000;

-- =========================================
-- TASK 94 : ACCESS VIEW
-- Purpose:
-- Retrieve data from SQL View
-- =========================================

select * from premium_mobiles;

-- =========================================
-- TASK 95 : CREATE INDEX
-- Purpose:
-- Improve query performance on model_name
-- =========================================

create index idx_model_name on mobile_sales(model_name);

-- =========================================
-- TASK 96 : CREATE VIEW FOR HIGHLY RATED MOBILES
-- Purpose:
-- Create reusable view for top-rated mobiles
-- =========================================

create view highly_rated_mobiles as 
select model_name, price, avg_rating
from mobile_sales
where avg_rating > 4.5;

-- =========================================
-- TASK 97 : CREATE VIEW FOR BRAND ANALYSIS
-- Purpose:
-- Create reusable view for brand-wise analysis
-- =========================================

create view brand_analysis as
select substring_index(model_name, ' ', 1) as brand_name,
COUNT(*) as total_mobiles,
avg(price) as average_price,
avg(avg_rating) as average_rating
from flipkart_mobile_cleaned
group by brand_name;

-- =========================================
-- TASK 98 : ACCESS BRAND ANALYSIS VIEW
-- Purpose:
-- Retrieve brand analysis data using view
-- =========================================

select * from brand_analysis;

-- =========================================
-- TASK 99 : CREATE INDEX ON PRICE
-- Purpose:
-- Improve filtering performance on price column
-- =========================================

create index idx_price on mobile_sales(price);

-- =========================================
-- TASK 100 : CREATE INDEX ON AVG RATING
-- Purpose:
-- Improve sorting and filtering on avg_rating
-- =========================================

create index idx_avg_rating on mobile_sales(avg_rating);

-- =========================================
-- TASK 101 : SHOW ALL CREATED VIEWS
-- Purpose:
-- Display all views created in the project
-- =========================================

show full tables where TABLE_TYPE = 'VIEW';

-- =========================================
-- TASK 102 : SHOW ALL INDEXES
-- Purpose:
-- Display all indexes created in the project
-- =========================================

show index from mobile_sales;

-- =========================================
-- TASK 103 : ACCESS HIGHLY RATED MOBILES VIEW
-- Purpose:
-- Retrieve highly rated mobiles using view
-- =========================================

select * from highly_rated_mobiles;

-- =========================================
-- BASIC SQL OPERATORS PRACTICE
-- =========================================

-- =========================================
-- TASK 104 : EQUAL TO OPERATOR (=)
-- =========================================

select *
from flipkart_mobile_cleaned
where price = 15000;

-- =========================================
-- TASK 105 : NOT EQUAL TO OPERATOR (!=)
-- =========================================

select *
from flipkart_mobile_cleaned
where processor != 'Snapdragon';

-- =========================================
-- TASK 106 : GREATER THAN OPERATOR (>)
-- =========================================

select *
from flipkart_mobile_cleaned
where price > 30000;

-- =========================================
-- TASK 107 : LESS THAN OPERATOR (<)
-- =========================================

select *
from flipkart_mobile_cleaned
where avg_rating < 4.0;

-- =========================================
-- TASK 108 : GREATER THAN EQUAL TO (>=)
-- =========================================

select *
from flipkart_mobile_cleaned
where avg_rating >= 4.5;

-- =========================================
-- TASK 109 : LESS THAN EQUAL TO (<=)
-- =========================================

select *
from flipkart_mobile_cleaned
where price <= 10000;

-- =========================================
-- TASK 110: AND OPERATOR
-- =========================================

select *
from flipkart_mobile_cleaned
where price > 20000
and avg_rating > 4.3;

-- =========================================
-- TASK 111 : OR OPERATOR
-- =========================================

select *
from flipkart_mobile_cleaned
where processor like '%Snapdragon%'
or processor like '%MediaTek%';

-- =========================================
-- TASK 112 : NOT OPERATOR
-- =========================================

select * from flipkart_mobile_cleaned where NOT price > 50000;

-- =========================================
-- TASK 113 : BETWEEN OPERATOR
-- =========================================

select * from flipkart_mobile_cleaned where price between 10000 and 30000;

-- =========================================
-- TASK 114 : IN OPERATOR
-- =========================================

select * from flipkart_mobile_cleaned where processor IN ('Snapdragon', 'MediaTek');

-- =========================================
-- TASK 115 : LIKE OPERATOR
-- =========================================

select * from flipkart_mobile_cleaned where model_name like '%Samsung%';

-- =========================================
-- TASK 116 : IS NULL OPERATOR
-- =========================================

select * from flipkart_mobile_cleaned where processor is null;

-- =========================================
-- TASK 117 : IS NOT NULL OPERATOR
-- =========================================

select * from flipkart_mobile_cleaned where battery_capacity is not null;

-- =========================================
-- TASK 118 : ORDER BY ASC
-- =========================================

select * from flipkart_mobile_cleaned order by price asc;

-- =========================================
-- TASK 119 : ORDER BY DESC
-- =========================================

select * from flipkart_mobile_cleaned order by avg_rating desc;

-- =========================================
-- TASK 120 : LIMIT
-- =========================================

select * from flipkart_mobile_cleaned limit 5;

-- =========================================
-- END OF PROJECT
-- Flipkart Mobile Data Cleaning & Analysis Using MySQL
-- =========================================