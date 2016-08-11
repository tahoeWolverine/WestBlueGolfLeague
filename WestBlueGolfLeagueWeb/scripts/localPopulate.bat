echo off
echo Enter MySQL username (usually 'root'):
set /p usern=
echo Enter MySQL password (configured at setup):
set /p password=
echo Your username is %usern%
echo Your Group is %password%
echo Loading database...
<<<<<<< HEAD
call "C:\Program Files\MySQL\MySQL Server 5.6\bin\mysql.exe" --user=%usern% --password=%password% < 06_03_2016.sql
=======
call "C:\Program Files\MySQL\MySQL Server 5.6\bin\mysql.exe" --user=%usern% --password=%password% < 08_10_2016.sql
>>>>>>> origin/master
echo Creating WestBlue users...
call "C:\Program Files\MySQL\MySQL Server 5.6\bin\mysql.exe" --user=%usern% --password=%password% < createSqlUsers.sql
pause