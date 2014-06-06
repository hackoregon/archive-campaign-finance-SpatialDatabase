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

mkdir -p /usr/local/src
pushd /usr/local/src
rm -fr address_standardizer
svn co svn://svn.code.sf.net/p/pagc/code/branches/sew-refactor/postgresql address_standardizer
cd address_standardizer
make
#if you have in non-standard location pcre try
# make SHLIB_LINK="-L/path/pcre/lib -lpostgres -lpgport -lpcre" CPPFLAGS="-I.  -I/path/pcre/include" 
make install
popd
