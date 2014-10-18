DROP TABLE IF EXISTS geocoded_transactions;
CREATE TABLE geocoded_transactions TABLESPACE spatial AS 
  SELECT tran_id,
    concat_ws(' ', addr_line1, COALESCE(addr_line2, ' '), city, state, zip) 
    AS address
  FROM raw_committee_transactions 
  WHERE addr_line1 IS NOT NULL
  AND addr_line1 !~ '\*'
  AND addr_line1 !~ '\?'
  AND city IS NOT NULL
  AND state IS NOT NULL
  AND zip IS NOT NULL
;
CREATE INDEX ON geocoded_transactions (address);
ALTER TABLE geocoded_transactions
  ADD COLUMN ztran_id serial NOT NULL PRIMARY KEY;
ALTER TABLE geocoded_transactions ADD COLUMN addy norm_addy;
ALTER TABLE geocoded_transactions ADD COLUMN geom geometry;
ALTER TABLE geocoded_transactions ADD COLUMN geojson text;
ALTER TABLE geocoded_transactions ADD COLUMN rating integer;
VACUUM ANALYZE geocoded_transactions;
