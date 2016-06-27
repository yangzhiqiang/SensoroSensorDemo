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
#import <SensoroSensorKit/SensoroSensorKit.h>

@interface ViewController () <UITableViewDataSource, SensoroDeviceManagerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *deviceList;

@property (strong,nonatomic) NSArray<SensoroDevice*> * devices;

@property BOOL started;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    SensoroDeviceManager.sharedInstance.delegate = self;
    
    CGRect frame = CGRectMake(0, 0, 44, 44);
    UILabel* verLabel = [[UILabel alloc] initWithFrame:frame];
    
    NSString* version = [NSString stringWithFormat:@"%0.2f",SensoroSensorKitVersionNumber];
    verLabel.text = version;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:verLabel];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Stop" style:UIBarButtonItemStylePlain target:self action:@selector(scanAction)];
    
    self.started = true;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) scanAction {
    if ( self.started == NO ){
        [SensoroDeviceManager.sharedInstance startScan];
        
        self.started = YES;
        self.navigationItem.leftBarButtonItem.title = @"Stop";
    }else{
        [SensoroDeviceManager.sharedInstance stopScan];
        self.started = NO;
        self.navigationItem.leftBarButtonItem.title = @"Start";
    }
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
