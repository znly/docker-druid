#!/bin/bash
set -e

echo "Starting $@ with the following"
echo "DRUID_XMX ${DRUID_XMX}"
echo "DRUID_XMS ${DRUID_XMS}"
echo "DRUID_MAXNEWSIZE ${DRUID_MAXNEWSIZE}"
echo "DRUID_NEWSIZE ${DRUID_NEWSIZE}"
echo "DRUID_HOSTNAME ${DRUID_HOSTNAME}"
echo "DRUID_LOGLEVEL ${DRUID_LOGLEVEL}"
echo "DRUID_USE_CONTAINER_IP ${DRUID_USE_CONTAINER_IP}"
echo "DRUID_MAX_DIRECTMEM_SIZE ${DRUID_MAX_DIRECTMEM_SIZE}"
echo "ipaddress ${ipaddress}"



# Run as broker if needed
if [ "${1:0:1}" = '' ]; then
    set -- broker "$@"
fi
if [ "$DRUID_XMX" != "-" ]; then
    sed -ri 's/Xmx.*/Xmx'${DRUID_XMX}'/g' /opt/druid/conf/druid/$1/jvm.config
fi
if [ "$DRUID_XMS" != "-" ]; then
    sed -ri 's/Xms.*/Xms'${DRUID_XMS}'/g' /opt/druid/conf/druid/$1/jvm.config
fi
if [ "$DRUID_MAXNEWSIZE" != "-" ]; then
    sed -ri 's/MaxNewSize=.*/MaxNewSize='${DRUID_MAXNEWSIZE}'/g' /opt/druid/conf/druid/$1/jvm.config
fi
if [ "$DRUID_NEWSIZE" != "-" ]; then
    sed -ri 's/NewSize=.*/NewSize='${DRUID_NEWSIZE}'/g' /opt/druid/conf/druid/$1/jvm.config
fi
if [ "$DRUID_HOSTNAME" != "-" ]; then
    sed -ri 's/druid.host=.*/druid.host='${DRUID_HOSTNAME}'/g' /opt/druid/conf/druid/$1/runtime.properties
fi
if [ "$DRUID_LOGLEVEL" != "-" ]; then
    sed -ri 's/druid.emitter.logging.logLevel=.*/druid.emitter.logging.logLevel='${DRUID_LOGLEVEL}'/g' /opt/druid/conf/druid/_common/common.runtime.properties
fi
if [ "$DRUID_USE_CONTAINER_IP" != "-" ]; then
    ipaddress=`ip a|grep "global eth0"|awk '{print $2}'|awk -F '\/' '{print $1}'`
    sed -ri 's/druid.host=.*/druid.host='${ipaddress}'/g' /opt/druid/conf/druid/$1/runtime.properties
fi
if [ "$DRUID_MAX_DIRECTMEM_SIZE" != "-" ]; then
    sed -ri 's/MaxDirectMemorySize.*/MaxDirectMemorySize='${DRUID_MAX_DIRECTMEM_SIZE}'/g' /opt/druid/conf/druid/$1/jvm.config
fi


: ${KAFKA_BROKER_HOSTNAME='kafka'}
: ${KAFKA_BROKER_PORT='9092'}

echo "Waiting for kafka server @ $KAFKA_BROKER_HOSTNAME:$KAFKA_BROKER_PORT to start... "
until nc -z -w 2 ${KAFKA_BROKER_HOSTNAME} ${KAFKA_BROKER_PORT}; do sleep 1; done
echo "Kafka brokers are now online @ $KAFKA_BROKER_HOSTNAME:$KAFKA_BROKER_PORT"

java `cat /opt/druid/conf/druid/$1/jvm.config | xargs` -cp /opt/druid/conf/druid/_common:/opt/druid/conf/druid/$1:/opt/druid/lib/* io.druid.cli.Main server $@
