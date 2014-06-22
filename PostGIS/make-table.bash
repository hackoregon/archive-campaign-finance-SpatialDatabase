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

export i=${1}
cd /gisdata

rm -fr temp; mkdir temp # work area for unzipped shapefiles
SOURCE="ftp2.census.gov/geo/tiger/TIGER2013/${i}/tl_*zip" 
unzip -d temp ${SOURCE}
SHAPEFILES=`find temp -name '*.shp'`
TABLE=`echo ${i} | tr [:upper:] [:lower:]`
echo making table ${TABLE}
time shp2pgsql -s 4269 -W LATIN1 -d -I ${SHAPEFILES} districts.${TABLE} \
  | psql -d districts 2>&1 \
  | grep -v ^INSERT
exit
mkdir -p GeoJSON/${i}
GEOJSON=`echo ${SHAPEFILES} | sed 's/shp/geojson/'`
ogr2ogr -f GeoJSON ${GEOJSON} ${SHAPEFILES}

mkdir -p GeoJSONzip
pushd temp
zip -9ur ../GeoJSONzip/${i}.zip ${GEOJSON}
popd
