#!/bin/bash

MQTT_BROKER_HOST="a11homvea4zo8t-ats.iot.ap-east-1.amazonaws.com"
MQTT_BROKER_PORT=8883

ackStr="{\"message\":{\"downloadStatus\":1}}"

while true
do
    mosquitto_sub  -t  "device/${device_id}/action/upgrade" -h $MQTT_BROKER_HOST -C 1 --cafile "$(pwd)/AmazonRootCA1.pem" --cert  "$(pwd)/cert.pem" --key  "$(pwd)/private.pem"  --insecure -p $MQTT_BROKER_PORT
    upgrade  10
    mosquitto_pub -t  "device/${device_id}/action/download-complate" -m $ackStr -h $MQTT_BROKER_HOST  --cafile "$(pwd)/AmazonRootCA1.pem" --cert  "$(pwd)/cert.pem" --key  "$(pwd)/private.pem"  --insecure -p $MQTT_BROKER_PORT
done 