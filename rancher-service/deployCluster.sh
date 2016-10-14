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
	echo "Usage: ./deploy.sh <aws|tutor>"
	exit 1
	;;
esac

export COMPOSE_FILE=docker-compose.cluster.yml
export COMPOSE_PROJECT_NAME=tutormeetplus
echo 
echo Deploy on $SERVICE
echo
rancher-compose up -p -d -u -c