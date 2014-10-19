DROP TABLE IF EXISTS voter_reg.points CASCADE;
CREATE TABLE voter_reg.points AS
SELECT DISTINCT
  upper(trim(both ' ' from county)) AS county,
  upper(trim(both ' ' from precinct)) AS precinct,
  upper(trim(both ' ' from precinct_name)) AS precinct_name,
  upper(trim(both ' ' from split)) AS split,
  COUNT(addid) AS addresses,
  ST_Collect(geom) AS points
FROM voter_reg.addresses
WHERE rating < 37
GROUP BY county, precinct, precinct_name, split
ORDER BY addresses DESC;
ALTER TABLE voter_reg.points OWNER TO znmeb;
