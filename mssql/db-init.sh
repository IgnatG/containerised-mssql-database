#wait for the SQL Server to come up
sleep 60s

echo "running set up script"
# Use the correct path for SQL tools in newer containers
if [ -f "/opt/mssql-tools18/bin/sqlcmd" ]; then
    /opt/mssql-tools18/bin/sqlcmd -S localhost -U SA -P $MSSQL_SA_PASSWORD -d master -i ./db-init.sql -C
else
    /opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P $MSSQL_SA_PASSWORD -d master -i ./db-init.sql
fi

echo "db initialized"