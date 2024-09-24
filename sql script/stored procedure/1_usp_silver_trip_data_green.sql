USE nyc_taxi_ldw
GO


-- CREATE EXTERNAL TABLE：創建外部表並將查詢結果存儲到外部數據源中。
-- DROP EXTERNAL TABLE：刪除外部表的元數據，但不會刪除外部數據源中的實際數據文件。
-- 因此，在這個存儲過程中，執行 DROP EXTERNAL TABLE 語句後，外部數據源中的數據文件不會被刪除，僅僅是刪除了外部表的定義。

--必須使用動態SQL，因為表名是根據傳入的 @year 和 @month 動態生成的，無法在靜態的 T-SQL 語句中直接引用這樣的表名。 

CREATE OR ALTER PROCEDURE silver.usp_silver_trip_data_green
@year varchar(4), -- 定義參數
@month VARCHAR(2)
AS
BEGIN

    DECLARE @create_sql_stmt NVARCHAR(MAX), -- 定義變數
            @drop_sql_stmt   NVARCHAR(MAX);
    SET @create_sql_stmt = 
        'CREATE EXTERNAL TABLE silver.trip_data_green' + @year + '_' + @month +
        ' WITH
            (
                data_source= nyc_taxi_src,
                location = ''silver/trip_data_green/year=' + @year + '/month=' + @month + ''',
                file_format = parquet_file_format
            )
        AS
        SELECT [VendorID] AS vendor_id
                ,[lpep_pickup_datetime]
                ,[lpep_dropoff_datetime]
                ,[store_and_fwd_flag]
                ,[total_amount]
                ,[payment_type]
                ,[trip_type]
                ,[congestion_surcharge]
                ,[extra]
                ,[mta_tax]
                ,[tip_amount]
                ,[tolls_amount]
                ,[ehail_fee]
                ,[improvement_surcharge]
                ,[RatecodeID] AS rate_code_id
                ,[PULocationID] AS pu_location_id
                ,[DOLocationID] AS do_location_id
                ,[passenger_count]
                ,[trip_distance]
                ,[fare_amount]
        from bronze.vw_trip_data_green_csv
        where  year= '''+ @year +''' 
           and month= '''+ @month + '''';
    
    EXEC sp_executesql @create_sql_stmt ;

    SET @drop_sql_stmt = 
    'DROP EXTERNAL TABLE silver.trip_data_green' + @year + '_' + @month ;

    EXEC sp_executesql @drop_sql_stmt ;
END