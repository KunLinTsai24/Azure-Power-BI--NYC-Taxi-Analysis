USE nyc_taxi_ldw
GO

CREATE OR ALTER PROCEDURE silver.usp_silver_vendor
AS
BEGIN

    IF OBJECT_ID('silver.vendor') IS NOT NULL
        DROP EXTERNAL TABLE silver.vendor

    CREATE EXTERNAL TABLE silver.vendor
        WITH
        (
            data_source= nyc_taxi_src,
            location = 'silver/vendor',
            file_format = parquet_file_format
        )
    AS
    select *
    from bronze.vendor;

END