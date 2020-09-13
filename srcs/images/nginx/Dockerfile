FROM alpine

RUN apk update ; apk add nginx openrc openssl openssh


RUN mkdir /www ; adduser -D -g 'www' www ; chown -R www:www /var/lib/nginx ; chown -R www:www /www
ADD ./srcs/index.html /var/www
RUN mkdir -p /run/nginx
RUN openssl req -x509 -nodes -subj '/CN=localhost' -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/server.key -out /etc/ssl/certs/server.crt

RUN openrc ; touch /run/openrc/softlevel
RUN rc-update add sshd

EXPOSE 80 443 22

ADD ./srcs/startup.sh /
CMD ["/bin/ash", "/startup.sh"]
