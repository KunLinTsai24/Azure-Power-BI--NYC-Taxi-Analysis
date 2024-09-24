USE nyc_taxi_ldw;
GO

CREATE OR ALTER PROCEDURE bronze.usp_bronze_trip_data_green
AS
BEGIN
    DECLARE @create_sql_stmt NVARCHAR(MAX), -- 定義變數
            @drop_sql_stmt   NVARCHAR(MAX);

    -- 動態生成 DROP VIEW 語句
    SET @drop_sql_stmt = 'DROP VIEW IF EXISTS bronze.vw_trip_data_green_csv;';
    
    -- 執行 DROP VIEW 語句
    EXEC sp_executesql @drop_sql_stmt;

    -- 動態生成 CREATE VIEW 語句
    SET @create_sql_stmt = 
        'CREATE VIEW bronze.vw_trip_data_green_csv
        AS
        SELECT
            trip_green_taxi.filepath(1) AS year,
            trip_green_taxi.filepath(2) AS month,
            trip_green_taxi.*
        FROM
            OPENROWSET(
                BULK ''raw/trip_data_green_csv/year=*/month=*/*.csv'',
                data_source = ''nyc_taxi_src'',
                FORMAT = ''CSV'',
                PARSER_VERSION = ''2.0'',
                HEADER_ROW = TRUE
            ) 
        WITH (
            VendorID INT,
            lpep_pickup_datetime DATETIME2(7),
            lpep_dropoff_datetime DATETIME2(7),
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
        ) AS trip_green_taxi;';

    -- 執行 CREATE VIEW 語句
    EXEC sp_executesql @create_sql_stmt;

END;
GO

