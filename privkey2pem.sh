#!/bin/bash
## Command Line parsing
#######################

if [[ $# -lt 1 ]]; then
    echo "Usage: $ ec_sign_hex  <priv-key-hex>"
    exit 1
fi

privKeyHex=$1

## Create .pem and .pub files
#############################
pubKeyHex="$(openssl ec -inform DER -text -noout -in <(cat <(echo -n "302e0201010420") <(echo -n "${privKeyHex}") <(echo -n "a00706052b8104000a") | xxd -r -p) 2>/dev/null | tail -6 | head -5 | sed 's/[ :]//g' | tr -d '\n')"
asnFormatKey="30740201010420${privKeyHex}a00706052b8104000aa144034200${pubKeyHex}"
echo "-----BEGIN EC PARAMETERS-----" > tracker01.key
echo 06052b8104000a | xxd -r -p |base64 >> tracker01.key
echo "-----END EC PARAMETERS-----" >> tracker01.key
echo "-----BEGIN EC PRIVATE KEY-----" >> tracker01.key
echo $asnFormatKey | xxd -r -p | base64 | fold -w 64 >> tracker01.key
echo "-----END EC PRIVATE KEY-----" >> tracker01.key
echo $privKeyHex > privKey

