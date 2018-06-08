# SensoroSensorDemo
用于演示如何使用 Sensoro 传感器 SDK，项目中存在两个 Target，

* SensoroSensorDemo, 演示如何在 Swift 项目中使用 Sensoro 传感器 SDK。
* SensoroSensorOCDemo，演示如何在 Objective - C 项目中使用 Sensoro 传感器 SDK。在 Objective - C 项目中使用 SDK 时，需要注意一点，由于 SDK 是用 Swift 实现的，所以需要设定项目的 `Build Setting` 的 `Embedded Content Contains Swift Code` 选项为 `YES`。 

###Change List:

#### 2018-06-08
**版本1.3.2**

1. 可以从设备中获取到 peripheral，以便使用系统蓝牙进行连接。

#### 2018-04-13
**版本1.3.1**

1. 适应新版的XCode 9.3 和Swift 4.1。
2. 添加升级功能，可以通过指定固件，及设备密码来升级设备。
3. 支持人工煤气及压力传感器。

#### 2017-10-16
适应新版的XCode 9 和Swift 4.0.

#### 2017-09-15
增加火焰和人工燃气支持。

### 2017-04-14
在透传功能中，添加密码认证功能。

### 2017-04-14
透传功能中，实现超过20个字节的写入和读出。

### 2017-03-30
提供对一些传感器的支持。

### 2017-03-28
用户可以通过 SDK，通过 Chip 写入后端设备，或者从后端获取数据。
