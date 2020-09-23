# pebble-simulator
The simulator for producing pebble data.

## Dependencies
- linux bash
- openssl
- mosquitto-clients

## Run
`./simulator.sh`

This, by default, produces 30 data points for all 8 sensors at random. The output is written to pebble.dat which looks like below.
```
{"message":{"SNR":187,"VBAT":4.36002,"gas_resistance":1173,"temperature":16.21609,"pressure":515.32678,"humidity":31.51630,"temperature":76.22284,"gyroscope":[6,-1214,8],"accelerometer":[937,1214,1491],"timestamp":"85000"},"signature_r":"00fb7f17b6f524a684ac392eb47761bd1f994fd0a1f92d227a263e3ea981d2007e02204","signature_s":""}
```

## Files
`tracker01.key` - ECDSA private key used by the simulator

`simulator.sh` - The simulator

`pebble.dat` - The data points produced which are in JSON format

`public.pem` - MQTT client  public certification

`AmazonRootCA1.pem` - AWS IOT CA certification

`private.pem` - MQTT client  private key



