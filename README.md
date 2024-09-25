# NYC-Taxi-Analysis

## Introduction

The New York City taxi industry is a vital component of the city's transportation network, serving millions of passengers annually. However, it faces specific challenges that directly impact its operations and profitability:

1. Fluctuating Demand Patterns: Passenger demand varies significantly based on the borough, day of the week, and whether it's a weekend or weekday. This fluctuation makes it challenging to optimize taxi availability and meet customer needs efficiently.
2. Shifts in Payment Preferences: There's an increasing shift towards cashless transactions, yet a substantial number of passengers continue to use cash. Understanding payment behavior is crucial for encouraging the use of credit cards, which can improve transaction efficiency and safety.

To address these issues, this project utilized **Azure Synapse Analytics** for data processing and **ELT pipeline automation**, alongside **Power BI** for visualization. This approach enabled us to analyze and optimize credit card payment campaigns, identify taxi demand patterns, and automate data preparation processes, thereby providing actionable insights for improving operations and profitability.

## Business Requirements

To tackle the identified problems, our project focuses on:

**1. Encouraging Credit Card Payments:**

   * Analyze current payment methods to establish a baseline ratio of cash to credit card transactions.
   * Examine payment behaviors during different days of the week and across boroughs to target campaigns effectively.

**2. Identifying Taxi Demand Patterns:**

   * Assess demand based on boroughs, days of the week/weekend, and trip types (street hail vs. dispatch).
   * Analyze trip distance, duration, and fare amounts to optimize pricing and routing strategies.

**3. Data Accessibility and Analysis:**

   *  Automate data preparation and ingestion processes.
   *  Store transformed data efficiently to enable quick querying and analysis using SQL.
   *  Integrate with Power BI for dynamic visualization of results.

**4. Non-Functional Requirements:**

   *  Partition data by month and year to enhance query performance and manageability.
   *  Implement robust scheduling and monitoring of data pipelines.

## Process Overview

To meet these requirements, we utilized **Azure Synapse Analytics** for data processing and **Power BI** for visualization. The following outlines the steps taken in the project:

