FROM alpine:3.7

RUN apk update ; apk add nginx openrc openssl
RUN mkdir /www ; adduser -D -g 'www' www ; chown -R www:www /var/lib/nginx ; chown -R www:www /www
RUN mkdir -p /run/nginx
RUN openssl req -x509 -nodes -subj '/CN=localhost' -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/server.key -out /etc/ssl/certs/server.crt
CMD ["nginx", "-g", "daemon off;"]

EXPOSE 80 443
