USE nyc_taxi_ldw;

IF OBJECT_ID('silver.calendar') IS NOT NULL
    DROP EXTERNAL TABLE silver.calendar
GO

CREATE EXTERNAL TABLE silver.calendar
    WITH
    (
        data_source= nyc_taxi_src,
        location = 'silver/calendar',
        file_format = parquet_file_format
    )
AS
select *
from bronze.calendar;