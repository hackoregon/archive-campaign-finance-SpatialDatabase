UPDATE orestar.raw_committee_transactions
SET
(addy, geomout, rating, lon, lat) = (
  (g).addy,
  (g).geomout,
  COALESCE((g).rating, 9999),
  ST_X((g).geomout),
  ST_Y((g).geomout)
)
FROM (SELECT * FROM orestar.raw_committee_transactions
WHERE rating IS NULL 
AND addr_line1 IS NOT NULL
AND city IS NOT NULL
AND state IS NOT NULL
AND zip IS NOT NULL
LIMIT 2000) AS a
LEFT JOIN LATERAL
  geocode(concat_ws(' ', 
    replace(a.addr_line1, '*', ''), 
    COALESCE(a.addr_line2, ' '),
    a.city, 
    a.state, 
    a.zip
  ), 1)
AS g
ON ((g).rating < 9999)
WHERE a.tran_id = orestar.raw_committee_transactions.tran_id;
