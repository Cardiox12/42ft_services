FROM alpine:3.7

RUN apk update ; apk add nginx openrc
RUN mkdir /www ; adduser -D -g 'www' www ; chown -R www:www /var/lib/nginx ; chown -R www:www /www
RUN mkdir -p /run/nginx
CMD ["nginx", "-g", "daemon off;"]

EXPOSE 80
