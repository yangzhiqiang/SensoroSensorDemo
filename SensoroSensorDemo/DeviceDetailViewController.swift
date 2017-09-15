//
//  DeviceDetailViewController.swift
//  SensoroSensorDemo
//
//  Created by David Yang on 16/6/12.
//  Copyright © 2016年 Sensoro. All rights reserved.
//

import UIKit
import SensoroSensorKit

class DeviceDetailViewController: UITableViewController {

    var device : SensoroDevice? = nil;
    var timerForUpdate : Timer! = nil;
    
    var valuesIdxes : [SensorIndex] = [
        .idx_SN,
        .idx_RSSI,
        .idx_HardwareVer,
        .idx_FirmwareVer,
        .idx_BatteryLevel,
        .idx_Temperature,
        .idx_Humidity,
        .idx_Light,
        .idx_Accelerator,
        .idx_Custom,
        .idx_Leak,
        .idx_CO,
        .idx_CO2,
        .idx_NO2,
        .idx_CH4,
        .idx_LPG,
        .idx_PM1,
        .idx_PM2_5,
        .idx_PM10,
        .idx_Cover,
        .idx_LiquidLevel
    ];
    
    var valuesDesces : [String] = [
        "SN",
        "RSSI",
        "硬件版本号",
        "固件版本号",
        "电量",
        "温度",
        "湿度",
        "光线",
        "加速度",
        "自定义",
        "滴漏",
        "一氧化碳",
        "二氧化碳",
        "二氧化氮",
        "甲烷",
        "液化天然气",
        "PM1",
        "PM2.5",
        "PM10",
        "井盖",
        "液位"
    ];
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        //self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "测试",
                                                                 style: .plain,
                                                                 target: self,
                                                                 action: #selector(transparentTest));
        
        self.timerForUpdate = Timer.scheduledTimer(timeInterval: 1,
                                                   target: self,
                                                   selector: #selector(updateContent(timer:)),
                                                   userInfo: nil,
                                                   repeats: true);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func updateContent(timer : Timer){
        tableView.reloadData();
    }
    
    @objc func transparentTest(){
        if let storyboard = self.storyboard {
            if let contrller = storyboard.instantiateViewController(withIdentifier: "transparent") as? TransparentTestViewController {
                
                contrller.device = device;
                self.navigationController?.pushViewController(contrller, animated: true);
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return valuesIdxes.count;
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "valueCell", for: indexPath)

        cell.textLabel?.text = valuesDesces[indexPath.row];
        
        cell.selectionStyle = .none;
        if let device = self.device {
            cell.detailTextLabel?.text = device.getValue(valuesIdxes[indexPath.row]).stringValue;
        }
        
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
