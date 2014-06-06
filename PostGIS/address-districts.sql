-- View: public.address_districts

-- DROP VIEW public.address_districts;

CREATE OR REPLACE VIEW public.address_districts AS 
 SELECT registered_voters.res_address_1,
    registered_voters.city,
    registered_voters.county,
    registered_voters.state,
    registered_voters.zip_code,
    district_precinct_detail.district_code,
    district_precinct_detail.district_name,
    district_precinct_detail.district_type
   FROM registered_voters,
    district_precinct_detail
  WHERE district_precinct_detail.district_code <> 'FED'::text AND district_precinct_detail.district_code <> 'State Par'::text AND district_precinct_detail.district_code <> 'State NP'::text AND registered_voters.county = district_precinct_detail.county AND registered_voters.precinct = district_precinct_detail.precinct AND registered_voters.split = district_precinct_detail.split;

ALTER TABLE public.address_districts
  OWNER TO znmeb;
