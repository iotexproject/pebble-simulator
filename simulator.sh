#!/bin/bash

# version
VER="v1.02"

# set default mode
default_mode="random"


SNR=0
snr_mode=$default_mode

VBAT=4.145454406738281
vbat_mode=$default_mode

GPS=(3158.46080 11848.37307)
gps_mode=$default_mode

ENV=(5312190 31.838768005371094 1006.739990234375 51.03300094604492)
env_mode=$default_mode

LIGHT=53.85771942138672
light_mode=$default_mode

gyr=(-2 9 12)
gyr_mode=$default_mode

accel=(-38 166 8270)
accel_mode=$default_mode

temp=31.838768005371094
temp_mode=$default_mode

timestp="3334970018"
#timestp_mode="fixed"

RANDOM_MAX_INT=32768

STEP=10

CountPkg=30

genFile="$(pwd)/pebble.dat"

getTime()
{
	current=`date "+%Y-%m-%d %H:%M:%S"`
	timeStamp=`date -d "$current" +%s`
	# ms
	currentTimeStamp=$(( timeStamp*1000+`date "+%N"`/1000000 ))
	echo $currentTimeStamp
}


SetMode()
{
     local  mode_sel=( "fixed" "random" "linear" )
     printf '\033\143'
     echo " 1. fixed"
     echo " 2. random"
     echo " 3. linear"
     read -n 1 key
     case $1 in
     1)
       snr_mode=${mode_sel[$key]}
	;;
     2)
       vbat_mode=${mode_sel[$key]}
	;;
     3)
       gps_mode=${mode_sel[$key]}
	;;
     4)
       env_mode=${mode_sel[$key]}
	;;
     5)
       light_mode=${mode_sel[$key]}
	;;
     6)
       gyr_mode=${mode_sel[$key]}
	;;
     7)
       accel_mode=${mode_sel[$key]}
	;;
     8)
       temp_mode=${mode_sel[$key]}
	;;
     9)
       timestp_mode=${mode_sel[$key]}
	;;
     esac
     if [ $key == "1" ];then
     case $1 in
     1)
       echo "Please input SNR data end with enter( eg. 0 ) :"
       read str
       SNR=$str
	;;
     2)
       echo "Please input VBAT data end with enter( eg. 4.145454406738281 ) :"
       read str
       VBAT=$str
	;;
     3)
       echo "Please input GPS data end with enter( eg. 60.500525 13.886719 ) :"
       read str
       GPS[0]=$(echo $str|awk '{print  $1 }')
       GPS[1]=$(echo $str|awk '{print  $2 }')
	;;
     4)
       echo "Please input env data end with enter(gas_resistance temperature pressure humidity)( eg. 5312190 31.838768005371094 1006.739990234375 51.03300094604492 ):"
       read str
       env_mode[0]=$(echo $str|awk '{print  $1 }')
       env_mode[1]=$(echo $str|awk '{print  $2 }')
       env_mode[2]=$(echo $str|awk '{print  $3 }')
       env_mode[3]=$(echo $str|awk '{print  $4 }')
	;;
     5)
       echo "Please input light data end with enter( eg. 53.85771942138672 ) :"
       read str
       LIGHT=$str
	;;
     6)
       echo "Please input gyroscope data end with enter( eg. -2 9 12 ) :"
       read str
       gyr_mode[0]=$(echo $str|awk '{print  $1 }')
       gyr_mode[1]=$(echo $str|awk '{print  $2 }')
       gyr_mode[2]=$(echo $str|awk '{print  $3 }')
	;;
     7)
       echo "Please input accelerometer data end with enter( eg. -38 166 8270 ) :"
       read str
       accel_mode[0]=$(echo $str|awk '{print  $1 }')
       accel_mode[1]=$(echo $str|awk '{print  $2 }')
       accel_mode[2]=$(echo $str|awk '{print  $3 }')
	;;
      8)
       echo "Please input temperature data end with enter( eg. 31.83876 ) :"
       read str
       temp=$str
	;;
     esac
     fi
}



