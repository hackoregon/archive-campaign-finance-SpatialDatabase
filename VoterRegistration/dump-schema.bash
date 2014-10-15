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
export JOBS=${3}
sudo mkdir -p /gisdata/pgdump
sudo chown -R postgres:postgres /gisdata
sudo rm -fr /gisdata/pgdump/${DATABASE}.${SCHEMA}.backup
sudo su - postgres -c \
  "/usr/bin/time pg_dump -d ${DATABASE} -n ${SCHEMA} -E UTF8 -F d -j ${JOBS} -Z 9 -f /gisdata/pgdump/${DATABASE}.${SCHEMA}.backup"
sudo chown -R ${USER}:${USER} /gisdata
