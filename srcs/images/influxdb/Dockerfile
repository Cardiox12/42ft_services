FROM alpine

RUN apk update ; apk add wget libc6-compat
RUN wget https://dl.influxdata.com/influxdb/releases/influxdb-1.8.2_linux_amd64.tar.gz -P /tmp
RUN tar -zxvf /tmp/influxdb-1.8.2_linux_amd64.tar.gz -C /tmp;\
	rm -rf /tmp/influxdb-1.8.2_linux_amd64.tar.gz

ADD ./srcs/startup.sh /tmp

CMD ["/bin/ash", "/tmp/startup.sh"]
