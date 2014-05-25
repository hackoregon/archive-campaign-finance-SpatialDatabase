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
su - postgres -c \
  "psql -d ${1} -c 'CREATE EXTENSION fuzzystrmatch;'"
su - postgres -c \
  "psql -d ${1} -c 'CREATE EXTENSION postgis_tiger_geocoder;'"
su - postgres -c \
  "psql -d ${1} -c 'GRANT USAGE ON SCHEMA tiger TO PUBLIC;'"
su - postgres -c \
  "psql -d ${1} -c 'GRANT USAGE ON SCHEMA tiger_data TO PUBLIC;'"
su - postgres -c \
  "psql -d ${1} -c 'GRANT SELECT, REFERENCES, TRIGGER ON ALL TABLES IN SCHEMA tiger TO PUBLIC;'"
su - postgres -c \
  "psql -d ${1} -c 'GRANT SELECT, REFERENCES, TRIGGER ON ALL TABLES IN SCHEMA tiger_data TO PUBLIC;'"
su - postgres -c \
  "psql -d ${1} -c 'GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA tiger TO PUBLIC;'"
su - postgres -c \
  "psql -d ${1} -c 'ALTER DEFAULT PRIVILEGES IN SCHEMA tiger_data GRANT SELECT, REFERENCES ON TABLES TO PUBLIC;'"
