CREATE EXTENSION IF NOT EXISTS adminpack;
CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;
DROP DATABASE IF EXISTS znmeb;
DROP DATABASE IF EXISTS voter_reg;
DROP DATABASE IF EXISTS geocoder;
DROP DATABASE IF EXISTS congress_districts;
DROP DATABASE IF EXISTS elementary_school_districts;
DROP DATABASE IF EXISTS secondary_school_districts;
DROP DATABASE IF EXISTS unified_school_districts;
DROP DATABASE IF EXISTS state_legislature_lower_districts;
DROP DATABASE IF EXISTS state_legislature_upper_districts;
DROP ROLE IF EXISTS znmeb;

CREATE ROLE znmeb 
  WITH LOGIN NOSUPERUSER INHERIT CREATEDB NOCREATEROLE NOREPLICATION;
\password znmeb

CREATE DATABASE znmeb
  WITH OWNER znmeb;
\connect znmeb
\i create-postgis-extensions.sql
