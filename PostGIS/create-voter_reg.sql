CREATE DATABASE voter_reg
  WITH OWNER znmeb;
\connect voter_reg
\i create-postgis-extensions.sql
