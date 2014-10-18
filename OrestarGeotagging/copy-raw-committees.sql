DROP TABLE IF EXISTS geocoded_committees;
CREATE TABLE geocoded_committees TABLESPACE spatial AS 
  SELECT committee_id, treasurer_mailing_address
  FROM raw_committees 
  WHERE treasurer_mailing_address IS NOT NULL
  AND treasurer_mailing_address !~ '\*'
  AND treasurer_mailing_address !~ '\?'
;
CREATE INDEX ON geocoded_committees (treasurer_mailing_address);
ALTER TABLE geocoded_committees
  ADD COLUMN zcommittee_id serial NOT NULL PRIMARY KEY;
ALTER TABLE geocoded_committees ADD COLUMN addy norm_addy;
ALTER TABLE geocoded_committees ADD COLUMN geom geometry;
ALTER TABLE geocoded_committees ADD COLUMN geojson text;
ALTER TABLE geocoded_committees ADD COLUMN rating integer;
VACUUM ANALYZE geocoded_committees;
