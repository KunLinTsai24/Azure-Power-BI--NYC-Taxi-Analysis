USE nyc_taxi_ldw;

IF OBJECT_ID('silver.rate_code') IS NOT NULL
    DROP EXTERNAL TABLE silver.rate_code
GO

CREATE EXTERNAL TABLE silver.rate_code
    WITH
    (
        data_source= nyc_taxi_src,
        location = 'silver/rate_code',
        file_format = parquet_file_format
    )
AS
select *
from bronze.vw_rate_code;