![](https://github.com/KunLinTsai24/NYC-Taxi-Analysis/blob/main/img/nyc_taxi_architecture_solution.png)

---
### Data Sources

  **Fact Table:** 
  * trip_data (CSV files in a hierarchical folder structure)

**Dimension Tables:**

   * taxi_zone (CSV)
   * calendar (CSV)
   * trip_type (TSV)
   * rate_code (JSON)
   * payment_type (JSON)
   * vendor (CSV)
---
### Data Exploration and Schema Application

**1. Querying CSV and TSV Files:**

Employed OPENROWSET to read CSV and TSV files, specifying data types explicitly for taxi_zone.csv, calendar.csv, vendor.csv, and trip_type.tsv.

**2. Querying JSON Files:**

Used OPENROWSET and OPENJSON to parse payment_type.json (a single-line JSON containing an array) and rate_code.json (standard JSON format).

**3. Querying Partitioned Data:**

Leveraged OPENROWSET with wildcards and metadata functions like filename() and filepath() to read partitioned CSV, Parquet, and Delta Lake files.

**4. Data Quality Check:**

 * Identified duplicates using GROUP BY on primary keys.
 * Detected missing values by comparing COUNT(*) with COUNT(column_name).
---
### Data Ingestion and Transformation

**1. Bronze Layer (Raw Data Exposure):**
*  Created external data sources and file formats.
*  Established external tables for CSV files (bronze.taxi_zone, bronze.calendar, bronze.vendor, bronze.trip_type).
*  Built views using OPENROWSET for JSON files (bronze.rate_code, bronze.payment_type).
*  Implemented partition pruning strategies for efficient querying of bronze.trip_data.

**2. Silver Layer (Structured and Cleaned Data)**:

*  Utilized CREATE EXTERNAL TABLE AS SELECT (CETAS) to transform and store data as Parquet files.
*  Transformed bronze tables and views into silver tables (silver.taxi_zone, silver.calendar, silver.vendor, silver.trip_type, silver.rate_code, silver.payment_type).
*  Employed stored procedures to partition data by year and month, saving it to corresponding storage locations.
*  Created views with partition pruning for silver.trip_data to optimize query performance.

**3. Gold Layer (Aggregated Business Metrics)**:

*  Joined key information required for reporting and analysis to create comprehensive tables.
*  Stored transformed data in Parquet format to facilitate efficient SQL querying.
*  Applied CETAS and stored procedures to aggregate business metrics by year and month.
*  Developed views with partition pruning (gold.trip_data) for enhanced performance.
---
### Scheduling and Automation with Synapse Pipelines

**1. Pipeline Configuration**:
  * Defined parameters (e.g., file paths) and variables to manage pipeline execution dynamically.
    
**2. Raw to Bronze Transformation**:
  * Implemented ForEach activities looping through stored procedures to create bronze tables and views.

**3. Bronze to Silver Transformation**:

  * Set up ForEach activities looping through file paths and stored procedures.
  * Included Delete activities to clear existing files in target folders before data ingestion.
  * Executed stored procedures to perform CETAS operations with bronze tables and views, creating silver tables.

**4. Silver to Gold Transformation**:

  * Scripted activities to retrieve distinct years and months for partitioning.
  * Employed ForEach activities to loop through these time periods, performing deletions and executing stored procedures to generate gold-level data and views.

**5. Scheduling and Monitoring**:

  * Added triggers to schedule pipeline executions monthly.

![](https://github.com/KunLinTsai24/NYC-Taxi-Analysis/blob/main/img/pipeline.png)
---
### Power BI Reporting and Visualization

**Credit Card Campaign Analysis**:

* **Payment Type by Day of Week**:
  * Created line charts showing that the gap between card and cash payments decreases on Fridays, Saturdays, and Sundays.
  * Recommendation: Focus credit card promotion campaigns on weekends to capitalize on higher cash payment usage.

* **Payment Type by Borough**:
  * Developed bar charts indicating that Queens and Bronx have closer counts between cash and card payments.
  * Recommendation: Target these boroughs for promotional efforts to encourage credit card usage.

* **Payment Type by Month**:

  * Generated line charts showing a stable trend where card payments are approximately 10,000 trips higher than cash payments monthly.
  * Insight: While the overall trend is stable, there is potential to increase card payments further.

![](https://github.com/KunLinTsai24/NYC-Taxi-Analysis/blob/main/img/campaign.png)

**Taxi Demand Analysis**:

* **Demand by Day of Week**:

  * Used bar charts to reveal that Fridays experience the highest demand.
  * Action: Allocate more taxis and drivers on Fridays to meet increased demand.

* **Demand by Borough**:

  * Illustrated that Manhattan has the highest demand using bar charts.
  * Strategy: Optimize taxi availability in Manhattan to maximize revenue opportunities.

* **Trip Type by Month**:

  * Presented line charts showing that street hail trips consistently surpass dispatch trips by about 50,000 each month.
  * Consideration: Enhance street hail services while exploring opportunities to grow dispatch services.
    
![](https://github.com/KunLinTsai24/NYC-Taxi-Analysis/blob/main/img/demand.png)
---
### Conclusion

By harnessing the capabilities of Azure Synapse Analytics and Power BI, we have automated the data preparation process and enabled comprehensive analysis of the NYC taxi dataset. This approach has provided valuable insights into payment behaviors and demand patterns, informing strategic decisions to address industry challenges.

**Key findings include:**

  * **Payment Behavior**: Targeted campaigns during weekends and in specific boroughs can encourage credit card usage, improving transaction efficiency and security.
  * **Demand Patterns**: Understanding peak demand times and locations allows for better resource allocation, enhancing customer satisfaction and revenue.

**Next Steps**

  **Implement Marketing Campaigns**:

  * Launch targeted promotions to encourage credit card payments during weekends and in Queens and Bronx.

  **Optimize Operations**:

  * Adjust driver schedules and taxi availability to align with demand patterns identified in the analysis.
---
### Learning Outcome

Throughout this project, I gained significant insights and skills in:

  * **Data Automation and Pipeline Development**: Mastered building dynamic and efficient data pipelines in Azure Synapse Analytics using parameters, variables, stored procedures, and CETAS, which streamlined data preparation and ensured robust, reliable workflows.
  * **Data Transformation and Management**: Developed proficiency in handling diverse data formats (CSV, TSV, JSON, Parquet), applied schemas effectively, addressed data quality challenges, and implemented best practices in data modeling, partitioning, and indexing to optimize query performance.
  * **Data Visualization with Power BI**: Enhanced my ability to create insightful visualizations and dashboards, connected Power BI seamlessly to Azure Synapse Analytics, and optimized data models and refresh schedules for better performance and user engagement.
