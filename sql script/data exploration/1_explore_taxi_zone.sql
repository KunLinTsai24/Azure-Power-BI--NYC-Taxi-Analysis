-- HEADER_ROW set to TRUE, Tow and Field terminators set
SELECT
    TOP 100 *
FROM
    OPENROWSET(
        BULK 'https://synapsecoursedljason.dfs.core.windows.net/nyc-taxi-data/raw/taxi_zone.csv',
        FORMAT = 'CSV',
        PARSER_VERSION = '2.0',
        HEADER_ROW= true,
        fieldterminator = ',',
        ROWTERMINATOR = '\n'
    ) AS zone

-- Examine the data types for the columns
EXEC sp_describe_first_result_set N' SELECT
    TOP 100 *
FROM
    OPENROWSET(
        BULK ''https://synapsecoursedljason.dfs.core.windows.net/nyc-taxi-data/raw/taxi_zone.csv'',
        FORMAT = ''CSV'',
        PARSER_VERSION = ''2.0'',
        HEADER_ROW= true,
        fieldterminator = '','',
        ROWTERMINATOR = ''\n''
    ) AS zone'

-- Examine Max Len for each field

SELECT
    MAX(LEN(LocationID)) AS 'MaxLen_LocationID',
    MAX(LEN(Borough)) AS 'MaxLen_Borough',
    MAX(LEN(Zone)) AS 'MaxLen_Zone',
    MAX(LEN(service_zone)) AS 'MaxLen_servicezone'

FROM
    OPENROWSET(
        BULK 'https://synapsecoursedljason.dfs.core.windows.net/nyc-taxi-data/raw/taxi_zone.csv',
        FORMAT = 'CSV',
        PARSER_VERSION = '2.0',
        HEADER_ROW= true,
        fieldterminator = ',',
        ROWTERMINATOR = '\n'
    ) AS zone

--Use WITH clause to provide explicit data types

SELECT
    TOP 100 *
FROM
    OPENROWSET(
        BULK 'https://synapsecoursedljason.dfs.core.windows.net/nyc-taxi-data/raw/taxi_zone.csv',
        FORMAT = 'CSV',
        PARSER_VERSION = '2.0',
        HEADER_ROW= true,
        fieldterminator = ',',
        ROWTERMINATOR = '\n'
    ) 
    WITH(
        LocationID SMALLINT,
        Borough VARCHAR(15),
        Zone VARCHAR(50),
        service_zone VARCHAR(15)
    )
        AS zone

-- Examine Collation 
select name, collation_name FROM sys.databases


-- Specify Collation

SELECT
    TOP 100 *
FROM
    OPENROWSET(
        BULK 'https://synapsecoursedljason.dfs.core.windows.net/nyc-taxi-data/raw/taxi_zone.csv',
        FORMAT = 'CSV',
        PARSER_VERSION = '2.0',
        HEADER_ROW= true,
        fieldterminator = ',',
        ROWTERMINATOR = '\n'
    ) 
    WITH(
        LocationID SMALLINT,
        Borough VARCHAR(15) COLLATE Latin1_General_100_CI_AI_SC_UTF8,
        Zone VARCHAR(50) COLLATE Latin1_General_100_CI_AI_SC_UTF8,
        service_zone VARCHAR(15) COLLATE Latin1_General_100_CI_AI_SC_UTF8
    )
        AS zone

--Create database and specify collation at database level

CREATE DATABASE nyc_taxi_discovery

USE nyc_taxi_discovery

ALTER DATABASE nyc_taxi_discovery COLLATE Latin1_General_100_CI_AI_SC_UTF8

--select only subset of columns

SELECT
    TOP 100 *
FROM
    OPENROWSET(
        BULK 'https://synapsecoursedljason.dfs.core.windows.net/nyc-taxi-data/raw/taxi_zone.csv',
        FORMAT = 'CSV',
        PARSER_VERSION = '2.0',
        HEADER_ROW= true,
        fieldterminator = ',',
        ROWTERMINATOR = '\n'
    ) 
    WITH(
        Borough VARCHAR(15),
        Zone VARCHAR(50)
    )
        AS zone

-- Read data from a file without header in a subset of coulumns

SELECT
    TOP 100 *
FROM
    OPENROWSET(
        BULK 'https://synapsecoursedljason.dfs.core.windows.net/nyc-taxi-data/raw/taxi_zone_without_header.csv',
        FORMAT = 'CSV',
        PARSER_VERSION = '2.0',
        fieldterminator = ',',
        ROWTERMINATOR = '\n'
    ) 
       WITH(
        Borough VARCHAR(15) 2, --number is the index of the column
        Zone VARCHAR(50) 3
    )
        AS zone

--Fix columns names

SELECT
    TOP 100 *
FROM
    OPENROWSET(
        BULK 'https://synapsecoursedljason.dfs.core.windows.net/nyc-taxi-data/raw/taxi_zone.csv',
        FORMAT = 'CSV',
        PARSER_VERSION = '2.0',
        FIRSTROW = 2,
        fieldterminator = ',',
        ROWTERMINATOR = '\n'
    ) 
    WITH(
        location_id SMALLINT 1, --use index and specify the column name of your own
        borough VARCHAR(15) 2,
        zone VARCHAR(50) 3,
        service_zone VARCHAR(15) 4
    )
        AS zone

-- Create External Data Source

CREATE EXTERNAL DATA SOURCE nyc_taxi_data_raw
WITH(
    LOCATION = 'https://synapsecoursedljason.dfs.core.windows.net/nyc-taxi-data/raw'
)

SELECT
    TOP 100 *
FROM
    OPENROWSET(
        BULK 'taxi_zone.csv',
        DATA_SOURCE ='nyc_taxi_data_raw',
        FORMAT = 'CSV',
        PARSER_VERSION = '2.0',
        FIRSTROW = 2,
        fieldterminator = ',',
        ROWTERMINATOR = '\n'
    ) 
    WITH(
        location_id SMALLINT 1,
        borough VARCHAR(15) 2,
        zone VARCHAR(50) 3,
        service_zone VARCHAR(15) 4
    )
        AS zone