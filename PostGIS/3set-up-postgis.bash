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

export HERE=`pwd` # need absolute path later

# PostgreSQL username = Linux username
export PGUSER=${USER}

# drop the old databases if any
for i in \
  ${PGUSER} \
  geocoder \
  congress_districts \
  elementary_school_districts \
  secondary_school_districts \
  unified_school_districts \
  state_legislature_lower_districts \
  state_legislature_upper_districts \
  orestar
do
  sudo su - postgres -c "dropdb ${i}"
done

# drop and re-create the user
sudo su - postgres -c "dropuser ${PGUSER}"
sudo su - postgres -c "createuser -d ${PGUSER}"

# create databases for the user
for i in \
  ${PGUSER} \
  geocoder \
  congress_districts \
  elementary_school_districts \
  secondary_school_districts \
  unified_school_districts \
  state_legislature_lower_districts \
  state_legislature_upper_districts \
  orestar
do
  sudo su - postgres -c "createdb -O ${PGUSER} ${i}"
  sudo ${HERE}/create-postgis.bash ${i}
done

# create the TIGER extensions in 'geocoder'
sudo ${HERE}/create-tiger-schema.bash geocoder

echo "Create a password for the PostgreSQL user '${PGUSER}'"
psql -c '\password'
