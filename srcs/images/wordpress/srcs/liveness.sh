if curl http://localhost:5050/ &> /dev/null
then
	exit 0
else
	exit 1
fi
