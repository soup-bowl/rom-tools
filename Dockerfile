FROM ubuntu:24.04

RUN apt-get update && \
	apt-get install -y 7zip unzip mame-tools curl python3 python3-pip

# tochd installation
RUN curl -L -o /tmp/scripts.zip https://github.com/thingsiplay/tochd/archive/refs/tags/v0.13.zip
RUN unzip /tmp/scripts.zip -d /tmp/ && \
	mv /tmp/tochd*/tochd.py /usr/local/bin/tochd && \
	chmod +x /usr/local/bin/tochd && \
	rm /tmp/scripts.zip && rm -r /tmp/tochd*

ADD entrypoint.sh /opt/entrypoint.sh

WORKDIR /app
ENTRYPOINT [ "/opt/entrypoint.sh" ]
