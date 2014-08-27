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

export OUT=/gisdata # where the cleaned files live
sudo mkdir -p ${OUT}
sudo chown -R ${USER}:${USER} ${OUT}

# dump the ORESTAR schema
time pg_dump -F p -O -E UTF8 -Z 9 -n orestar \
  -f /gisdata/pgdump/orestar.sql.gz us_geocoder

# dump the whole database
../PostGIS/dump-database.bash us_geocoder
