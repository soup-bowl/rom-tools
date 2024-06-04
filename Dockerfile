# Build maxcso
FROM ubuntu:24.04 as maxcso

RUN apt-get update && apt-get install -y curl unzip build-essential pkgconf zlib1g-dev liblz4-dev libuv1-dev

RUN curl -L -o /tmp/scripts.zip https://github.com/unknownbrackets/maxcso/archive/refs/tags/v1.13.0.zip
RUN unzip /tmp/scripts.zip -d /tmp/build && \
	mkdir /opt/build && \
	mv /tmp/build/maxcso*/* /opt/build

WORKDIR /opt/build
RUN make

# Build PSXPackager
FROM mcr.microsoft.com/dotnet/sdk:6.0 as psxp

RUN apt-get update && apt-get install -y curl unzip build-essential

RUN curl -L -o /tmp/scripts.zip https://github.com/RupertAvery/PSXPackager/archive/refs/tags/v1.6.3.zip
RUN unzip /tmp/scripts.zip -d /tmp/build && \
	mkdir /opt/build && \
	mv /tmp/build/*/* /opt/build

WORKDIR /opt/build
RUN make build-linux

# Build MAIN
FROM ubuntu:24.04

RUN apt-get update && \
	apt-get install -y --no-install-recommends 7zip unzip mame-tools curl python3 python3-pip

# tochd installation
RUN curl -L -o /tmp/scripts.zip https://github.com/thingsiplay/tochd/archive/refs/tags/v0.13.zip
RUN unzip /tmp/scripts.zip -d /tmp/ && \
	mv /tmp/tochd*/tochd.py /usr/local/bin/tochd && \
	chmod +x /usr/local/bin/tochd && \
	rm /tmp/scripts.zip && rm -r /tmp/tochd*

# maxcso installation
COPY --from=maxcso /opt/build/maxcso /usr/local/bin/maxcso
RUN apt-get install -y libuv1t64
RUN chmod +x  /usr/local/bin/maxcso

# PSXPackager installation
COPY --from=psxp /opt/build/build/psxpackager-linux-x64 /opt/psxpackager
ENV PATH="${PATH}:/opt/psxpackager"

ADD entrypoint.sh /opt/entrypoint.sh

WORKDIR /app
ENTRYPOINT [ "/opt/entrypoint.sh" ]
