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

# generate the scripts
cd /gisdata # just in case
psql -d us_geocoder -f sql/make-scripts.sql

pushd bash

# common edits for all scripts
for i in 'national' 'or_geocoder'
do
  sed -i 's;export PGBIN=/usr/pgsql-9.0/bin;export PGBIN=/usr/bin;' ${i}.bash
  sed -i 's;--no-parent;--quiet --no-parent;' ${i}.bash
  sed -i 's;export PGHOST=localhost;;' ${i}.bash
  sed -i 's;export PGUSER=postgres;;' ${i}.bash
  sed -i 's;export PGPASSWORD=.*$;;' ${i}.bash
  chmod +x ${i}.bash
done

# now change database names and run them
for i in 'or_geocoder'
do
  sed -i "s;export PGDATABASE=.*$;export PGDATABASE=${i};" national.bash
  sed -i "s;export PGDATABASE=.*$;export PGDATABASE=${i};" ${i}.bash
  time ./national.bash 2>&1 | grep -v ^INSERT | tee ${i}-national.log
  time ./${i}.bash 2>&1 | grep -v ^INSERT | tee ${i}.log
  psql -d ${i} -c "SELECT install_missing_indexes();"
  time psql -d ${i} -c "VACUUM ANALYZE;"
done
popd
