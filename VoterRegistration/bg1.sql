UPDATE voter_reg.addresses
SET
(geom, geojson, rating) = (
  (g).geomout, ST_AsGeoJSON((g).geomout), COALESCE((g).rating, 9999)
)
FROM (
  SELECT * FROM voter_reg.addresses
  WHERE rating IS NULL
  AND addid % 6 = 1
  LIMIT 10000
) AS a
LEFT JOIN LATERAL geocode(a.address, 1) AS g
ON ((g).rating < 9999)
WHERE a.addid = voter_reg.addresses.addid;
