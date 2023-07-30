sqlcmd -S .\SQLEXPRESS -v FullScriptDir="%CD%" -i PopulateDatabase.sql -b
pause