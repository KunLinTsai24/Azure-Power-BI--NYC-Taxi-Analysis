USE nyc_taxi_discovery

-- Identify any data quality issues in trip total amount

SELECT
    min(total_amount) min_total_amount,
    max(total_amount) max_total_amount,
    avg(total_amount) avg_total_amount,
    count(1) total_number_of_records,
    count(total_amount) not_null_total_number_of_records
FROM
    OPENROWSET(
        BULK 'trip_data_green_parquet/year=2020/month=01/',
        DATA_SOURCE = 'nyc_taxi_data_raw',
        FORMAT = 'PARQUET'
    ) AS [result]

--

SELECT
    *
FROM
    OPENROWSET(
        BULK 'trip_data_green_parquet/year=2020/month=01/',
        DATA_SOURCE = 'nyc_taxi_data_raw',
        FORMAT = 'PARQUET'
    ) AS [result]
where  total_amount<0

--

SELECT
    payment_type, count(1) AS number_of_records
FROM
    OPENROWSET(
        BULK 'trip_data_green_parquet/year=2020/month=01/',
        DATA_SOURCE = 'nyc_taxi_data_raw',
        FORMAT = 'PARQUET'
    ) AS [result]
group by payment_type
order by payment_type