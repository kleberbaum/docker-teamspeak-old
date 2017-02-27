FROM frolvlad/alpine-glibc:alpine-3.5_glibc-2.25

MAINTAINER Philipp Daniels <philipp.daniels@gmail.com>

ARG TS_VERSION=3.0.12.4

WORKDIR /teamspeak

RUN echo "## Downloading ${TS_VERSION} ##" && \
  apk add --no-cache bzip2 tar && \
  wget -qO- "http://dl.4players.de/ts/releases/${TS_VERSION}/teamspeak3-server_linux_amd64-${TS_VERSION}.tar.bz2" | tar -xjv --strip-components=1 -C ${PWD} && \  
  apk del --purge --no-cache bzip2 tar && \
  chown -R root:root ${PWD} && \
  mv redist lib && \
  mv libts3db_*.so lib/ && \
  rm -R doc serverquerydocs tsdns ts3server_*.sh

EXPOSE 9000-9999/udp 10011/tcp 30033/tcp

VOLUME /teamspeak/files /teamspeak/logs

COPY docker-entrypoint.sh .
ENTRYPOINT ["./docker-entrypoint.sh"]

