#!/bin/bash


# config  mqtt broker host
MQTT_BROKER_HOST="a11homvea4zo8t-ats.iot.us-east-2.amazonaws.com"
MQTT_BROKER_PORT=8883



defDeviceID="Not Configured"


devWorkmode=0
devChannel=1FF7

devUpPeriod=10

devSampleN=30
devUpInterval=10



confDevID()
{
    printf '\033\143'
    echo ""
    echo " Please enter the device id and end with enter"
    read  key
    defDeviceID=$key
    echo "Your device id is $defDeviceID ,press any key to return to main menu" 
    read -n 1 key
}

confParam()
{
    printf '\033\143'
    echo ""
    if [ $devWorkmode == "1" ];then
        echo " 1. Set Working mode (Current: Bulk Upload)"
    else
        echo " 1. Set Working mode (Current: Periodic Upload)"
    fi  
    echo ""
    echo " 2. Set Data Channel(Hexadecimal) (Current:$devChannel)"  
    echo ""
    echo " 3. Set Periodic Upload cycle (Current: $devUpPeriod s)"
    echo ""
    echo " 4. Set Number of Samples (Current : $devSampleN)"
    echo ""
    echo " 5. Set Bulk Upload Interval (Current : $devUpInterval s)"
    echo ""
    echo " 6. Press any key to return"
    read  -n 1 key
    printf '\033\143'
    case $key in
        1)
            echo "1. Bulk Upload"
            echo ""
            echo "2. Periodic Upload"
            echo ""
            read -n 1 key
            if [ $key == "1" ] ;then 
               devWorkmode=1
            else
               devWorkmode=0
            fi
        ;;
        2)
            echo " Input Data Channel(Uppercase hexadecimal):"
            read  key
            devChannel=$key            
        ;;
        3)
            echo "Input Periodic Upload cycle(Unit s):"
            read key
            devUpPeriod=$key
        ;;
        4)
            echo "Input Number of Samples:"
            read key
            devSampleN=$key
        ;;
        5)
            echo "Input Bulk Upload Interval(Unit s):"
            read key
            devUpInterval=$key
        ;;
    esac
}

pubData()
{
    printf '\033\143'
   
    if [ "$defDeviceID" == "Not Configured" ];then
        echo "Device id  not configured"
        echo "Press '1' in main menu to set device id"
        echo "Press any key to return"
        read -n 1 key
        return
    fi
      
    echo "Publish Topic : topic/config/$defDeviceID"
       
    hexToDecimal=$(echo "obase=10; ibase=16; $devChannel" | bc)
    echo ""
    echo "Json package:"
    echo "{"
    echo "     \"bulk_upload\":$devWorkmode,
     \"data_channel\":$hexToDecimal,
     \"upload_period\":$devUpPeriod,
     \"bulk_upload_sampling_cnt\":$devSampleN,
     \"bulk_upload_sampling_freq\":$devUpInterval"
    echo "}"

    objMessage="{\"bulk_upload\":$devWorkmode,\"data_channel\":$hexToDecimal,\"upload_period\":$devUpPeriod,\"bulk_upload_sampling_cnt\":$devSampleN,\"bulk_upload_sampling_freq\":$devUpInterval}"
    mosquitto_pub -t  topic/config/$defDeviceID -m $objMessage -h $MQTT_BROKER_HOST  --cafile "$(pwd)/AmazonRootCA1.pem" --cert  "$(pwd)/cert.pem" --key  "$(pwd)/private.pem"  --insecure -p $MQTT_BROKER_PORT

    echo "Publish complete"
    echo "Press any key to return"
    read -n 1 key    
}



while true 

do

    printf '\033\143'
    echo "========>> PEBBLE CONFIGURE <<========"
    echo ""
    echo " 1. Set  Device ID (Current  $defDeviceID)"
    echo ""
    echo " 2. Configuration parameter "
    echo ""
    echo " 3. Publish to broker "
    echo ""
    echo " 4. Other keys to exit"
    echo ""
    read -n 1 key
    echo ""
    case $key in

       1)
           confDevID
       ;;
       2)
           confParam
       ;;
       3)
           pubData 
       ;;
       *)
           break
       ;;
    esac

done

