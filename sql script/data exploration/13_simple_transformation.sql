USE nyc_taxi_discovery

-- Number of trip made by duration in hours
SELECT
    DATEDIFF(hour, lpep_pickup_datetime,lpep_dropoff_datetime) AS from_hour,
    DATEDIFF(hour, lpep_pickup_datetime,lpep_dropoff_datetime) +1 AS to_hour,
    count(1) AS number_of_trips
FROM
    OPENROWSET(
        BULK 'trip_data_green_parquet/year=2020/month=01/',
        DATA_SOURCE = 'nyc_taxi_data_raw',
        FORMAT = 'PARQUET'
    ) AS trip_data
group by     
    DATEDIFF(hour, lpep_pickup_datetime,lpep_dropoff_datetime),
    DATEDIFF(hour, lpep_pickup_datetime,lpep_dropoff_datetime) +1 
order by 
    from_hour,
    to_hour 