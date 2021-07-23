#!/bin/bash




TYPE_SENSRO_DATA="0"
TYPE_REG_CONFIRM="1"
TYPE_CONF_UP_LOAD="2"
TYPE_DEV_STATUS="3"

TYPE_DECODE_CONFIRM="0"
TYPE_DECODE_REG_OVER="1"

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
