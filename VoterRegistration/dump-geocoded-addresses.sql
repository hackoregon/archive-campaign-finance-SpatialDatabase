CREATE INDEX ON voter_reg.addresses (geom);
\copy (select * from voter_reg.addresses where rating < 37) to '/gisdata/Addresses.csv' (format csv, header);
