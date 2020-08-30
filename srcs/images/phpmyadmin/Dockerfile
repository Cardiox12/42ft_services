FROM alpine

RUN apk update ; apk add phpmyadmin

EXPOSE 5000
CMD ["/usr/bin/php", "-S", "0.0.0.0:5000", "-t", "/usr/share/webapps/phpmyadmin"]
