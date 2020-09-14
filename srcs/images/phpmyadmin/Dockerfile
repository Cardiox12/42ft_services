FROM alpine

RUN apk update ; apk add phpmyadmin

RUN rm -f /usr/share/webapps/phpmyadmin/config.inc.php

ADD ./srcs/config.inc.php /usr/share/webapps/phpmyadmin/

ADD ./srcs/startup.sh /

CMD ["/bin/ash", "/startup.sh"]
