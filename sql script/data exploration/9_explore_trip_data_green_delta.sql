use nyc_taxi_data_raw



-- for delta, you can't query from subfolder
select top 100
    *
FROM OPENROWSET(
    BULK 'trip_data_green_delta',
    DATA_SOURCE = 'nyc_taxi_data_raw',
    FORMAT = 'DELTA'
)
 WITH (
       VendorID INT,
        lpep_pickup_datetime datetime2(7),
        lpep_dropoff_datetime datetime2(7),
        store_and_fwd_flag CHAR(1),
        RatecodeID INT,
        PULocationID INT,
        DOLocationID INT,
        passenger_count INT,
        trip_distance FLOAT,
        fare_amount FLOAT,
        extra FLOAT,
        mta_tax FLOAT,
        tip_amount FLOAT,
        tolls_amount FLOAT,
        ehail_fee INT,
        improvement_surcharge FLOAT,
        total_amount FLOAT,
        payment_type INT,
        trip_type INT,
        congestion_surcharge FLOAT,
        year VARCHAR(4),
        month VARCHAR(2)
   )AS trip_data;


-- select part of the data
select top 100
    *
FROM OPENROWSET(
    BULK 'trip_data_green_delta',
    DATA_SOURCE = 'nyc_taxi_data_raw',
    FORMAT = 'DELTA'
)AS trip_data
where year='2021'

-- choose certain version (not support in severless sql pool)



