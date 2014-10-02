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

sudo yum update -y
sudo yum install -y \
  npm \
  perl-Regexp-Assemble \
  qgis \
  spatialite-gui \
  spatialite-tools \
  osm2pgsql \
  pgRouting \
  postgis \
  postgis-docs \
  postgis-utils
npm install -g topojson
sudo ./install-pagc-address-standardizer.bash
