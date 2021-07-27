# Pebble Simulator
This is a shell script that simulates verifiable IoT data produced by a Pebble Tracked device and store it to a local file. If required, the script can publish the data to AWS IoT Core using MQTT similarly to a real Pebble Tracker device. 

# Installation
The script has been successfully tested on Ubuntu 16.04.6 and MacOS 10.14

### Dependencies
- linux bash
- openssl 1.0.2g or later
- mosquitto-clients

### Ubuntu
Run the following commands in a Linux shell 
```
$ apt-get install  openssl
$ apt-get install  mosquitto-clients
```

### MacOS
```
$ brew install openssl
$ brew install mosquitto
```
## Run the simulator
```
$ ./simulator.sh

========>> PEBBLE SIMULATOR <<========

 1.  Config Sensors

 2.  Set Number of Data Points (Current: 30)

 3.  Generate Simulated Data

 4.  Publish to IoTT Portal

 5.  Publish to IoTeX Blockchain

 6.  Device Registration

 7.  Set Device IMEI (Current: 123456655945820)

 8.  Update ECC key pair

 9.  Exit

Select:
```
## How to registration
1. Run the simulator
```
    ./simulator.sh
```

2. Select menu '5' 

3. Add a device on the page:  https://portal.iott.network/"
    
    When you get the prompt "Device registration complete!", it means that the device has been registered

## Generate the data points
You need to register the device before generating data.By default, the scirpt will generate 30 data points using random values for each of the 8 sensors available on Pebble Tracker, along with the elliptic curve signature for each data point. You can change the number of generated data points by selecting the menu item #2. Finally select the menu item #3 to generate and save the data points to pebble.dat. Each data point is saved in JSON format:
```json
{
    "message": {
        "snr": 185,
        "vbat": 3.98584,
        "latitude": 8150.30185,
        "longitude": 9830.17993,
        "gasResistance": 1124,
        "temperature": 16.38644,
        "pressure": 503.77594,
        "humidity": 31.56519,
        "light": 725.80341,
        "temperature2": 76.39319,
        "gyroscope": [7, -1184, 8],
        "accelerometer": [906, 1184, 1461],
        "timestamp": "150000",
        "random": "e954d411fed3f5c0"
    },
    "signature": {
        "r": "4c05a4fa3eba782780a517ba03ef6fdd65e5b560a027808b47fcc6ed2b864169",
        "s": "05bde29104febe10c096c550b91f5d8ed2cf0d15fe48e164ee0e9765dda76f34"
    }
}
```

```
$ cat pebble.dat

{"message":{"snr":3,"vbat":0.96024,"latitude":1608.27036,"longitude":15147.14661,"gasResistance":3451,"temperature":39.17099,"pressure":1084.90033,"humidity":60.16272,"light":1306.92780,"temperature2":19.17529,"gyroscope":[11,-2638,-13],"accelerometer":[2361,2638,2915],"timestamp":"5000","random":"3f7e6c358150c30c"},"signature":{"r":"5d1557f43c6aa781e82043f73f84cca9cd06e5eba06b530a9d83d28e89889f38","s":"1a79e43825a1f5e48706d8e4eb359c283c8f31fa4f9b37f2200494f8a137a2e4"}}
{"message":{"snr":88,"vbat":2.59143,"latitude":4628.10452,"longitude":2906.98260,"gasResistance":6099,"temperature":65.62442,"pressure":1746.80295,"humidity":93.23846,"light":1968.83044,"temperature2":45.63116,"gyroscope":[-1,2,-4570],"accelerometer":[4016,4293,4570],"timestamp":"10000","random":"0bfc6c9b3363ec67"},"signature":{"r":"d46facce007012e22dbcf47b0e54d8bb07a1dc25d5ad49bf7da62a96157d8741","s":"08b65972c616ee6c0cf6f5d501cab49995f4d32b70a908c1d7cac5254ffa63fc"}}
...
{"message":{"snr":86,"vbat":2.48517,"latitude":157.96259,"longitude":12137.83881,"gasResistance":2153,"temperature":26.61856,"pressure":760.86353,"humidity":44.36566,"light":982.82999,"temperature2":6.62286,"gyroscope":[9,-1826,-10],"accelerometer":[1549,1826,2104],"timestamp":"25000","random":"6b95e9e7a4bcd119"},"signature":{"r":"8bec9b753ae7743f7c6ac9cb51baa5c70f12e9f511c96216975657002b809768","s":"4dccd4be89388ba70ef3b498a8c56e1acfad859f73526591b8988a8536d8d70e"}}
```
## How to config private key
1. Run the simulator.
```
./simulator.sh
```
2. Select menu '7'. 
   
3. Select menu '1' if you enter a new private key. Or the simulator automatically generates a private key, select menu '2'.
   
4. Now return to the main menu, you can see the configured private key at the end of menu '7'.



