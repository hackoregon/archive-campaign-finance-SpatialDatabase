DROP TABLE IF EXISTS geocoded_transactions;
CREATE TABLE geocoded_transactions TABLESPACE spatial AS 
  SELECT * FROM raw_committee_transactions 
    WHERE addr_line1 IS NOT NULL
    AND addr_line1 !~ '\*'
    AND addr_line1 !~ '\?'
    AND city IS NOT NULL
    AND state IS NOT NULL
    AND zip IS NOT NULL
;
CREATE INDEX ON geocoded_transactions (addr_line1);
CREATE INDEX ON geocoded_transactions (city);
CREATE INDEX ON geocoded_transactions (state);
CREATE INDEX ON geocoded_transactions (zip);
ALTER TABLE geocoded_transactions ADD COLUMN ztran_id serial NOT NULL PRIMARY KEY;
ALTER TABLE geocoded_transactions ADD COLUMN addy norm_addy;
ALTER TABLE geocoded_transactions ADD COLUMN geomout geometry;
ALTER TABLE geocoded_transactions ADD COLUMN rating integer;
ALTER TABLE geocoded_transactions ADD COLUMN lon double precision;
ALTER TABLE geocoded_transactions ADD COLUMN lat double precision;
ALTER TABLE geocoded_transactions ADD COLUMN srid text;
VACUUM ANALYZE geocoded_transactions;
