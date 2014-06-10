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

# make destinations
sudo mkdir -p /gisdata
sudo chown -R ${USER}:${USER} /gisdata
cd /gisdata

# Grab documentation
mkdir -p docs
pushd docs
for i in \
  http://www2.census.gov/acs2012_5yr/summaryfile/ACS_2008-2012_SF_Tech_Doc.pdf \
  http://www.census.gov/geo/maps-data/data/pdfs/tiger/tgrshp2012/TGRSHP2012_TechDoc.pdf
do
  wget -q -nc ${i}
done
popd

# create directories
mkdir -p census

# download data
wget ftp://ftp2.census.gov/geo/tiger/TIGER_DP/2012ACS/*41.gdb.zip \
  --quiet \
  --no-parent \
  --relative \
  --recursive \
  --level=1 \
  --accept=zip \
  --mirror \
  --reject=html 
