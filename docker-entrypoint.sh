#!/bin/bash
set -e

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

# catch all environment vars that start with DRUID_ and set them to override druid.
ucDruidVars=$(env | awk -F= '/^DRUID_/ {
    gsub("_",".",$1)
    print "-D"tolower($1)"="$2
}')
lcDruidVars=$(env | awk -F= '/^druid_/ {
    gsub("_",".",$1)
    print "-D"$1"="$2
}')


java `cat /opt/druid/conf/druid/$1/jvm.config | xargs` ${ucDruidVars} ${lcDruidVars} -cp /opt/druid/conf/druid/_common:/opt/druid/conf/druid/$1:/opt/druid/lib/* io.druid.cli.Main server $@
