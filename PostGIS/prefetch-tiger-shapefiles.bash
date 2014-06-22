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

sudo mkdir -p /gisdata
sudo chown -R ${USER}:${USER} /gisdata
cd /gisdata

for i in STATE COUNTY CD ZCTA5 SLDU SLDL ELSD SCSD UNSD \
  PLACE COUSUB TRACT TABBLOCK BG FACES FEATNAMES EDGES ADDR
do
  echo fetching ${i}
  time wget \
    --quiet \
    --no-parent \
    --relative \
    --recursive \
    --level=1 \
    --accept=zip \
    --reject=html \
    --mirror \
    "ftp://ftp2.census.gov/geo/tiger/TIGER2013/${i}/tl*zip" 
  echo ${i} fetched
done

# state ZIP codes - geocoder needs them
echo fetching ZCTA5
time wget 
  --quiet \
  --no-parent \
  --relative \
  --recursive \
  --level=1 \
  --accept=zip \
  --reject=html \
  --mirror \
  ftp://ftp2.census.gov/geo/tiger/TIGER2010/ZCTA5/2010/tl_2010_[!u]*zip
echo ZCTA5 fetched
