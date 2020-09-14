FROM alpine

RUN apk update ; apk add bash mysql mysql-client openrc busybox-extras

RUN openrc ; touch /run/openrc/softlevel

RUN sed -i 's/skip-networking/#skip-networking/g' /etc/my.cnf.d/mariadb-server.cnf

ADD ./srcs/create_tables.sql /tmp
ADD ./srcs/create_users.sql /tmp
ADD ./srcs/wordpress.sql /tmp
ADD ./srcs/startup.sh /tmp
ADD ./srcs/liveness.sh /

EXPOSE 3306

CMD ["/bin/ash", "/tmp/startup.sh"]
