# mysql.server status
# SUCCESS! MySQL running (1340)
# ERROR! MySQL is not running
mysql_status="$(mysql.server status)"
if [[ $mysql_status == *ERROR* ]];
then
    mysql.server start
fi

passenger start