SensorMenu()
{
	while true
        do
		printf '\033\143'
		echo "Enter number to select a sensor to config"
		echo ""
		echo " Sensor             Mode              Default Data"
		echo ""
		echo " 1. SNR             $snr_mode            $SNR"
		echo " 2. VBAT            $vbat_mode            $VBAT"
		echo " 3. GPS             $gps_mode            ${GPS[0]},${GPS[1]}"
		echo " 4. ENV             $env_mode            ${ENV[0]},${ENV[1]},${ENV[2]}"
		echo " 5. LIGHT           $light_mode            $LIGHT"
		echo " 6. gyroscope       $gyr_mode            ${gyr[0]},${gyr[1]},${gyr[2]}"
		echo " 7. accelerometer   $accel_mode            ${accel[0]},${accel[1]},${accel[2]}"
                echo " 8. temperature     $temp_mode            $temp"
                echo "---------------------------------------------------------------------------"
		echo " 9. Main menu"
		read -n 1 key
		if [ "$key" == "9" ];then
			break
		else
			SetMode $key
		fi
	done
}
RandomInt()
{
  local min=$1
  local max=$2
  local random=$( echo "${min}+${RANDOM}/${RANDOM_MAX_INT}*(${max}-${min}+1)" | bc -l )
  echo -n ${random%.*}
}
RandomFloat()
{

  local precision=$1
  local scale=$2
  local max_int=$3
  local random=$( echo "${RANDOM}/${RANDOM_MAX_INT}*(${max_int}^${precision}) + ${RANDOM}/${RANDOM_MAX_INT} " | bc -l )
  printf "%.${scale}f" ${random}

}

NextData()
{
    # SNR
     if [ $snr_mode == "random" ];then
         SNR=$( RandomInt 0 255 )
     elif [ $snr_mode == "linear" ];then
         let SNR += $STEP
         if [ $SNR > 255 ];then
             SNR=0
         fi
     fi
     # VBAT
     if [ $vbat_mode == "random" ];then
         VBAT=$( RandomFloat 1 5 5 )
     elif [ $snr_mode == "linear" ];then
         let VBAT += 1
         if [ $VBAT > 5 ];then
             VBAT=0.145454406738281
         fi
     fi
     # GPS
     if [ $gps_mode == "random" ];then
         gps_m=$( RandomFloat 1 5 60 )
         gps_g=$( RandomInt 0 90 )
         let gps_g=gps_g*100
         GPS[0]=$(echo $gps_g+$gps_m |bc -l)
         gps_m=$( RandomFloat 1 5 60 )
	 gps_g=$( RandomInt 0 180 )
	 let gps_g=gps_g*100
         GPS[1]=$(echo $gps_g+$gps_m |bc -l)
     elif [ $snr_mode == "linear" ];then
         GPS[0] = $(echo ${GPS[0]} + 2.1000|bc -l)
         GPS[1] = $(echo ${GPS[1]} + 2.1000|bc -l)
         if [ ${GPS[0]} > 9060 ];then
             GPS[0]=1032.14545
         fi
         if [ ${GPS[1]} > 18060 ];then
             GPS[1]=10030.14545
         fi
     fi
      # ENV
      if [ $env_mode == "random" ];then
         ENV[0]=$( RandomInt 0 8000 )
         ENV[1]=$( RandomFloat 1 5 80 )
         ENV[2]=$( RandomFloat 1 5 2000 )
         ENV[3]=$( RandomFloat 1 5 100 )
      elif [ $env_mode == "linear" ];then
         ENV[0] = $(echo ${ENV[0]} + 100|bc -l)
         ENV[1] = $(echo ${ENV[1]} + 2.1000|bc -l)
         ENV[2] = $(echo ${ENV[2]} + 100|bc -l)
         ENV[3] = $(echo ${ENV[3]} + 2.100|bc -l)
         if [ ${ENV[0]} > 8000 ];then
             ENV[0]=10.14545
         fi
         if [ ${ENV[1]} > 80 ];then
             GPS[1]=10.14545
         fi
         if [ ${ENV[2]} > 2000 ];then
             ENV[0]=10.14545
         fi
         if [ ${ENV[3]} > 100 ];then
             GPS[1]=10.14545
         fi
      fi
      # Light
      if [ $light_mode == "random" ];then
         LIGHT=$( RandomFloat 1 5 2000 )
     elif [ $light_mode == "linear" ];then
         LIGHT=$(echo $LIGHT+50.10001|bc -l)
         if [ $LIGHT > 2000 ];then
             LIGHT=10.14545
         fi
     fi
     # gyroscope
      if [ $gyr_mode == "random" ];then
         gyr[0]=$( RandomInt 1 15 )
         gyr[1]=$( RandomInt 1 15 )
         gyr[2]=$( RandomInt 1 15 )
         flg=$( RandomInt 1 3 )
         let flg=flg-1     
         gyr[${flg}]=$(echo 0-${gyr[${flg}]}|bc -l)
      elif [ $gyr_mode == "linear" ];then
         gyr[0]=$(${gyr[0]} + 1|bc -l)
         gyr[1]=$(${gyr[1]} + 1|bc -l)
         gyr[2]=$(${gyr[2]} + 1|bc -l)
         if [ ${gyr[0]} > 15 ];then
             gyr[0]=-1
         fi
         if [ ${ENV[1]} > 15 ];then
             gyr[1]=1
         fi
         if [ ${ENV[2]} > 15 ];then
             gyr[2]=-2
         fi
      fi
     # accelerometer
      if [ $accel_mode == "random" ];then
         accel[0]=$( RandomInt 0 5000 )
         accel[1]=$( RandomInt 0 5000 )
         accel[2]=$( RandomInt 0 5000 )
         flg=$( RandomInt 1 3 )
         let flg=flg-1
         gyr[$flg]=$(echo 0-${accel[$flg]}|bc -l)
      elif [ $gyr_mode == "linear" ];then
         accel[0]=$(${accel[0]} + 20|bc -l)
         accel[1]=$(${accel[1]} + 20|bc -l)
         accel[2]=$(${accel[2]} + 20|bc -l)
         if [ ${gyr[0]} > 5000 ];then
             accel[0]=-10
         fi
         if [ ${accel[1]} > 5000 ];then
             accel[1]=-12
         fi
         if [ ${accel[2]} > 5000 ];then
             accel[2]=500
         fi
      fi
      #temperature
      if [ $light_mode == "random" ];then
         temp=$( RandomFloat 1 5 80 )
     elif [ $light_mode == "linear" ];then
         temp=$(echo $temp+2.10001|bc -l)
         if [ $temp > 80 ];then
             temp=10.14545
         fi
     fi
      let timestp=timestp+5000
}

