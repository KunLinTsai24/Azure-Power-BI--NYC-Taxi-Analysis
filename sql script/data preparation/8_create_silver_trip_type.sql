USE nyc_taxi_ldw;

IF OBJECT_ID('silver.trip_type') IS NOT NULL
    DROP EXTERNAL TABLE silver.trip_type
GO

CREATE EXTERNAL TABLE silver.trip_type
    WITH
    (
        data_source= nyc_taxi_src,
        location = 'silver/trip_type',
        file_format = parquet_file_format
    )
AS
select *
from bronze.trip_type;