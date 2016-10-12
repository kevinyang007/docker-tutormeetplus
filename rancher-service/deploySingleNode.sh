#!/bin/sh
SERVICE=$1
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
	echo ./deploy.sh <aws|tutor> <hostname1 [hostname2...]>
	;;
esac

shift

for host in $@; do
	export RANCHER_HOSTNAME=$host
	echo 
	echo Deploy on $host
	echo
	rancher-compose -p tutormeetplus-$RANCHER_HOSTNAME up -p -u -c -d
done