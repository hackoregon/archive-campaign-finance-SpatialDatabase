* pagc address standardizer is slower than the default. Measurements coming.
* The default standardizer takes 11471049 milliseconds to process 2502343 rows on a 4.0 GHz workstation. That works out to about 4.68 milliseconds per address. The whole run took 3.19 hours.
* Making the normalized_address table:
    1. In PgAdmin, open the SQL window in the 'voter_reg' database.
    1. Enter 'SELECT * FROM geocoder_input_data;'
    1. Execute ***with output to a file*** ('Execute to file') in the 'Query' menu. In the dialog, select ',' as the separator and no header line (uncheck the column names box). This will give you a huge CSV file after a few hours. Set the output file name to '/gisdata/geocoder-data/normalized_addresses.csv'
    1. From a command prompt, type 'psql -U <user> -d voter_reg < normalized_addresses.sql' to read 'normalized_addresses.csv' into the 'normalized_addresses' table.