GenerateFile()
{    
    if [ -a $genFile ];then
    	rm $genFile
    fi

    for((integer = 1; integer <= $CountPkg; integer++))
    do
	NextData
       objMessage="\"message\":{\"SNR\":$SNR,\"VBAT\":$VBAT,\"latitude\":${GPS[0]},\"longitude\":${GPS[1]},\"gas_resistance\":${ENV[0]},\"temperature\":${ENV[1]},\"pressure\":${ENV[2]},\"humidity\":${ENV[3]},\"temperature\":$temp,\"gyroscope\":[${gyr[0]},${gyr[1]},${gyr[2]}],\"accelerometer\":[${accel[0]},${accel[1]},${accel[2]}],\"timestamp\":\"$timestp\"}"
       ecc_str=$(echo $objMessage |openssl dgst -sha256 -sign tracker01.key |xxd -ps)
       ecc_str=$(echo $ecc_str|sed  's/ //g')
       sign_r=$(echo ${ecc_str:8:71})
       sign_s=$(echo ${ecc_str:78:141})
       echo "{$objMessage,\"signature_r\":\"$sign_r\",\"signature_s\":\"$sign_s\"}" >> $genFile
    done

}

NumberofPackages()
{
	printf '\033\143'
	echo "How many packages you want to generate :"
	read key
        CountPkg=$key
}

main()
{
    timestp=$( getTime )
    #echo $timestp
    while true
    do
        printf '\033\143'
        echo "========>> PEBBLE SIMULATOR <<========"
        echo ""
        echo ""
        echo " 1.  Config Sensors"
        echo ""
        echo " 2.  Set Number of Data Points: $CountPkg"
        echo ""
        echo " 3.  Upload to AWS MQTT"
        echo ""
        echo " 4.  Run - Produce Data Points"
        echo ""
        echo " 5.  Exit"
        echo ""
        echo "Select:"
        read -n 1 key
        if [[ $key == "1" ]];then
            SensorMenu
        elif [[ $key == "2" ]] ;then
	    NumberofPackages
        elif [[ $key == "3" ]] ;then
            echo ""
	    echo  "Will be done later"
            break
        elif [[ $key == "4" ]];then
            echo ""
            GenerateFile
            echo ""
            echo "${genFile}  generated!"
            echo ""
            break
        else
            break
        fi
    done
}

if [ "$1" == "-v" ];then
	echo  "$VER" 
        exit
fi


main

