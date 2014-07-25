UPDATE voter_reg.addresses
SET
(addy, geomout, rating, lon, lat, srid) = (
  (g).addy,
  (g).geomout,
  COALESCE((g).rating, 9999),
  ST_X((g).geomout),
  ST_Y((g).geomout),
  '4269'
)
FROM (SELECT * FROM voter_reg.addresses
WHERE rating IS NULL LIMIT 10000) AS a
LEFT JOIN LATERAL geocode(a.address, 1) AS g
ON ((g).rating < 9999)
WHERE a.addid = voter_reg.addresses.addid;
