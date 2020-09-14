FROM alpine

RUN apk update ; apk add lighttpd php7-common \
php7-iconv php7-json php7-gd \
php7-curl php7-xml php7-mysqli \
php7-imap php7-cgi fcgi php7-pdo \
php7-pdo_mysql php7-soap php7-xmlrpc \
php7-posix php7-mcrypt php7-gettext \
php7-ldap php7-ctype php7-dom \
wget mysql mysql-client openrc php

RUN sed -i 's/#include "mod_fastcgi.conf"/include "mod_fastcgi.conf"/g' /etc/lighttpd/lighttpd.conf

RUN sed -i 's/\/usr\/bin\/php-cgi/\/usr\/bin\/php-cgi7/g' /usr/bin/php-cgi7

RUN openrc ; touch /run/openrc/softlevel

RUN rc-service lighttpd start && rc-update add lighttpd default

RUN /etc/init.d/lighttpd restart

RUN mkdir -p /usr/share/webapps/

RUN wget http://wordpress.org/latest.tar.gz -P /usr/share/webapps

RUN tar -xzvf /usr/share/webapps/latest.tar.gz -C /usr/share/webapps

RUN rm -f /usr/share/webapps/latest.tar.gz

RUN chown -R lighttpd /usr/share/webapps/

RUN ln -s /usr/share/webapps/wordpress/ /var/www/localhost/htdocs/wordpress

ADD ./srcs/wp-config.php /usr/share/webapps/wordpress

EXPOSE 5050

CMD ["/usr/bin/php", "-S", "0.0.0.0:5050", "-t", "/usr/share/webapps/wordpress"]