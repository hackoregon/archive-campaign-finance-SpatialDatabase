
-- address standardization pass
DROP TABLE IF EXISTS orestar.tran_addresses CASCADE;
CREATE TABLE orestar.tran_addresses AS
SELECT
  tran_id,
  normalize_address(concat_ws(' ',
    replace(addr_line1, '*', ''),
    COALESCE(addr_line2, ' '),
    city,
    state,
    zip
  )) AS addy
FROM orestar.raw_committee_transactions
WHERE addr_line1 IS NOT NULL
AND city IS NOT NULL
AND state IS NOT NULL
AND zip IS NOT NULL LIMIT 1000;

-- geocode pass
DROP TABLE IF EXISTS orestar.tran_geocodes CASCADE;
CREATE TABLE orestar.tran_geocodes AS
SELECT a.tran_id, g.rating, g.geomout
FROM orestar.tran_addresses AS a, geocode(a.addy, 1) AS g;
