FROM alpine

RUN apk update ; apk add bash mysql mysql-client openrc

RUN mkdir /run/openrc ; touch /run/openrc/softlevel

RUN sed -i 's/skip-networking/#skip-networking/g' /etc/my.cnf.d/mariadb-server.cnf

RUN mkdir -p /run/mysqld ; \
		chown -R mysql:mysql /run/mysqld/


RUN mysql_install_db --user=root --datadir="/var/lib/mysql"


EXPOSE 3306

CMD ["/usr/bin/mysqld", "--user=root"]
