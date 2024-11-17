# Supplychain_Analytics
This project analyzes sales data to uncover trends, measure performance, and identify areas for improvement. It leverages SQL queries to compute metrics such as total sales, profit margins, order counts, and more.


## Dataset

The dataset used in this project is publicly available on Kaggle.

You can find the dataset [here](https://www.kaggle.com/datasets/dorothyjoel/us-regional-sales).

## Database Schema

The dataset used in this project has the following table structure:  

| **Column Name**     | **Data Type**  |
|----------------------|----------------|
| `OrderNumber`        | `varchar(20)`  |
| `Sales_Channel`      | `varchar(20)`  |
| `WarehouseCode`      | `varchar(20)`  |
| `ProcuredDate`       | `date`         |
| `OrderDate`          | `date`         |
| `ShipDate`           | `date`         |
| `DeliveryDate`       | `date`         |
| `CurrencyCode`       | `varchar(10)`  |
| `_SalesTeamID`       | `text`         |
| `_CustomerID`        | `text`         |
| `_StoreID`           | `text`         |
| `_ProductID`         | `text`         |
| `Order_Quantity`     | `int`          |
| `Discount_Applied`   | `double`       |
| `Unit_Cost`          | `double`       |
| `Unit_Price`         | `double`       |


## Key Features
#### 1. Comprehensive Sales Insights 
- Calculates total sales, sales by channel, warehouse, and time periods to uncover performance trends.  

#### 2. Profitability and Revenue Analysis
- Evaluates profit margins for products, ranks items by profitability, and identifies revenue-driving customers.  

#### 3. Operational Efficiency Metrics  
- Analyzes order processing, shipping times, and gaps in fulfillment to assess operational performance.

#### 4. Advanced Query Techniques
- Utilizes window functions (`RANK`, `LEAD`) and dynamic partitioning for in-depth ranking and comparative analysis.

#### 5. Impact of Discounts and Team Contributions
- Assesses how discounts affect total sales and order volume, and calculates each sales team's percentage contribution to the company’s overall revenue.

#### 6. Summary Reporting
- Creates a detailed monthly summary table with metrics like revenue after discounts, total orders, average discount, and profit margin.
