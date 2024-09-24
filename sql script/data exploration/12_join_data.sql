USE nyc_taxi_discovery

-- Identify number of trip made from each borough


SELECT
    zone.borough, count(1) AS number_of_trips
From     
    OPENROWSET(
        BULK 'trip_data_green_parquet/year=2020/month=01/',
        DATA_SOURCE = 'nyc_taxi_data_raw',
        FORMAT = 'PARQUET'
    ) 
        AS trip_data
JOIN 
        OPENROWSET(
        BULK 'taxi_zone.csv',
        DATA_SOURCE ='nyc_taxi_data_raw',
        FORMAT = 'CSV',
        PARSER_VERSION = '2.0',
        FIRSTROW = 2
    ) 
    WITH(
        location_id SMALLINT 1,
        borough VARCHAR(15) 2,
        zone VARCHAR(50) 3,
        service_zone VARCHAR(15) 4
    )
        AS zone
ON trip_data.PULocationID = zone.location_id
GROUP by zone.borough
ORDER by number_of_trips desc