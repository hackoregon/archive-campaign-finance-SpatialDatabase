\copy (select * from voter_reg.addresses where rating < 37) to '/gisdata/Addresses.csv' (format csv, header);
