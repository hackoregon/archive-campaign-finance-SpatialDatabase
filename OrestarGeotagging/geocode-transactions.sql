
-- address standardization pass
DROP TABLE IF EXISTS orestar.trans_addresses CASCADE;
CREATE TABLE orestar.trans_addresses AS
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
DROP TABLE IF EXISTS orestar.trans_geocodes CASCADE;
CREATE TABLE orestar.trans_geocodes AS
SELECT tran_id, geocode(addy) FROM orestar.trans_addresses;
