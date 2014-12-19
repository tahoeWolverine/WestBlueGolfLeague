To migrate the MySql model over to sqlite, execute the following steps:

1. Open up MySql workbench
2. install plugin from file "sqlitePluginForMySqlWorkbench.lua"
3. Restart MySql Workbench and open data file named "dataModel.mwb"
4. go to Tools -> Utilities -> Export SQLite Create Script.  This creates a SQLite schema creation file (CREATE TABLE statments)
5. run the command "sqlite3 db.sqlite"
6. once in Sqlite shell, impor the file which was created at step 4.  Example ".read dataModelSqliteCreate.sql"