service mariadb restart &> /dev/null
mysql < /tmp/create_tables.sql
mysql < /tmp/create_users.sql

tail -F /dev/null