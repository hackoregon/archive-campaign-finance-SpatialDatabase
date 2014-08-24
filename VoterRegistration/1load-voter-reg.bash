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
sudo mkdir -p ${OUT}
sudo chown -R ${USER}:${USER} ${OUT}

# create a 'voter_reg' schema in the 'or_geocoder' database
sed "s/znmeb/${USER}/" create-voter_reg.sql \
  | psql -d or_geocoder -U ${USER}

rm -f ${OUT}/DistrictPrecinctDetail.txt
echo "Unpacking district precinct detail"
unzip -p ${RAW}/Ex-DistrictPrecinctDetail.zip \
  | iconv -f LATIN1 -t UTF8 \
  | sed 's/[ \t]*$//' \
  | grep -v -e '^[ \t]*$' \
  | grep -v ^COUNTY \
  >> ${OUT}/DistrictPrecinctDetail.txt
sed "s/znmeb/${USER}/" DistrictPrecinctDetail.sql \
  | psql -d or_geocoder -U ${USER}

rm -f ${OUT}/RegisteredVoters.txt
echo "Unpacking registered voters"
for i in ${RAW}/Ex-RegisteredVoters*zip
do
  unzip -p ${i} \
    | iconv -f LATIN1 -t UTF8 \
    | grep -v ^17303866 \
    | grep -v ^100640811 \
    | grep -v ^100498123 \
    | grep -v ^VOTER_ID \
    >> ${OUT}/RegisteredVoters.txt
done
sed "s/znmeb/${USER}/" RegisteredVoters.sql \
  | psql -d or_geocoder -U ${USER}

# optimize
sudo su - postgres -c "vacuumdb --analyze or_geocoder"

# archive some raw data
pushd ${OUT}
rm VoterReg.zip # clean slate
zip -9m VoterReg.zip \
  DistrictPrecinctDetail.txt \
  Counties.csv \
  VRsplits.csv \
  CIsplits.csv \
  Districts.csv
