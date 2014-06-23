UPDATE voter_reg.addresses
SET
(addy, geomout, rating, lon, lat) = (
  (g).addy,
  (g).geomout,
  COALESCE((g).rating, 9999),
  ST_X((g).geomout),
  ST_Y((g).geomout)
)
FROM (SELECT * FROM voter_reg.addresses
WHERE rating IS NULL LIMIT 2000) AS a
LEFT JOIN LATERAL
  geocode(concat_ws(' ', a.res_address_1, a.city, a.state, a.zip_code), 1)
AS g
ON ((g).rating < 9999)
WHERE a.addid = voter_reg.addresses.addid;
