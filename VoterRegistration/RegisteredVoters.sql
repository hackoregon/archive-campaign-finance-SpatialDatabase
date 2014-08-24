
-- get raw registered voter list
DROP TABLE IF EXISTS voter_reg.registered_voters CASCADE;
CREATE TABLE voter_reg.registered_voters (
  voter_id text,
  first_name text,
  middle_name text,
  last_name text,
  name_suffix text,
  birth_date text,
  confidential text,
  eff_regn_date text,
  status text,
  party_code text,
  phone_num text,
  unlisted text,
  county text,
  res_address_1 text,
  res_address_2 text,
  house_num text,
  house_suffix text,
  pre_direction text,
  street_name text,
  street_type text,
  post_direction text,
  unit_type text,
  unit_num text,
  addr_non_std text,
  city text,
  state text,
  zip_code text,
  zip_plus_four text,
  eff_address_1 text,
  eff_address_2 text,
  eff_address_3 text,
  eff_address_4 text,
  eff_city text,
  eff_state text,
  eff_zip_code text,
  eff_zip_plus_four text,
  absentee_type text,
  precinct_name text,
  precinct text,
  split text
);
\copy voter_reg.registered_voters from '/gisdata/RegisteredVoters.txt';
ALTER TABLE voter_reg.registered_voters ADD COLUMN row_id serial NOT NULL PRIMARY KEY;
ALTER TABLE voter_reg.registered_voters OWNER TO znmeb;

-- count voters by county
DROP TABLE IF EXISTS voter_reg.counties CASCADE;
CREATE TABLE voter_reg.counties AS
SELECT DISTINCT
  upper(trim(both ' ' from county)),
  COUNT(row_id) AS voters
FROM voter_reg.registered_voters
GROUP BY county
ORDER BY voters DESC;
ALTER TABLE voter_reg.counties OWNER TO znmeb;
\copy (select * from voter_reg.counties) to '/gisdata/Counties.csv' (format csv, header);

-- extract distinct 'splits'
DROP TABLE IF EXISTS voter_reg.vrsplits CASCADE;
CREATE TABLE voter_reg.vrsplits AS
SELECT DISTINCT
  upper(trim(both ' ' from state)) AS state,
  upper(trim(both ' ' from county)) AS county,
  upper(trim(both ' ' from precinct_name)) AS precinct_name,
  upper(trim(both ' ' from precinct)) AS precinct,
  upper(trim(both ' ' from split)) AS split,
  COUNT(row_id) AS voters
FROM voter_reg.registered_voters
GROUP BY state, county, precinct_name, precinct, split
ORDER BY voters DESC;
ALTER TABLE voter_reg.vrsplits OWNER TO znmeb;
\copy (select * from voter_reg.vrsplits) to '/gisdata/VRsplits.csv' (format csv, header);

-- extract distinct districts
DROP TABLE IF EXISTS voter_reg.districts CASCADE;
CREATE TABLE voter_reg.districts AS
SELECT DISTINCT
  upper(trim(both ' ' from d.district_code)) AS district_code,
  upper(trim(both ' ' from d.district_name)) AS district_name,
  upper(trim(both ' ' from d.district_type)) AS district_type,
  SUM(s.voters) AS voters
FROM voter_reg.cisplits AS d, voter_reg.vrsplits AS s
WHERE upper(trim(both ' ' from d.county)) = s.county 
AND upper(trim(both ' ' from d.precinct_name)) = s.precinct_name
AND upper(trim(both ' ' from d.precinct)) = s.precinct 
AND upper(trim(both ' ' from d.split)) = s.split
GROUP BY d.district_code, d.district_name, d.district_type
ORDER BY voters DESC;
ALTER TABLE voter_reg.districts OWNER TO znmeb;
\copy (select * from voter_reg.districts) to '/gisdata/Districts.csv' (format csv, header);

-- extract distinct addresses
DROP TABLE IF EXISTS voter_reg.addresses CASCADE; 
CREATE TABLE voter_reg.addresses AS
SELECT DISTINCT 
  upper(trim(both ' ' from concat_ws(
  ' ', res_address_1, city, state, zip_code))) AS address,
  upper(trim(both ' ' from county)) AS county,
  upper(trim(both ' ' from precinct_name)) AS precinct_name,
  upper(trim(both ' ' from precinct)) AS precinct,
  upper(trim(both ' ' from split)) AS split,
  COUNT(voter_id) AS voters
FROM voter_reg.registered_voters
GROUP BY address, county, precinct, precinct_name, split;
ALTER TABLE voter_reg.addresses OWNER TO znmeb;
CREATE INDEX ON voter_reg.addresses (address);
CREATE INDEX ON voter_reg.addresses (county);
CREATE INDEX ON voter_reg.addresses (precinct);
CREATE INDEX ON voter_reg.addresses (precinct_name);
CREATE INDEX ON voter_reg.addresses (split);

-- add columns for geocoder
ALTER TABLE voter_reg.addresses ADD COLUMN addy norm_addy;
ALTER TABLE voter_reg.addresses ADD COLUMN geomout geometry;
ALTER TABLE voter_reg.addresses ADD COLUMN rating integer;
ALTER TABLE voter_reg.addresses ADD COLUMN lon double precision;
ALTER TABLE voter_reg.addresses ADD COLUMN lat double precision;
ALTER TABLE voter_reg.addresses ADD COLUMN srid text;
ALTER TABLE voter_reg.addresses ADD COLUMN addid serial NOT NULL PRIMARY KEY;

-- drop unused columns
ALTER TABLE voter_reg.registered_voters DROP voter_id;
ALTER TABLE voter_reg.registered_voters DROP first_name;
ALTER TABLE voter_reg.registered_voters DROP middle_name;
ALTER TABLE voter_reg.registered_voters DROP last_name;
ALTER TABLE voter_reg.registered_voters DROP name_suffix;
ALTER TABLE voter_reg.registered_voters DROP birth_date;
ALTER TABLE voter_reg.registered_voters DROP confidential;
ALTER TABLE voter_reg.registered_voters DROP eff_regn_date;
ALTER TABLE voter_reg.registered_voters DROP status;
ALTER TABLE voter_reg.registered_voters DROP party_code;
ALTER TABLE voter_reg.registered_voters DROP phone_num;
ALTER TABLE voter_reg.registered_voters DROP unlisted;
ALTER TABLE voter_reg.registered_voters DROP eff_address_1;
ALTER TABLE voter_reg.registered_voters DROP eff_address_2;
ALTER TABLE voter_reg.registered_voters DROP eff_address_3;
ALTER TABLE voter_reg.registered_voters DROP eff_address_4;
ALTER TABLE voter_reg.registered_voters DROP eff_city;
ALTER TABLE voter_reg.registered_voters DROP eff_state;
ALTER TABLE voter_reg.registered_voters DROP eff_zip_code;
ALTER TABLE voter_reg.registered_voters DROP eff_zip_plus_four;
