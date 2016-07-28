#!/bin/bash

#EXTERNALIP=${EXTERNAL_IP:=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)}
EXTERNALIP=${EXTERNAL_IP:=$(curl -4 icanhazip.com)}

cd /app 
sed -i -- "s/EXTERNAL_IP/$EXTERNALIP/g" config.json

npm run build && npm start
