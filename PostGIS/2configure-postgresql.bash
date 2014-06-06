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

sudo postgresql-setup initdb # fails harmlessly if data directory isn't empty
sudo systemctl enable postgresql # start the server on reboot
sudo systemctl start postgresql # start the server now

# password protect the PostgreSQL superuser, 'postgres'
echo "Create a PostgreSQL password for 'postgres', the PostgreSQL superuser"
#sudo su - postgres -c "psql -c '\password postgres'"

# install the extensions - will ERROR harmlessly if they're already there
sudo mkdir -p /gisdata
sudo chown -R ${USER}:${USER} /gisdata
cp create-extensions.psql /gisdata
sudo chown -R postgres:postgres /gisdata
sudo su - postgres -c \
  "psql -f /gisdata/create-extensions.psql"
exit
sudo su - postgres -c "psql -c 'CREATE EXTENSION adminpack;'"
sudo su - postgres -c \
  "psql -c 'CREATE EXTENSION plpgsql WITH SCHEMA pg_catalog;'"
