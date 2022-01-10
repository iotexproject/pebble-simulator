#!/bin/bash


TYPE_SENSRO_DATA="0"
TYPE_REG_CONFIRM="1"
TYPE_CONF_UP_LOAD="2"
TYPE_DEV_STATUS="3"

TYPE_DECODE_CONFIRM="0"
TYPE_DECODE_REG_OVER="1"

MQTT_CERT="$(pwd)/cert_mainnet.pem"
MQTT_KEY="$(pwd)/private_mainnet.pem"
NETTYPE="mainnet"
MQTT_BROKER_HOST="a11homvea4zo8t-ats.iot.ap-east-1.amazonaws.com"
MQTT_BROKER_PORT=8883


OSTYPE="Linux"
os_detect()
{
    # Mac 
    if [ "$(uname)" == "Darwin" ];then           
        OSTYPE="Darwin"
        echo "Darwin detected"
    # GNU/Linux
    elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ];then  
        OSTYPE="Linux"
        echo "Linux detected"
    else
        OSTYPE="unknowtype"
        echo "unknow os"
    fi    
}

net_selection()
{
    if [[ "$1" == "mainnet" ]];then
        MQTT_CERT="$(pwd)/cert_mainnet.pem"
        MQTT_KEY="$(pwd)/private_mainnet.pem"
        MQTT_BROKER_HOST="a11homvea4zo8t-ats.iot.ap-east-1.amazonaws.com"
        NETTYPE="mainnet"

        echo "mainnet"
    else
        MQTT_CERT="$(pwd)/cert_testnet.pem"
        MQTT_KEY="$(pwd)/private_testnet.pem"
        MQTT_BROKER_HOST="a11homvea4zo8t-ats.iot.us-east-1.amazonaws.com"
        NETTYPE="testnet"
    fi
}