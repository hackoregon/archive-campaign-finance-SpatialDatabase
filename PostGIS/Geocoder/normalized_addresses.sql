DROP TABLE IF EXISTS public.normalized_addresses;

CREATE TABLE public.normalized_addresses
(
  status text,
  party_code text,
  county text,
  precinct text,
  split text,
  normalized_address norm_addy
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.normalized_addresses
  OWNER TO znmeb;

\copy normalized_addresses FROM '/gisdata/geocoder-data/headerless.csv' WITH (FORMAT CSV);
