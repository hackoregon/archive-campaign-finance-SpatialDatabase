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

# go to workspace
cd /gisdata

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

# Grab documentation
echo fetching documentation
mkdir -p docs
pushd docs
for i in \
  http://en.flossmanuals.net/openstreetmap/_booki/openstreetmap/openstreetmap.pdf \
  http://download.osgeo.org/qgis/doc/manual/qgis-1.0.0_a-gentle-gis-introduction_en.pdf \
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

for i in STATE COUNTY CD ZCTA5 SLDU SLDL ELSD SCSD UNSD \
  PLACE COUSUB TRACT TABBLOCK BG FACES FEATNAMES EDGES ADDR
do
  echo fetching ${i}
  time wget \
    --quiet \
    --no-parent \
    --relative \
    --recursive \
    --level=1 \
    --accept=zip \
    --reject=html \
    --mirror \
    "ftp://ftp2.census.gov/geo/tiger/TIGER2013/${i}/tl*zip" 
  echo ${i} fetched
done

# state ZIP codes - geocoder needs them
echo fetching state ZCTA5
time wget \
  --quiet \
  --no-parent \
  --relative \
  --recursive \
  --level=1 \
  --accept=zip \
  --reject=html \
  --mirror \
  ftp://ftp2.census.gov/geo/tiger/TIGER2010/ZCTA5/2010/tl_2010_[!u]*zip
echo ZCTA5 fetched

echo fetching Oregon ACS databases
time wget \
  --quiet \
  --no-parent \
  --relative \
  --recursive \
  --level=1 \
  --accept=zip \
  --reject=html \
  --mirror \
  ftp://ftp2.census.gov/geo/tiger/TIGER_DP/2012ACS/*_41.gdb.zip
echo finished
