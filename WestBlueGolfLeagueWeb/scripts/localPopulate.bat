echo off
echo Enter MySQL username (usually 'root'):
set /p usern=
echo Enter MySQL password (configured at setup):
set /p password=
echo Your username is %usern%
echo Your Group is %password%
echo Loading database...
call "C:\Program Files\MySQL\MySQL Server 5.6\bin\mysql.exe" --user=%usern% --password=%password% < 08_11_2021.sql
echo Creating WestBlue users...
call "C:\Program Files\MySQL\MySQL Server 5.6\bin\mysql.exe" --user=%usern% --password=%password% < createSqlUsers.sql
pause