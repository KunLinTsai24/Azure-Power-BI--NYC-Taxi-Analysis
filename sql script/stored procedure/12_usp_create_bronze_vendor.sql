USE nyc_taxi_ldw
GO

CREATE OR ALTER PROCEDURE bronze.usp_bronze_vendor
AS
BEGIN
    IF OBJECT_ID('bronze.vendor') IS NOT NULL
        DROP EXTERNAL TABLE bronze.vendor;
    CREATE EXTERNAL TABLE bronze.vendor
        (   
                vendor_id TINYINT,
                vendor_name VARCHAR(50)
        )  
        WITH (
                LOCATION = 'raw/vendor.csv',  
                DATA_SOURCE = nyc_taxi_src,  
                FILE_FORMAT = csv_file_format_pv1,
                Reject_value = 10, 
                Rejected_row_location = 'raw/rejection/vendor' 
        );

END