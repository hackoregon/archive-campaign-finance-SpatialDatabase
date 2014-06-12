DROP DATABASE IF EXISTS voter_reg;
CREATE DATABASE voter_reg
  WITH OWNER znmeb;
\connect voter_reg
\i create-postgis-extensions.sql
CREATE EXTENSION IF NOT EXISTS fuzzystrmatch;
CREATE EXTENSION IF NOT EXISTS postgis_tiger_geocoder;
