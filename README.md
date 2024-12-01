# Project Background
The New York City taxi industry plays a crucial role in urban transportation, accommodating millions of passengers yearly. This project analyzed trip data to address key challenges affecting operational efficiency and revenue. The findings from this analysis aim to support operational teams in optimizing taxi availability and improving customer satisfaction while assisting marketing teams in targeting promotional campaigns to encourage credit card usage.

The project focused on two key objectives:

- **Encouraging Credit Card Payments**: Analyze payment behavior across boroughs and days to identify opportunities for promoting cashless transactions.

- **Identifying Taxi Demand Patterns**: Assess trends in trip demand by location and time to optimize taxi availability and routing strategies.

To achieve these objectives, this project utilized **Azure Synapse Analytics** for data processing and **ELT pipeline automation**, alongside **Power BI** for visualization. This approach enabled us to analyze and optimize credit card payment campaigns, identify taxi demand patterns, and automate data preparation processes, thereby providing actionable insights for improving operations and profitability.

![](https://github.com/KunLinTsai24/NYC-Taxi-Analysis/blob/main/img/nyc_taxi_architecture_solution.png)

<br/>

The SQL script used to inspect and clean the data for this analysis can be found here \[[link](https://github.com/KunLinTsai24/Consumer-Demand-and-Payment-Behavior-Optimization/tree/main/sql%20script)\].

# Data Structure & Initial Checks

The NYC taxi dataset consists of trip-level and supporting data from multiple sources. Key details include:

- **Fact Table**:
  - **Trip Data**: Includes trip distance, fare, passenger count, and payment type.
- **Dimension Tables**:
  - **Taxi Zones**: Maps trips to specific boroughs.
  - **Calendar**: Provides date-related attributes.
  - **Trip Type**: Differentiates between street hail and dispatch trips.
  - **Rate Code and Payment Type**: Encodes fare structure and payment methods.

**ETL pipeline Construction**

The ETL pipeline transforms raw data into meaningful insights through a structured process. Initially, raw data is explored using SQL commands like OPENROWSET to query CSV, TSV, JSON, and partitioned files while performing data quality checks for duplicates and missing values. In the Bronze Layer, external tables and views are created to expose raw data efficiently. The Silver Layer involves cleaning and structuring data by transforming it into Parquet files using CETAS, partitioning by time, and creating optimized views. Finally, the Gold Layer aggregates business metrics through stored procedures and dynamic views, consolidating data for analysis. Automation is achieved using Synapse pipelines with parameterized activities to process data in stages (Raw to Bronze, Bronze to Silver, Silver to Gold) and scheduled triggers to ensure timely execution and monitoring.

![](https://github.com/KunLinTsai24/NYC-Taxi-Analysis/blob/main/img/pipeline.png)

# Executive Summary

### Overview of Findings

The analysis of NYC Taxi data provided key insights into passenger demand and payment behaviors. Taxi demand analysis highlighted that Fridays and Manhattan consistently experience the highest demand, emphasizing the need for optimized resource allocation and improved operational strategies. Meanwhile, the card payment campaign analysis revealed that although card payments dominate, certain boroughs like Queens and Bronx, as well as weekends, show opportunities to narrow the gap between cash and card payments through targeted promotional efforts.

# Insights Deep Dive

### Card Payment Campaign Analysis

- **Payment Type by Day of Week**: Card payments exceeded cash payments across all days, with the gap narrowing on Fridays and Saturdays. Card payments peaked at about 140,000 trips, while cash payments reached around 110,000 trips.
- **Payment Type by Borough**: Manhattan led in both card and cash payments, followed by Brooklyn, Queens, and Bronx, with closer gaps in Queens and Bronx.
- **Payment Type by Month**: Card payments were consistently higher than cash, maintaining a stable gap of approximately 10,000 trips each month.

![](https://github.com/KunLinTsai24/NYC-Taxi-Analysis/blob/main/img/campaign.png)

### Taxi Demand Analysis

- **Demand by Day of Week**: Fridays had the highest demand, with approximately 0.26 million trips, while Sundays showed the lowest at about 0.17 million trips.
- **Demand by Borough**: Manhattan dominated with about 0.8 million trips, followed by Queens and Brooklyn at approximately 0.4 million and 0.3 million trips, respectively. Bronx recorded around 0.1 million trips.
- **Trip Type by Month**: Street hail trips consistently outnumbered dispatch trips, with street hail trips peaking at around 0.3 million in January 2020, while dispatch trips remained below 0.05 million throughout the year.

![](https://github.com/KunLinTsai24/NYC-Taxi-Analysis/blob/main/img/demand.png)

# Recommendations

### Card Payment Campaign Analysis

- **Weekend Credit Card Promotions**: Launch promotional campaigns targeting weekends, particularly Fridays and Saturdays, when the gap between card and cash payments narrows, to further encourage cashless transactions.
- **Target Borough-Specific Campaigns**: Focus credit card adoption efforts in Queens and Bronx, where the gap between cash and card payments is smaller, indicating potential for growth.
- **Sustain Monthly Campaigns**: Maintain consistent marketing efforts to reinforce and expand the steady lead of card payments over cash on a monthly basis.

### Taxi Demand Analysis

- **Optimize Taxi Allocation on Fridays**: Increase the number of taxis and drivers available on Fridays to meet peak demand and maximize revenue opportunities.
- **Focus Resources in Manhattan**: Ensure high availability of taxis in Manhattan, as it consistently has the highest trip demand.
- **Enhance Street Hail Services**: Improve the reliability and efficiency of street hail services to maintain their dominance, while also exploring strategies to grow dispatch services to capture untapped demand.

# Assumptions and Caveats
Throughout the analysis, multiple assumptions were made to manage challenges with the data. These assumptions and caveats are noted below:

- **Payment Attribution**: Payment trends were analyzed based on primary trip data without considering external promotions.
- **Demand Variability**: Fluctuations in demand patterns may not fully account for weather, events, or external disruptions.
