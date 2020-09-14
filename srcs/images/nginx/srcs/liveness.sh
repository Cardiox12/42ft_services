if curl http://127.0.0.1:80 &> /dev/null && /etc/init.d/sshd status &> /dev/null
then
	exit 0
else
	exit 1
fi