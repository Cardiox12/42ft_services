service mariadb restart &> /dev/null
mysql < /tmp/create_tables.sql
mysql < /tmp/create_users.sql
mysql -u root -p wordpress --password='root' < /tmp/wordpress.sql

tail -F /dev/null
