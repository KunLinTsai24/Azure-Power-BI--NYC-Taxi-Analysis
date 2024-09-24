USE nyc_taxi_ldw;

-- no partition
/*
IF OBJECT_ID('silver.trip_data_green') IS NOT NULL
    DROP EXTERNAL TABLE silver.trip_data_green
GO

CREATE EXTERNAL TABLE silver.trip_data_green
    WITH
    (
        data_source= nyc_taxi_src,
        location = 'silver/trip_data_green',
        file_format = parquet_file_format
    )
AS
select *
from bronze.trip_data_green_csv;
*/

--use stored procedure to create partition

EXEC silver.usp_silver_trip_data_green '2020', '01'
EXEC silver.usp_silver_trip_data_green '2020', '02'
EXEC silver.usp_silver_trip_data_green '2020', '03'
EXEC silver.usp_silver_trip_data_green '2020', '04'
EXEC silver.usp_silver_trip_data_green '2020', '05'
EXEC silver.usp_silver_trip_data_green '2020', '06'
EXEC silver.usp_silver_trip_data_green '2020', '07'
EXEC silver.usp_silver_trip_data_green '2020', '08'
EXEC silver.usp_silver_trip_data_green '2020', '09'
EXEC silver.usp_silver_trip_data_green '2020', '10'
EXEC silver.usp_silver_trip_data_green '2020', '11'
EXEC silver.usp_silver_trip_data_green '2020', '12'
EXEC silver.usp_silver_trip_data_green '2021', '01'
EXEC silver.usp_silver_trip_data_green '2021', '02'
EXEC silver.usp_silver_trip_data_green '2021', '03'
EXEC silver.usp_silver_trip_data_green '2021', '04'
EXEC silver.usp_silver_trip_data_green '2021', '05'
EXEC silver.usp_silver_trip_data_green '2021', '06'