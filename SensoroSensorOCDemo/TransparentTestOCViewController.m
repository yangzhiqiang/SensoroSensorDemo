//
//  TransparentTestOCViewController
//  SensoroSensorDemo
//
//  Created by David Yang on 2017/3/31.
//  Copyright © 2017年 Sensoro. All rights reserved.
//

#import "TransparentTestOCViewController.h"
#import "SVProgressHUD.h"

@interface TransparentTestOCViewController ()

@property (weak, nonatomic) IBOutlet UITextField *retValue;
@property (weak, nonatomic) IBOutlet UITextField *writeValue;
@property (weak, nonatomic) IBOutlet UIButton *connectBtn;
@property (weak, nonatomic) IBOutlet UILabel *count;
@property (weak, nonatomic) IBOutlet UITextView *receivedText;

@end

@implementation TransparentTestOCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    if (_device != nil && _device.isConnected) {
        [_device stopSession];
    }
}

- (IBAction)createSession:(id)sender {
    if (_device == nil ){return;}
    
    if (_device.isConnected){
        [_device stopSession];
        
        [_connectBtn setTitle:@"建立连接" forState:UIControlStateNormal];
        return;
    }
    
    [SVProgressHUD showProgress:-1 status:@"连接中 ..."];
    //修改xxxx为相应的设备密码
    [_device startSessionWithPassword: @"xxxx" completion:^(NSError * _Nullable error) {
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
}

- (IBAction)writeToDevice:(id)sender {
    if (_device == nil ){return;}
    
    NSScanner * scanner = [NSScanner scannerWithString:_writeValue.text];
    
    if (scanner != nil ){
        int ret = 0;
        if ([scanner scanInt:&ret] == YES ) {
            
            int8_t write = ret;
            NSData * data = [NSData dataWithBytes:&write length:1];
            
            [_device writeWithData:data writeCallback:^(NSError * _Nullable error) {
                if (error != nil ){
                    NSLog(@"Write Error : %@",error);
                }else{
                    NSLog(@"Write is OK");
                }
            }];
        }
    }
}

- (IBAction)longerThan20Byte:(id)sender {
    NSString * writeStr = @"0123456789ABCDE0123456789ABCDE";
    NSData * data = [writeStr dataUsingEncoding:NSUTF8StringEncoding];
    
    [_device writeWithData:data writeCallback:^(NSError * _Nullable error) {
        if (error != nil ){
            NSLog(@"Write Error : %@",error);
        }else{
            NSLog(@"Write is OK");
        }
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
