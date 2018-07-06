//
//  ExternalConnectTestController.swift
//  SensoroSensorDemo
//
//  Created by David Yang on 2018/7/6.
//  Copyright © 2018年 Sensoro. All rights reserved.
//

import UIKit
import SensoroSensorKit
import CoreBluetooth

class ExternalConnectTestController: UIViewController {

    @IBOutlet weak var loger: UITextView!

    var device : SensoroDevice? = nil;
    var manager : CBCentralManager!;
    var peripheral : CBPeripheral!;

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let device = self.device else {
            return;
        }

        SensoroDeviceManager.sharedInstance.stopScan();

        // Do any additional setup after loading the view.
        manager = CBCentralManager(delegate: self,
                                   queue: nil,
                                   options: [CBCentralManagerOptionShowPowerAlertKey : false]);
        manager.delegate = self;
        
        if let uuid = device.peripheral?.identifier {
            let peripherals = manager.retrievePeripherals(withIdentifiers: [uuid]);
            if peripherals.count >= 0 {
                self.peripheral = peripherals[0];
                self.peripheral.delegate = self;
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func connectDevice(_ sender: Any) {
//        manager.stopScan();
        manager.connect(peripheral, options: nil);
    }
}

extension ExternalConnectTestController : CBCentralManagerDelegate {
    // MARK: CBCentralManagerDelegate
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            print("Power on");
        case .poweredOff:
            print("Power off");
        case .unauthorized:
            print("unauthorized");
        case .resetting:
            print("Resetting");
        default: break
        }
    }
    func centralManager(_ central: CBCentralManager,
                        didDiscover peripheral: CBPeripheral,
                        advertisementData: [String : Any],
                        rssi RSSI: NSNumber) {
        
        if RSSI.intValue == 127 {//非法数据
            return ;
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("didConnectPeripheral");
        
        peripheral.discoverServices(nil);
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("didDisconnectPeripheral");
        
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("didFailToConnectPeripheral");
        
    }
}

extension ExternalConnectTestController : CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        print("didDiscoverServices");
        
        self.manager.cancelPeripheralConnection(peripheral);
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
    }
    //写入时返回。
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
    }
    //读取时返回。
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        //print("didUpdateValueForCharacteristic");
    }
    func peripheral(_ peripheral: CBPeripheral, didModifyServices invalidatedServices: [CBService]) {
        print("didModifyServices");
    }
}
