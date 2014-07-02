
-- address standardization pass
DROP TABLE IF EXISTS orestar.stand_addresses CASCADE;
CREATE TABLE orestar.stand_addresses AS
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
AND zip IS NOT NULL;

-- geocode pass
DROP TABLE IF EXISTS orestar.geocodes CASCADE;
CREATE TABLE orestar.geocodes AS
SELECT tran_id, geocode(addy) FROM orestar.stand_addresses;
