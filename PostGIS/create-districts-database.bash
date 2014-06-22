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

for i in \
  "DROP DATABASE IF EXISTS districts;" \
  "CREATE DATABASE districts WITH OWNER ${USER};"
do
  sudo su - postgres -c "psql -d postgres -c '${i}'"
done

for i in \
  "CREATE EXTENSION IF NOT EXISTS postgis;" \
  "CREATE EXTENSION IF NOT EXISTS postgis_topology;" \
do
  sudo su - postgres -c "psql -d districts -c '${i}'"
done
