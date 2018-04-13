//
//  UpgradeDeviceController.swift
//  SensoroSensorKitTest
//
//  Created by David Yang on 2018/3/27.
//  Copyright © 2018年 Sensoro. All rights reserved.
//

import UIKit
import SensoroSensorKit

class UpgradeDeviceController: UIViewController {

    var device : SensoroDevice? = nil;

    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    @IBAction func upgradeDevice(_ sender: Any) {

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
    }
    
}
