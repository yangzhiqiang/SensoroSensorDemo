//
//  ViewController.m
//  SensoroSensorDemo
//
//  Created by David Yang on 16/6/13.
//  Copyright © 2016年 Sensoro. All rights reserved.
//

#import "ViewController.h"
#import "DeviceDetailTableViewController.h"
#import <SensoroSensorKit/SensoroSensorKit-Swift.h>

@interface ViewController () <UITableViewDataSource, SensoroDeviceManagerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *deviceList;

@property (strong,nonatomic) NSArray<SensoroDevice*> * devices;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    SensoroDeviceManager.sharedInstance.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark SensoroDeviceManagerDelegate

- (void) deviceManager:(SensoroDeviceManager *)manager newDevices:(NSArray<SensoroDevice *> *)devices {
    
    self.devices = SensoroDeviceManager.sharedInstance.devices;
    
    [self.deviceList reloadData];
}

- (void) deviceManager:(SensoroDeviceManager *)manager goneDevices:(NSArray<SensoroDevice *> *)devices {
    
    self.devices = SensoroDeviceManager.sharedInstance.devices;
    [self.deviceList reloadData];
}

- (void) deviceManager:(SensoroDeviceManager *)manager didRangeDevices:(NSArray<SensoroDevice *> *)devices{
    [self.deviceList reloadData];
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.devices.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"deviceCell" forIndexPath:indexPath];
    
    cell.textLabel.text = [_devices[indexPath.row] getValue: SensorIndexIdx_SN].stringValue;
    cell.detailTextLabel.text = [_devices[indexPath.row] getValue: SensorIndexIdx_RSSI].stringValue;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString: @"showDetail"]) {
        
        DeviceDetailTableViewController * controller = segue.destinationViewController;
        
        NSIndexPath* path = _deviceList.indexPathForSelectedRow;
        controller.device = _devices[path.row];
    }
    
}

@end
