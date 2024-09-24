USE nyc_taxi_ldw;
GO

CREATE OR ALTER PROCEDURE bronze.usp_bronze_payment_type
AS
BEGIN
    DECLARE @create_sql_stmt NVARCHAR(MAX), -- 定義變數
            @drop_sql_stmt   NVARCHAR(MAX);

    -- 動態生成 DROP VIEW 語句
    SET @drop_sql_stmt = 'DROP VIEW IF EXISTS bronze.vw_payment_type;';
    
    -- 執行 DROP VIEW 語句
    EXEC sp_executesql @drop_sql_stmt;

    -- 動態生成 CREATE VIEW 語句
    SET @create_sql_stmt = 
        'CREATE VIEW bronze.vw_payment_type 
        AS
        SELECT
            payment_type,
            description
        FROM
            OPENROWSET(
                BULK ''raw/payment_type.json'',
                DATA_SOURCE =''nyc_taxi_src'',
                FORMAT = ''CSV'',
                PARSER_VERSION =''1.0'', 
                FIELDTERMINATOR = ''0x0b'', 
                FIELDQUOTE = ''0x0b'',
                ROWTERMINATOR = ''0x0a'' 
            ) 
        WITH
        (
            jsonDoc NVARCHAR(MAX)    
        ) AS payment_type
        CROSS APPLY OPENJSON(jsonDoc)
        WITH(
            payment_type SMALLINT,
            description VARCHAR(20) ''$.payment_type_desc''
        );';

    -- 執行 CREATE VIEW 語句
    EXEC sp_executesql @create_sql_stmt;

END;
