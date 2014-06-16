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

sudo cp qgis.repo /etc/yum.repos.d # latest QGIS packages live here
sudo yum update -y
sudo yum install -y \
  dos2unix \
  perl-Regexp-Assemble \
  subversion \
  patch \
  gdal \
  gdal-devel \
  gdal-doc \
  gdal-ruby \
  gdal-perl \
  gdal-python \
  dans-gdal-scripts \
  grass \
  grass-devel \
  proj \
  proj-devel \
  proj-epsg \
  proj-nad \
  geos \
  geos-devel \
  geos-python \
  GMT \
  GMT-coastlines \
  GMT-doc \
  GMT-coastlines-full \
  GMT-coastlines-high \
  GMT-common \
  GMT-devel \
  foxtrotgps \
  gpscorrelate \
  gpsdrive \
  viking \
  zyGrib \
  josm \
  carto \
  mapnik \
  mapnik-demo \
  mapnik-utils \
  marble \
  merkaartor \
  osm-gps-map \
  osm-gps-map-devel \
  osm-gps-map-gobject \
  osm2pgsql \
  python-phyghtmap \
  pgRouting \
  postgis \
  postgis-docs \
  postgis-utils \
  qgis \
  qgis-devel \
  qgis-grass \
  qgis-python \
  qlandkartegt \
  readosm \
  readosm-devel \
  routino \
  spatialite-gui \
  spatialite-tools \
  libspatialite-devel \
  librasterlite-devel \
  saga \
  saga-devel \
  mapserver \
  qgis-mapserver
sudo ./install-pagc-address-standardizer.bash
