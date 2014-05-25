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
for i in \
  congress_districts \
  elementary_school_districts \
  secondary_school_districts \
  unified_school_districts \
  state_legislature_lower_districts \
  state_legislature_upper_districts
do
  rm -fr /gisdata/${i}
  mkdir -p /gisdata/${i}
done

cd /gisdata

# download data
for i in \
  ftp://ftp2.census.gov/geo/tiger/TIGER2013/CD/tl* \
  ftp://ftp2.census.gov/geo/tiger/TIGER2013/ELSD/tl_*_41_* \
  ftp://ftp2.census.gov/geo/tiger/TIGER2013/SCSD/tl_*_41_* \
  ftp://ftp2.census.gov/geo/tiger/TIGER2013/UNSD/tl_*_41_* \
  ftp://ftp2.census.gov/geo/tiger/TIGER2013/SLDL/tl_*_41_* \
  ftp://ftp2.census.gov/geo/tiger/TIGER2013/SLDU/tl_*_41_*
do
  wget ${i} --no-parent --relative --recursive --level=1 --accept=zip \
    --mirror --reject=html 
done

# unzip
unzip -o -d congress_districts \
  ftp2.census.gov/geo/tiger/TIGER2013/CD/tl*
unzip -o -d elementary_school_districts \
  ftp2.census.gov/geo/tiger/TIGER2013/ELSD/tl_*_41_*
unzip -o -d secondary_school_districts \
  ftp2.census.gov/geo/tiger/TIGER2013/SCSD/tl_*_41_*
unzip -o -d unified_school_districts \
  ftp2.census.gov/geo/tiger/TIGER2013/UNSD/tl_*_41_*
unzip -o -d state_legislature_lower_districts \
  ftp2.census.gov/geo/tiger/TIGER2013/SLDL/tl_*_41_*
unzip -o -d state_legislature_upper_districts \
  ftp2.census.gov/geo/tiger/TIGER2013/SLDU/tl_*_41_*

# push into databases
for i in \
  congress_districts \
  elementary_school_districts \
  secondary_school_districts \
  unified_school_districts \
  state_legislature_lower_districts \
  state_legislature_upper_districts
do
  pushd ${i}
  shp2pgsql -d -D -I tl*shp | psql -d ${i}
  popd
done
