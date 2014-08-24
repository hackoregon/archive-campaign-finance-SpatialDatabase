DROP TABLE IF EXISTS voter_reg.district_precinct_detail CASCADE;
CREATE TABLE voter_reg.district_precinct_detail (
  county text,
  precinct text,
  precinct_name text,
  split text,
  district_code text,
  district_name text,
  district_type text
);
ALTER TABLE voter_reg.district_precinct_detail OWNER TO znmeb;
\copy voter_reg.district_precinct_detail from '/gisdata/DistrictPrecinctDetail.txt';

-- clean and index the table
DROP TABLE IF EXISTS voter_reg.cidpd CASCADE;
CREATE TABLE voter_reg.cidpd AS
SELECT DISTINCT
  upper(trim(both ' ' from county)) AS county,
  upper(trim(both ' ' from precinct_name)) AS precinct_name,
  upper(trim(both ' ' from precinct)) AS precinct,
  upper(trim(both ' ' from split)) AS split,
  upper(trim(both ' ' from district_code)) AS district_code,
  upper(trim(both ' ' from district_name)) AS district_name,
  upper(trim(both ' ' from district_type)) AS district_type
FROM voter_reg.district_precinct_detail;
CREATE INDEX ON voter_reg.cidpd (county);
CREATE INDEX ON voter_reg.cidpd (precinct_name);
CREATE INDEX ON voter_reg.cidpd (precinct);
CREATE INDEX ON voter_reg.cidpd (split);
CREATE INDEX ON voter_reg.cidpd (district_code);
CREATE INDEX ON voter_reg.cidpd (district_name);
CREATE INDEX ON voter_reg.cidpd (district_type);
ALTER TABLE voter_reg.cidpd OWNER TO znmeb;
\copy (select * from voter_reg.cidpd) to '/gisdata/CIDPD.csv' (format csv, header);
