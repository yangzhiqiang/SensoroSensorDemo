#iOS Sensor SDK 

##Quick Start

###1.Adding SensoroSensorKit.Framework to the workspace

Drag SensoroSensorKit.Framework to the workspace, or add file to the Framework onto workspace while adding SensoroSensorKit.Framework to the project's config file and “Embedded Binaries”

Since the Framework is completed with Swift, if you want to run it in Objective-C projects, please set `Embedded Content Contains Swift Code` in `Build Setting` to `YES`

###2.Importing Modules

Adding the following statement in the corresponding SDK definition

If necessary, set up the dependency path in 'Build Setting'－`Framework Search Paths`

Objective - C

```
#import <SensoroSensorKit/SensoroSensorKit-Swift.h>
```

Swift

```
import SensoroSensorKit
```

###3.Declaration to Support  Corresponding Protocol

Objective-C

```
@interface ViewController : UIViewController <SensoroDeviceManagerDelegate>
```

Swift

```
class ViewController: UIViewController, SensoroDeviceManagerDelegate
```
###4.Proxy Setting

Objective-C

```
SensoroDeviceManager.sharedInstance.delegate = self;
```

Swift

```
SensoroDeviceManager.sharedInstance.delegate = self;
```

###5.Proxy Implementation

Implement corresponding protocol function and add the handler

Objective-C

```

#pragma mark SensoroDeviceManagerDelegate

- (void) deviceManager:(SensoroDeviceManager *)manager newDevices:(NSArray<SensoroDevice *> *)devices {
    //process new discover devices.
}

- (void) deviceManager:(SensoroDeviceManager *)manager goneDevices:(NSArray<SensoroDevice *> *)devices {
    //process disappear devices.
}

- (void) deviceManager:(SensoroDeviceManager *)manager didRangeDevices:(NSArray<SensoroDevice *> *)devices{
    //periodic callback per second，update the processing state.
}
```

Swift

```
// MARK: SensoroDeviceManagerDelegate    
func deviceManager(manager: SensoroDeviceManager, goneDevices devices: [SensoroDevice]) {
	//process new discover devices.
}

func deviceManager(manager: SensoroDeviceManager, newDevices devices: [SensoroDevice]) {
    //process disappear devices.
}
   
(unc deviceManager(manager: SensoroDeviceManager, newDevices devices: [SensoroDevice]) {
    //process the disappear devices
}
  
func deviceManager(manager: SensoroDeviceManager, didRangeDevices devices: [SensoroDevice]) {
    //periodic callback per second，update the processing state.
}
```


###6. Receiving Sensor Values


####Example：
* receive the SN value and convert to string <br/>


Swift

```
device.getValue(.Idx_SN).stringValue;
```
Objective - C

```
[device getValue: SensorIndexIdx_SN].stringValue;
```
* receive the thermometer sensor value and covert to string <br/>

Swift

```
device.getValue(.Idx_Temperature).stringValue;
```
Objective - C

```
[device getValue: SensorIndexIdx_Temperature].stringValue;
```

## Upgrade firmware

### 1. Getting information to upgrade device


1. firmware that version is newer or equal than version of firmware of device.
2. password of device.

