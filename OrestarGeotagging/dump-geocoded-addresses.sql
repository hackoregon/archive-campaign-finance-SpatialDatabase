CREATE INDEX ON geocoded_committees (geom);
CREATE INDEX ON geocoded_transactions (geom);
\copy (select * from geocoded_committees) to '/gisdata/GeocodedCommittees.csv' (format csv, header);
\copy (select * from geocoded_transactions) to '/gisdata/GeocodedTransactions.csv' (format csv, header);
