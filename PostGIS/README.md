# Setting up PostGIS

The current setup is for [Fedora Linux 20](https://fedoraproject.org/), and all the dependencies are already present in [CompJournoStick](http://znmeb.github.io/CompJournoStick/). It's pretty easy to port this to RHEL/CentOS, Ubuntu or openSUSE. I'll do that once we know where servers, etc. are going to reside, but for now I'm staying on the Fedora desktop.

Note that with PostgreSQL on Linux, there are two sets of users, Linux users and PostgreSQL database users, often called 'roles' in PostgreSQL jargon. For most desktop installations, things are easier if they are mapped one-to-one. That is, the PostgreSQL role 'znmeb' is the same person as the Linux user 'znmeb'.

When PostgreSQL is installed and configured, there will be a 'postgres' Linux user. And there will be a 'postgres' database role (user) inside the PostgreSQL database. This database user has 'superuser' powers - it can create other users and in general mess with stuff inside PostgreSQL just like 'root' can on a Linux system.

1. Install the Linux packages
      ```
      ./1yum-install-dependencies.bash
      ```
      This will install [PostgreSQL](http://www.postgresql.org/), [pgAdmin](http://www.pgadmin.org/index.php), [PostGIS](http://postgis.net/), [QGIS](http://www.qgis.org/en/site/) and some [OpenStreetMap](www.openstreetmap.org/) tools, plus any dependencies. You only have to run this once. It won't hurt anything if you run it again.

2. Configure PostgreSQL
      ```
      ./2configure-postgresql.bash
      ```
      This creates the PostgreSQL data area on the hard drive, enables the PostgreSQL server to start at boot time, starts it and installs the 'adminpack' extension. It will ask you to create a password for the PostgreSQL 'superuser', named 'postgres'. You only have to run this once, but it won't hurt anything if you run it again.

3. Set up the PostGIS databases
      ```
      ./3set-up-postgis.bash
      ```
      This will create a _non-superuser_ PostgreSQL role/user with the same name as your Fedora Linux login. If the role/user exists already, it will be deleted and recreated. Then the script will create the following empty databases for that user:

            congress_districts: US Congressional districts for the whole USA
            state_legislature_upper_districts: Oregon Senate districts
            state_legislature_lower_districts: Oregon House districts
            unified_school_districts: Unified school districts for Oregon
            elementary_school_districts: Elementary school districts for Oregon
            secondary_school_districts: Secondary school districts for Oregon
            geocoder: A database for the TIGER geocoding / reverse geocoding package

4. Download the district shapefiles
      ```
      ./4download-tiger-districts.bash
      ```
      This will download the shapefiles (except for the 'geocoder' data) required to populate the databases from the [US Census Bureau's TIGER/Line® FTP site](http://www.census.gov/geo/maps-data/data/tiger-line.html). The first time you run it, it will take longer because it's downloading, but subsequent runs will only download if the file has changed on the FTP site.

      After the download, the script unpacks the ZIP archives and imports them into the databases.

5. Download the TIGER geocoder data. This is a three-step process. For more details, see [_PostGIS in Action, Second Edition_](http://www.manning.com/obe2/).
	```
	./5make-geocoder-download-scripts.bash
	```
	This executes some code in the PostGIS package to create two scripts in `/gisdata`. One script, called 'state-county.bash', downloads nationwide state and county shapefiles. The second, called 'oregon-washington.bash', downloads detailed shapefiles for Oregon and Washington states. I've put Washington state data here mostly for my own use; Census data treats Clark and Skamania counties as part of the Portland metro area.

	After the scripts are generated, do the following:
	```
	sudo su - postgres
	cd /gisdata
	```
	This puts you into the PostgreSQL _Linux_ maintenance account. The scripts require this 'superuser' privilege to run. Edit the two 'bash' scripts to set the ***PostgreSQL*** password for the 'postgres' role/user - you should have set this in the second step. You'll see a line
	```
	export PGPASSWORD=yourpasswordhere
	```
	Change all instances of 'yourpasswordhere' to the PostgreSQL password for the 'postgres' role/user. Notes:
	
	* There may be more than one instance; you need to change all of them.
	* If your password contains special characters, you'll need to enclose it in single quotes. For example, `export PGPASSWORD='duck,duck:g00s3'`.

	Finally, run the scripts.
	```
	./state-county.bash
	./oregon-washington.bash
	```
	Like the previous download script, they will run longer the first time while downloading the raw data from the TIGER FTP site. Later ones will only download changed ZIP archives.
