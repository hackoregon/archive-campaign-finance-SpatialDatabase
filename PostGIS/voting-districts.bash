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

cd /gisdata

TABLE=`echo VTD | tr [:upper:] [:lower:]`
ARCHIVES=`find ftp2.census.gov/geo/tiger/TIGER2012/VTD -name '*.zip'` 
FIRST=1
for i in ${ARCHIVES}
do
  rm -fr temp; mkdir temp
  unzip -d temp ${i}
  SHAPEFILES=`find temp -name '*.shp'`
  if [ ${FIRST} ]
  then
    time shp2pgsql \
      -s 4269 \
      -d \
      -I \
      -W LATIN1 \
      ${SHAPEFILES} districts.${TABLE} \
      | psql -d us_geocoder 2>&1 | grep -v ^INSERT
    unset FIRST
  else
    time shp2pgsql \
      -s 4269 \
      -a \
      -W LATIN1 \
      ${SHAPEFILES} districts.${TABLE} \
      | psql -d us_geocoder 2>&1 | grep -v ^INSERT
  fi
  psql -d us_geocoder -c "VACUUM ANALYZE districts.${TABLE};"
done
