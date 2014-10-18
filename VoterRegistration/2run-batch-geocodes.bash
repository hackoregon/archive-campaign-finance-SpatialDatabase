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

while [ `psql -q -d or_geocoder < count.sql` -gt 0 ]
do
  time psql -d or_geocoder < bg0.sql &
  time psql -d or_geocoder < bg1.sql &
  time psql -d or_geocoder < bg2.sql &
  time psql -d or_geocoder < bg3.sql &
  time psql -d or_geocoder < bg4.sql &
  time psql -d or_geocoder < bg5.sql &
  wait
  psql -q -d or_geocoder < count.sql
done
