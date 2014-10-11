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

pg_restore \
  --dbname=postgres \
  --clean \
  --create \
  --jobs=${2} \
  --no-owner \
  --no-data-for-failed-tables \
  ${1}
