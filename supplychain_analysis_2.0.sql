create database supplychain_db;

create table sales_data (
	OrderNumber varchar(20),
    Sales_Channel varchar(20),
    WarehouseCode varchar(20),
    ProcuredDate date,
    OrderDate date,
    ShipDate date,
    DeliveryDate date,
    CurrencyCode varchar(10),
    _SalesTeamID text,
    _CustomerID	text,
    _StoreID text,
    _ProductID text,
    Order_Quantity int,
    Discount_Applied double,
    Unit_Cost double,
    Unit_Price double
);

select * from sales_data;

-- Analzing the Sales by Sales Channel

-- 1. Calculate total sales
select sum(Unit_Price * Order_Quantity) as Total_Sales from sales_data;

-- 2. total sales by sales channel
select Sales_Channel, round(sum(Unit_Price * Order_Quantity),2) as total_sales 
from sales_data
group by 1
order by round(sum(Unit_Price * Order_Quantity),2) desc;


-- Analyzing the Performance of Different Warehouses

-- 3. total sales by warehouse
select WarehouseCode, round(sum(Unit_Price * Order_Quantity),2) as total_sales 
from sales_data
group by 1
order by round(sum(Unit_Price * Order_Quantity),2) desc;
-- end

-- 4. What are the total sales and order counts by year or quarter?
select quarter(orderdate), year(orderdate), round(sum(Unit_Price * Order_Quantity),2) as total_sales, count(OrderNumber) as order_count
from sales_data
group by 1, 2;

-- 5. What are the top-performing products in terms of revenue and order volume?
select _ProductID, round(sum(Unit_Price * Order_Quantity),2) as revenue, count(OrderNumber) as order_count
from sales_data
group by 1
order by 2,3 desc
limit 5;

-- 6. Which customers contribute the most to the company's revenue?
select _CustomerID, round(sum(Unit_Price * Order_Quantity),2) as revenue_generated
from sales_data
group by 1
order by 2 desc
limit 10;

-- 7. What is the average time between order date, ship date, and delivery date? Are there any delays?
select avg(datediff(shipdate,OrderDate)) as AvgProcessingTime , avg(datediff(deliverydate,shipdate)) as AvgShippingTime
from sales_data;

-- 8. How does the applied discount impact total sales and order volume?
select Discount_Applied, round(sum(Unit_Price * Order_Quantity),2) as revenue, count(OrderNumber) as order_count
from sales_data
group by 1
order by 1;

-- 9. What is the profit margin across different products, and how do product costs impact overall profitability?
select _ProductID, round(sum((Unit_Price - Unit_Cost) * Order_Quantity),2) as TotalProfit, round(avg(Unit_Cost),2) as avgcost
from sales_data
group by 1
order by 2 desc;

-- Intermediate to Advanced queries

-- 10. Find the top 3 selling products by revenue in each warehouse
with ranked_Sales as (
select WarehouseCode,_ProductID, round(sum(Unit_Price * Order_Quantity),2) as revenue,
dense_rank() over(partition by WarehouseCode order by round(sum(Unit_Price * Order_Quantity),2) desc) as revenue_rank
from sales_data
group by 1, 2
)
select * from ranked_Sales
where revenue_rank <=3;


-- 11. Rank customers based on total revenue, allowing customers with the same revenue to share the same rank.
select _CustomerID, round(sum(Unit_Price * Order_Quantity),2) as revenue, dense_rank() over(order by round(sum(Unit_Price * Order_Quantity),2) desc) as customer_rank
from sales_data
group by 1;

-- 12. Calculate the profit margin for each product and rank them based on profitability.
select *, rank() over(order by Profit desc) as profit_rank
from (select _ProductID, round(sum((Unit_Price - Unit_Cost) * Order_Quantity),2) as Profit
from sales_data
group by 1) as profit_table;

-- for profit margin

select _ProductID,Profit,ProfitMargin , rank() over(order by ProfitMargin desc) as profit_margin_rank
from (select _ProductID, 
	round(sum((Unit_Price - Unit_Cost) * Order_Quantity),2) as Profit,
    ROUND(SUM(Unit_Price * Order_Quantity), 2) AS Revenue,
	ROUND((SUM((Unit_Price - Unit_Cost) * Order_Quantity) / SUM(Unit_Price * Order_Quantity)) * 100, 2) AS ProfitMargin
from sales_data
group by 1) as profit_table;


-- 13. Calculate the time taken between OrderDate and ShipDate for each order 
-- and find the next ship date to calculate gaps in fulfillment times.

select WarehouseCode from sales_data;

select OrderNumber, 
	orderdate, 
    shipDate, 
   -- datediff(shipDate, orderdate) as processing_time_in_days,
    LEAD(ShipDate) OVER (ORDER BY ShipDate) AS NextShipDate,
    DATEDIFF(LEAD(ShipDate) OVER (ORDER BY ShipDate), ShipDate) AS TimeToNextOrder
from sales_data
where WarehouseCode = 'WARE-XYS1001';

/*If the time gap between shipments is consistently short (0-2 days), 
it indicates that the warehouse is frequently processing and shipping orders, suggesting high operational efficiency. 
Larger gaps, like the 4-day gap for SO-000169, might indicate a slow-down or a break in processing.*/

-- 14. Create Summary Table of Sales by Month (CTAS) -- we can create it as a view
select 
	year(orderdate) as Year,
    month(orderdate) as Month,
    ROUND(SUM((Unit_Price - Discount_Applied * Unit_Price)* Order_Quantity), 2) AS Revenue_afterdiscount,
    ROUND(SUM(Unit_Cost * Order_Quantity), 2) AS Total_cost,
    COUNT(OrderNumber) AS TotalOrders, 
    round(AVG(Discount_Applied),2) AS AvgDiscount,
    round(sum((Unit_Price - Discount_Applied * Unit_Price) * Order_Quantity),2) as Profit,
    ROUND((SUM(((Unit_Price - Discount_Applied * Unit_Price) - Unit_Cost) * Order_Quantity) / SUM((Unit_Price - Discount_Applied * Unit_Price) * Order_Quantity)) * 100, 2) AS ProfitMargin
from sales_data
group by 1,2;

-- 15. Calculate the percentage contribution of each sales team's revenue to total sales. (Window Function for Percent Contribution)
select _SalesTeamID, 
	round(SUM(Unit_Price * Order_Quantity),2) AS TeamRevenue,
	round((SUM(Unit_Price * Order_Quantity) / sum(SUM(Unit_Price * Order_Quantity))  over()) * 100,2) AS PercentContribution
from sales_data
group by 1
order by 3 desc;







