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
  "DROP DATABASE IF EXISTS districts;" \
  "CREATE DATABASE districts OWNER ${USER};"
do
  sudo su - postgres -c "psql -d postgres -c '${i}'"
done

for i in \
  "CREATE EXTENSION IF NOT EXISTS postgis;" \
  "CREATE EXTENSION IF NOT EXISTS postgis_topology;" \
  "CREATE EXTENSION IF NOT EXISTS fuzzystrmatch;" \
  "CREATE EXTENSION IF NOT EXISTS postgis_tiger_geocoder;" \
  "GRANT USAGE ON SCHEMA tiger TO PUBLIC;" \
  "GRANT USAGE ON SCHEMA tiger_data TO PUBLIC;" \
  "GRANT SELECT, REFERENCES, TRIGGER ON ALL TABLES IN SCHEMA tiger TO PUBLIC;" \
  "GRANT SELECT, REFERENCES, TRIGGER ON ALL TABLES IN SCHEMA tiger_data TO PUBLIC;" \
  "GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA tiger TO PUBLIC;" \
  "ALTER DEFAULT PRIVILEGES IN SCHEMA tiger_data GRANT SELECT, REFERENCES ON TABLES TO PUBLIC;" \
  "CREATE SCHEMA districts AUTHORIZATION ${USER};"
do
  sudo su - postgres -c "psql -d districts -c '${i}'"
done
