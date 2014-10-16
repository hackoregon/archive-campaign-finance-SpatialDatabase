UPDATE geocoded_transactions
SET
(geomout, rating, srid) = (
  ST_Transform((g).geomout, 4326),
  COALESCE((g).rating, 9999),
  4326
)
FROM (SELECT * FROM geocoded_transactions WHERE rating IS NULL LIMIT 1000) AS a
LEFT JOIN LATERAL geocode(a.address, 1) AS g
ON ((g).rating < 9999)
WHERE a.ztran_id = geocoded_transactions.ztran_id;
