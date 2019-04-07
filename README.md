WestBlueGolfLeague
==================

WestBlueGolfLeague website and iPhone app

### WestBlue website developer setup
1. Clone repo
2. Install [MySQL v5.6 64bit binary](http://dev.mysql.com/downloads/installer/)
3. Install Visual Studio 2013
4. Run the script `$/WestBlueGolfLeagueWeb/scripts/localPouplate.bat` in your shell of choice. This script will populate your development database with the most recent data.
  * Note that this script will prompt you for your MySQL username and password. These are needed to create the database and user accounts that will be used.
  * If you installed your MySQL binaries at a different location than the default, you will need to edit the `.bat` file to point the script to the correct location. Or just manually run the SQL scripts.
  * You will likely need to run createInitialDBUsers.sql on the db to get the site to launch properly. See step 7 for the likely place to run that - MySQL Workbench
5. Open the solution `$/WestBlueGolfLeagueWeb/WestBlueGolfLeagueWeb.sln`
6. Start the website by hitting `F5` or `CTRL` + `F5` and navigate to the local address in your browser of choice.
7. **OPTIONAL** Install MySQL Workbench to make schema changes or visually configure your database.
8. **OPTIONAL** Ask an admin on the website to add you as a captain or admin; this will allow you to add golfers, create a new season, and add other captains or admins.

iOS App
=======

The iOS App has become legacy for now. Distribution was difficult and it's now several iOS versions back.

Wiki
====

Additional dev information is available on the wiki of this repo.
