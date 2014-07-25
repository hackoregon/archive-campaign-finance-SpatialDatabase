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
