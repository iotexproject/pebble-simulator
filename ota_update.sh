#!/bin/bash


ackStr="{\"message\":{\"downloadStatus\":1}}"

MQTT_CERT=$1
MQTT_KEY=$2
MQTT_BROKER_HOST=$3
MQTT_BROKER_PORT=$4

while true
do
    mosquitto_sub  -t  "device/${device_id}/action/upgrade" -h $MQTT_BROKER_HOST -C 1 --cafile "$(pwd)/AmazonRootCA1.pem" --cert  "$MQTT_CERT" --key  "$MQTT_KEY"  --insecure -p $MQTT_BROKER_PORT
    sleep  10
    mosquitto_pub -t  "device/${device_id}/action/download-complate" -m $ackStr -h $MQTT_BROKER_HOST  --cafile "$(pwd)/AmazonRootCA1.pem" --cert  "$MQTT_CERT" --key  "$MQTT_KEY"  --insecure -p $MQTT_BROKER_PORT
done 