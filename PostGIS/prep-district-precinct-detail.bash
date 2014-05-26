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

unzip -c /data/HackOregon/voter_reg/Ex-DistrictPrecinctDetail.zip \
  | tail -n +4 \
  | sed 's/[ \t]*$//' \
  | grep -v -e '^[ \t]*$' \
  > district-precinct-detail.txt
