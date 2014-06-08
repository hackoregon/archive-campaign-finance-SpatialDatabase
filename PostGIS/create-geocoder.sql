DROP DATABASE IF EXISTS geocoder;
CREATE DATABASE geocoder
  WITH OWNER postgres;
\connect geocoder
\i create-postgis-extensions.sql
\i create-geocoder-extensions.sql
