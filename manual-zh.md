#iOS Sensor SDK 

##快速入门

###1.添加 SensoroSensorKit.Framework 到工程里
拖动 SensoroSensorKit.Framework 到工程里，或者通过添加文件的方式添加此 Framework 到工程中。同时在项目配置中，“Embedded Binaries” 中，添加SensoroSensorKit.Framework。

由于Framework用 Swift 实现的，所以如果在 Objective - C 项目中使用，需要在 `Build Setting` 中，必须要设定 `Embedded Content Contains Swift Code` 为 `YES`

###2.导入相应的模块
在需要调用相应的 SDK 定义的地方加入下面语句。

如有必要，在 `Build Setting` 的 `Framework Search Paths` 选项中设定正确的 Framework 搜索的路径

Objective - C

```
#import <SensoroSensorKit/SensoroSensorKit-Swift.h>
```

Swift

```
import SensoroSensorKit
```

###3.声明支持相应的协议

Objective-C

```
@interface ViewController : UIViewController <SensoroDeviceManagerDelegate>
```

Swift

```
class ViewController: UIViewController, SensoroDeviceManagerDelegate
```
###4.设定代理

Objective-C

```
SensoroDeviceManager.sharedInstance.delegate = self;
```

Swift

```
SensoroDeviceManager.sharedInstance.delegate = self;
```

###5.实现代理
实现相应的协议函数，并添加相应的处理

Objective-C

```

#pragma mark SensoroDeviceManagerDelegate

- (void) deviceManager:(SensoroDeviceManager *)manager newDevices:(NSArray<SensoroDevice *> *)devices {
    //处理新发现的设备。
}

- (void) deviceManager:(SensoroDeviceManager *)manager goneDevices:(NSArray<SensoroDevice *> *)devices {
    //处理消失的设备。
}

- (void) deviceManager:(SensoroDeviceManager *)manager didRangeDevices:(NSArray<SensoroDevice *> *)devices{
    //每秒定时回调，处理状态更新。
}
```

Swift

```
// MARK: SensoroDeviceManagerDelegate    
func deviceManager(manager: SensoroDeviceManager, goneDevices devices: [SensoroDevice]) {
	//处理新发现的设备。
}
    
func deviceManager(manager: SensoroDeviceManager, newDevices devices: [SensoroDevice]) {
    //处理消失的设备。
}
    
func deviceManager(manager: SensoroDeviceManager, didRangeDevices devices: [SensoroDevice]) {
    //每秒定时回调，处理状态更新。
}
```
###6. 获取传感器的值

####例子：
* 获取SN值，并转换为字符串 <br/>

Swift

```
device.getValue(.Idx_SN).stringValue;
```
Objective - C

```
[device getValue: SensorIndexIdx_SN].stringValue;
```
* 获取温度传感器值，并转换为字符串 <br/>

Swift

```
device.getValue(.Idx_Temperature).stringValue;
```
Objective - C

```
[device getValue: SensorIndexIdx_Temperature].stringValue;
```
##透传实现
###1. 启动任务
调用 startSession 启动透传任务

Swift

```
        device.startSession(password: "xxxx", completion: { [weak self](error) in
        //启动任务成功时，调用此函数
            if error != nil {
                SVProgressHUD.showError(withStatus: "连接失败");
                print(error.debugDescription);
            }else{
                SVProgressHUD.showSuccess(withStatus: "连接成功");
                
                if let parent = self {
                    parent.connectBtn.setTitle("断开连接", for: .normal);
                }
            }
        }) { [weak self] (data, error) in
//在设备返回数据时，回调此函数
            if error != nil {
                print(error.debugDescription);
            }else{
                if let parent = self {
                    
                    if let string = String(data: data! as Data, encoding: .utf8) {
                        parent.receivedText.text = string;
                    }else{
                        parent.receivedText.text = data!.debugDescription;
                    }
                    self?.count.text = String(data!.length);
                }
            }
        }
```
OC

