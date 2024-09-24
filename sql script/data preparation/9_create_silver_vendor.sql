USE nyc_taxi_ldw;

IF OBJECT_ID('silver.vendor') IS NOT NULL
    DROP EXTERNAL TABLE silver.vendor
GO

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