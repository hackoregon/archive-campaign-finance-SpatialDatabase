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

export DUMP=${1}

# cleanup first
for i in \
  ac_grass_roots_in_state \
  campaign_detail \
  candidate_by_state \
  cc_grass_roots_in_state \
  cc_working_transactions \
  direction_codes \
  raw_candidate_filings \
  raw_committee_transactions \
  raw_committee_transactions_ammended_transactions \
  raw_committees \
  raw_committees_scraped \
  state_translation \
  working_candidate_committees \
  working_candidate_filings \
  working_committees \
  working_transactions
do
  sudo su - postgres -c "psql -d us_geocoder -c \"DROP TABLE IF EXISTS ${i} CASCADE;\""
done
sudo su - postgres -c "psql -d us_geocoder -c \"DROP SCHEMA IF EXISTS http CASCADE;\""

# restore the ORESTAR files - they go into 'public' schema by default
sudo su - postgres -c "bzip2 -dc ${DUMP} | psql -d us_geocoder"

# make working copies of the input tables for geocoding
export HERE=`pwd`
sudo su - postgres -c \
  "psql -d us_geocoder -f ${HERE}/copy-raw-committees.sql"
sudo su - postgres -c \
  "psql -d us_geocoder -f ${HERE}/copy-raw-committee-transactions.sql"
sudo su - postgres -c \
  "psql -d us_geocoder -c \"ALTER TABLE geocoded_committees OWNER TO ${USER};\""
sudo su - postgres -c \
  "psql -d us_geocoder -c \"ALTER TABLE geocoded_transactions OWNER TO ${USER};\""
