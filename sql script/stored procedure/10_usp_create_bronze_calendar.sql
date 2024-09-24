USE nyc_taxi_ldw
GO

CREATE OR ALTER PROCEDURE bronze.usp_bronze_calendar
AS
BEGIN
    IF OBJECT_ID('bronze.calendar') IS NOT NULL
        DROP EXTERNAL TABLE bronze.calendar;
    CREATE EXTERNAL TABLE bronze.calendar
        (   date_key INT,
            date DATE,
            year SMALLINT,
            month TINYINT,
            day TINYINT,
            day_name VARCHAR(10),
            day_of_year SMALLINT,
            week_of_month TINYINT,
            week_of_year TINYINT,
            month_name VARCHAR(10),
            year_month INT,
            year_week INT )  
        WITH (
                LOCATION = 'raw/calendar.csv',  
                DATA_SOURCE = nyc_taxi_src,  
                FILE_FORMAT = csv_file_format_pv1,
                Reject_value = 10, 
                Rejected_row_location = 'raw/rejection/calendar' 
        );

END