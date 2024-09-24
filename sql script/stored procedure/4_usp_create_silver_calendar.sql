USE nyc_taxi_ldw
GO

CREATE OR ALTER PROCEDURE silver.usp_silver_calendar
AS
BEGIN

    IF OBJECT_ID('silver.calendar') IS NOT NULL
        DROP EXTERNAL TABLE silver.calendar

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

END