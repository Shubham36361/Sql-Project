use orders;

SELECT * FROM orders.orders;
select   product_id,sum(sale_price) as sales from orders group by product_id order by sales desc;
select  distinct region from orders
 with cte as( select region, product_id , sum(sale_price)as sales 
 from orders group by region,product_id) select*, row_number() over
 (partition by region order by sales desc) as rn from cte;
 with cte as( select region, product_id , sum(sale_price)as sales
 from orders grous group by region,product_id) select * from(  select*, row_number()
 over
 (partition by region order by sales desc) as rn from cte) A where rn <=5;
select year (order_date ) from orders;
select year (order_date) as order_year  , month(order_date)
as order_month,sum(sale_price) as sales from orders group by year(order_date) ,
 month(order_date)
 order by year(order_date),month (order_date);
with cte as(
select year (order_date) as order_year  , month(order_date)
as order_month,sum(sale_price) as sales from orders group by year(order_date) ,
 month(order_date)
 order by year(order_date) ,month(order_date)
)
select order_month,order_year
,case when order_year=2022 then sales else 0 end as sales_2022
,case when order_year = 2023 then sales else 0 end as sales_2023
from cte 
order by order_month
with cte as(
 select category,  format (order_date,"yyyyMM") as order_year_month,sum(sale_price)
 as sales from orders group by category, format(order_date,"yyyyMM")
 order by category, format(order_date,"yyyyMM")
 )
select * from(
 select*,
 row_number() over(partition by category order by sales desc) as rn from cte
 ) a
 where rn=1
with cte as (
select sub_category,year(order_date) as order_year,
sum(sale_price) as sales
from orders
group by sub_category,year(order_date)
)
,cte2 as (
select sub_category
,sum(case when order_year=2022 then sales else 0 end) as sales_2022
,sum(case when order_year=2023 then sales else 0 end) as sales_2023
from cte 
group  by sub_category
)
select*
,(sales_2023+sales_2022)+100/sales_2022
from cte2
order by (sales_2023=sales_2022)+100/sales_2022 desc;
sal