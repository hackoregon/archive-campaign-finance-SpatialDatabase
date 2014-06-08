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
sudo chown -R ${USER}:${USER} /gisdata

# execute script builder
psql -f make-tiger-scripts.sql geocoder znmeb
chmod +x /gisdata/*.bash

# fix path
for i in '/gisdata/national.bash' '/gisdata/oregon.bash'
do
  sed -i 's;export PGBIN=/usr/pgsql-9.0/bin;export PGBIN=/usr/bin;' ${i}
done

# change owner to 'postgres' - the generated scripts have to run as 'postgres'
sudo chown -R postgres:postgres /gisdata
