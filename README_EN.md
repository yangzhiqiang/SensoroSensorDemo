# SensoroSensorDemo
This demo show how to use Sensoro sensor SDK. There are two "Target" es in project

* SensoroSensorDemo, it show how to integrate the SDK to swift project. 
* SensoroSensorOCDemo，show how to integrate the SDK to objective-c project. 

**Note** : For Objective - C project. Because the SDK implement in swift language, so you have to change `Build Setting` -> `Embedded Content Contains Swift Code` to `YES`.

###Change List:

#### 2018-04-13
**版本1.3.1**

1. Support XCode 9.3 and Swift 4.1.
2. Support upgrade the device by OTA, you need to provide firmware and password of device.
3. Support Artificial Gas and pressure sensor.


#### 2017-10-16
Suport Xcode 9 and swift 4.0.

### 2017-09-15
Add support for flame and artificial gas sensor.

### 2017-04-18 
Add password authorization in "Transfer" function

### 2017-04-14
Support longer than 20 bytes in "Transfer" function

### 2017-03-30
Support some sensor

### 2017-03-28
Add "transfer" function that user can write data by sdk through chip to custom device. or get data from custom data through chip.
