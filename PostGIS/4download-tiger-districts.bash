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

# run the GeoJSON creator first to snag all the data
../GeoJSON/make-tiger-geojson.bash

cp create-postgis-extensions.sql /gisdata
cp dump-database.bash /gisdata
cd /gisdata

# Grab documentation
mkdir docs
pushd docs
for i in \
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
  j=`echo ${i} | tr [:upper:] [:lower:]` # database names need to be lowercase
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
# Elementary School Districts: ftp://ftp2.census.gov/geo/tiger/TIGER2013/ELSD/
# Secondary School Districts: ftp://ftp2.census.gov/geo/tiger/TIGER2013/SCSD/
# State Representatives: ftp://ftp2.census.gov/geo/tiger/TIGER2013/SLDL/
# State Senators: ftp://ftp2.census.gov/geo/tiger/TIGER2013/SLDU/
# Unified School Districts: ftp://ftp2.census.gov/geo/tiger/TIGER2013/UNSD/
for i in ELSD SCSD SLDL SLDU UNSD
do
  j=`echo ${i} | tr [:upper:] [:lower:]` # database names need to be lowercase
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
