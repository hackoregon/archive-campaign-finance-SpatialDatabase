DROP DATABASE IF EXISTS geocoder;
CREATE DATABASE geocoder
  WITH OWNER postgres;
\connect geocoder
\i create-postgis-extensions.sql
\i create-geocoder-extensions.sql
\o /gisdata/national.bash
\t
\a
SELECT loader_generate_nation_script('sh');
\o
\o /gisdata/oregon.bash
SELECT loader_generate_script(ARRAY['OR'], 'sh');
\o
