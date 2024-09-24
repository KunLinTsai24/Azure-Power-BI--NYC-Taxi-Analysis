USE nyc_taxi_discovery

SELECT
    location_id,
    count(1) AS number_of_records
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
group by zone.location_id
having count(1)>1