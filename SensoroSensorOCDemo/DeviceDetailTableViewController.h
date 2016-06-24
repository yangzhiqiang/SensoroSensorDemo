//
//  DeviceDetailTableViewController.h
//  SensoroSensorKit
//
//  Created by David Yang on 16/6/13.
//  Copyright © 2016年 Sensoro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SensoroSensorKit/SensoroSensorKit-Swift.h>

@interface DeviceDetailTableViewController : UITableViewController

@property (strong,nonatomic) SensoroDevice * device;

@end
