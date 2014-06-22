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

export i=${1}
export pattern=${2}
wget \
  --quiet \
  --no-parent \
  --relative \
  --recursive \
  --level=1 \
  --accept=zip \
  --reject=html \
  --mirror \
  "ftp://ftp2.census.gov/geo/tiger/TIGER2013/${i}/tl_2013_${pattern}*zip" 
