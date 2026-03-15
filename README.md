## Enterprise Retail Analytics Data Warehouse
(Snowflake + dbt + CI/CD)

This project demonstrates the design and implementation of a modern analytics data warehouse built with Snowflake and dbt to support business reporting, product analytics, and customer insights.

The solution applies modern analytics engineering practices, including layered data modeling, dimensional modeling, data quality testing, and automated CI/CD pipelines.

The focus of the project is transforming raw transactional e-commerce data into reliable analytical models optimized for reporting and analytical workloads.

Dataset used: Online Retail II (UCI Machine Learning Repository)
~1M e-commerce transactions from a UK-based online retailer.

## 1. Architecture Overview

The solution follows a modern dbt layered architecture:

PNG

Staging Layer
Stores cleaned and standardized source data.

Responsibilities include:
- column normalization
- data type standardization
- basic data validation
- source column renaming

Model: `stg_sales`


Core Analytical Layer
Implements the central analytical model with fact and dimension tables.

Tables:
- `fct_order_lines`
- `fct_orders`
- `dim_customer`
- `dim_product`
- `dim_date`
This layer standardizes business entities and prepares data for analytical use.

Data Mart Layer
Domain-specific analytical datasets for business teams.

Domains:
- finance
- marketing
- product

Tables:
- `mart_revenue_daily`
- `mart_customer_metrics`
- `mart_product_performance`

These datasets are optimized for BI reporting and analytical queries.

## 2. Data Flow

Source dataset contains the following attributes:
- Invoice
- StockCode
- Description
- Quantity
- InvoiceDate
- UnitPrice
- CustomerID
- Country

Pipeline flow:
PNG

The pipeline transforms raw transactional records into structured analytical datasets ready for reporting and analysis.

## 3. Core Analytical Model
The warehouse implements a star schema optimized for analytics workloads.

Fact Table - `fct_order_lines`
Grain: one row per product per invoice

Contains:
- quantity
- unit price
- sales amount
- cancellation indicator

Fact Table - `fct_orders`
Grain: one row per invoice

Contains aggregated order metrics:
- total items
- gross revenue
- cancelled revenue
- net revenue

Dimension Tables:
- `dim_customer`
- `dim_product`
- `dim_date`

These dimensions enable analysis across:
- customers
- products
- time


## 4. Analytical Data Marts
Finance Mart - `mart_revenue_daily`

Daily financial metrics:
- gross revenue
- net revenue
- cancelled revenue

Used for:
- financial reporting
- revenue trend analysis

Marketing Mart - `mart_customer_metrics`

Customer-level metrics:
- number of orders
- total revenue
- first purchase date
- last purchase date

Used for:
- customer analytics
- retention analysis

Product Mart - `mart_product_performance`
Product-level performance metrics:
- units sold
- order counts
- revenue share
- return rate
- cumulative revenue share

Used for:
- product performance analysis
- assortment optimization

## 5. Data Quality Controls
Data quality is implemented using dbt tests.

Controls include:
- null checks
- uniqueness checks
- referential integrity validation
- relationship tests between fact and dimension tables

Example:
- `not_null`
- `unique`
- `relationships`
These controls ensure data consistency and integrity across the analytical model.

## 6. CI/CD Pipeline
The project implements automated CI/CD pipelines using GitHub Actions.

Pipeline definitions:
- `.github/workflows/dbt-ci.yml`
- `.github/workflows/dbt-cd.yml`

Continuous Integration
CI runs on:
- pull requests
- feature branches

Pipeline steps:
- Checkout repository
- Setup Python
- Install dbt-snowflake
- Install dependencies
- Download production manifest
- Run Slim CI build

Slim CI command:
`dbt build --select state:modified+ --defer --state state`

Benefits:
- builds only modified models
- faster validation
- reuses production models where possible

Continuous Deployment
CD runs on:
`push to main branch`

Pipeline steps:
- Checkout repo
- Install dbt
- dbt deps
- dbt debug
- dbt build
The deployment pipeline builds the entire dbt project in the Snowflake production environment.

## 7. Snowflake Infrastructure Setup

The repository includes infrastructure setup scripts.
```
infra/
    init_snowflake.sql
```
The script creates:
- warehouse
- database
- schema
- roles
- user permissions

Example components:
DBT_WH warehouse
ANALYTICS_DB database
DBT_ROLE role
DBT_USER user

This allows the project environment to be reproducible and deployable.

## 8. Repository Structure
```
dbt_snowflake_demo_repo/

├── models
│
│   ├── staging
│   │   └── stg_sales.sql
│
│   └── marts
│       ├── core
│       │   ├── fct_order_lines.sql
│       │   ├── fct_orders.sql
│       │   ├── dim_customer.sql
│       │   ├── dim_product.sql
│       │   └── dim_date.sql
│
│       ├── finance
│       │   └── mart_revenue_daily.sql
│
│       ├── marketing
│       │   └── mart_customer_metrics.sql
│
│       └── product
│           └── mart_product_performance.sql
│
├── macros
├── tests
├── seeds
├── snapshots
│
├── infra
│   └── init_snowflake.sql
│
├── .github/workflows
│   ├── dbt-ci.yml
│   └── dbt-cd.yml
│
└── dbt_project.yml
```

## 9. Technical Scope

Data modeling:
- dimensional modeling
- star schema design
- fact and dimension tables

Transformation framework:
- dbt

Data warehouse:
- Snowflake

Automation:
- GitHub Actions
- CI/CD pipelines
- Slim CI

Languages and tools:
- SQL
- Git
- GitHub

## 10. Use Cases

This project demonstrates capabilities relevant for:
- Data Engineer
- Analytics Engineer
- Data Warehouse Developer
- BI Engineer
- SQL Developer

## 11. Technologies

Snowflake
dbt
SQL
Git
GitHub Actions
CI/CD pipelines
Dimensional data modeling