### 2. Upgrade
```
        //Getting path of firmware
        if let firmwarePath = Bundle.main.path(forResource: "tracker_dfu_test", ofType: "zip", inDirectory: "firmware") {
            
            print(firmwarePath);

            //call upgrade method to upgrade it.
            device?.upgrade(password: "", firmware: firmwarePath, progressWatcher: { (progress) in
                //indicator to progress to transfer firmware.
                self.progressLabel.text = String(format : "%.1f%%",progress);
            }, stateWatcher: { (state, error) in
                //indicator 
                if error == nil {
                    var tip = "";
                    switch state {
                    case .ready:
                        tip = "Ready to entere DFU";
                    case .enteringDFU:
                        tip = "entering DFU";
                    case .dfuTransfering:
                        tip = "transfering data";
                    case .disconnecting:
                        tip = "disconnecting";
                    case .validating:
                        tip = "validate data";
                    case .completed:
                        tip = "upgrade is ok";
                    case .timeout:
                        tip = "timeout";
                    case .failed:
                        tip = "failed";
                    }
                    self.statusLabel.text = tip;
                    print(tip);
                }else{//
                    let tip = "Failed: \(error?.localizedDescription ?? "nil")"
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



##Definition Description

###<a name="SensorValue">SensorValue</a>

#### Purpose

To define to value of a sensor，including Float，NSData，Int，String and other data type.

#### Member

##### Property


Name|Attribute|Type (Swift)|Type (Objective - C)|Description
---|---|---|---|---
intValue|read-only|Int | NSInteger | If the value of `Sensor` is transformable, it returns the corresponding value; otherwise, it returns Int.Max. For example, None, SN, or Custom
floatValue|read-only|Float | float | If the value of `Sensor` is transformable, it returns the corresponding value; otherwise, it returns NaN. For example, None, SN, or Custom
stringValue|read-only|String | NSString * | If the value of `Sensor` is transformable, it returns the corresponding value; otherwise, it returns empty string. For example, None, SN, or Custom
dataValue||NSData | NSData * | only the custom data returns the value，others return nil


##### Function

None

###<a name="SensoroDevice">SensoroDevice</a>
#### Purpose

Represents a device, and sensor information can be retrieved from this sensor.

#### Member
#####Property
None

Function

* getValue
	* Description <br/>
		to return sensor valuel; its parameter is the type of [SensorIndex](#SensorIndex) type

	* Call method
		* swift
			`func getValue(index : SensorIndex) -> SensorValue`
		* OC
			`- (SensorValue * _Nonnull)getValue:(enum SensorIndex)index;`

	* Return type <br/>
		SensorValue, when referring to corresponding sensor and when the sensor doesn't exsit with the device, it returns.None.

###<a name="SensorIndex">SensorIndex</a>
Purpose
Index，used to index the  value of the corresponding sensor from [SensoroDevice](#SensoroDevice). enum type.

####Member definition

* Swift
	* Idx_SN // SN
	* Idx_RSSI // RSSI
	* Idx_HardwareVer // Hardware version number
	* Idx_FirmwareVer // Firmware version number
	* Idx_BatteryLevel // Battery power level
	* Idx_Temperature // Temperature sensor
	* Idx_Humidity // Humidity sensor 
	* Idx_Light // Light sensor
	* Idx_Accelerator // Accelerator sensor
	* Idx_Custom // Custom data

* OC
	* SensorIndexIdx_SN = 0, // SN
	* SensorIndexIdx_RSSI = 1, // RSSI
	* SensorIndexIdx_HardwareVer = 2, // Hardware version number
	* SensorIndexIdx_FirmwareVer = 3, // Firmware version number
	* SensorIndexIdx_BatteryLevel = 4, // Battery power level
	* SensorIndexIdx_Temperature = 5, // Temperature sensor
	* SensorIndexIdx_Humidity = 6, // Humidity sensor 
	* SensorIndexIdx_Light = 7, // Light sensor
	* SensorIndexIdx_Accelerator = 8, //Accelerator sensor
	* SensorIndexIdx_Custom = 9, // Custom data


#####Property
None
#####Function
None		
###<a name="SensoroDeviceManager">SensoroDeviceManager</a>
####Purpose


To initiate device scanning and manage devices, singleton.
####Member

#####Property

* sharedInstance
	* Description <br/>

		Return of single object of SensoroDeviceManager.
	* Type: `SensoroDeviceManager`
	* Property: read-only

* delegate
	* Description <br/>
		Proxy setting
	* Type: `SensoroDeviceManagerDelegate`
	* Property: Read-only

* devices
	* Description <br/>
		Return discovered devices; in the array, objects sorted by RSSI
	* Type: <br/>

		Swift : `[SensoroDevice]`
		
		OC : `NSArray<SensoroDevice *> *`
	* Property: Read-only



#####Function

None		

###<a name="SensoroDeviceManagerDelegate">SensoroDeviceManagerDelegate</a>
####Purpose
Proxy protocol, implemented by the client object,and handles [SensoroDeviceManager] (#SensoroDeviceManager) related events. No optional function; all function values must be selected.

####Member

#####Property
None

#####Functions
* Discovered new devices <br/>
	* Description <br/>
		Discover new devices and return arrays of device objects.
	* Swift 
	`func deviceManager(manager : SensoroDeviceManager, newDevices devices : [SensoroDevice]);`
	* OC
	`- (void)deviceManager:(SensoroDeviceManager * _Nonnull)manager newDevices:(NSArray<SensoroDevice *> * _Nonnull)devices;`
	* Value
		* manager: SensoroDeviceManager，return data arrays of SensoroDeviceManager，since the system only has one sensor SensoroDeviceManager instance，this equals to SensoroDeviceManager.sharedInstance
		* devices: [SensoroDevice], include new discover end-device. Return of discovered device sorting the object by RSSI.

* Missing devices <br/>
	* Description <br/>
		Find non-response devices and return arrays of device objects.
	* Swift 
	`func deviceManager(manager : SensoroDeviceManager, goneDevices devices : [SensoroDevice]);`
	* OC
	`- (void)deviceManager:(SensoroDeviceManager * _Nonnull)manager goneDevices:(NSArray<SensoroDevice *> * _Nonnull)devices;`
	* Parameter
		* manager: SensoroDeviceManager，return data arrays of SensoroDeviceManager，since the system only has one sensor SensoroDeviceManager instance，this equals to SensoroDeviceManager.sharedInstance
		* devices: [SensoroDevice], includes all missing end-devices. If an end-device doesn't respond after 8 seconds, system will assume this device is missing and returns as NUL.

* Periodic response
	* Description <br/>
		Periodical callback. Callback interval set as 1 second. Non-adjustable at this stage.
	* Swift 
	`func deviceManager(manager : SensoroDeviceManager, didRangeDevices devices : [SensoroDevice])`
	* OC
	`- (void)deviceManager:(SensoroDeviceManager * _Nonnull)manager didRangeDevices:(NSArray<SensoroDevice *> * _Nonnull)devices;`
	* Parameter
		* manager: SensoroDeviceManager，return data arrays of SensoroDeviceManager，since the system only has one sensor SensoroDeviceManager instance，this equals to SensoroDeviceManager.sharedInstance
		* devices: [SensoroDevice], includes all discovered end-device. Sorted by signal strength, and the device with strongest signal will be displayed first.

## Sample Code Snippets

[Github sourcecode](https://github.com/yangzhiqiang/SensoroSensorDemo)

Include Swift and Objective - C two version。

##Log of Updates
Date | Version | Author | Content
---|---|---|---
2016-06-24|1.0|David | Initial content
