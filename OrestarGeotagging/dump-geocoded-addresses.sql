\copy (select * from committee_addresses) to '/gisdata/CommitteeAddresses.csv' (format csv, header);
\copy (select * from committee_geocodes) to '/gisdata/CommitteeGeocodes.csv' (format csv, header);
\copy (select * from raw_committee_transactions) to '/gisdata/RawCommitteeTransactions.csv' (format csv, header);
