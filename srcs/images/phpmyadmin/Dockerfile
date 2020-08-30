FROM alpine

RUN apk update ; apk add phpmyadmin

EXPOSE 5000
CMD ["/usr/bin/php", "-S", "127.0.0.1:5000", "-t", "/usr/share/webapps/phpmyadmin"]
