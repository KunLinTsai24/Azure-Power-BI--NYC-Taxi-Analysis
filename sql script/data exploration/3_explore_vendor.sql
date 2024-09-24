USE nyc_taxi_discovery;

SELECT
    *
FROM
    OPENROWSET(
        BULK 'vendor_unquoted.csv',
        DATA_SOURCE ='nyc_taxi_data_raw',
        FORMAT = 'CSV',
        PARSER_VERSION = '2.0',
        HEADER_ROW= true
    ) AS vendor;

--excaped char 
SELECT
    *
FROM
    OPENROWSET(
        BULK 'vendor_escaped.csv',
        DATA_SOURCE ='nyc_taxi_data_raw',
        FORMAT = 'CSV',
        PARSER_VERSION = '2.0',
        HEADER_ROW= true,
        ESCAPECHAR = '\\' --first \ is for escape the second \
    ) AS vendor;

--field quote
SELECT
    *
FROM
    OPENROWSET(
        BULK 'vendor.csv',
        DATA_SOURCE ='nyc_taxi_data_raw',
        FORMAT = 'CSV',
        PARSER_VERSION = '2.0',
        HEADER_ROW= true,
        FIELDQUOTE = '"' --this is defalt field quote
    ) AS vendor;
