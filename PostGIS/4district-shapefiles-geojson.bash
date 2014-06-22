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

# create 'districts' schema in 'geocoder' database
for i in
  "DROP SCHEMA IF EXISTS districts CASCADE;" \
  "CREATE SCHEMA districts AUTHORIZATION ${USER};"
do
  sudo su - postgres -c "psql -d geocoder -c '${i}'"
done

# create workspace
sudo mkdir -p /gisdata
sudo mkdir -p /gisdata/shapefiles
sudo mkdir -p /gisdata/GeoJSON
sudo mkdir -p /gisdata/GeoJSONzip
sudo chown -R ${USER}:${USER} /gisdata

# copy the scripts to the workspace
for i in \
  download-shapefiles.bash \
  make-district-table.bash \
  make-geojson.bash
do
  cp ${i} /gisdata/bash
done
chmod +x /gisdata/bash/*.bash

# now go over to the data area
cd /gisdata

# Grab documentation
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

# national
# States: ftp://ftp2.census.gov/geo/tiger/TIGER2013/STATE/
# Counties: ftp://ftp2.census.gov/geo/tiger/TIGER2013/COUNTY/
# Congressional districts: ftp://ftp2.census.gov/geo/tiger/TIGER2013/CD/
# ZIP Code Tabulation Areas: ftp://ftp2.census.gov/geo/tiger/TIGER2013/ZCTA5/
for i in STATE COUNTY CD ZCTA5
do
  bash/make-geojson-and-table.bash ${i} "us"
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

# Oregon counties
# Addresses: ftp://ftp2.census.gov/geo/tiger/TIGER2013/ADDR/
# Edges: ftp://ftp2.census.gov/geo/tiger/TIGER2013/EDGES/
# Faces: ftp://ftp2.census.gov/geo/tiger/TIGER2013/FACES/
# Feature Names: ftp://ftp2.census.gov/geo/tiger/TIGER2013/FEATNAMES/
for i in SLDU SLDL ELSD SCSD UNSD
do
  bash/make-geojson-and-table.bash ${i} "41"
done

# optimize
psql -d geocoder -c "VACUUM VERBOSE ANALYZE;"

# dump the file sizes
pushd ftp2.census.gov/geo/tiger/TIGER2013
echo "Compressed shapefile sizes"
du -sh *
popd
pushd GeoJSONzip
echo "Compressed GeoJSON sizes"
du -sh *
popd
