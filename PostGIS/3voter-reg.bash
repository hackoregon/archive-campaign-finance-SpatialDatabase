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

export RAW=${1} # where the zipped files live
export OUT=/gisdata # where the cleaned files live
sudo chown -R ${USER}:${USER} ${OUT}

rm -f ${OUT}/DistrictPrecinctDetail.txt
unzip -p ${RAW}/Ex-DistrictPrecinctDetail.zip \
  | dos2unix \
  | grep -v ^COUNTY \
  >> ${OUT}/DistrictPrecinctDetail.txt
sed "s/znmeb/${USER}/" DistrictPrecinctDetail.psql \
  | psql -d voter_reg -U ${USER}

rm -f ${OUT}/RegisteredVoters.txt
for i in ${RAW}/Ex-RegisteredVoters*zip
do
  unzip -p ${i} \
    | dos2unix \
    | grep -v ^VOTER_ID \
    | grep -v ^17303866 \
    | grep -v ^100640811 \
    | grep -v ^100498123 \
    >> ${OUT}/RegisteredVoters.txt
done
sed "s/znmeb/${USER}/" RegisteredVoters.psql \
  | psql -d voter_reg -U ${USER}
