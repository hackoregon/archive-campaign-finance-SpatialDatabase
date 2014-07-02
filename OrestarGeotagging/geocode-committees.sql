
-- address standardization pass
DROP TABLE IF EXISTS orestar.committee_addresses CASCADE;
CREATE TABLE orestar.committee_addresses AS
SELECT
  tran_id,
  normalize_address(concat_ws(' ',
    replace(addr_line1, '*', ''),
    COALESCE(addr_line2, ' '),
    city,
    state,
    zip
  )) AS addy
FROM orestar.raw_committees
WHERE addr_line1 IS NOT NULL
AND city IS NOT NULL
AND state IS NOT NULL
AND zip IS NOT NULL;

-- geocode pass
DROP TABLE IF EXISTS orestar.committee_geocodes CASCADE;
CREATE TABLE orestar.committee_geocodes AS
SELECT tran_id, geocode(addy) FROM orestar.committee_addresses;
