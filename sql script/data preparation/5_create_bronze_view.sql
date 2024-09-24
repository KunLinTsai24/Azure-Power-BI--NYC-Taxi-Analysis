USE nyc_taxi_ldw
GO

-- create rate_code view
DROP VIEW IF EXISTS bronze.vw_rate_code
GO

CREATE VIEW bronze.vw_rate_code 
AS
SELECT
    rate_code_id,rate_code
FROM
    OPENROWSET(
        BULK 'raw/rate_code.json',
        DATA_SOURCE ='nyc_taxi_src',
        FORMAT = 'CSV',
        PARSER_VERSION ='1.0', 
        FIELDTERMINATOR = '0x0b', 
        FIELDQUOTE = '0x0b',
        ROWTERMINATOR = '0x0b'
    ) 
WITH
(
    jsonDoc NVARCHAR(MAX)    
)
    as rate_code

CROSS APPLY OPENJSON(jsonDoc)
WITH(
    rate_code_id TINYINT,
    rate_code VARCHAR(25)
)
GO


--create payment_type view
DROP VIEW IF EXISTS bronze.vw_payment_type
GO

CREATE VIEW bronze.vw_payment_type
AS
SELECT
    payment_type,
    description
FROM
    OPENROWSET(
        BULK 'raw/payment_type.json',
        DATA_SOURCE ='nyc_taxi_src',
        FORMAT = 'CSV',
        PARSER_VERSION ='1.0', 
        FIELDTERMINATOR = '0x0b', 
        FIELDQUOTE = '0x0b',
        ROWTERMINATOR = '0x0a' 
    ) 
WITH
(
    jsonDoc NVARCHAR(MAX)    
)
    as payment_type

CROSS APPLY OPENJSON(jsonDoc)
WITH(
    payment_type SMALLINT,
    description VARCHAR(20) '$.payment_type_desc'
)
GO


-- create trip_data_green view

DROP VIEW IF EXISTS bronze.vw_trip_data_green_csv
GO

CREATE VIEW bronze.vw_trip_data_green_csv
AS
SELECT
    trip_green_taxi.filepath(1) AS year,
    trip_green_taxi.filepath(2) AS month,
    trip_green_taxi.*
FROM
    OPENROWSET(
        BULK 'raw/trip_data_green_csv/year=*/month=*/*.csv',
        data_source = 'nyc_taxi_src',
        FORMAT = 'CSV',
        PARSER_VERSION = '2.0',
        Header_row = true
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
        congestion_surcharge FLOAT
  )AS trip_green_taxi
GO
