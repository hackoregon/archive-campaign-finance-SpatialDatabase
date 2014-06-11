-- set test data
DROP TABLE IF EXISTS addr_to_geocode;
CREATE TABLE addr_to_geocode(
  addid serial NOT NULL PRIMARY KEY,
  rating integer,
  address text,
  norm_address text,
  pt geometry,
  lat double precision,
  lon double precision
);
INSERT INTO addr_to_geocode(address) VALUES 
  ('18645 SW Farmington Road, Aloha, OR 97007'),
  ('111 SW 5th Ave, Portland, OR 97204'),
  ('14555 SW Teal Blvd, Beaverton, OR 97007'),
  ('17455 SW Farmington Rd, Aloha, OR 97007'),
  ('900 Court St NE, Salem, OR 97301')
;

-- geocode
UPDATE addr_to_geocode
  SET (rating, norm_address, pt, lat, lon) = (
    COALESCE((g).rating, -1),
    pprint_addy((g).addy),
    (g).geomout,
    ST_Y((g).geomout),
    ST_X((g).geomout)
  )
FROM (SELECT * FROM addr_to_geocode WHERE rating IS NULL LIMIT 100) AS a
  LEFT JOIN LATERAL geocode(a.address, 1) AS g
  ON ((g).rating < 22)
WHERE a.addid = addr_to_geocode.addid;

-- display
SELECT * from addr_to_geocode;
