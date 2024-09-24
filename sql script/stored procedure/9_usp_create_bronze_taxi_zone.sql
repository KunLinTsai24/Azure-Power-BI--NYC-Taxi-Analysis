USE nyc_taxi_ldw
GO

CREATE OR ALTER PROCEDURE bronze.usp_bronze_taxi_zone
AS
BEGIN
    IF OBJECT_ID('bronze.taxi_zone') IS NOT NULL
        DROP EXTERNAL TABLE bronze.taxi_zone;

    CREATE EXTERNAL TABLE bronze.taxi_zone
        (   location_id SMALLINT ,
            borough VARCHAR(15) ,
            zone VARCHAR(50) ,
            service_zone VARCHAR(15) )  
        WITH (
                LOCATION = 'raw/taxi_zone.csv',  
                DATA_SOURCE = nyc_taxi_src,  
                FILE_FORMAT = csv_file_format_pv1,
                Reject_value = 10, 
                Rejected_row_location = 'rejection/taxi_zone'
        );
END