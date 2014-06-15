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

# TIGER/Line® documentation:
#    http://www.census.gov/geo/education/howtos.html
# Folder names:
#   ftp://ftp2.census.gov/geo/tiger/TIGER2013/2013-FolderNames-Defined.pdf
# Dependencies: GDAL - Geospatial Data Abstraction Library 1.11.0 or later
#               wget
#               unzip
#               zip
#
# This should work on Ubuntu; I'll test in the VM
# This might work on MacOS X if you have all the dependencies; someone test ;-)

sudo mkdir -p /gisdata
sudo mkdir -p /gisdata/shapefiles
sudo mkdir -p /gisdata/GeoJSON
sudo mkdir -p /gisdata/GeoJSONzip
sudo chown -R ${USER}:${USER} /gisdata
cp create-postgis-extensions.sql /gisdata
cp dump-database.bash /gisdata
chmod +x /gisdata/*.bash
cd /gisdata

# Grab documentation
mkdir -p docs
pushd docs
for i in \
  http://docs.qgis.org/2.2/pdf/en/QGIS-2.2-UserGuide-en.pdf \
  http://docs.qgis.org/2.2/pdf/en/QGIS-2.2-QGISTrainingManual-en.pdf \
  http://docs.qgis.org/2.2/pdf/en/QGIS-2.2-PyQGISDeveloperCookbook-en.pdf \
  http://postgis.net/stuff/postgis-2.1.pdf \
  http://www.census.gov/geo/maps-data/data/pdfs/tiger/tgrshp2013/TGRSHP2013_TechDoc.pdf \
  http://www.census.gov/geo/education/pdfs/tiger/Downloading_TIGERLine_Shp.pdf \
  http://www.census.gov/geo/education/pdfs/tiger/2_Opening.pdf \
  http://www.census.gov/geo/education/pdfs/tiger/Downloading_AFFData.pdf \
  http://www.census.gov/geo/education/pdfs/tiger/JoiningTIGERshp_with_AFFdata.pdf \
  http://www.census.gov/geo/education/pdfs/tiger/AFF_TIGERLine_Joining_Presentation.pdf \
  http://www.census.gov/geo/education/pdfs/brochures/Geocoding.pdf \
  ftp://ftp2.census.gov/geo/tiger/TIGER2013/2013-FolderNames-Defined.pdf
do
  wget -q -nc ${i}
done
popd

# national
# States: ftp://ftp2.census.gov/geo/tiger/TIGER2013/STATE/
# Counties: ftp://ftp2.census.gov/geo/tiger/TIGER2013/COUNTY/
# Congressional districts: ftp://ftp2.census.gov/geo/tiger/TIGER2013/CD/
# ZIP Code Tabulation Areas: ftp://ftp2.census.gov/geo/tiger/TIGER2013/ZCTA5/
for i in STATE COUNTY CD ZCTA5
do
  wget \
    --quiet \
    --no-parent \
    --relative \
    --recursive \
    --level=1 \
    --accept=zip \
    --reject=html \
    --mirror \
    "ftp://ftp2.census.gov/geo/tiger/TIGER2013/${i}/tl_2013_us*zip" 
  mkdir -p shapefiles/${i}
  unzip -n -u -d shapefiles/${i} \
    "ftp2.census.gov/geo/tiger/TIGER2013/${i}/tl_2013_us*zip" 
  SOURCE=`find shapefiles/${i} -name '*.shp'`
  DEST=`echo ${SOURCE}|sed 's/shp/geojson/'|sed 's/shapefiles/GeoJSON/'`
  mkdir -p GeoJSON/${i}

  # this step will throw errors if the GeoJSON is already done, saving time
  ogr2ogr -f GeoJSON ${DEST} ${SOURCE}
  zip -9ur GeoJSONzip/${i}.zip ${DEST}

  j=`echo ${i} | tr [:upper:] [:lower:]` # database names should be lowercase
  pushd shapefiles/${i}
  psql -U ${USER} -d ${USER} -c "DROP DATABASE IF EXISTS ${j};"
  psql -U ${USER} -d ${USER} -c "CREATE DATABASE ${j} WITH OWNER ${USER};"
  psql -U postgres -d ${j} -f "/gisdata/create-postgis-extensions.sql"
  shp2pgsql \
    -s 4269 \
    -W LATIN1 \
    -c \
    -I \
    tl*shp \
    | psql -U ${USER} -d ${j} > /dev/null
  /gisdata/dump-database.bash ${j}
  popd
done

# state of Oregon
# State Senators: ftp://ftp2.census.gov/geo/tiger/TIGER2013/SLDU/
# State Representatives: ftp://ftp2.census.gov/geo/tiger/TIGER2013/SLDL/
# Elementary School Districts: ftp://ftp2.census.gov/geo/tiger/TIGER2013/ELSD/
# Secondary School Districts: ftp://ftp2.census.gov/geo/tiger/TIGER2013/SCSD/
# Unified School Districts: ftp://ftp2.census.gov/geo/tiger/TIGER2013/UNSD/
# Block Groups: ftp://ftp2.census.gov/geo/tiger/TIGER2013/BG/
# County Subdivisions: ftp://ftp2.census.gov/geo/tiger/TIGER2013/COUSUB/
# Places: ftp://ftp2.census.gov/geo/tiger/TIGER2013/PLACE/
# Tabulation Blocks: ftp://ftp2.census.gov/geo/tiger/TIGER2013/TABBLOCK/
# Tracts: ftp://ftp2.census.gov/geo/tiger/TIGER2013/TRACT/
for i in SLDU SLDL ELSD SCSD UNSD BG COUSUB PLACE TABBLOCK TRACT
do
  wget \
    --quiet \
    --no-parent \
    --relative \
    --recursive \
    --level=1 \
    --accept=zip \
    --reject=html \
    --mirror \
    "ftp://ftp2.census.gov/geo/tiger/TIGER2013/${i}/tl_2013_41*zip" 
  mkdir -p shapefiles/${i}
  unzip -n -u -d shapefiles/${i} \
    "ftp2.census.gov/geo/tiger/TIGER2013/${i}/tl_2013_41*zip" 
  SOURCE=`find shapefiles/${i} -name '*.shp'`
  DEST=`echo ${SOURCE}|sed 's/shp/geojson/'|sed 's/shapefiles/GeoJSON/'`
  mkdir -p GeoJSON/${i}

  # this step will throw errors if the GeoJSON is already done, saving time
  ogr2ogr -f GeoJSON ${DEST} ${SOURCE}
  zip -9ur GeoJSONzip/${i}.zip ${DEST}

  j=`echo ${i} | tr [:upper:] [:lower:]` # database names should be lowercase
  pushd shapefiles/${i}
  psql -U ${USER} -d ${USER} -c "DROP DATABASE IF EXISTS ${j};"
  psql -U ${USER} -d ${USER} -c "CREATE DATABASE ${j} WITH OWNER ${USER};"
  psql -U postgres -d ${j} -f "/gisdata/create-postgis-extensions.sql"
  shp2pgsql \
    -s 4269 \
    -W LATIN1 \
    -c \
    -I \
    tl*shp \
    | psql -U ${USER} -d ${j} > /dev/null
  /gisdata/dump-database.bash ${j}
  popd
done

# Oregon counties - geocoder uses them so we prefetch the shapefiles
# Addresses: ftp://ftp2.census.gov/geo/tiger/TIGER2013/ADDR/
# Edges: ftp://ftp2.census.gov/geo/tiger/TIGER2013/EDGES/
# Faces: ftp://ftp2.census.gov/geo/tiger/TIGER2013/FACES/
# Feature Names: ftp://ftp2.census.gov/geo/tiger/TIGER2013/FEATNAMES/
for i in ADDR EDGES FACES FEATNAMES 
do
  wget \
    --quiet \
    --no-parent \
    --relative \
    --recursive \
    --level=1 \
    --accept=zip \
    --reject=html \
    --mirror \
    "ftp://ftp2.census.gov/geo/tiger/TIGER2013/${i}/tl_2013_41*zip" 
done

# dump the file sizes
pushd ftp2.census.gov/geo/tiger/TIGER2013
echo "Compressed shapefile sizes"
du -sh *
popd
pushd shapefiles
echo "Uncompressed shapefile sizes"
du -sh *
popd
pushd GeoJSON
echo "Uncompressed GeoJSON sizes"
du -sh *
popd
pushd GeoJSONzip
echo "Compressed GeoJSON sizes"
du -sh *
popd
