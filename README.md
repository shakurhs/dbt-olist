# Olist E-commerce Analytics Pipeline

## Project Overview

This project builds a dbt transformation layer on top of the Olist Brazilian E-commerce dataset stored in PostgreSQL. Raw data was accessed from an external PostgreSQL server. The transformation follows a three-tier architecture: staging for cleaning, intermediate for business logic, and mart for reporting outputs.

The project was validated using `dbt compile` due to read-only access to the database. All model dependencies resolve correctly and SQL syntax is verified across all layers.

## Data Architecture

**Staging Layer**
Cleans raw tables, casts data types, handles null values, and standardizes column naming. Materialized as views to keep execution fast and storage minimal.

**Intermediate Layer**
Joins staging tables and calculates derived metrics such as delivery delays, seller revenue, and review aggregations. Prepares data for final aggregation.

**Mart Layer**
Produces business-ready tables for analysis including monthly revenue trends, customer segmentation, and product performance rankings.

## Models

| Layer | Model | Description |
|---|---|---|
| Staging | `stg_customers` | Cleaned customer records |
| Staging | `stg_orders` | Cleaned order records with status standardization |
| Staging | `stg_order_items` | Cleaned order line items |
| Staging | `stg_order_reviews` | Cleaned review scores and comments |
| Staging | `stg_products` | Cleaned product catalog |
| Intermediate | `int_orders_enriched` | Orders joined with customers and delivery metrics |
| Intermediate | `int_sellers_metric` | Seller-level revenue and performance aggregations |
| Mart | `mart_monthly_revenue` | Monthly revenue trends |
| Mart | `mart_customer_segment` | Customer segmentation by purchase behavior |
| Mart | `mart_product_performance` | Product rankings by revenue and review score |

## Execution Commands

```bash
dbt compile        # Validate SQL syntax and dependency graph
dbt run            # Execute all transformations
dbt docs generate  # Build documentation files
dbt docs serve     # View lineage graph in browser
```

## Future Improvements

- **Data Quality Tests** : Add `not_null`, `unique`, and `accepted_values` tests at the staging layer, and custom SQL tests at the intermediate and mart layers
- **Incremental Loading** : Implement incremental materialization using timestamp fields to avoid full table refreshes on every run
- **Orchestration** : Schedule and monitor pipeline runs using Apache Airflow with dbt-cosmos
- **Source Freshness Monitoring** : Use `dbt source freshness` to detect when raw data stops arriving unexpectedly

## Environment

- **Warehouse:** PostgreSQL
- **Transformation:** dbt Core
- **Validation:** `dbt compile` (read-only database access)