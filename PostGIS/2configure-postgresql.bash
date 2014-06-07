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
echo "Creating a database password for 'postgres', the PostgreSQL superuser"
psql -U postgres -d postgres -c '\password postgres'

# patch the configuration to force MD5 password authentication
sudo patch -N -b /var/lib/pgsql/data/pg_hba.conf pg_hba.conf.patch
sudo systemctl restart postgresql # restart the server

# install default extensions - will ERROR harmlessly if they're already there
# set up non-superuser
echo "Creating a non-superuser database user ${USER}"
echo "You will be asked to set a password for ${USER}"
echo "${USER}, voter_reg and geocoder databases will be created"
sed "s/znmeb/${USER}/g" 01create-default-extensions-and-user.sql \
  | psql -d postgres -U postgres
