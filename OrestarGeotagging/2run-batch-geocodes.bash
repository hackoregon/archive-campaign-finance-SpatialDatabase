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

# do the committees in a simple query
/usr/bin/time psql -d us_geocoder -f ./geocode-committees.sql 

# need grouped updates for the transactions - takes too long
while [ `psql -q -d us_geocoder < count.sql` -gt 0 ]
do
  /usr/bin/time psql -d us_geocoder < batch-geocode-transactions.sql
  psql -q -d us_geocoder < count.sql
done
