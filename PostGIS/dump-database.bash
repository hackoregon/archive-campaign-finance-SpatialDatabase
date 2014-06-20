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
  "vacuumdb -z -v -f ${i}"
sudo su - postgres -c \
  "pg_dump -v -E UTF8 -Fc -Z9 -f /gisdata/pgdump/${1}.backup ${1}"
sudo chown -R ${USER}:${USER} /gisdata
