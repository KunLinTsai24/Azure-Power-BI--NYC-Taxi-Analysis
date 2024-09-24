USE nyc_taxi_discovery;

SELECT
    *
FROM
    OPENROWSET(
        BULK 'trip_type.tsv',
        DATA_SOURCE ='nyc_taxi_data_raw',
        FORMAT = 'CSV',
        PARSER_VERSION = '2.0',
        HEADER_ROW= true,
        FIELDTERMINATOR = '\t' --tab terminator
    ) 
WITH(
    trip_type INT,
    trip_type_desc VARCHAR(15)
)
AS trip_type;