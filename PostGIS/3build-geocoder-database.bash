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

# make workspace
sudo rm -fr /gisdata/temp
sudo mkdir -p /gisdata/temp
sudo mkdir -p /gisdata/sql
sudo mkdir -p /gisdata/bash
sudo chown -R ${USER}:${USER} /gisdata

# drop and re-create the geocoder databases
./create-geocoder-databases.bash

# copy the code to /gisdata
cp run-geocoder-scripts.bash /gisdata/bash
cp prefetch-tiger-shapefiles.bash /gisdata/bash
chmod +x /gisdata/bash/*.bash
cp make-scripts.sql /gisdata/sql

# change owner to 'postgres' - the generated scripts have to run as 'postgres'
sudo chown -R postgres:postgres /gisdata
