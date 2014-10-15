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

# make histogram of ratings - used to choose cutoff
psql -d or_geocoder < create-rating-histogram.sql

# make the point collection table
sed "s/znmeb/${USER}/" create-points.sql | psql -d or_geocoder

# dump the 'addresses' table
psql -d or_geocoder < dump-geocoded-addresses.sql
pushd ${OUT}
zip -9m ${OUT}/VoterReg.zip \
  Addresses.csv
popd

# dump the schema
./dump-schema.bash or_geocoder voter_reg 5
