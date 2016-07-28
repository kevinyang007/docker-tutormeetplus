#!/bin/bash

#EXTERNALIP=${EXTERNAL_IP:=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)}
EXTERNALIP=${EXTERNAL_IP:=$(curl -s icanhazip.com)}

STUNIP=${STUN_IP:=$EXTERNALIP}
echo "stunServerAddress="${STUNIP} > /etc/kurento/modules/kurento/WebRtcEndpoint.conf.ini
echo "stunServerPort=3478" >> /etc/kurento/modules/kurento/WebRtcEndpoint.conf.ini

TURNIP=${TURN_IP:=$EXTERNALIP}
USERNAME=${TURN_USERNAME:=kurento}
PASSWORD=${TURN_PASSWORD:=kurento}
echo "turnURL="${USERNAME}":"${PASSWORD}"@"${TURNIP}":3478" >> /etc/kurento/modules/kurento/WebRtcEndpoint.conf.ini

MINPORT=${MIN_PORT:=49152}
MAXPORT=${MAX_PORT:=65535}
echo "minPort="${MINPORT} > /etc/kurento/modules/kurento/BaseRtpEndpoint.conf.ini
echo "maxPort="${MAXPORT} >> /etc/kurento/modules/kurento/BaseRtpEndpoint.conf.ini


# Include stun defaults if available
if [ -f /etc/default/kurento-media-server ] ; then
    . /etc/default/kurento-media-server
fi

exec /usr/bin/kurento-media-server "$@"
