//
//  UpgradeDeviceController.m
//  SensoroSensorOCDemo
//
//  Created by David Yang on 2018/4/12.
//  Copyright © 2018年 Sensoro. All rights reserved.
//

#import "UpgradeDeviceController.h"

@interface UpgradeDeviceController ()

@property (weak, nonatomic) IBOutlet UILabel *progressLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@end

@implementation UpgradeDeviceController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)updateStart:(id)sender {
    
    //获取本地的DFU地址
    NSString * firmwarePath = [[NSBundle mainBundle] pathForResource:@"tracker_dfu_test" ofType:@"zip"];
    //调用升级函数进行升级。
    [_device upgradeWithPassword:@"" firmware:firmwarePath progressWatcher:^(double progress) {

        self.progressLabel.text = [NSString stringWithFormat:@"%.1f%%", progress];

    } stateWatcher:^(DeviceUpgradeStatus status, NSError * _Nullable error) {
        if ( error == nil ) {
            
            NSString * tip = @"未知状态";
            
            switch (status) {
                case DeviceUpgradeStatusReady:
                    tip = @"准备进入DFU";
                case DeviceUpgradeStatusEnteringDFU:
                    tip = @"正在进入DFU";
                case DeviceUpgradeStatusDfuTransfering:
                    tip = @"正在传输数据";
                case DeviceUpgradeStatusDisconnecting:
                    tip = @"连接断开";
                case DeviceUpgradeStatusValidating:
                    tip = @"正在校验";
                case DeviceUpgradeStatusCompleted:
                    tip = @"更新完成";
                case DeviceUpgradeStatusTimeout:
                    tip = @"更新超时";
                case DeviceUpgradeStatusFailed:
                    tip = @"更新失败";
                default:
                    break;
            }
            
            self.statusLabel.text = tip;
        }else{
            self.statusLabel.text = [NSString stringWithFormat:@"更新失败 %@", error];
        }
    }];
    
}

@end
