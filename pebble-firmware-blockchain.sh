#!/bin/bash


RSA_PRIVATE_KEY_FILE="$(pwd)/rsa_private_key.pem"
RSA_PUBLIC_KEY_FILE="$(pwd)/rsa_public_key.pem"


OSTYPE="Linux"
RSAInit()
{
    # generate RSA private key
    if [ ! -f "$RSA_PRIVATE_KEY_FILE" ];then
        if [ -f "$RSA_PUBLIC_KEY_FILE" ];then
            rm -rf "$RSA_PUBLIC_KEY_FILE"
        fi
        openssl genrsa -out rsa_private_key.pem 2048        
    fi
    if [ ! -f "$RSA_PUBLIC_KEY_FILE" ];then
        openssl rsa -in rsa_private_key.pem -pubout -out rsa_public_key.pem
    fi 
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

#hexdump -e '16/1 "%02X"' hello.en | xxd -r -p| openssl rsautl -decrypt -inkey rsa_private_key.pem
RSADecrypto()
{
    str=$1
    echo -n $str |xxd -r -p | openssl pkeyutl -inkey rsa_private_key.pem  -pkeyopt rsa_padding_mode:oaep -pkeyopt rsa_oaep_md:sha256 -decrypt
}
# $1 : device id , $2 : pebble contract
GetResponse()
{
    if [ $OSTYPE == "Linux" ];then
        ./pebble_contract_linux  $1 $2
    elif [ $OSTYPE == "Darwin" ];then
        ./pebble_contract_darwin $1 $2
    else
        echo "un os type"
        return
    fi    
}


