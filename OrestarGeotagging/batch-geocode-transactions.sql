UPDATE geocoded_transactions
SET
(addy, geom, geojson, rating) = (
  (g).addy,
  (g).geomout,
  ST_AsGeoJSON((g).geomout),
  COALESCE((g).rating, 9999)
)
FROM (
  SELECT * FROM geocoded_transactions 
  WHERE rating IS NULL 
  LIMIT 2500
) AS a
LEFT JOIN LATERAL geocode(a.address, 1) AS g
ON ((g).rating < 9999)
WHERE a.ztran_id = geocoded_transactions.ztran_id;
