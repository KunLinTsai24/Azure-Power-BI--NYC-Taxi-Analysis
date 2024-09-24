USE nyc_taxi_ldw
GO

CREATE OR ALTER PROCEDURE silver.usp_silver_taxi_zone
AS
BEGIN

    IF OBJECT_ID('silver.taxi_zone') IS NOT NULL
        DROP EXTERNAL TABLE silver.taxi_zone;

    CREATE EXTERNAL TABLE silver.taxi_zone
        WITH
        (
            data_source= nyc_taxi_src,
            location = 'silver/taxi_zone', --儲存的地點
            file_format = parquet_file_format
        )
    AS
    select *
    from bronze.taxi_zone;

END