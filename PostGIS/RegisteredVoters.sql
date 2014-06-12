DROP TABLE IF EXISTS registered_voters CASCADE;
CREATE TABLE registered_voters (
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
ALTER TABLE registered_voters OWNER TO znmeb;
\copy registered_voters from '/gisdata/RegisteredVoters.txt';

DROP VIEW IF EXISTS public.duplicate_voter_ids CASCADE;
CREATE OR REPLACE VIEW public.duplicate_voter_ids AS 
 SELECT registered_voters.voter_id,
    count(registered_voters.voter_id) AS id_count
   FROM registered_voters
  GROUP BY registered_voters.voter_id
 HAVING count(registered_voters.voter_id) > 1;

ALTER TABLE public.duplicate_voter_ids
  OWNER TO znmeb;

DROP VIEW IF EXISTS public.show_duplicate_voter_ids CASCADE;
CREATE OR REPLACE VIEW public.show_duplicate_voter_ids AS 
 SELECT registered_voters.voter_id,
    registered_voters.status,
    registered_voters.party_code,
    registered_voters.first_name,
    registered_voters.last_name,
    registered_voters.res_address_1,
    registered_voters.eff_address_1,
    registered_voters.city,
    registered_voters.eff_city,
    registered_voters.state,
    registered_voters.eff_state,
    registered_voters.zip_code,
    registered_voters.eff_zip_code,
    registered_voters.county,
    registered_voters.precinct,
    registered_voters.split
   FROM duplicate_voter_ids,
    registered_voters
  WHERE registered_voters.voter_id = duplicate_voter_ids.voter_id;

ALTER TABLE public.show_duplicate_voter_ids
  OWNER TO znmeb;

DROP VIEW IF EXISTS public.geocoder_input_data CASCADE;

CREATE OR REPLACE VIEW public.geocoder_input_data AS 
 SELECT registered_voters.status,
    registered_voters.party_code,
    registered_voters.county,
    registered_voters.precinct,
    registered_voters.split,
    normalize_address(concat_ws(' '::text, registered_voters.res_address_1, registered_voters.city, registered_voters.state, registered_voters.zip_code)::character varying) AS normalized_address
   FROM registered_voters;

ALTER TABLE public.geocoder_input_data
  OWNER TO znmeb;
