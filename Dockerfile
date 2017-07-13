FROM progrium/busybox
MAINTAINER jbaptiste <jb@zen.ly>

# Java config
ENV DRUID_VERSION   0.9.1.1
ENV JAVA_HOME       /opt/jre1.8.0_40
ENV PATH            $PATH:/opt/jre1.8.0_40/bin

# Druid env variable
ENV DRUID_XMX           '-'
ENV DRUID_XMS           '-'
ENV DRUID_NEWSIZE       '-'
ENV DRUID_MAXNEWSIZE    '-'
ENV DRUID_HOSTNAME      '-'
ENV DRUID_LOGLEVEL      '-'

RUN opkg-install wget tar bash \
    && mkdir /tmp/druid

RUN wget -q --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" -O - \
     http://download.oracle.com/otn-pub/java/jdk/8u131-b11/d54c1d3a095b4ff2b6607d096fa80163/jdk-8u131-linux-x64.tar.gz | tar -xzf - -C /opt 

RUN wget -q --no-check-certificate --no-cookies -O - \
    http://static.druid.io/artifacts/releases/druid-$DRUID_VERSION-bin.tar.gz | tar -xzf - -C /opt \
    && ln -s /opt/druid-$DRUID_VERSION /opt/druid

COPY conf /opt/druid-$DRUID_VERSION/conf
COPY docker-entrypoint.sh /docker-entrypoint.sh

RUN mkdir -p /tmp/druid

ENTRYPOINT ["/docker-entrypoint.sh"]
