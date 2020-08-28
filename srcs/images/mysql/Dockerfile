FROM alpine:3.7

RUN apk update ; apk add mysql mysql-client openrc
RUN mkdir /run/openrc ; touch /run/openrc/softlevel
RUN /etc/init.d/mariadb setup
