UPDATE geocoded_transactions
SET
(geom, geojson, rating) = (
  (g).geomout,
  ST_AsGeoJSON((g).geomout),
  COALESCE((g).rating, 9999)
)
FROM (
  SELECT * FROM geocoded_transactions 
  WHERE rating IS NULL 
  AND ztran_id % 6 = 0
  LIMIT 2500
) AS a
LEFT JOIN LATERAL geocode(a.address, 1) AS g
ON ((g).rating < 9999)
WHERE a.ztran_id = geocoded_transactions.ztran_id;
