USE nyc_taxi_discovery

SELECT
    rate_code_id,rate_code
FROM
    OPENROWSET(
        BULK 'rate_code.json',
        DATA_SOURCE ='nyc_taxi_data_raw',
        FORMAT = 'CSV',
        PARSER_VERSION ='1.0', 
        FIELDTERMINATOR = '0x0b', 
        FIELDQUOTE = '0x0b',
        ROWTERMINATOR = '0x0b' --這個JSON本身是個ARRAY
    ) 
WITH
(
    jsonDoc NVARCHAR(MAX)    
)
    as rate_code

CROSS APPLY OPENJSON(jsonDoc)
WITH(
    rate_code_id TINYINT,
    rate_code VARCHAR(25)
)
-- multi line(與standard json一樣，只是排版過)

SELECT
    rate_code_id,rate_code
FROM
    OPENROWSET(
        BULK 'rate_code_multi_line.json',
        DATA_SOURCE ='nyc_taxi_data_raw',
        FORMAT = 'CSV',
        PARSER_VERSION ='1.0', 
        FIELDTERMINATOR = '0x0b', 
        FIELDQUOTE = '0x0b',
        ROWTERMINATOR = '0x0b' --這個JSON本身是個ARRAY
    ) 
WITH
(
    jsonDoc NVARCHAR(MAX)    
)
    as rate_code

CROSS APPLY OPENJSON(jsonDoc)
WITH(
    rate_code_id TINYINT,
    rate_code VARCHAR(25)
)