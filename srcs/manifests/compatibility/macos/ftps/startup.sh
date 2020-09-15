echo -e "Admin-1234\nAdmin-1234" | adduser -h /ftp/admin admin
chown admin:admin /ftp/admin
exec /usr/sbin/vsftpd -opasv_min_port=21000 -opasv_max_port=21005 -opasv_address=192.168.99.230 etc/vsftpd/vsftpd.conf &

tail -F /dev/null