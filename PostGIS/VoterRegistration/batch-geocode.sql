UPDATE registered_voters
SET
(normalized_address, geomout, rating, lon, lat) = (
  pprint_addy((g).addy),
  (g).geomout,
  COALESCE((g).rating, -1),
  ST_X((g).geomout),
  ST_Y((g).geomout)
)
FROM (SELECT * FROM registered_voters
WHERE rating IS NULL LIMIT 100) AS a
LEFT JOIN LATERAL 
  geocode(concat_ws(' ', a.res_address_1, a.city, a.state, a.zip_code), 1)
AS g
ON ((g).rating < 22)
WHERE a.addid = registered_voters.addid;
