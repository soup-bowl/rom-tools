# Build maxcso
FROM ubuntu:24.04 AS maxcso

ARG MAXCSO_VERSION=1.13.0

RUN apt-get update && \
	apt-get install -y --no-install-recommends build-essential liblz4-dev libuv1-dev pkgconf unzip zlib1g-dev && \
	apt-get clean

ADD https://github.com/unknownbrackets/maxcso/archive/refs/tags/v${MAXCSO_VERSION}.zip /tmp/scripts.zip
	
RUN unzip /tmp/scripts.zip -d /tmp/build && \
	mkdir /opt/build && \
	mv /tmp/build/maxcso*/* /opt/build

WORKDIR /opt/build
RUN make

# Build PSXPackager
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS psxp

ARG PSXP_VERSION=1.6.3

RUN apt-get update && \
	apt-get install -y --no-install-recommends build-essential unzip && \
	apt-get clean

ADD https://github.com/RupertAvery/PSXPackager/archive/refs/tags/v${PSXP_VERSION}.zip /tmp/scripts.zip

RUN unzip /tmp/scripts.zip -d /tmp/build && \
	mkdir /opt/build && \
	mv /tmp/build/*/* /opt/build

WORKDIR /opt/build
RUN make build-linux

FROM ubuntu:24.04 AS tochd

ARG TOCHD_VERSION=0.13

RUN apt-get update && \
	apt-get install -y --no-install-recommends unzip && \
	apt-get clean

ADD https://github.com/thingsiplay/tochd/archive/refs/tags/v${TOCHD_VERSION}.zip /tmp/scripts.zip

RUN unzip /tmp/scripts.zip -d /tmp/ && \
	mv /tmp/tochd*/tochd.py /tmp/tochd

FROM ubuntu:24.04 AS xiso

ARG XISO_VERSION=202501282328

RUN apt-get update && \
	apt-get install -y --no-install-recommends build-essential ca-certificates git unzip cmake make gcc && \
	apt-get clean && \
	git clone https://github.com/XboxDev/extract-xiso.git --branch build-${XISO_VERSION} /opt

WORKDIR /opt/build

RUN cmake .. && \
	make

# Build primary system
FROM ubuntu:24.04

LABEL \
	org.opencontainers.image.source=https://github.com/soup-bowl/rom-tools \
	org.opencontainers.image.description="Rom Tools" \
	org.opencontainers.image.licenses=MIT

RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
	# maxcso dep
	libuv1t64 \
	# tochd deps
	mame-tools \
	python3 \
	python3-pip \
	7zip \
	&& apt-get clean

# maxcso installation
COPY --from=tochd /tmp/tochd /usr/local/bin/tochd
COPY --from=maxcso /opt/build/maxcso /usr/local/bin/maxcso
COPY --from=psxp /opt/build/build/psxpackager-linux-x64 /opt/psxpackager
COPY --from=xiso /opt/build/extract-xiso /usr/local/bin/extract-xiso
RUN	chmod +x /usr/local/bin/maxcso && \
	chmod +x /usr/local/bin/tochd && \
	chmod +x /usr/local/bin/extract-xiso

ENV PATH="${PATH}:/opt/psxpackager"

COPY entrypoint.sh /opt/entrypoint.sh

WORKDIR /app
ENTRYPOINT [ "/opt/entrypoint.sh" ]
