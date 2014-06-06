DROP TABLE IF EXISTS district_precinct_detail CASCADE;
CREATE TABLE district_precinct_detail (
  county text,
  precinct text,
  precinct_name text,
  split text,
  district_code text,
  district_name text,
  district_type text
);
ALTER TABLE district_precinct_detail OWNER TO znmeb;
\copy district_precinct_detail from '/gisdata/DistrictPrecinctDetail.txt';
