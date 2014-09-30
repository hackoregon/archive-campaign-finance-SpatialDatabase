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

sudo chown -R ${USER}:${USER} /gisdata
cd /gisdata
mkdir -p /gisdata/ZippedGeoJSON

# 'Political' entities
for i in STATE CD COUNTY ZCTA5 SLDU SLDL UNSD SCSD ELSD
do

  # all the zipfiles in the entity
  export ARCHIVES=`find ftp2.census.gov/geo/tiger/TIGER2014/${i} -name '*.zip'`
  for j in ${ARCHIVES}
  do
    rm -fr temp; mkdir temp
    unzip -d temp ${j}
    pushd temp
    export SHAPEFILE=`find . -name '*.shp' | sed 's;./;;'`
    export GEOJSON=`echo ${SHAPEFILE} | sed 's;.shp;.geojson;'`
    ogr2ogr -f GeoJSON -t_srs EPSG:4326 ${GEOJSON} ${SHAPEFILE}
    export ZIPFILE="/gisdata/ZippedGeoJSON/${GEOJSON}.zip"
    zip -9u ${ZIPFILE} ${GEOJSON}
    echo "Made ${ZIPFILE}"
    popd
  done
done
