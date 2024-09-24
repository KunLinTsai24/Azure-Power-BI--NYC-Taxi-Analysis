USE nyc_taxi_ldw;

IF OBJECT_ID('silver.payment_type') IS NOT NULL
    DROP EXTERNAL TABLE silver.payment_type
GO

CREATE EXTERNAL TABLE silver.payment_type
    WITH
    (
        data_source= nyc_taxi_src,
        location = 'silver/payment_type',
        file_format = parquet_file_format
    )
AS
select *
from bronze.vw_payment_type;