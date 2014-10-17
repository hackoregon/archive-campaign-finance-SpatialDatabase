UPDATE geocoded_committees
SET
(geojson, rating) = (ST_AsGeoJSON((g).geomout), COALESCE((g).rating, 9999))
FROM (SELECT * FROM geocoded_committees WHERE rating IS NULL) AS a
LEFT JOIN LATERAL geocode(a.treasurer_mailing_address, 1) AS g
ON ((g).rating < 9999)
WHERE a.zcommittee_id = geocoded_committees.zcommittee_id;
