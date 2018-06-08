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
    
    var started = true;
    
    var devices = [SensoroDevice]();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        SensoroDeviceManager.sharedInstance.delegate = self;
        
        let frame = CGRect(x: 0, y: 0, width: 44, height: 44);//CGRectMake(0, 0, 44, 44);
        let version = UILabel(frame: frame);
        
//        SensoroSensorKitVersionString
        let bundle = Bundle(identifier: "com.sensoro.SensoroSensorKit")! // Get a reference to the bundle from your framework (not the bundle of the app itself!)
        let build = bundle.infoDictionary![kCFBundleVersionKey as String] as! String // Get the build from the framework's bundle as a String
        
        version.text =  String(format: "%@", build);
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: version);
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Stop",
                                                                style: .plain,
                                                                target: self,
                                                                action: #selector(scanAction));
    }
    
    @objc func scanAction(){
        if started == true {
            SensoroDeviceManager.sharedInstance.stopScan();
            self.navigationItem.leftBarButtonItem?.title = "Start";
            started = false;
        }else{
            SensoroDeviceManager.sharedInstance.startScan();
            self.navigationItem.leftBarButtonItem?.title = "Stop";
            started = true;
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: SensoroDeviceManagerDelegate
    
    func deviceManager(_ manager: SensoroDeviceManager, goneDevices devices: [SensoroDevice]) {
        self.devices = manager.devices;
        
        
        
        
        deviceList.reloadData();
    }
    
    func deviceManager(_ manager: SensoroDeviceManager, newDevices devices: [SensoroDevice]) {
        self.devices = manager.devices;

        deviceList.reloadData();
    }
    
    func deviceManager(_ manager: SensoroDeviceManager, didRangeDevices devices: [SensoroDevice]) {
        
        deviceList.reloadData();
    }
    
    // MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return devices.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "deviceCell") as? SensorCell {
            
            cell.updateContent(device: devices[indexPath.row]);
            cell.selectionStyle = .none;
            
            return cell;
        }else{
            return UITableViewCell();
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let controller = segue.destination as? DeviceDetailViewController {
                if let path = deviceList.indexPathForSelectedRow {
                    controller.device = devices[path.row];
                }
            }
        }
    }
}

