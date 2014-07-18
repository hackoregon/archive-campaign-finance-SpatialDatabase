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

sudo mkdir -p /gisdata/pgdump
sudo chown -R postgres:postgres /gisdata
sudo su - postgres -c \
  "time vacuumdb --analyze ${1} 2>&1 | tee /gisdata/pgdump/${1}-vacuumdb.log"
sudo rm -fr /gisdata/pgdump/${1}.backup
sudo su - postgres -c \
  "time pg_dump -c -C -E UTF8 -Fd -Z9 -j 8 -f /gisdata/pgdump/${1}.backup ${1} 2>&1 | tee /gisdata/pgdump/${1}-pg_dump.log"
sudo chown -R ${USER}:${USER} /gisdata
