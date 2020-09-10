FROM alpine

RUN apk update ; apk add vsftpd openrc openssl

RUN openrc ; touch /run/openrc/softlevel
RUN mkdir -p /srv/ftp ; chown nobody:nogroup /srv/ftp

RUN openssl req -x509 -nodes -subj '/CN=localhost' -days 365 \ 
		-newkey rsa:2048 \ 
		-keyout /etc/vsftpd/vsftpd.pem \ 
		-out /etc/vsftpd/vsftpd.pem

RUN mkdir -p /var/log/ftp

ADD ./srcs/vsftpd.conf /etc/vsftpd/
ADD ./srcs/startup.sh /

RUN mkdir -p /ftp

EXPOSE 21 21000-21005

CMD ["/bin/ash", "/startup.sh"]