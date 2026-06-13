# Enterprise Retail Analytics Data Warehouse

**Snowflake + dbt + GitHub Actions (CI/CD)**

## 1. Business Scenario

A UK-based online retailer generates transactional sales data from its e-commerce platform.

The raw data contains:

* cancellations and returns
* duplicate order lines
* inconsistent structures
* limited analytical usability

Business teams require trusted datasets to support:

* revenue reporting
* customer analytics
* product performance analysis
* operational decision-making

The objective is to transform raw transactional data into a structured analytics warehouse using Snowflake and dbt, providing reliable datasets for reporting and business intelligence.

Dataset used:

**Online Retail II (UCI Machine Learning Repository)**

~1M e-commerce transactions from a UK-based online retailer.

---

## 2. Architecture Overview

The solution follows a modern dbt layered architecture.

### Staging Layer

Stores cleaned and standardized source data.

Responsibilities include:

* column normalization
* data type standardization
* basic data validation
* source column renaming

Model:

* `stg_sales`

### Core Analytical Layer

Implements the central analytical model using fact and dimension tables.

Tables:

* `fct_order_lines`
* `fct_orders`
* `dim_customer`
* `dim_product`
* `dim_date`

This layer standardizes business entities and prepares data for analytical use.

### Data Mart Layer

Domain-specific analytical datasets for business teams.

Domains:

* finance
* marketing
* product

Tables:

* `mart_revenue_daily`
* `mart_customer_metrics`
* `mart_product_performance`

These datasets are optimized for BI reporting and analytical queries.

---

## 3. Data Flow

Source dataset contains:

* Invoice
* StockCode
* Description
* Quantity
* InvoiceDate
* UnitPrice
* CustomerID
* Country

Pipeline Flow:

Raw Sales Data

↓

Staging Layer (`stg_sales`)

↓

Core Models (`facts + dimensions`)

↓

Business Data Marts

↓

BI Reporting / Analytics

The pipeline transforms raw transactional records into structured analytical datasets ready for reporting and business analysis.

---

## 4. Star Schema & Core Models

The warehouse implements a dimensional star schema designed for analytical reporting and BI workloads.

Fact tables store business events and measures.

Dimension tables provide business context used for filtering, grouping, and aggregation.

### Fact Table — `fct_order_lines`

**Grain:** One row per product per invoice.

Contains:

* quantity
* unit price
* sales amount
* cancellation indicator

### Fact Table — `fct_orders`

**Grain:** One row per invoice.

Contains:

* total items
* gross revenue
* cancelled revenue
* net revenue

### Dimension Tables

* `dim_customer`
* `dim_product`
* `dim_date`

These dimensions support analysis across:

* customers
* products
* time

---

## 5. Analytical Data Marts

### Finance Mart — `mart_revenue_daily`

Daily financial metrics:

* gross revenue
* net revenue
* cancelled revenue

Used for:

* financial reporting
* revenue trend analysis

### Marketing Mart — `mart_customer_metrics`

Customer-level metrics:

* number of orders
* total revenue
* first purchase date
* last purchase date

Used for:

* customer analytics
* customer value analysis
* retention analysis

### Product Mart — `mart_product_performance`

Product-level performance metrics:

* units sold
* order counts
* revenue share
* return rate
* cumulative revenue share

Used for:

* product performance analysis
* assortment optimization

---

## 6. Data Quality Controls

Data quality is implemented using dbt tests.

Controls include:

* not null validation
* uniqueness validation
* referential integrity validation
* relationship testing between fact and dimension tables

Examples:

* `not_null`
* `unique`
* `relationships`

These controls ensure consistency and integrity across the analytical model.

---

## 7. CI/CD Automation

The project uses GitHub Actions to automate validation and deployment workflows.

Pipeline definitions:

* `.github/workflows/dbt-ci.yml`
* `.github/workflows/dbt-cd.yml`

### Continuous Integration (CI)

CI validates project changes before deployment.

Typical validation steps:

* checkout repository
* setup Python
* install dbt-snowflake
* install dependencies
* dbt parsing and validation
* dbt test execution

### Continuous Deployment (CD)

CD runs automatically on push to the main branch.

Pipeline steps:

* checkout repository
* install dbt
* dbt deps
* dbt debug
* dbt build

This process automatically deploys the latest analytical models into Snowflake.

---

## 8. Snowflake Infrastructure Setup

The repository includes infrastructure setup scripts.

```text
infra/
└── init_snowflake.sql
```

The script creates:

* warehouse
* database
* schema
* roles
* permissions

Example components:

* `DBT_WH`
* `ANALYTICS`
* `RAW`
* `MART`

This makes the environment reproducible and easy to deploy.

---

## 9. Repository Structure

```text
retail-analytics-warehouse/

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
├── infra
├── .github/workflows
├── dbt_project.yml
└── README.md
```

---

## 10. Business Questions Answered

The analytical model supports answering questions such as:

* How does revenue change over time?
* Which products generate the highest revenue?
* Which customers contribute the most revenue?
* What percentage of sales is returned or cancelled?
* Which products have the highest return rates?
* How many active customers purchase each month?
* How does customer purchasing behavior evolve over time?

---

## 11. Technical Scope

### Data Modeling

* dimensional modeling
* star schema design
* fact and dimension tables

### Data Transformation

* dbt

### Data Warehouse

* Snowflake

### Automation

* GitHub Actions
* CI/CD pipelines

### Development Tools

* SQL
* Git
* GitHub

---

## 12. Technologies

* Snowflake
* dbt
* SQL
* Git
* GitHub Actions
* CI/CD
* Dimensional Modeling

---

## 13. Use Cases

This project demonstrates capabilities relevant for:

* Analytics Engineer
* Data Engineer
* Data Warehouse Developer
* BI Engineer
* SQL Developer

---

## 14. Project Outcomes

The solution delivers:

* standardized analytical datasets
* dimensional models optimized for reporting
* automated testing and deployment workflows
* reusable business-focused data marts

The project demonstrates practical Analytics Engineering workflows using Snowflake, dbt, SQL, Git, and GitHub Actions.
