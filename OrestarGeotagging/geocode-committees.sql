UPDATE geocoded_committees
SET
(geomout, rating, srid) = (
  ST_Transform((g).geomout, 4326),
  COALESCE((g).rating, 9999),
  4326  
)
FROM (SELECT * FROM geocoded_committees WHERE rating IS NULL) AS a
LEFT JOIN LATERAL
  geocode(a.treasurer_mailing_address, 1) AS g
ON ((g).rating < 9999)
WHERE a.zcommittee_id = geocoded_committees.zcommittee_id;
