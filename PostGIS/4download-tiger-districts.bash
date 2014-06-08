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

# make shapefile destinations
sudo mkdir -p /gisdata
sudo chown -R ${USER}:${USER} /gisdata
cp create-postgis-extensions.sql /gisdata
cd /gisdata

# Grab documentation
for i in \
  http://www.census.gov/geo/maps-data/data/pdfs/tiger/tgrshp2013/TGRSHP2013_TechDoc.pdf \
  http://www.census.gov/geo/education/pdfs/tiger/Downloading_TIGERLine_Shp.pdf \
  http://www.census.gov/geo/education/pdfs/tiger/2_Opening.pdf \
  http://www.census.gov/geo/education/pdfs/tiger/Downloading_AFFData.pdf \
  http://www.census.gov/geo/education/pdfs/tiger/JoiningTIGERshp_with_AFFdata.pdf \
  http://www.census.gov/geo/education/pdfs/tiger/JoiningTIGERshp_with_AFFdata.pdf \
  http://www.census.gov/geo/education/pdfs/tiger/AFF_TIGERLine_Joining_Presentation.pdf \
  http://www.census.gov/geo/education/pdfs/brochures/Geocoding.pdf \
  ftp://ftp.census.gov/geo/tiger/TIGER2013/2013-FolderNames-Defined.pdf
do
  wget -q -nc ${i}
done

# Grab shapefiles
rm -fr shapefiles
for i in \
  congress_districts \
  elementary_school_districts \
  secondary_school_districts \
  unified_school_districts \
  state_legislature_lower_districts \
  state_legislature_upper_districts
do
  mkdir -p shapefiles/${i}
done

# download data
for i in \
  ftp://ftp.census.gov/geo/tiger/TIGER2013/CD/tl* \
  ftp://ftp.census.gov/geo/tiger/TIGER2013/ELSD/tl_*_41_* \
  ftp://ftp.census.gov/geo/tiger/TIGER2013/SCSD/tl_*_41_* \
  ftp://ftp.census.gov/geo/tiger/TIGER2013/UNSD/tl_*_41_* \
  ftp://ftp.census.gov/geo/tiger/TIGER2013/SLDL/tl_*_41_* \
  ftp://ftp.census.gov/geo/tiger/TIGER2013/SLDU/tl_*_41_*
do
  wget ${i} --quiet --no-parent --relative --recursive --level=1 --accept=zip \
    --mirror --reject=html 
done

# unzip
unzip -o -d shapefiles/congress_districts \
  ftp.census.gov/geo/tiger/TIGER2013/CD/tl*
unzip -o -d shapefiles/elementary_school_districts \
  ftp.census.gov/geo/tiger/TIGER2013/ELSD/tl_*_41_*
unzip -o -d shapefiles/secondary_school_districts \
  ftp.census.gov/geo/tiger/TIGER2013/SCSD/tl_*_41_*
unzip -o -d shapefiles/unified_school_districts \
  ftp.census.gov/geo/tiger/TIGER2013/UNSD/tl_*_41_*
unzip -o -d shapefiles/state_legislature_lower_districts \
  ftp.census.gov/geo/tiger/TIGER2013/SLDL/tl_*_41_*
unzip -o -d shapefiles/state_legislature_upper_districts \
  ftp.census.gov/geo/tiger/TIGER2013/SLDU/tl_*_41_*

# push into databases
for i in \
  congress_districts \
  elementary_school_districts \
  secondary_school_districts \
  unified_school_districts \
  state_legislature_lower_districts \
  state_legislature_upper_districts
do
  pushd shapefiles/${i}
  psql -U ${USER} -d ${USER} -c "DROP DATABASE IF EXISTS ${i};"
  psql -U ${USER} -d ${USER} -c "CREATE DATABASE ${i} WITH OWNER ${USER};"
  psql -U postgres -d ${i} -f "/gisdata/create-postgis-extensions.sql"
  shp2pgsql \
    -s 4269 \
    -W LATIN1 \
    -c \
    -I \
    tl*shp \
    | psql -U ${USER} -d ${i} > /dev/null
  pg_dump \
    --username=postgres \
    --format=custom \
    --compress=9 \
    --file="/gisdata/${i}.pgdump" \
    ${i}
  popd
done
