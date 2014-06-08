The current setup is for [Fedora Linux 20](https://fedoraproject.org/),
which is what I run most of the time. I do have a Windows laptop and
will be porting this setup to it as part of the Hack Oregon project. I'm
looking for a Mac user to port this to Macintosh laptops. If you use
another Linux distro on your desktop, open an issue on Github and I'll
do the port for you.

***Important note***: in PostgreSQL on Linux, there are two sets of
users, Linux users and PostgreSQL database users. And PostgreSQL
database users are called ***roles*** in PostgreSQL jargon. For most
Linux desktop installations, things are easier if they are mapped
one-to-one. That is, the PostgreSQL role 'znmeb' is the same person as
the Linux user 'znmeb'.

When PostgreSQL is installed and configured, there will be a 'postgres'
Linux user. And there will be a 'postgres' database role (user) inside
the PostgreSQL database. The 'postgres' database role has 'superuser'
powers - it can create other roles and in general mess with stuff inside
PostgreSQL just like 'root' can on a Linux system. So for practical
usage you'll ususally want to create a non-superuser role for day-to-day
work.

Install the Linux packages
--------------------------

    ./1yum-install-dependencies.bash

This will install

-   [PostgreSQL](http://www.postgresql.org/),
-   [pgAdmin](http://www.pgadmin.org/index.php),
-   [PostGIS](http://postgis.net/),
-   [QGIS](http://www.qgis.org/en/site/),
-   some [OpenStreetMap](www.openstreetmap.org/) tools, and
-   any dependencies.

You only have to run this once. It won't hurt anything if you run it
again.

Configure PostgreSQL
--------------------

    ./2configure-postgresql.bash

This script

-   creates the PostgreSQL data area on the hard drive,
-   enables the PostgreSQL server to start at boot time,
-   starts the PostgreSQL server,
-   asks you to create a password for the 'postgres' database superuser,
-   installs the 'adminpack' and 'plpgsql' extensions, and
-   creates a non-superuser database user and a 'home' database.

The database user and home database will have the same name as your
Linux login. For example, if your login is 'charlie' you'll have a
database login of 'charlie' and there will be a database named
'charlie'. The script will ask you to create a password for this user as
well.

You only have to run this script once, but it won't hurt anything if you
run it again.

(Optional) Load the 'voter\_reg' database
-----------------------------------------

    ./3load-voter-reg.bash /path/to/voter_reg_zip_files

If you have the voter registration database ZIP archives, this script
will load some of the data into PostgreSQL. This is mostly for my use at
the moment; we may not need it for the actual application.

Download the TIGER districts
----------------------------

    ./4download-tiger-districts.bash

This script will create the following databases for the non-superuser
database role:

-   congress\_districts: US Congressional districts for the whole USA
-   state\_legislature\_upper\_districts: Oregon State Senate districts
-   state\_legislature\_lower\_districts: Oregon State House districts
-   unified\_school\_districts: Unified school districts for Oregon
-   elementary\_school\_districts: Elementary school districts for
    Oregon
-   secondary\_school\_districts: Secondary school districts for Oregon

First, the script will download the shapefiles required to populate the
databases from the [US Census Bureau's TIGER/Line® FTP
site](http://www.census.gov/geo/maps-data/data/tiger-line.html). The
first time you run it, it will take longer because it's downloading, but
subsequent runs will only download if the file has changed on the FTP
site.

After the download, the script unpacks the ZIP archives and imports them
into the databases. You can ignore any ERROR messages this script
generates.

Download the TIGER/Line® geocoder data.
---------------------------------------

This is a two-step process. For more details, see [*PostGIS in Action,
Second Edition*](http://www.manning.com/obe2/).

### Create the download scripts.

    ./5make-geocoder-download-scripts.bash

This executes some code in the PostGIS package to create two scripts in
`/gisdata`. One script, called 'national.bash', downloads nationwide
state and county shapefiles. The second, called 'oregon.bash', downloads
detailed shapefiles for Oregon.

### Edit and run the download scripts.

    sudo su - postgres
    cd /gisdata
    ./6run-geocoder-scripts.bash

This puts you into the PostgreSQL ***Linux*** maintenance account. The
scripts require this 'superuser' privilege to run.

#### Edit the download scripts

The '6run-geocoder-scripts.bash' script will first ask you to edit the
two 'bash' scripts to set the ***PostgreSQL*** password for the
'postgres' role - you should have set this password in the 'Configure
PostgreSQL' step. You'll see a line

    export PGPASSWORD=yourpasswordhere

Change all instances of 'yourpasswordhere' to the PostgreSQL password
for the 'postgres' role. Notes:

-   There may be more than one instance; you need to change all of them.
-   If your password contains special characters, you'll need to enclose
    it in single quotes. For example,

<!-- -->

    export PGPASSWORD='duck,duck:g00s3'

#### Run the download scripts.

After you've edited them, '6run-geocoder-scripts.bash' will run the
download scripts. Like previous download scripts, they will run longer
the first time while downloading the raw data from the TIGER/Line® FTP
site. Later ones will only download changed ZIP archives.
