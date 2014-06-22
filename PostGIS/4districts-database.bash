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

# create 'districts' schema in 'districts' database
./create-districts-database.bash

# create workspace
sudo mkdir -p /gisdata
sudo chown -R ${USER}:${USER} /gisdata

# copy the scripts to the workspace
for i in \
  make-table.bash
do
  cp ${i} /gisdata/bash
done
chmod +x /gisdata/bash/*.bash

# now go over to the data area
cd /gisdata

for i in STATE COUNTY CD ZCTA5 SLDU SLDL ELSD SCSD UNSD
do
  bash/make-table.bash ${i}
done

# optimize
psql -d districts -c "VACUUM VERBOSE ANALYZE;"

# dump the file sizes
pushd ftp2.census.gov/geo/tiger/TIGER2013
echo "Compressed shapefile sizes"
du -sh *
popd
