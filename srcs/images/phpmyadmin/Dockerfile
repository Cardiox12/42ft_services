FROM alpine

RUN apk update ; apk add phpmyadmin

RUN rm -f /usr/share/webapps/phpmyadmin/config.inc.php

ADD ./srcs/config.inc.php /usr/share/webapps/phpmyadmin/

CMD ["/usr/bin/php", "-S", "0.0.0.0:5000", "-t", "/usr/share/webapps/phpmyadmin"]
