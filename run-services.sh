#!/bin/bash

. /functions.sh

reload_config

if [[ ! -f /root/.first_run ]]; then
sed -i "s/#\$ModLoad imudp/\$ModLoad imudp/" /etc/rsyslog.conf
sed -i "s/#\$UDPServerRun/\$UDPServerRun/" /etc/rsyslog.conf
cat <<EOF>>  /etc/rsyslog.d/haproxy.conf
local2.*    /var/log/haproxy/haproxy.log
EOF
touch /root/.first_run
fi

trap "/sbin/service haproxy stop; /sbin/service rsyslog stop; killall reloader.sh; killall etcdctl; killall tail; exit 0" SIGINT SIGTERM SIGHUP

/sbin/service rsyslog start
/sbin/service haproxy start

touch /var/log/container.log
tail -F /var/log/container.log &

ETCDCTL_NOTIFY=${ETCDCTL_NOTIFY:-"/services/haproxy/notify"}

if [ ! -z "${ETCDCTL_PEERS}" ] ; then
    export ETCDCTL_PEERS
    export ETCDCTL_NOTIFY
    /reloader.sh ${ETCDCTL_WATCH} &
fi


wait
