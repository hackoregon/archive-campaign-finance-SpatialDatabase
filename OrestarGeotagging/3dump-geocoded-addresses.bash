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

export OUT=/gisdata # where the cleaned files live
sudo mkdir -p ${OUT}
sudo chown -R ${USER}:${USER} ${OUT}

# dump the geocoded tables
psql -d us_geocoder < dump-geocoded-addresses.sql
pushd ${OUT}
zip -9m ${OUT}/ORESTAR.zip \
  GeocodedCommittees.csv \
  GeocodedTransactions.csv
popd

# dump the tables
./dump-table.bash us_geocoder public geocoded_committees 5
./dump-table.bash us_geocoder public geocoded_transactions 5
