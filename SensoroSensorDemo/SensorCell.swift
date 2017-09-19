//
//  SensorCell.swift
//  SensoroSensorDemo
//
//  Created by David Yang on 2017/9/18.
//  Copyright © 2017年 Sensoro. All rights reserved.
//

import UIKit
import SensoroSensorKit

class SensorCell: UITableViewCell {
    @IBOutlet weak var Sn: UILabel!
    @IBOutlet weak var RSSI: UILabel!
    @IBOutlet weak var sensorDetail: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func updateContent(device : SensoroDevice){
        self.Sn.text = device.getValue(.idx_SN).stringValue;
        self.RSSI.text = device.getValue(.idx_RSSI).stringValue;
        
        var sensorValues = [String]();
        
        for value in device.values {
            switch value.idx {
            case .idx_Temperature:
                if value.hasValue {
                    sensorValues.append("Temp.: " + value.stringValue + " ℃");
                }
            case .idx_Humidity:
                if value.hasValue {
                    sensorValues.append("Humi.: " + value.stringValue + " RH %");
                }
            case .idx_Light:
                if value.hasValue {
                    let lightStr = String(format:"%d",value.intValue);
                    sensorValues.append("Light: " + lightStr + " LUX");
                }
            case .idx_CO:
                if value.hasValue {
                    sensorValues.append("CO: " + value.stringValue + " ppm");
                }
            case .idx_CO2:
                if value.hasValue {
                    sensorValues.append("CO2: " + value.stringValue + " ppm");
                }
            case .idx_NO2:
                if value.hasValue {
                    sensorValues.append("NO2: " + value.stringValue + " ppm");
                }
            case .idx_PM1:
                if value.hasValue {
                    sensorValues.append("PM1: " + value.stringValue + " ug/m3");
                }
            case .idx_PM2_5:
                if value.hasValue {
                    sensorValues.append("PM2.5: " + value.stringValue + " ug/m3");
                }
            case .idx_PM10:
                if value.hasValue {
                    sensorValues.append("PM10: " + value.stringValue + " ug/m3");
                }
            case .idx_Leak:
                if value.hasValue {
                    if value.intValue == 0 {
                        sensorValues.append("滴漏: " + "无泄漏");
                    } else {
                        sensorValues.append("滴漏: " + "泄漏");
                    }
                }
            case .idx_Cover:
                if value.hasValue {
                    if value.intValue == 1 {
                        sensorValues.append("井盖: " + "开");
                    }else{
                        sensorValues.append("井盖: " + "关");
                    }
                }
            case .idx_Flame:
                if value.hasValue {
                    if value.intValue == 1 {
                        sensorValues.append("火焰: " + "有火焰");
                    }else{
                        sensorValues.append("火焰: " + "无火焰");
                    }
                }
            case .idx_CH4:
                if value.hasValue {
                    sensorValues.append("CH4: " + value.stringValue);
                }
            case .idx_LPG:
                if value.hasValue {
                    sensorValues.append("LPG: " + value.stringValue);
                }
            case .idx_LiquidLevel:
                if value.hasValue {
                    sensorValues.append("液位: " + value.stringValue);
                }
            case .idx_SO2:
                if value.hasValue {
                    sensorValues.append("SO2: " + value.stringValue + "ppm");
                }
            case .idx_NH3:
                if value.hasValue {
                    sensorValues.append("NH3: " + value.stringValue);
                }
            case .idx_O3:
                if value.hasValue {
                    sensorValues.append("O3: " + value.stringValue);
                }
            case .idx_Pitch:
                if value.hasValue {
                    sensorValues.append( "Pitch: " + value.stringValue + " °");
                }
            case .idx_Roll:
                if value.hasValue {
                    sensorValues.append("Roll: " + value.stringValue + " °");
                }
            case .idx_Yaw:
                if value.hasValue {
                    sensorValues.append("Yaw: " + value.stringValue + " °");
                }
            default:
                break;
            }
        }
        
        self.sensorDetail.text = sensorValues.joined(separator: ",");
    }
    
}
