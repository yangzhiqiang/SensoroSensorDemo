//
//  DeviceDetailTableViewController.m
//  SensoroSensorKit
//
//  Created by David Yang on 16/6/13.
//  Copyright © 2016年 Sensoro. All rights reserved.
//

#import "DeviceDetailTableViewController.h"
#import "TransparentTestOCViewController.h"

SensorIndex valuesIdxes[21] = {
    SensorIndexIdx_SN,
    SensorIndexIdx_RSSI,
    SensorIndexIdx_HardwareVer,
    SensorIndexIdx_FirmwareVer,
    SensorIndexIdx_BatteryLevel,
    SensorIndexIdx_Temperature,
    SensorIndexIdx_Humidity,
    SensorIndexIdx_Light,
    SensorIndexIdx_Accelerator,
    SensorIndexIdx_Custom,
    SensorIndexIdx_Leak,
    SensorIndexIdx_CO,
    SensorIndexIdx_CO2,
    SensorIndexIdx_NO2,
    SensorIndexIdx_CH4,
    SensorIndexIdx_LPG,
    SensorIndexIdx_PM1,
    SensorIndexIdx_PM2_5,
    SensorIndexIdx_PM10,
    SensorIndexIdx_Cover,
    SensorIndexIdx_LiquidLevel
};

NSArray<NSString*> * valuesDesces = nil;

@interface DeviceDetailTableViewController () {
    
}

@property (nonatomic,strong) NSArray * valuesDesces;

@end

@implementation DeviceDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    if ( valuesDesces == nil ) {
        valuesDesces = @[@"SN",
                         @"RSSI",
                         @"硬件版本号",
                         @"固件版本号",
                         @"电量",
                         @"温度",
                         @"湿度",
                         @"光线",
                         @"加速度",
                         @"自定义",
                         @"滴漏",
                         @"一氧化碳",
                         @"二氧化碳",
                         @"二氧化氮",
                         @"甲烷",
                         @"液化天然气",
                         @"PM1",
                         @"PM2.5",
                         @"PM10",
                         @"井盖",
                         @"液位"
                         ];
    }
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"测试"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(transparentTest:)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) transparentTest: (id) sender {
    TransparentTestOCViewController * controller = (TransparentTestOCViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"transparent"];
    
    controller.device = self.device;
    
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return valuesDesces.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"valueCell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    cell.textLabel.text = valuesDesces[indexPath.row];
    cell.detailTextLabel.text = [_device getValue:valuesIdxes[indexPath.row]].stringValue;
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
