#!/bin/bash

#EXTERNALIP=${EXTERNAL_IP:=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)}
#EXTERNALIP=${EXTERNAL_IP:=$(curl -s icanhazip.com)}
eth0=$( curl --connect-timeout 3 -s http://169.254.169.254/latest/meta-data/local-ipv4 || ip -4 -o a | grep eth0 | awk {'print $4'} | cut -d/ -f1)
LOCALIP=${LOCAL_IP:=$eth0}

EXTERNALIP=${LOCALIP}

NAME=${USERNAME:=kurento}
PW=${PASSWORD:=kurento}

MINPORT=${MIN_PORT:=49152}
MAXPORT=${MAX_PORT:=65535}

mkdir -p /var/log/turnserver
exec /usr/bin/turnserver --no-cli -f -a -v -r tutorabc.com -u $NAME:$PW --no-stdout-log --external-ip $EXTERNALIP/$LOCALIP --min-port $MINPORT --max-port $MAXPORT --relay-ip $LOCALIP
