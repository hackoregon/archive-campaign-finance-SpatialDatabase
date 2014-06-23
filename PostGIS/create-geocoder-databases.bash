#! /bin/bash
#
# Copyright (C) 2014 by M. Edward (Ed) Borasky
#
# This program is licensed to you under the terms of version 3 of the
# GNU Affero General Public License. This program is distributed WITHOUT
# ANY EXPRESS OR IMPLIED WARRANTY, INCLUDING THOSE OF NON-INFRINGEMENT,
# MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. Please refer to the
# AGPL (http://www.gnu.org/licenses/agpl-3.0.txt) for more details.
#

for i in \
  "DROP DATABASE IF EXISTS or_geocoder;" \
  "CREATE DATABASE or_geocoder WITH OWNER ${USER};" \
  "DROP DATABASE IF EXISTS us_geocoder;" \
  "CREATE DATABASE us_geocoder WITH OWNER ${USER};"
do
  sudo su - postgres -c "psql -d postgres -c '${i}'"
done

for j in or us
do
  for i in \
    "CREATE EXTENSION IF NOT EXISTS postgis;" \
    "CREATE EXTENSION IF NOT EXISTS postgis_topology;" \
    "CREATE EXTENSION IF NOT EXISTS fuzzystrmatch;" \
    "CREATE EXTENSION IF NOT EXISTS postgis_tiger_geocoder;" \
    "CREATE EXTENSION IF NOT EXISTS address_standardizer;" \
    "GRANT USAGE ON SCHEMA tiger TO PUBLIC;" \
    "GRANT USAGE ON SCHEMA tiger_data TO PUBLIC;" \
    "GRANT SELECT, REFERENCES, TRIGGER ON ALL TABLES IN SCHEMA tiger TO PUBLIC;" \
    "GRANT SELECT, REFERENCES, TRIGGER ON ALL TABLES IN SCHEMA tiger_data TO PUBLIC;" \
    "GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA tiger TO PUBLIC;" \
    "ALTER DEFAULT PRIVILEGES IN SCHEMA tiger_data GRANT SELECT, REFERENCES ON TABLES TO PUBLIC;"
  do
    sudo su - postgres -c "psql -d ${j}_geocoder -c '${i}'"
  done
done
