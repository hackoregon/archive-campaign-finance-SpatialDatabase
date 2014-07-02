
-- address standardization pass
DROP TABLE IF EXISTS orestar.committee_addresses CASCADE;
CREATE TABLE orestar.committee_addresses AS
SELECT
  committee_id,
  normalize_address(treasurer_mailing_address) AS addy
FROM orestar.raw_committees
WHERE treasurer_mailing_address IS NOT NULL;

-- geocode pass
DROP TABLE IF EXISTS orestar.committee_geocodes CASCADE;
CREATE TABLE orestar.committee_geocodes AS
SELECT a.committee_id, g.rating, g.geomout
FROM orestar.committee_addresses AS a, geocode(a.addy, 1) AS g;
