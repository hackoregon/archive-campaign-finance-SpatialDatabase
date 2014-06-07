SELECT 
  district_precinct_detail.county, 
  district_precinct_detail.precinct, 
  district_precinct_detail.precinct_name, 
  district_precinct_detail.split, 
  district_precinct_detail.district_code, 
  district_precinct_detail.district_name, 
  district_precinct_detail.district_type
FROM 
  public.district_precinct_detail
WHERE 
  district_precinct_detail.district_type != 'FEDERAL STATEWIDE' AND 
  district_precinct_detail.district_type != 'STATEWIDE PARTISAN' AND 
  district_precinct_detail.district_type != 'STATEWIDE NONPARTISAN'
ORDER BY
  district_precinct_detail.county ASC, 
  district_precinct_detail.precinct ASC, 
  district_precinct_detail.split ASC, 
  district_precinct_detail.district_code ASC;
