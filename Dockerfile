
FROM openjdk:8-jre-alpine
MAINTAINER Avi Deitcher <https://github.com/deitch>

EXPOSE 8081 8082 8083 8090 8091

# Java config
ENV DRUID_VERSION   0.9.2

# Druid env variable
ENV DRUID_XMX           '-'
ENV DRUID_XMS           '-'
ENV DRUID_NEWSIZE       '-'
ENV DRUID_MAXNEWSIZE    '-'
ENV DRUID_HOSTNAME      '-'
ENV DRUID_LOGLEVEL      '-'

RUN apk add --update wget tar bash

RUN mkdir -p /opt

RUN wget -q --no-check-certificate --no-cookies -O - \
    http://static.druid.io/artifacts/releases/druid-$DRUID_VERSION-bin.tar.gz | tar -xzf - -C /opt \
    && ln -s /opt/druid-$DRUID_VERSION /opt/druid

COPY conf /opt/druid-$DRUID_VERSION/conf
COPY docker-entrypoint.sh /docker-entrypoint.sh

RUN mkdir -p /tmp/druid

ENTRYPOINT ["/docker-entrypoint.sh"]
