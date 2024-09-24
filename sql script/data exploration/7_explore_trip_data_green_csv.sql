USE nyc_taxi_discovery


-- get file from subfolder
SELECT
    TOP 100 *
FROM
    OPENROWSET(
        BULK 'trip_data_green_csv/year=2020/**', -- get file from subfolder
        data_source = 'nyc_taxi_data_raw',
        FORMAT = 'CSV',
        PARSER_VERSION = '2.0',
        Header_row = true
    ) AS trip_green_taxi

-- get file from more than one folder
SELECT
    TOP 100 *
FROM
    OPENROWSET(
        BULK ('trip_data_green_csv/year=2020/month=01/*.csv', 'trip_data_green_csv/year=2020/month=02/*.csv'),
        data_source = 'nyc_taxi_data_raw',
        FORMAT = 'CSV',
        PARSER_VERSION = '2.0',
        Header_row = true
    ) AS trip_green_taxi

-- get more than 1 wildcard
SELECT
    TOP 100 *
FROM
    OPENROWSET(
        BULK 'trip_data_green_csv/year=*/month=*/*.csv',
        data_source = 'nyc_taxi_data_raw',
        FORMAT = 'CSV',
        PARSER_VERSION = '2.0',
        Header_row = true
    ) AS trip_green_taxi

-- file metadata function filename()
SELECT
    TOP 100
    trip_green_taxi.filename() AS file_name,
    trip_green_taxi.*
FROM
    OPENROWSET(
        BULK 'trip_data_green_csv/year=*/month=*/*.csv',
        data_source = 'nyc_taxi_data_raw',
        FORMAT = 'CSV',
        PARSER_VERSION = '2.0',
        Header_row = true
    ) AS trip_green_taxi


-- record count
SELECT
    trip_green_taxi.filename() AS file_name,
    count(1) record_count
FROM
    OPENROWSET(
        BULK 'trip_data_green_csv/year=*/month=*/*.csv',
        data_source = 'nyc_taxi_data_raw',
        FORMAT = 'CSV',
        PARSER_VERSION = '2.0',
        Header_row = true
    ) AS trip_green_taxi
GROUP BY trip_green_taxi.filename()
ORDER BY trip_green_taxi.filename()

-- where clause

SELECT
    trip_green_taxi.filename() AS file_name,
    count(1) record_count
FROM
    OPENROWSET(
        BULK 'trip_data_green_csv/year=*/month=*/*.csv',
        data_source = 'nyc_taxi_data_raw',
        FORMAT = 'CSV',
        PARSER_VERSION = '2.0',
        Header_row = true
    ) AS trip_green_taxi
WHERE trip_green_taxi.filename() in ('green_tripdata_2020-01.csv','green_tripdata_2021-01.csv')
GROUP BY trip_green_taxi.filename()
ORDER BY trip_green_taxi.filename()

-- file path

SELECT
    trip_green_taxi.filename() AS file_name,
    trip_green_taxi.filepath() AS file_path,
    count(1) record_count
FROM
    OPENROWSET(
        BULK 'trip_data_green_csv/year=*/month=*/*.csv',
        data_source = 'nyc_taxi_data_raw',
        FORMAT = 'CSV',
        PARSER_VERSION = '2.0',
        Header_row = true
    ) AS trip_green_taxi
WHERE trip_green_taxi.filename() in ('green_tripdata_2020-01.csv','green_tripdata_2021-01.csv')
GROUP BY trip_green_taxi.filename(),trip_green_taxi.filepath()
ORDER BY trip_green_taxi.filename(),trip_green_taxi.filepath()

-- number means the position of the wildcard in 'BULK'

SELECT
    trip_green_taxi.filepath(1) AS year,
    trip_green_taxi.filepath(2) AS month,
    count(1) record_count
FROM
    OPENROWSET(
        BULK 'trip_data_green_csv/year=*/month=*/*.csv',
        data_source = 'nyc_taxi_data_raw',
        FORMAT = 'CSV',
        PARSER_VERSION = '2.0',
        Header_row = true
    ) AS trip_green_taxi
WHERE trip_green_taxi.filename() in ('green_tripdata_2020-01.csv','green_tripdata_2021-01.csv')
GROUP BY trip_green_taxi.filename(),trip_green_taxi.filepath(1),trip_green_taxi.filepath(2)
ORDER BY trip_green_taxi.filename(),trip_green_taxi.filepath(1),trip_green_taxi.filepath(2)

-- where clause

SELECT
    trip_green_taxi.filepath(1) AS year,
    trip_green_taxi.filepath(2) AS month,
    count(1) record_count
FROM
    OPENROWSET(
        BULK 'trip_data_green_csv/year=*/month=*/*.csv',
        data_source = 'nyc_taxi_data_raw',
        FORMAT = 'CSV',
        PARSER_VERSION = '2.0',
        Header_row = true
    ) AS trip_green_taxi
WHERE trip_green_taxi.filepath(1)='2020' and trip_green_taxi.filepath(2) in ('06','07','08')
GROUP BY trip_green_taxi.filename(),trip_green_taxi.filepath(1),trip_green_taxi.filepath(2)
ORDER BY trip_green_taxi.filename(),trip_green_taxi.filepath(1),trip_green_taxi.filepath(2)
