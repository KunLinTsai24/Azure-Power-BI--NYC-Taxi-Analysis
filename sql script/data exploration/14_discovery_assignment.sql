USE nyc_taxi_discovery;

/* Identify the percentage of cash and credit card trips by borough
Example Data As below
----------------------------------------------------------------------------------------------
borough	    total_trips	cash_trips	card_trips	cash_trips_percentage	card_trips_percentage
----------------------------------------------------------------------------------------------
Bronx	    2019	    751	        1268	    37.20	                62.80
Brooklyn	6435	    2192	    4243	    34.06	                65.94
----------------------------------------------------------------------------------------------
*/

SELECT
    zone.borough,
    count(1) total_trips,
    sum( case when payment_type.description = 'Cash' then 1 else 0 end) AS cash_trips,
    sum( case when payment_type.description = 'Credit card' then 1 else 0 end) AS cash_trips,
    cast(sum(case when payment_type.description = 'Cash' then 1 else 0 end)/cast(count(1) as decimal)*100 AS decimal(5,2)) AS cash_trips_percentage,
    cast(sum(case when payment_type.description = 'Credit card' then 1 else 0 end)/cast(count(1) as decimal)*100 AS decimal(5,2)) AS credit_card_trips_percentage
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
JOIN
    OPENROWSET(
        BULK 'payment_type.json',
        DATA_SOURCE ='nyc_taxi_data_raw',
        FORMAT = 'CSV',
        PARSER_VERSION ='1.0', 
        FIELDTERMINATOR = '0x0b', 
        FIELDQUOTE = '0x0b',
        ROWTERMINATOR = '0x0a' 
    ) 
    WITH(
    jsonDoc NVARCHAR(MAX)    
    )
    as payment
    CROSS APPLY OPENJSON(jsonDoc)
    WITH(
        payment_type SMALLINT,
        description VARCHAR(20) '$.payment_type_desc'
    ) as payment_type
ON trip_data.payment_type = payment_type.payment_type
where payment_type.description in ('Cash','Credit card')
GROUP by zone.borough
ORDER by zone.borough