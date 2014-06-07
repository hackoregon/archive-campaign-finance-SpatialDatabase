CREATE EXTENSION IF NOT EXISTS adminpack;
CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;
DROP DATABASE IF EXISTS znmeb;
DROP DATABASE IF EXISTS voter_reg;
DROP DATABASE IF EXISTS geocoder;
DROP ROLE IF EXISTS znmeb;

CREATE ROLE znmeb 
  WITH LOGIN NOSUPERUSER INHERIT CREATEDB NOCREATEROLE NOREPLICATION;
\password znmeb

CREATE DATABASE znmeb
  WITH OWNER znmeb;
\connect znmeb
\i create-postgis-extensions.sql

CREATE DATABASE voter_reg
  WITH OWNER znmeb;
\connect voter_reg
\i create-postgis-extensions.sql

CREATE DATABASE geocoder
  WITH OWNER postgres;
\connect geocoder
\i create-postgis-extensions.sql
\i create-geocoder-extensions.sql
