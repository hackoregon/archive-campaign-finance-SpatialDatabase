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

export i=${1}
mkdir -p GeoJSON/${i}
SOURCE=`find shapefiles/${i} -name '*.shp'`
DEST=`echo ${SOURCE}|sed 's/shp/geojson/'|sed 's/shapefiles/GeoJSON/'`

# this step will throw errors if the GeoJSON is already done, saving time
ogr2ogr -f GeoJSON ${DEST} ${SOURCE}
zip -9ur GeoJSONzip/${i}.zip ${DEST}
