UPDATE normalized_addresses
SET
(geomout, rating, lon, lat) = (
  (g).geomout,
  COALESCE((g).rating, -1),
  ST_X((g).geomout),
  ST_Y((g).geomout)
)
FROM (SELECT * FROM normalized_addresses
WHERE rating IS NULL LIMIT 10000) AS a
LEFT JOIN LATERAL geocode(a.normalized_address, 1) AS g
ON ((g).rating < 22)
WHERE a.addid = normalized_addresses.addid;