DROP TABLE IF EXISTS public.normalized_addresses;
CREATE TABLE public.normalized_addresses
(
  normalized_address norm_addy,
  county text,
  precinct text,
  split text
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.normalized_addresses
  OWNER TO znmeb;
\copy normalized_addresses FROM '/gisdata/geocoder-data/normalized_addresses.csv' WITH (FORMAT CSV);
ALTER TABLE public.normalized_addresses ADD COLUMN geomout geometry;
ALTER TABLE public.normalized_addresses ADD COLUMN rating integer;
ALTER TABLE public.normalized_addresses ADD COLUMN lon double precision;
ALTER TABLE public.normalized_addresses ADD COLUMN lat double precision;
ALTER TABLE public.normalized_addresses ADD COLUMN addid serial PRIMARY KEY;
