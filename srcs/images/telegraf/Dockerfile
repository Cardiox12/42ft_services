FROM alpine

RUN apk update ; apk add libc6-compat wget
RUN wget https://dl.influxdata.com/telegraf/releases/telegraf-1.15.2_linux_amd64.tar.gz -P /tmp ;\
	tar -xzvf /tmp/telegraf-1.15.2_linux_amd64.tar.gz -C /tmp ;\ 
	mv /tmp/telegraf-1.15.2 /tmp/telegraf ;\
	rm -rf /tmp/telegraf-1.15.2_linux_amd64.tar.gz

RUN mkdir -p /root/.telegraf/
ADD ./srcs/telegraf.conf /root/.telegraf/
ADD ./srcs/startup.sh /tmp
ADD ./srcs/liveness.sh /

CMD ["/bin/ash", "/tmp/startup.sh"]
