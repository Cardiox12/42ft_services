echo -e "Admin-1234\nAdmin-1234" | adduser -h /ftp/admin admin
# rc-service vsftpd start
chown admin:admin /ftp/admin
exec /usr/sbin/vsftpd -opasv_min_port=21000 -opasv_max_port=21005 -opasv_address=127.0.0.1 /etc/vsftpd/vsftpd.conf &

tail -F /dev/null