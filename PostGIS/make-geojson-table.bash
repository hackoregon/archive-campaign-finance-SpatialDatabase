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
export pattern=${2}
wget \
  --quiet \
  --no-parent \
  --relative \
  --recursive \
  --level=1 \
  --accept=zip \
  --reject=html \
  --mirror \
  "ftp://ftp2.census.gov/geo/tiger/TIGER2013/${i}/tl_2013_${pattern}*zip" 

# GeoJSON zipped
rm -fr temp; mkdir temp
SOURCE="ftp2.census.gov/geo/tiger/TIGER2013/${i}/tl_2013_${pattern}*zip" 
unzip -d temp ${SOURCE}
SHAPEFILES=`find temp -name '*.shp'`
mkdir -p GeoJSON/${i}
GEOJSON=`echo ${SHAPEFILES} | sed 's/shp/geojson/'`
ogr2ogr -f GeoJSON ${GEOJSON} ${SHAPEFILES}

mkdir -p GeoJSONzip
pushd temp
zip -9ur ../GeoJSONzip/${i}.zip ${GEOJSON}
popd

TABLE=`echo ${i} | tr [:upper:] [:lower:]`
shp2pgsql -s 4269 -W LATIN1 -d -I ${SHAPEFILES} districts.${TABLE} \
  | psql -d geocoder 2>&1 \
  | grep -v ^INSERT
