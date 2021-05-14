#!/bin/bash

MQTT_BROKER_HOST="a11homvea4zo8t-ats.iot.ap-east-1.amazonaws.com"
MQTT_BROKER_PORT=8883

strStart="{\"message\":{\"deviceState\":\"online\"}}"
strRun="{\"message\":{\"deviceState\":\"running\"}}"

mosquitto_pub -t  "device/${device_id}/action/update-state" -m "$strStart" -h $MQTT_BROKER_HOST  --cafile "$(pwd)/AmazonRootCA1.pem" --cert  "$(pwd)/cert.pem" --key  "$(pwd)/private.pem"  --insecure -p $MQTT_BROKER_PORT 
while true
do

    mosquitto_pub -t  "device/${device_id}/action/update-state" -m "$strRun" -h $MQTT_BROKER_HOST  --cafile "$(pwd)/AmazonRootCA1.pem" --cert  "$(pwd)/cert.pem" --key  "$(pwd)/private.pem"  --insecure -p $MQTT_BROKER_PORT 
    sleep 20

done 