#! /bin/bash
#
# Copyright (C) 2013 by M. Edward (Ed) Borasky
#
# This program is licensed to you under the terms of version 3 of the
# GNU Affero General Public License. This program is distributed WITHOUT
# ANY EXPRESS OR IMPLIED WARRANTY, INCLUDING THOSE OF NON-INFRINGEMENT,
# MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. Please refer to the
# AGPL (http://www.gnu.org/licenses/agpl-3.0.txt) for more details.
#

sudo postgresql-setup initdb
sudo systemctl start postgresql
sudo systemctl enable postgresql

# install the extensions
sudo su - postgres -c \
  "psql -c 'CREATE EXTENSION IF NOT EXISTS adminpack;'"
sudo su - postgres -c \
  "psql -c 'CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;'"

# create a non-root user - can can log in and create schemas/tables only!
sudo su - postgres -c "dropdb ${USER}"
sudo su - postgres -c "dropdb or_geocoder"
sudo su - postgres -c "dropdb us_geocoder"
sudo su - postgres -c "dropdb districts"
sudo su - postgres -c "dropuser ${USER}"
sudo su - postgres -c "createuser ${USER}"

# create a 'home' database for the user
sudo su - postgres -c "createdb --owner=${USER} ${USER}"

# create 'spatial' tablespace
# https://docs.fedoraproject.org/en-US/Fedora/13/html/Managing_Confined_Services/sect-Managing_Confined_Services-PostgreSQL-Configuration_Examples.html
sudo mkdir -p /home/spatial
sudo chown -R postgres:postgres /home/spatial
sudo semanage fcontext -a -t postgresql_db_t "/home/spatial(/.*)?"
sudo restorecon -R -v /home/spatial

sudo su - postgres -c \
  "psql -c \"CREATE TABLESPACE spatial LOCATION '/home/spatial';\""
sudo su - postgres -c "psql -c '\\db+'"
sudo ls -altrZ /home/spatial

# VACUUM!
time sudo su - postgres -c "vacuumdb --all --analyze"
