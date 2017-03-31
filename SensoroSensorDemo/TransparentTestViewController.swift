//
//  TransparentTestViewController.swift
//  SensoroSensorKit
//
//  Created by David Yang on 2017/3/27.
//  Copyright © 2017年 Sensoro. All rights reserved.
//

import UIKit
import SensoroSensorKit

class TransparentTestViewController: UIViewController {

    @IBOutlet weak var writeValue: UITextField!
    @IBOutlet weak var retValue: UITextField!
    @IBOutlet weak var connectBtn: UIButton!

    var device : SensoroDevice? = nil;
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated);
        
        guard let device = self.device else {
            return ;
        }
        
        if device.isConnected {
            device.stopSession();
            self.connectBtn.setTitle("建立连接", for: .normal);
            return;
        }
    }
    
    deinit {
        print("deinit of TransparentTestViewController");
    }
    
    @IBAction func createSession(_ sender: Any) {
        guard let device = self.device else {
            return ;
        }
        
        if device.isConnected {
            device.stopSession();
            self.connectBtn.setTitle("建立连接", for: .normal);
            return;
        }
        
        SVProgressHUD.showProgress(-1, status: "连接中 ...");
        
        device.startSession(completion: { [weak self](error) in
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

            if error != nil {
                print(error.debugDescription);
            }else{
                if let parent = self {
                    let range = NSMakeRange(0, 1);
                    var binValue : Int8 = 0;
                    data!.getBytes(&binValue, range: range);
                    parent.retValue.text = String(binValue);
                }
            }
        }
    }
    
    @IBAction func writeToDevice(_ sender: Any) {
        
        guard let device = self.device, device.isConnected else {
            return;
        }
        
        if var valueInt = Int8(self.writeValue.text ?? "") {
            
            var value = Data();
            
            value.append(UnsafeBufferPointer(start: &valueInt, count: 1));
            
            device.write(data: value) { (error) in
                if error != nil {
                    print(error ?? "nil");
                }
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
