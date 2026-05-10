select * from customers limit 10;

-- Buisness Analysis question

--Q1. What is Total revenue generated male vs female customer?
select gender, sum(purchase_amount) as revenue 
from customers
group by gender;

--Q2. Which customers used a discount but still spent more than the average purchase amount? 
select customer_id, purchase_amount
from customers
where discount_applied = 'Yes' and purchase_amount >= (select avg(purchase_amount) from customers);

--Q3. Which are the top 5 products with the highest average review rating?
select item_purchased, round(avg(review_rating::numeric),2) as higest_average_review_rating
from customers
group by item_purchased
order by higest_average_review_rating desc
limit 5;

--Q4. Compare the average Purchase Amounts between Standard and Express Shipping. 
select shipping_type, avg(purchase_amount) as avg_purchase_amount
from customers
where shipping_type in ('Standard','Express')
group by shipping_type;

--Q5. Do subscribed customers spend more? Compare average spend and total revenue 
--between subscribers and non-subscribers.
select subscription_status, 
       round(avg(purchase_amount::numeric),2) as average_spend,
	   round(sum(purchase_amount::numeric),2) as revenue
from customers
group by subscription_status
order by average_spend desc;

--Q6. Which 5 products have the highest percentage of purchases with discounts applied?
select item_purchased,
       round(100.0 * sum(case when discount_applied = 'Yes' then 1 else 0 end)/count(*),2) as purchase_percent
from customers
group by item_purchased
order by purchase_percent desc
limit 5;

--Q7. Segment customers into New, Returning, and Loyal based on their total 
-- number of previous purchases, and show the count of each segment. 
with customer_type as (
select customer_id,previous_purchases,
case 
    when previous_purchases = 1 then 'New'
	when previous_purchases between 2 and 10 then 'Returning'
	else 'Loyal'
	end as customer_segment
from customers
)

select customer_segment, count(*) as total_customer
from customer_type
group by customer_segment;

--Q8. What are the top 3 most purchased products within each category? 
with item_count as (
select category, item_purchased,
count(customer_id) as total_order,
row_number() over(partition by category order by count(customer_id) desc) as item_rank
from customers
group by category, item_purchased
)

select item_rank, category, item_purchased , total_order
from item_count
where item_rank <=3;

--Q9. Are customers who are repeat buyers (more than 5 previous purchases) also likely to subscribe?
select subscription_status, 
	   count(customer_id) as total_customer
from customers
where previous_purchases >= 5
group by subscription_status;

-- Ans = NO

--Q10. What is the revenue contribution of each age group? 
select age_group, sum(purchase_amount) as total_revenue
from customers
group by age_group
order by total_revenue desc;

