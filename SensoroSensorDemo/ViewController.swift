//
//  ViewController.swift
//  SensoroSensorDemo
//
//  Created by David Yang on 16/6/2.
//  Copyright © 2016年 Sensoro. All rights reserved.
//

import UIKit
import SensoroSensorKit

class ViewController: UIViewController, UITableViewDataSource, SensoroDeviceManagerDelegate {

    @IBOutlet var deviceList : UITableView!;
    
    var devices = [SensoroDevice]();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        SensoroDeviceManager.sharedInstance.delegate = self;
        
        let frame = CGRect(x: 0, y: 0, width: 44, height: 44);//CGRectMake(0, 0, 44, 44);
        let version = UILabel(frame: frame);
        
        version.text =  String(format: "%.2f", SensoroSensorKitVersionNumber);
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: version);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: SensoroDeviceManagerDelegate
    
    func deviceManager(manager: SensoroDeviceManager, goneDevices devices: [SensoroDevice]) {
        self.devices = manager.devices;
        
        deviceList.reloadData();
    }
    
    func deviceManager(manager: SensoroDeviceManager, newDevices devices: [SensoroDevice]) {
        self.devices = manager.devices;

        deviceList.reloadData();
    }
    
    func deviceManager(manager: SensoroDeviceManager, didRangeDevices devices: [SensoroDevice]) {
        
    }
    
    // MARK: UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return devices.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier("deviceCell") {
            
            cell.textLabel?.text = devices[indexPath.row].getValue(.Idx_SN).stringValue;
            cell.detailTextLabel?.text = devices[indexPath.row].getValue(.Idx_RSSI).stringValue;
            cell.selectionStyle = .None;
            
            return cell;
        }else{
            return UITableViewCell();
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            
            if let controller = segue.destinationViewController as? DeviceDetailViewController {
                if let path = deviceList.indexPathForSelectedRow {
                    controller.device = devices[path.row];
                }
            }
        }
    }
}

