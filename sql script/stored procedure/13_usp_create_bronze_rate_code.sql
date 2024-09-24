USE nyc_taxi_ldw
GO

CREATE OR ALTER PROCEDURE bronze.usp_bronze_rate_code

AS
BEGIN
    DECLARE @create_sql_stmt NVARCHAR(MAX), -- 定義變數
            @drop_sql_stmt   NVARCHAR(MAX);

    -- 動態生成 DROP VIEW 語句
    SET @drop_sql_stmt = 'DROP VIEW IF EXISTS bronze.vw_rate_code;';
    
    -- 執行 DROP VIEW 語句
    EXEC sp_executesql @drop_sql_stmt;

    -- 動態生成 CREATE VIEW 語句
    SET @create_sql_stmt = 
        'CREATE VIEW bronze.vw_rate_code 
        AS
        SELECT
            rate_code_id,
            rate_code
        FROM
            OPENROWSET(
                BULK ''raw/rate_code.json'',
                DATA_SOURCE =''nyc_taxi_src'',
                FORMAT = ''CSV'',
                PARSER_VERSION =''1.0'', 
                FIELDTERMINATOR = ''0x0b'', 
                FIELDQUOTE = ''0x0b'',
                ROWTERMINATOR = ''0x0b''
            ) 
        WITH
        (
            jsonDoc NVARCHAR(MAX)    
        ) AS rate_code
        CROSS APPLY OPENJSON(jsonDoc)
        WITH(
            rate_code_id TINYINT,
            rate_code VARCHAR(25)
        );';

    -- 執行 CREATE VIEW 語句
    EXEC sp_executesql @create_sql_stmt;

END;