```
    [_device startSessionWithPassword: "xxxx" completion:^(NSError * _Nullable error) {
        if (error != nil) {
            [SVProgressHUD showErrorWithStatus:@"连接失败"];
        }else{
            [SVProgressHUD showSuccessWithStatus:@"连接成功"];
            [_connectBtn setTitle:@"断开连接" forState:UIControlStateNormal];
        }
    } notify:^(NSData * _Nullable data, NSError * _Nullable error) {
        if (error != nil ){
            NSLog(@"Error : %@",error);
        }else{
            
            NSString * ret = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            
            if (ret != nil ){
                self.receivedText.text = ret;
            }else{
                self.receivedText.text = data.debugDescription;
            }
            
            self.count.text = [NSString stringWithFormat:@"%lu", data.length];
        }
    }];
```

### 2. 写入数据
在任务建立成功后，调用函数，写入数据。

Swift

```
        if let value = "0123456789ABCDE0123456789ABCDE".data(using: .utf8) {
            device.write(data: value) { (error) in
                if error != nil {
                    print(error ?? "nil");
                }else{
                    print("Write is OK");
                }
            }
        }
```

OC

```
    NSString * writeStr = @"0123456789ABCDE0123456789ABCDE";
    NSData * data = [writeStr dataUsingEncoding:NSUTF8StringEncoding];
    
    [_device writeWithData:data writeCallback:^(NSError * _Nullable error) {
        if (error != nil ){
            NSLog(@"Write Error : %@",error);
        }else{
            NSLog(@"Write is OK");
        }
    }];
```

## 升级设备实现
### 1. 获取设备相关的信息

设备升级功能需要用户提供以下的信息。

1. 相应版本的固件。固件版本必须大于等于现在设备端的固件的版本。
2. 设备相应的密码。

### 2. 升级设备
```
        //获取指定的DFU固件
        if let firmwarePath = Bundle.main.path(forResource: "tracker_dfu_test", ofType: "zip", inDirectory: "firmware") {
            
            print(firmwarePath);

            //调用函数进行升级。
            device?.upgrade(password: "", firmware: firmwarePath, progressWatcher: { (progress) in
                //指示固件传输进度。
                self.progressLabel.text = String(format : "%.1f%%",progress);
            }, stateWatcher: { (state, error) in
                //指示固件传输的阶段
                if error == nil {//如果没有错误，则根据状态进行判断。
                    var tip = "";
                    switch state {
                    case .ready:
                        tip = "准备进入DFU";
                    case .enteringDFU:
                        tip = "正在进入DFU";
                    case .dfuTransfering:
                        tip = "正在传输数据";
                    case .disconnecting:
                        tip = "连接断开";
                    case .validating:
                        tip = "正在校验";
                    case .completed:
                        tip = "更新完成";
                    case .timeout:
                        tip = "更新超时";
                    case .failed:
                        tip = "更新失败";
                    }
                    self.statusLabel.text = tip;
                    print(tip);
                }else{//出现错误，则输出错误，升级失败。
                    let tip = "更新失败: \(error?.localizedDescription ?? "nil")"
                    self.statusLabel.text = tip;
                    print(tip);
                    
                    if let deviceInfo = (error as NSError?)?.userInfo {
                        if let deviceCode = deviceInfo["deviceError"] as? String {
                            print("Device Error : \(deviceCode)")
                        }
                    }
                    
                }
            })
        }

```



##定义说明
###<a name="SensorValue">SensorValue</a>

#### 用途
用于表示一个 Sensor 的值，有 Float，NSData，Int，String 等类型的数据。
#### 成员
#####属性：
名称|属性|类型 (Swift)|类型 (Objective - C)|说明
---|---|---|---|---
intValue|只读|Int | NSInteger | Sensor 的值可以转换时返回相应的值，不可以转换时返回Int.Max,例如，None，SN，自定义
floatValue|只读|Float | float | Sensor 的值可以转换时返回相应的值，不可以转换时返回NaN,例如，None，SN，自定义
stringValue|只读|String | NSString * | Sensor 的值可以转换时返回相应的值，不可以转换时返回空字符串
dataValue|只读|NSData | NSData * | 只有自定义数据返回值，其他的返回nil
intValue|只读|Bool | BOOL | 用于指示是否存在数值

#####函数
无

