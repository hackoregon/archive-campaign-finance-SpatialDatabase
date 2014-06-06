SELECT 
  registered_voters.res_address_1, 
  registered_voters.city, 
  registered_voters.county, 
  registered_voters.state, 
  registered_voters.zip_code, 
  district_precinct_detail.district_code, 
  district_precinct_detail.district_name, 
  district_precinct_detail.district_type
FROM 
  public.registered_voters, 
  public.district_precinct_detail
WHERE 
  registered_voters.county = district_precinct_detail.county AND
  registered_voters.precinct = district_precinct_detail.precinct AND
  registered_voters.split = district_precinct_detail.split AND
  district_precinct_detail.district_code != 'FED' AND 
  district_precinct_detail.district_code != 'State Par' AND 
  district_precinct_detail.district_code != 'State NP';
