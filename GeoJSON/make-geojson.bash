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
mkdir -p /gisdata/GeoJSON
mkdir -p /gisdata/TopoJSON
mkdir -p /gisdata/ZippedGeoJSON

# 'Political' entities
for i in \
  ftp2.census.gov/geo/tiger/TIGER2014/STATE \
  ftp2.census.gov/geo/tiger/TIGER2014/CD \
  ftp2.census.gov/geo/tiger/TIGER2014/COUNTY \
  ftp2.census.gov/geo/tiger/TIGER2014/SLDU \
  ftp2.census.gov/geo/tiger/TIGER2014/SLDL \
  ftp2.census.gov/geo/tiger/TIGER2014/UNSD \
  ftp2.census.gov/geo/tiger/TIGER2014/SCSD \
  ftp2.census.gov/geo/tiger/TIGER2014/ELSD \
  ftp2.census.gov/geo/tiger/TIGER2012/VTD \
  ftp2.census.gov/geo/tiger/TIGER2010/ZCTA5/2010
do

  # all the zipfiles in the entity
  export ARCHIVES=`find ${i} -name '*.zip'`
  for j in ${ARCHIVES}
  do
    rm -fr temp; mkdir temp
    unzip -d temp ${j}
    pushd temp

    # create file name symbols
    export SHAPEFILE=`find . -name '*.shp' | sed 's;./;;'`
    if [ "${SHAPEFILE}" == "tl_2010_us_zcta510.shp" ]
    then
      echo "tl_2010_us_zcta510.shp is a bad news bear; skipping"
      break
    fi
    export GEOJSON=`echo ${SHAPEFILE} | sed 's;.shp;.geojson;'`
    export TOPOJSON=`echo ${SHAPEFILE} | sed 's;.shp;.topojson;'`
    export ZIPFILE="/gisdata/ZippedGeoJSON/${GEOJSON}.zip"

    # reproject the shapefile - TopoJSON wants that done for it
    ogr2ogr -f 'ESRI Shapefile' -t_srs EPSG:4326 temp.shp ${SHAPEFILE}
    ogr2ogr -f GeoJSON ${GEOJSON} temp.shp
    zip -9u ${ZIPFILE} ${GEOJSON}
    mv ${GEOJSON} /gisdata/GeoJSON/
    echo "Made /gisdata/GeoJSON/${GEOJSON}"
    echo "Made ${ZIPFILE}"

    # make TopoJSON
    topojson -o ${TOPOJSON} --shapefile-encoding utf8  -- temp.shp
    mv ${TOPOJSON} /gisdata/TopoJSON/
    echo "Made /gisdata/TopoJSON/${TOPOJSON}"
    
    popd
  done
done
