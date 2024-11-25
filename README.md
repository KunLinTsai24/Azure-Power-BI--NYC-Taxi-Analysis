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
### ETL pipeline Construction
The ETL pipeline transforms raw data into meaningful insights through a structured process. Initially, raw data is explored using SQL commands like OPENROWSET to query CSV, TSV, JSON, and partitioned files while performing data quality checks for duplicates and missing values. In the Bronze Layer, external tables and views are created to expose raw data efficiently. The Silver Layer involves cleaning and structuring data by transforming it into Parquet files using CETAS, partitioning by time, and creating optimized views. Finally, the Gold Layer aggregates business metrics through stored procedures and dynamic views, consolidating data for analysis. Automation is achieved using Synapse pipelines with parameterized activities to process data in stages (Raw to Bronze, Bronze to Silver, Silver to Gold) and scheduled triggers to ensure timely execution and monitoring.

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
  * Recommendation: Focus on credit card promotion campaigns to increase card payments further.

![](https://github.com/KunLinTsai24/NYC-Taxi-Analysis/blob/main/img/campaign.png)

**Taxi Demand Analysis**:

* **Demand by Day of Week**:

  * Used bar charts to reveal that Fridays experience the highest demand.
  * Recommendation: Allocate more taxis and drivers on Fridays to meet increased demand.

* **Demand by Borough**:

  * Illustrated that Manhattan has the highest demand using bar charts.
  * Recommendation: Optimize taxi availability in Manhattan to maximize revenue opportunities.

* **Trip Type by Month**:

  * Presented line charts showing that street hail trips consistently surpass dispatch trips by about 50,000 each month.
  * Recommendation: Enhance street hail services while exploring opportunities to grow dispatch services.
    
![](https://github.com/KunLinTsai24/NYC-Taxi-Analysis/blob/main/img/demand.png)
---
### Conclusion

By harnessing the capabilities of Azure Synapse Analytics and Power BI, we have automated the data preparation process and enabled comprehensive analysis of the NYC taxi dataset. This approach has provided valuable insights into payment behaviors and demand patterns, informing strategic decisions to address industry challenges.

**Key findings include:**

  * **Payment Behavior**: Targeted campaigns during weekends and in specific boroughs can encourage credit card usage, improving transaction efficiency and security.
  * **Demand Patterns**: Understanding peak demand times and locations allows for better resource allocation, enhancing customer satisfaction and revenue.

**Next Steps**

  * **Implement Marketing Campaigns**: Launch targeted promotions to encourage credit card payments during weekends and in Queens and Bronx.

  * **Optimize Operations**: Adjust driver schedules and taxi availability to align with demand patterns identified in the analysis.

