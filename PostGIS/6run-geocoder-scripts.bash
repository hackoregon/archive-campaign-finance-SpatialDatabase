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

# edit to store the 'postgres' database password
vim national.bash oregon.bash

# now run the scripts and capture log files
for i in national oregon
do
  ./${i}.bash 2>&1 | grep -v ^INSERT | tee ${i}.log
done

echo "dumping the 'geocoder' database"
./dump-database.bash geocoder
