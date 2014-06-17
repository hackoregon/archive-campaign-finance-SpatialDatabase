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

# create database and generate the scripts
cd /gisdata # just in case
psql -f sql/create-geocoder-database.sql

pushd bash
for i in 'national' 'oregon'
do
  sed -i 's;export PGBIN=/usr/pgsql-9.0/bin;export PGBIN=/usr/bin;' ${i}.bash
  sed -i 's;--no-parent;--quiet --no-parent;' ${i}.bash
  vim ${i}.bash
  chmod +x ${i}.bash
  ./${i}.bash 2>&1 | grep -v ^INSERT | tee ${i}.log
done
popd

psql -d geocoder -c "SELECT install_missing_indexes();"
psql -d geocoder -c "VACUUM VERBOSE ANALYZE;"