###<a name="SensoroDevice">SensoroDevice</a>
####用途
代表一个设备，可以从此对象中获取到相应的传感器信息。
####成员
#####属性
* values
	* 说明 <br/>
		返回现在系统中扫描到的所有的传感器数据。
					
#####函数
* getValue
	* 说明 <br/>
		用于返回指定的传感器的值，参数是 [SensorIndex](#SensorIndex) 类型
	* 调用方法
		* swift
			`func getValue(index : SensorIndex) -> SensorValue`
		* OC
			`- (SensorValue * _Nonnull)getValue:(enum SensorIndex)index;`
	* 返回值类型 <br/>
		SensorValue, 参考相应的传感器时，当设备不存在相应的传感器时，返回.None。
* startSession
	* 说明 <br/>
		用于启动监听任务，只有监听成功后，才可写入数据。
	* 调用方法
		* swift
			`startSession(completion : @escaping ((Error?) -> Void), notify : @escaping ((NSData?,Error?) -> Void)) -> Void`
		* OC
			`- (void)startSessionWithCompletion:(void (^ _Nonnull)(NSError * _Nullable))completion notify:(void (^ _Nonnull)(NSData * _Nullable, NSError * _Nullable))notify`
			
	* 参数说明
		* password: 设备的密码。
		* completion : 启动成功或失败时，SDK的通知用函数。错误时，Error中包含相关信息，成功时，error为nil；
		* notify : 有数据返回时调用，data包含了数据，出错时，error包含相关错误信息。		
	* 返回值类型 <br/>
		无。
* stopSession
	* 说明 <br/>
		停止监听
* write
	* 说明 <br/>
		用于启动监听任务，只有监听成功后，才可写入数据。
	* 调用方法
		* swift
			`write(data : Data, writeCallback : @escaping ((Error?) -> Void))`
		* OC
			`- (void)writeWithData:(NSData * _Nonnull)data writeCallback:(void (^ _Nonnull)(NSError * _Nullable))writeCallback`
	* 参数说明
		* data : 待写入的数据；
		* writeCallback : 写入成功或者失败是的回调函数。
	* 返回值类型 <br/>
		无。


###<a name="SensorIndex">SensorIndex</a>
####用途
索引，用于从 [SensoroDevice](#SensoroDevice) 中索引相关的传感器的值。enum 类型。
####成员定义

* Swift
    * Idx_SN // SN
    * Idx_RSSI // RSSI
    * Idx_HardwareVer // 硬件版本号
    * Idx_FirmwareVer // 固件版本号
    * Idx_BatteryLevel // 电池电量
    * Idx_Temperature // 温度传感器
    * Idx_Humidity // 湿度传感器
    * Idx_Light // 光线传感器
    * Idx_Accelerator // 加速度传感器
    * Idx_Custom // 自定义数据。
    * idx_Leak
    * idx_CO
    * idx_CO2
    * idx_NO2
    * idx_CH4
    * idx_LPG
    * idx_PM1
    * idx_PM2_5
    * idx_PM10
    * idx_Cover
    * idx_LiquidLevel    
    * idx_Unknown
* OC
    * SensorIndexIdx_SN = 0, // SN
    * SensorIndexIdx_RSSI = 1, // RSSI
    * SensorIndexIdx_HardwareVer = 2, // 硬件版本号
    * SensorIndexIdx_FirmwareVer = 3, // 固件版本号
    * SensorIndexIdx_BatteryLevel = 4, // 电池电量
    * SensorIndexIdx_Temperature = 5, // 温度传感器
    * SensorIndexIdx_Humidity = 6, // 湿度传感器
    * SensorIndexIdx_Light = 7, // 光线传感器
    * SensorIndexIdx_Accelerator = 8, //加速度传感器
    * SensorIndexIdx_Custom = 9, // 自定义数据
    * SensorIndexIdx_Leak = 10,
    * SensorIndexIdx_CO = 11,
    * SensorIndexIdx_CO2 = 12,
    * SensorIndexIdx_NO2 = 13,
    * SensorIndexIdx_CH4 = 14,
    * SensorIndexIdx_LPG = 15,
    * SensorIndexIdx_PM1 = 16,
    * SensorIndexIdx_PM2_5 = 17,
    * SensorIndexIdx_PM10 = 18,
    * SensorIndexIdx_Cover = 19,
    * SensorIndexIdx_LiquidLevel = 20,
    * SensorIndexIdx_Unknown = 21,
  	
#####属性
无
#####函数
无
		
###<a name="SensoroDeviceManager">SensoroDeviceManager</a>
####用途
用于启动设备扫描，管理设备等，单例对象。
####成员
#####属性

* sharedInstance
	* 说明 <br/>
		返回当前系统中的 SensoroDeviceManager 单例实例。
	* 类型: `SensoroDeviceManager`
	* 属性: 只读

* delegate
	* 说明 <br/>
		设定代理。
	* 类型: `SensoroDeviceManagerDelegate`
	* 属性: 只读
* devices
	* 说明 <br/>
		返回现在的发现的设备。数组中对象按照RSSI进行排序。
	* 类型: <br/>
		Swift : `[SensoroDevice]`
		
		OC : `NSArray<SensoroDevice *> *`
	* 属性: 只读
#####函数
无

###<a name="SensoroDeviceManagerDelegate">SensoroDeviceManagerDelegate</a>
####用途
代理协议，由客户端对象来实现，负责处理 [SensoroDeviceManager](#SensoroDeviceManager) 对象相关的事件。没有可选函数，每一个都是必须要实现的。

####成员
#####属性
无
#####函数
* 发现新设备 <br/>
	* 说明 <br/>
		发现新的设备时进行回调。回调内容为设备对象数组。
	* Swift 
	`func deviceManager(manager : SensoroDeviceManager, newDevices devices : [SensoroDevice]);`
	* OC
	`- (void)deviceManager:(SensoroDeviceManager * _Nonnull)manager newDevices:(NSArray<SensoroDevice *> * _Nonnull)devices;`
	* 参数
		* manager: SensoroDeviceManager，回调此函数的 SensoroDeviceManager 实例，由于系统中只存在一个 SensoroDeviceManager 实例，所以等于SensoroDeviceManager.sharedInstance
		* devices: [SensoroDevice], 包含所有新发现的设备。按照信号强度排序，信号强的排在前面。

* 设备消失 <br/>
	* 说明 <br/>
		设备消失时进行回调此函数。回调内容为设备对象数组。
	* Swift 
	`func deviceManager(manager : SensoroDeviceManager, goneDevices devices : [SensoroDevice]);`
	* OC
	`- (void)deviceManager:(SensoroDeviceManager * _Nonnull)manager goneDevices:(NSArray<SensoroDevice *> * _Nonnull)devices;`
	* 参数
		* manager: SensoroDeviceManager，回调此函数的 SensoroDeviceManager 实例，由于系统中只存在一个 SensoroDeviceManager 实例，所以等于 SensoroDeviceManager.sharedInstance
		* devices: [SensoroDevice], 包含所有消失的设备。系统中某一个设备超过8秒没有接收到信号，即认为此设备消失了，无序。

* 周期性回调
	* 说明 <br/>
		周期性进行回调，回调间隔1s，现阶段不可以调整
	* Swift 
	`func deviceManager(manager : SensoroDeviceManager, didRangeDevices devices : [SensoroDevice])`
	* OC
	`- (void)deviceManager:(SensoroDeviceManager * _Nonnull)manager didRangeDevices:(NSArray<SensoroDevice *> * _Nonnull)devices;`
	* 参数
		* manager: SensoroDeviceManager，回调此函数的 SensoroDeviceManager 实例，由于系统中只存在一个 SensoroDeviceManager 实例，所以等于 SensoroDeviceManager.sharedInstance
		* devices: [SensoroDevice], 包含所有发现的设备。按照信号强度排序，信号强的排在前面。

## 例子代码

[Github 代码](https://github.com/yangzhiqiang/SensoroSensorDemo)

包括 Swift 和 Objective - C 两个版本。

##修订历史
日期 | 版本 | 修订人 | 内容
---|---|---|---
2016-06-24|1.0|David | 初始内容
2017-04-14|1.2|David | 增加透传功能说明，及传感器支持






















