USE nyc_taxi_discovery;

-- JSON_VALUE function
SELECT
    CAST(JSON_VALUE(jsonDoc, '$.payment_type') AS SMALLINT) payment_type,
    CAST(JSON_VALUE(jsonDoc, '$.payment_type_desc') AS VARCHAR(15)) payment_type_desc
FROM
    OPENROWSET(
        BULK 'payment_type.json',
        DATA_SOURCE ='nyc_taxi_data_raw',
        FORMAT = 'CSV',
        PARSER_VERSION ='1.0', -- defalut
        FIELDTERMINATOR = '0x0b', -- 使用垂直製表符作為欄位終止符，這表示欄位之間用垂直製表符分隔。
        FIELDQUOTE = '0x0b', -- 使用垂直製表符作為欄位引用符，這表示欄位值的開頭和結尾用垂直製表符包圍。
        ROWTERMINATOR = '0x0a' -- 使用換行符作為行終止符，這表示每行結束使用換行符。default
    ) 
WITH
(
    jsonDoc NVARCHAR(MAX)    
)
    as payment_type

-- OPENJSON function

SELECT
    payment_type,
    description
FROM
    OPENROWSET(
        BULK 'payment_type.json',
        DATA_SOURCE ='nyc_taxi_data_raw',
        FORMAT = 'CSV',
        PARSER_VERSION ='1.0', 
        FIELDTERMINATOR = '0x0b', 
        FIELDQUOTE = '0x0b',
        ROWTERMINATOR = '0x0a' 
    ) 
WITH
(
    jsonDoc NVARCHAR(MAX)    
)
    as payment_type

CROSS APPLY OPENJSON(jsonDoc)
WITH(
    payment_type SMALLINT,
    description VARCHAR(20) '$.payment_type_desc'
)


-- JSON with ARRAY with JSON_VALUE function
SELECT
    CAST(JSON_VALUE(jsonDoc, '$.payment_type') AS SMALLINT) payment_type,
    CAST(JSON_VALUE(jsonDoc, '$.payment_type_desc[0].value') AS VARCHAR(15)) payment_type_desc_0, --first element in the array, key is 'value'
    CAST(JSON_VALUE(jsonDoc, '$.payment_type_desc[1].value') AS VARCHAR(15)) payment_type_desc_1 -- second element in the array, key is 'value'
FROM
    OPENROWSET(
        BULK 'payment_type_array.json',
        DATA_SOURCE ='nyc_taxi_data_raw',
        FORMAT = 'CSV',
        PARSER_VERSION ='1.0', 
        FIELDTERMINATOR = '0x0b', 
        FIELDQUOTE = '0x0b', 
        ROWTERMINATOR = '0x0a' 
    ) 
WITH
(
    jsonDoc NVARCHAR(MAX)    
)
    as payment_type

-- JSON with ARRAY with OPENJSON function

SELECT
    payment_type, payment_type_desc_value
FROM
    OPENROWSET(
        BULK 'payment_type_array.json',
        DATA_SOURCE ='nyc_taxi_data_raw',
        FORMAT = 'CSV',
        PARSER_VERSION ='1.0', 
        FIELDTERMINATOR = '0x0b', 
        FIELDQUOTE = '0x0b', 
        ROWTERMINATOR = '0x0a' 
    ) 
WITH
(
    jsonDoc NVARCHAR(MAX)    
)
    as payment_type
CROSS APPLY OPENJSON(jsonDoc)
WITH(
    payment_type SMALLINT,
    payment_type_desc NVARCHAR(MAX) AS JSON
)
CROSS APPLY OPENJSON(payment_type_desc)
WITH (
    sub_type SMALLINT,
    payment_type_desc_value VARCHAR(20) '$.value'
)
