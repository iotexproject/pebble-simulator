#!/bin/bash




device_id=$1

timestamp=$2

MQTT_CERT=$3
MQTT_KEY=$4
MQTT_BROKER_HOST=$5
MQTT_BROKER_PORT=$6

strStart="{\"message\":{\"deviceState\":\"0\",\"timestamp\":\"$timestamp\"}}"
strRun="{\"message\":{\"deviceState\":\"3\",\"timestamp\":\"$timestamp\"}}"



#if [ $OSTYPE == "Linux" ];then
#    ./DataEncode_Linux "$strStart" "$TYPE_DEV_STATUS" |openssl dgst -sha256 -binary |openssl pkeyutl -sign -inkey tracker01.key |./PackEncode_Linux $strStart $TYPE_DEV_STATUS |mosquitto_pub -t  "device/${device_id}/state" -s  -h $MQTT_BROKER_HOST  --cafile "$(pwd)/AmazonRootCA1.pem" --cert  "$MQTT_CERT" --key  "$MQTT_KEY"  --insecure -p $MQTT_BROKER_PORT
#elif [ $OSTYPE == "Darwin" ];then
#    :
#fi
#mosquitto_pub -t  "device/${device_id}/action/update-state" -m "$strStart" -h $MQTT_BROKER_HOST  --cafile "$(pwd)/AmazonRootCA1.pem" --cert  "$MQTT_CERT" --key  "$MQTT_KEY"  --insecure -p $MQTT_BROKER_PORT 
while true
do

    #mosquitto_pub -t  "device/${device_id}/action/update-state" -m "$strRun" -h $MQTT_BROKER_HOST  --cafile "$(pwd)/AmazonRootCA1.pem" --cert  "$MQTT_CERT" --key  "$MQTT_KEY"  --insecure -p $MQTT_BROKER_PORT 
#    if [ $OSTYPE == "Linux" ];then
#        ./DataEncode_Linux "$strRun" "$TYPE_DEV_STATUS"  |openssl dgst -sha256 -binary |openssl pkeyutl -sign -inkey tracker01.key |./PackEncode_Linux $strRun $TYPE_DEV_STATUS |mosquitto_pub -t  "device/${device_id}/state" -s  -h $MQTT_BROKER_HOST  --cafile "$(pwd)/AmazonRootCA1.pem" --cert  "$MQTT_CERT" --key  "$MQTT_KEY"  --insecure -p $MQTT_BROKER_PORT
#    elif [ $OSTYPE == "Darwin" ];then
#        :
#    fi    
#    sleep 5
    mosquitto_pub -t  "device/${device_id}/query" -n  -h $MQTT_BROKER_HOST  --cafile "$(pwd)/AmazonRootCA1.pem" --cert  "$MQTT_CERT" --key  "$MQTT_KEY"  --insecure -p $MQTT_BROKER_PORT
    sleep 5

done 
