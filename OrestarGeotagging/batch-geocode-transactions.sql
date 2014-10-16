UPDATE geocoded_transactions
SET
(geomout, rating, srid) = (
  (g).geomout,
  COALESCE((g).rating, 9999),
  4269
)
FROM (SELECT * FROM geocoded_transactions WHERE rating IS NULL LIMIT 2500) AS a
LEFT JOIN LATERAL geocode(a.address, 1) AS g
ON ((g).rating < 9999)
WHERE a.ztran_id = geocoded_transactions.ztran_id;
