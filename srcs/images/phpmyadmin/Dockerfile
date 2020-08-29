FROM alpine

RUN apk update ; apk add phpmyadmin
CMD ["/usr/bin/php", "-S", "127.0.0.1:5000", "-t", "/usr/share/webapps/phpmyadmin"]
