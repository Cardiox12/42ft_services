if curl http://127.0.0.1:80 && /etc/init.d/sshd status
then
	exit 0
else
	exit 1
fi