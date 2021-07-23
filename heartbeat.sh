#!/bin/bash

MQTT_BROKER_HOST="a11homvea4zo8t-ats.iot.ap-east-1.amazonaws.com"
MQTT_BROKER_PORT=8883

device_id=$1

timestamp=$2

strStart="{\"message\":{\"deviceState\":\"0\",\"timestamp\":\"$timestamp\"}}"
strRun="{\"message\":{\"deviceState\":\"3\",\"timestamp\":\"$timestamp\"}}"

. ./utils.sh

if [ $OSTYPE == "Linux" ];then
    ./DataEncode_Linux "$strStart" "$TYPE_DEV_STATUS" |openssl dgst -sha256 -binary |openssl pkeyutl -sign -inkey tracker01.key |./PackEncode_Linux $strStart $TYPE_DEV_STATUS |mosquitto_pub -t  "device/${device_id}/state" -s  -h $MQTT_BROKER_HOST  --cafile "$(pwd)/AmazonRootCA1.pem" --cert  "$(pwd)/cert.pem" --key  "$(pwd)/private.pem"  --insecure -p $MQTT_BROKER_PORT
elif [ $OSTYPE == "Darwin" ];then
    :
fi
#mosquitto_pub -t  "device/${device_id}/action/update-state" -m "$strStart" -h $MQTT_BROKER_HOST  --cafile "$(pwd)/AmazonRootCA1.pem" --cert  "$(pwd)/cert.pem" --key  "$(pwd)/private.pem"  --insecure -p $MQTT_BROKER_PORT 
while true
do

    #mosquitto_pub -t  "device/${device_id}/action/update-state" -m "$strRun" -h $MQTT_BROKER_HOST  --cafile "$(pwd)/AmazonRootCA1.pem" --cert  "$(pwd)/cert.pem" --key  "$(pwd)/private.pem"  --insecure -p $MQTT_BROKER_PORT 
    if [ $OSTYPE == "Linux" ];then
        ./DataEncode_Linux "$strRun" "$TYPE_DEV_STATUS"  |openssl dgst -sha256 -binary |openssl pkeyutl -sign -inkey tracker01.key |./PackEncode_Linux $strRun $TYPE_DEV_STATUS |mosquitto_pub -t  "device/${device_id}/state" -s  -h $MQTT_BROKER_HOST  --cafile "$(pwd)/AmazonRootCA1.pem" --cert  "$(pwd)/cert.pem" --key  "$(pwd)/private.pem"  --insecure -p $MQTT_BROKER_PORT
    elif [ $OSTYPE == "Darwin" ];then
        :
    fi    
    sleep 5
    mosquitto_pub -t  "device/${device_id}/query" -n  -h $MQTT_BROKER_HOST  --cafile "$(pwd)/AmazonRootCA1.pem" --cert  "$(pwd)/cert.pem" --key  "$(pwd)/private.pem"  --insecure -p $MQTT_BROKER_PORT
    sleep 5

done 
