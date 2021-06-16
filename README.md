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
apt-get install  openssl
apt-get install  mosquitto-clients
```

### MacOS
```
brew install openssl
brew install mosquitto
```
## Run the simulator

```
./simulator.sh

========>> PEBBLE SIMULATOR <<========
 1.  Config Sensors
 2.  Set Number of Data Points (Current: 30)
 3.  Generate Simulated Data
 4.  Publish to IoTT Portal
 5.  Publish to IoTeX Blockchain
 6.  Device Registration
 7.  Set Device IMEI (Current: 498090403799636)
 8.  Update ECC key pair

 9.  Exit


Select:

```
## Generate the data points
By default, the scirpt will generate 30 data points using random values for each of the 8 sensors available on Pebble Tracker, along with the elliptic curve signature for each data point. You can change the number of generated data points by selecting the menu item #2. Finally select the menu item #3 to generate and save the data points to pebble.dat. Each data point is saved in JSON format:
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

