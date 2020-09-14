ps > /tmp/liveness

if cat /tmp/liveness | grep telegraf
then
    exit 0
else
    exit 1
fi