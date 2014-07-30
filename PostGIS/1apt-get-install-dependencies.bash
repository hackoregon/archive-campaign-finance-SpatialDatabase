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

sudo apt-get update
sudo apt-get upgrade
sudo apt-get install -y \
  postgresql-contrib \
  postgresql-doc \
  postgresql-plpython-9.3 \
  postgresql-plpython3-9.3 \
  postgresql-server-dev-9.3 \
  postgis \
  postgis-doc \
  postgresql-9.3-plr \
  postgresql-9.3-postgis-2.1 \
  postgresql-9.3-postgis-2.1-scripts \
  postgresql-9.3-postgis-scripts \
  postgresql-server-dev-all \
  osm2pgsql
