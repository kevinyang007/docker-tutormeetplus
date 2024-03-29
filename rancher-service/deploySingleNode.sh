#!/bin/sh
SERVICE=$1
case $SERVICE in
	"aws")
	echo Applying $SERVICE settings
	. secrets-dev.sh
	;;
	"tutor")
	echo Applying $SERVICE settings
	. secrets.sh
	;;
	*)
	echo "./deploy.sh <aws|tutor> <hostname1 [hostname2...]>"
	;;
esac

shift

export COMPOSE_FILE=docker-compose.yml
for host in $@; do
	export RANCHER_HOSTNAME=$host
	echo 
	echo Deploy on $host
	echo
	rancher-compose -p tutormeetplus-$RANCHER_HOSTNAME up -p -u -c -d
done