-- Table: district_precinct_detail

DROP TABLE district_precinct_detail;

CREATE TABLE district_precinct_detail
(
  county text,
  precinct text,
  precint_name text,
  split text,
  district_code text,
  district_name text,
  district_type text
)
WITH (
  OIDS=FALSE
);
ALTER TABLE district_precinct_detail
  OWNER TO NEWOWNER;
