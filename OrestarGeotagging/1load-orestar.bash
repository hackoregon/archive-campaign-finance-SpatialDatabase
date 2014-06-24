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

# create an 'orestar' schema in the 'us_geocoder' database
for i in \
  "DROP SCHEMA IF EXISTS orestar CASCADE;" \
  "CREATE SCHEMA orestar AUTHORIZATION ${USER};"
do
  sudo su - postgres -c "psql -d us_geocoder -c '${i}'"
done

# restore the ORESTAR files - they go into 'public' schema by default
sudo su - postgres -c "bzip2 -dc ${1} | psql -d us_geocoder"

# move the tables to the orestar schema
for i in \
  "ALTER TABLE raw_committees OWNER TO ${USER};" \
  "ALTER TABLE raw_committees SET SCHEMA orestar;" \
  "ALTER TABLE raw_committee_transactions OWNER TO ${USER};" \
  "ALTER TABLE raw_committee_transactions ADD COLUMN addy norm_addy;" \
  "ALTER TABLE raw_committee_transactions ADD COLUMN geomout geometry;" \
  "ALTER TABLE raw_committee_transactions ADD COLUMN rating integer;" \
  "ALTER TABLE raw_committee_transactions ADD COLUMN lon double precision;" \
  "ALTER TABLE raw_committee_transactions ADD COLUMN lat double precision;" \
  "ALTER TABLE raw_committee_transactions SET SCHEMA orestar;"
do
  sudo su - postgres -c "psql -d us_geocoder -c '${i}'"
done
