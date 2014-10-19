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

export DATABASE=${1}
export SCHEMA=${2}
export TABLE=${3}
sudo mkdir -p /gisdata/pgdump
sudo chown -R postgres:postgres /gisdata
sudo rm -fr /gisdata/pgdump/${DATABASE}.${SCHEMA}.${TABLE}.sql.gz
sudo su - postgres -c \
  "pg_dump -d ${DATABASE} -t ${SCHEMA}.${TABLE} -E UTF8 -c -O --no-tablespaces -F p -Z 9 -f /gisdata/pgdump/${DATABASE}.${SCHEMA}.${TABLE}.sql.gz"
sudo chown -R ${USER}:${USER} /gisdata
