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

# create schema
psql -d geocoder -c "DROP SCHEMA IF EXISTS districts CASCADE;"
psql -d geocoder -c "CREATE SCHEMA districts AUTHORIZATION ${USER};"

# make workspace
sudo mkdir -p /gisdata/bash
sudo chown -R ${USER}:${USER} /gisdata
cd /gisdata
for i in STATE COUNTY CD ZCTA5 SLDU SLDL ELSD SCSD UNSD
do
  SOURCE=`find shapefiles/${i} -name '*.shp'`
  DEST=`echo ${i} | tr [:upper:] [:lower:]`
  shp2pgsql -s 4269 -d -I ${SOURCE} districts.${DEST} \
    | psql -d geocoder 2>&1 \
    | grep -v ^INSERT
done

# optimize
psql -d geocoder -c "VACUUM VERBOSE ANALYZE;"
