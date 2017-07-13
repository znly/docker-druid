#!/bin/bash
set -e

echo "Starting $@ with teh following"
echo "DRUID_XMX ${DRUID_XMX}"
echo "DRUID_XMS ${DRUID_XMS}"
echo "DRUID_MAXNEWSIZE ${DRUID_MAXNEWSIZE}"
echo "DRUID_NEWSIZE ${DRUID_NEWSIZE}"
echo "DRUID_HOSTNAME ${DRUID_HOSTNAME}"
echo "DRUID_LOGLEVEL ${DRUID_LOGLEVEL}"
echo "DRUID_USE_CONTAINER_IP ${DRUID_USE_CONTAINER_IP}"
echo "ipaddress ${ipaddress}"



# Run as broker if needed
if [ "${1:0:1}" = '' ]; then
    set -- broker "$@"
fi
echo 1
if [ "$DRUID_XMX" != "-" ]; then
    sed -ri 's/Xmx.*/Xmx'${DRUID_XMX}'/g' /opt/druid/conf/druid/$1/jvm.config
fi
echo 2
if [ "$DRUID_XMS" != "-" ]; then
    sed -ri 's/Xms.*/Xms'${DRUID_XMS}'/g' /opt/druid/conf/druid/$1/jvm.config
fi
echo 3
if [ "$DRUID_MAXNEWSIZE" != "-" ]; then
    sed -ri 's/MaxNewSize=.*/MaxNewSize='${DRUID_MAXNEWSIZE}'/g' /opt/druid/conf/druid/$1/jvm.config
fi
echo 4
if [ "$DRUID_NEWSIZE" != "-" ]; then
    sed -ri 's/NewSize=.*/NewSize='${DRUID_NEWSIZE}'/g' /opt/druid/conf/druid/$1/jvm.config
fi
echo 5
if [ "$DRUID_HOSTNAME" != "-" ]; then
    sed -ri 's/druid.host=.*/druid.host='${DRUID_HOSTNAME}'/g' /opt/druid/conf/druid/$1/runtime.properties
fi
echo 6
if [ "$DRUID_LOGLEVEL" != "-" ]; then
    sed -ri 's/druid.emitter.logging.logLevel=.*/druid.emitter.logging.logLevel='${DRUID_LOGLEVEL}'/g' /opt/druid/conf/druid/_common/common.runtime.properties
fi
echo 7
if [ "$DRUID_USE_CONTAINER_IP" != "-" ]; then
    ipaddress=`ip a|grep "global eth0"|awk '{print $2}'|awk -F '\/' '{print $1}'`
    sed -ri 's/druid.host=.*/druid.host='${ipaddress}'/g' /opt/druid/conf/druid/$1/runtime.properties
fi
echo 8
java `cat /opt/druid/conf/druid/$1/jvm.config | xargs` -cp /opt/druid/conf/druid/_common:/opt/druid/conf/druid/$1:/opt/druid/lib/* io.druid.cli.Main server $@
