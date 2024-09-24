USE nyc_taxi_ldw
GO

CREATE OR ALTER PROCEDURE bronze.usp_bronze_trip_type
AS
BEGIN
    IF OBJECT_ID('bronze.trip_type') IS NOT NULL
        DROP EXTERNAL TABLE bronze.trip_type;
    CREATE EXTERNAL TABLE bronze.trip_type
        (   
            trip_type INT,
            trip_type_desc VARCHAR(15)
        )  
        WITH (
                LOCATION = 'raw/trip_type.tsv',  
                DATA_SOURCE = nyc_taxi_src,  
                FILE_FORMAT = tsv_file_format_pv1,
                Reject_value = 10, 
                Rejected_row_location = 'raw/rejection/trip_type' 
        );

END