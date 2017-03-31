# SensoroSensorDemo
用于演示如何使用 Sensoro 传感器 SDK，项目中存在两个 Target，

* SensoroSensorDemo, 演示如何在 Swift 项目中使用 Sensoro 传感器 SDK。
* SensoroSensorOCDemo，演示如何在 Objective - C 项目中使用 Sensoro 传感器 SDK。在 Objective - C 项目中使用 SDK 时，需要注意一点，由于 SDK 是用 Swift 实现的，所以需要设定项目的 `Build Setting` 的 `Embedded Content Contains Swift Code` 选项为 `YES`。 

###Change List:

### 2017-03-28
用户可以通过 SDK，通过 Chip 写入后端设备，或者从后端获取数据。

### 2017-03-30
提供对一些传感器的支持。
