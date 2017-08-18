FROM iron/java:1.8
MAINTAINER jbaptiste <jb@zen.ly>

# Java config
ENV DRUID_VERSION   0.10.1-rc3-SNAPSHOT
#ENV JAVA_HOME       /opt/jdk1.8.0_131
#ENV PATH            $PATH:/opt/jdk1.8.0_131/bin

# Druid env variable
ENV DRUID_XMX           '-'
ENV DRUID_XMS           '-'
ENV DRUID_NEWSIZE       '-'
ENV DRUID_MAXNEWSIZE    '-'
ENV DRUID_HOSTNAME      '-'
ENV DRUID_LOGLEVEL      '-'
ENV DRUID_USE_CONTAINER_IP      '-'
ENV DRUID_MAX_DIRECTMEM_SIZE "-"
RUN apk update && apk add wget tar bash curl vim \
    && mkdir /tmp/druid \ 
    && rm -rf /var/cache/apk/*

RUN mkdir -p /opt
# RUN wget -q --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" -O - \
#     http://download.oracle.com/otn-pub/java/jdk/8u131-b11/d54c1d3a095b4ff2b6607d096fa80163/server-jre-8u131-linux-x64.tar.gz | tar -xzf - -C /opt

# RUN wget -q --no-check-certificate --no-cookies -O - \
#     http://static.druid.io/artifacts/releases/druid-$DRUID_VERSION-bin.tar.gz | tar -xzf - -C /opt \
#     && ln -s /opt/druid-$DRUID_VERSION /opt/druid

ADD druid-0.10.1-rc3-SNAPSHOT-bin.tar.gz /opt/
RUN ln -s /opt/druid-$DRUID_VERSION /opt/druid 
COPY hadoop-aws-2.7.3.jar /opt/druid/hadoop-dependencies/hadoop-client/2.7.3/

COPY conf /opt/druid-$DRUID_VERSION/conf
COPY docker-entrypoint.sh /docker-entrypoint.sh

RUN mkdir -p /tmp/druid
EXPOSE 8090 8081 8080
ENTRYPOINT ["/docker-entrypoint.sh"]
