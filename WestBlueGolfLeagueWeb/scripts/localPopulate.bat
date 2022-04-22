echo off
echo Enter MySQL username (usually 'root'):
set /p usern=
echo Enter MySQL password (configured at setup):
set /p password=
echo Your username is %usern%
echo Your Group is %password%
echo Loading database...
call "C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" --user=%usern% --password=%password% < 04_22_2022-pre-season.sql
echo Creating WestBlue users...
call "C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" --user=%usern% --password=%password% < createSqlUsers.sql
pause