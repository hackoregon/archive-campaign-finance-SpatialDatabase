
-- address standardization pass
DROP TABLE IF EXISTS committee_addresses CASCADE;
CREATE TABLE committee_addresses AS
SELECT
  committee_id,
  normalize_address(treasurer_mailing_address) AS addy
FROM raw_committees
WHERE treasurer_mailing_address IS NOT NULL;

-- geocode pass
DROP TABLE IF EXISTS committee_geocodes CASCADE;
CREATE TABLE committee_geocodes AS
SELECT a.committee_id, g.rating, g.geomout
FROM committee_addresses AS a, geocode(a.addy, 1) AS g;
