# Olist E-commerce Analytics Pipeline

## Project Overview
This project implements a dbt transformation layer for the Olist Brazilian E-commerce dataset. The structure follows a three-tier analytics architecture: staging for standardization, intermediate for business logic, and mart for reporting outputs.

## Data Architecture
- Staging Layer: Cleans raw tables, casts data types, handles null values, and standardizes column naming. Views are used to keep execution fast and storage minimal.
- Intermediate Layer: Joins staging tables, calculates derived metrics (delivery delay, seller revenue, review aggregation), and prepares data for aggregation.
- Mart Layer: Produces business-ready tables for analysis. Includes monthly revenue trends, customer segmentation, and product performance rankings.

## Loading Strategy
Raw data is loaded using incremental append based on timestamp fields. This approach keeps historical records intact and allows daily updates without replacing full tables. 

Schema changes in source files are handled by setting the incremental policy to append_new_columns. The staging layer uses explicit casting and coalesce functions, so new or missing columns will not break downstream models. Full refresh execution is available for backfilling or correcting historical data when required.

## Orchestration Design
The pipeline is designed to run on Apache Airflow using dbt-cosmos. Airflow handles scheduling, dependency resolution, retry logic, and failure alerting. dbt-cosmos converts the dbt project graph into Airflow tasks automatically, which keeps the execution order correct and reduces manual DAG maintenance.

This separation allows data engineering to manage ingestion and monitoring while analytics engineering manages transformation logic inside dbt. An alternative implementation uses the BashOperator to execute dbt CLI commands directly inside Airflow, which is simpler but provides less granular task monitoring.

## Data Quality Framework
Quality checks are implemented at every layer using native dbt tests and custom SQL validations:
- Staging: unique and not_null tests on primary keys. accepted_values checks for order status and review score ranges.
- Intermediate: custom SQL tests verify business rules, such as negative revenue values or delivery delays outside reasonable boundaries (-30 to 30 days).
- Mart: row count thresholds and month-over-month growth anomaly detection to catch aggregation errors.
- Source Freshness: dbt source freshness command monitors if raw data loading stops unexpectedly.

All tests execute automatically after model runs. Failed tests stop the pipeline and trigger alerts before bad data reaches reporting layers.

## Environment Note
This project was validated using dbt compile due to read-only database access in the test environment. All model dependencies resolve correctly and SQL syntax is verified. In a production environment with write access, dbt run would materialize the views and tables as configured in the project.

## Execution Commands
dbt compile          # Validate syntax and dependency graph
dbt run              # Execute transformations
dbt test             # Run data quality checks
dbt docs generate    # Build documentation files
dbt docs serve       # View lineage and model details in browser