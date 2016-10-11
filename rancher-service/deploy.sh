#!/bin/sh
SERVICE=$1
export RANCHER_HOSTNAME=$2

case $SERVICE in
	"aws")
	echo Applying $SERVICE settings
	. secrets-aws.sh
	;;
	"tutor")
	echo Applying $SERVICE settings
	. secrets.sh
	;;
	*)
	echo please input aws or tutor
	;;
esac

rancher-compose -p tutormeetplus-$RANCHER_HOSTNAME up -p -u -c -d