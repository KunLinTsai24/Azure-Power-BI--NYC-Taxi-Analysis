USE nyc_taxi_ldw;

IF OBJECT_ID('silver.taxi_zone') IS NOT NULL
    DROP EXTERNAL TABLE silver.taxi_zone
GO

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