                                      -- Created Database
create database sales_eda;
                                    -- Created copy of raw table
create table sales_eda
(select * from sales_eda_raw);
									  -- Removed duplicates
with cte as
(select *,row_number() over(partition by transaction_id order by transaction_id) as rn
from sales_eda)

select *
from cte 
where rn=1;   -- filtered unique rows

create table sales_eda1   -- created a table with unique values from sales_eda table
(with cte as
(select *,row_number() over(partition by transaction_id order by transaction_id) as rn
from sales_eda)

select *
from cte 
where rn=1);

alter table sales_eda1 -- dropped row rn
drop column rn;

truncate sales_eda; -- truncated table sales_eda

insert into sales_eda  -- inserted unique rows to sales_eda table
(select * from sales_eda1);

drop table sales_eda1; -- dropped table sales_eda1

							      -- Handling Blanks and NULL values
-- transaction_id
update sales_eda
set transaction_id = null
where transaction_id='';

-- customer_id
update sales_eda
set customer_id = NULL
where customer_id ='';

select a.customer_id,a.customer_name,b.customer_id,b.customer_name
from sales_eda as a
 join sales_eda as b                    
  on a.customer_name = b.customer_name
  and a.transaction_id <> b.transaction_id
   where a.customer_id is null;

update sales_eda as a
 join sales_eda as b                    
  on a.customer_name = b.customer_name
  and a.transaction_id <> b.transaction_id
set a.customer_id = b.customer_id
where a.customer_id is null;

-- customer_name
update sales_eda
set customer_name = NULL
where customer_name ='';

update sales_eda
set customer_name = 'Mahika Saini'
where customer_id = 'CUST1003';

-- customer_age
update sales_eda
set customer_age = NULL
where customer_age ='';

update sales_eda
set customer_age = '35'  
where customer_name = 'Mahika Saini';

-- gender
update sales_eda
set gender = NULL
where gender ='';

update sales_eda
set gender = 'Male'  
where customer_name = 'Mahika Saini';

select distinct gender,
case when gender = 'F' then 'Female' 
     when gender = 'M' then 'Male' else gender end as x
from sales_eda;

update sales_eda
set gender = case when gender = 'F' then 'Female' 
     when gender = 'M' then 'Male' else gender end;
    
-- payment_mode
update sales_eda
set payment_mode = NULL
where payment_mode ='';

update sales_eda
set payment_mode = 'Credit Card'
where payment_mode ='CC';  
    
-- purchase_date
update sales_eda
set purchase_date = NULL
where purchase_date ='';

                                    -- Modified inconsistent date format
select purchase_date,
case when purchase_date regexp '^[0-9]{1,2}/[0-9]{1,2}/[0-9]{4}$' 
      then date_format(str_to_date(purchase_date, '%d/%m/%Y'), '%Y/%m/%d') end as x
from sales_eda;

update sales_eda
set purchase_date = case when purchase_date regexp '^[0-9]{1,2}/[0-9]{1,2}/[0-9]{4}$' 
      then date_format(str_to_date(purchase_date, '%d/%m/%Y'), '%Y/%m/%d') else purchase_date end;

                                     -- Deleted unnecessary rows
delete 
from sales_eda
where transaction_id is null and customer_id is null;
      
                                        -- Renamed columns
alter table sales_eda
rename column quantiy to quantity;

alter table sales_eda
rename column prce to price;
                                         -- Changed data type
alter table sales_eda
modify transaction_id varchar(100), 
modify customer_id varchar(100), 
modify customer_name varchar(100), 
modify customer_age int ,
modify gender varchar(100) ,
modify product_id varchar(100) ,
modify product_name varchar(100) ,
modify product_category varchar(100) ,
modify quantity int ,
modify price decimal(10,2) ,
modify payment_mode varchar(100) ,
modify purchase_date date ,
modify time_of_purchase time ,
modify status varchar(100);

									-- Exploratory Data Analysis
								-- What are the top 5 most selling products by quantity?     
with cte as
   (select product_name,sum(quantity) as total_quantity,
    dense_rank() over(order by sum(quantity) desc) as rnk
   from sales_eda
   where status = 'Delivered'
   group by product_name)
               
select product_name,total_quantity
from cte
where rnk<=5;		

                                   -- Which products are most frequently cancelled?
select product_name,count(*) as total_cancellations
from sales_eda
where status = 'Cancelled'
group by product_name
order by total_cancellations desc
limit 5;	

                       -- What time of the day has the highest number of purchases?
   select 
   case when time_format(time_of_purchase,'%H') between '06' and '11' then 'Morning'
        when time_format(time_of_purchase,'%H') between '12' and '17' then 'Afternoon'
        when time_format(time_of_purchase,'%H') between '18' and '23' then 'Evening'
        else 'Night' end as Time_of_day
   ,count(*) as total_purchases
   from sales_eda
   group by Time_of_day
   order by total_purchases desc;

                                -- Who are the top 5 highest spending customers?
with cte as
(select customer_name,concat('$',format(sum(price*quantity),0)) as total_spending,
dense_rank() over(order by sum(price*quantity) desc) as rnk
from sales_eda
group by customer_name)

select customer_name,total_spending
from cte
where rnk<=5;

                                -- Which product category generates highest revenue?
select product_category,concat('$',format(sum(price*quantity),0)) as total_revenue
from sales_eda
where status = 'Delivered'
group by product_category
order by total_revenue desc;

							-- What is the cancellation rate & return rate per product category?
-- cancellation rate
select product_category,
concat(round(100*(count(case when status='cancelled' then 1 end)/
count(*)),2),'%') as cancellation_rate
from sales_eda
group by product_category
order by 2 desc;

-- return rate
select product_category,
concat(round(100*(count(case when status='returned' then 1 end)/
count(*)),2),'%') as return_rate
from sales_eda
group by product_category
order by 2 desc;

								-- What is the most preferred payment mode?
select payment_mode,count(*) as total_payments
from sales_eda
group by payment_mode
order by total_payments desc;

                             -- How does age group affect purchasing behaviour?
select 
case when customer_age between 10 and 20 then '18 - 20'
     when customer_age between 21 and 30 then '21 - 30'
     when customer_age between 31 and 40 then '31 - 40'
     when customer_age between 41 and 50 then '41 - 50'
     else '51 - 60' end as age_group,
     count(*) as total_purchases,
     concat('$',format(sum(price*quantity),0)) as total_revenue
from sales_eda
group by age_group
order by total_purchases desc;

                                    -- What's the monthly sales trend?
select date_format(purchase_date,'%Y/%m') as `year_month`,
  concat('$',format(sum(price*quantity),0)) as total_sales
from sales_eda
group by `year_month`
order by `year_month`;

                          -- Are certain genders buying more specific product categories?
-- method 1 (Ranking most purchases by gender)
select gender,product_category,count(*) as total_purchases,
dense_rank() over(partition by gender order by count(*) desc) as ranking
from sales_eda
group by gender,product_category;

-- method 2 (Categorized view)
with cte as
(select gender,product_category,count(*) as total_purchases
from sales_eda
group by gender,product_category)

select product_category,
sum(case when gender = 'Male' then total_purchases end) as Male,
sum(case when gender = 'Female' then total_purchases end) as Female
from cte
group by product_category
order by product_category;