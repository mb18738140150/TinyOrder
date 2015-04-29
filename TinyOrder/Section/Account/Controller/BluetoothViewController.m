//
//  BluetoothViewController.m
//  TinyOrder
//
//  Created by 仙林 on 15/4/13.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "BluetoothViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "GeneralBlueTooth.h"

#define CELL_INDENTIFIER @"cell"

@interface BluetoothViewController ()<GeneralBlueToothDelegate,CBCentralManagerDelegate, CBPeripheralDelegate>

@property (nonatomic, strong)CBCentralManager * cbCentral;
@property (nonatomic, strong)NSMutableArray * peripheralArray;
@property (nonatomic, strong)CBPeripheral * peripheral;
@property (nonatomic, strong)CBCharacteristic * characteristic;

@property (nonatomic, assign)GeneralBlueTooth * bluetooth;

@end

@implementation BluetoothViewController

- (NSMutableArray *)peripheralArray
{
    if (!_peripheralArray) {
        self.peripheralArray = [NSMutableArray arrayWithCapacity:1];
    }
    return _peripheralArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.rowHeight = 60;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CELL_INDENTIFIER];
    
    self.bluetooth = [GeneralBlueTooth shareGeneralBlueTooth];
    self.bluetooth.delegate = self;
    [self.bluetooth starScanBluetooth];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.bluetooth stopScanBluetooth];
}


- (void)didConnectBluetooth
{
    [self.tableView reloadData];
}


- (void)printData:(id)sender
{
    NSLog(@"daying]]]]");
    NSString * str = @"打印是偶家问问你疯了另外你发来呢";
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    [self.peripheral writeValue:[str dataUsingEncoding:enc] forCharacteristic:self.characteristic type:CBCharacteristicWriteWithoutResponse];
    NSLog(@"%@", [str dataUsingEncoding:enc]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    if (self.bluetooth.myPeripheral) {
        return 1;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_INDENTIFIER forIndexPath:indexPath];
    if (self.bluetooth.myPeripheral.name) {
        cell.textLabel.text = self.bluetooth.myPeripheral.name;
        self.bluetooth.deviceName = self.bluetooth.myPeripheral.name;
    }else
    {
        cell.textLabel.text = @"打印机";
        self.bluetooth.deviceName = @"打印机";
    }
    // Configure the cell...
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.bluetooth connectBluetooth];
    if (self.bluetooth.myPeripheral.state) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    NSLog(@"----%ld", (long)central.state);
    switch (central.state) {
        case CBCentralManagerStatePoweredOn:
            [central scanForPeripheralsWithServices:nil options:nil];
            break;
        case CBCentralManagerStatePoweredOff:
        {
//            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"蓝牙还没打开" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            [alert show];
        }
            break;
        case CBCentralManagerStateResetting:
            NSLog(@"1");
            break;
        case CBCentralManagerStateUnauthorized:
            NSLog(@"2");
            break;
        case CBCentralManagerStateUnknown:
            NSLog(@"3");
            break;
        case CBCentralManagerStateUnsupported:
        {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"你的手机不支持蓝牙" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
            break;
            
        default:
            break;
    }
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    NSLog(@"%@, %@", peripheral.name, [[advertisementData objectForKey:@"kCBAdvDataServiceUUIDs"] firstObject]);
    [self.peripheralArray addObject:peripheral];
    [self.tableView reloadData];
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@"已经连接%@", peripheral.identifier);
    [self.cbCentral stopScan];
//    self.peripheral = peripheral;
    [peripheral setDelegate:self];
    [peripheral discoverServices:nil];
//    [peripheral writeValue:data forCharacteristic:<#(CBCharacteristic *)#> type:<#(CBCharacteristicWriteType)#>]
//    [self.navigationController popViewControllerAnimated:YES];
    /*
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"连接成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
     */
}


- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"已经断开连接" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    NSLog(@"++++%@",error);
}


- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    NSLog(@"didDiscoverServices");
    
    
    for (CBService *service in peripheral.services)
    {
        NSLog(@"+++++++%@", service.UUID);
        if ([service.UUID isEqual:[CBUUID UUIDWithString:@"E7810A71-73AE-499D-8C15-FAA9AEF0C3F2"]])
        {
            NSLog(@"Service found with UUID: %@", service.UUID);
            [peripheral discoverCharacteristics:[service.characteristics firstObject] forService:service];
            [peripheral discoverCharacteristics:nil forService:service];
            break;
        }
        
        
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    
    if (error)
    {
        NSLog(@"Discovered characteristics for %@ with error: %@", service.UUID, [error localizedDescription]);
        
//        [self error];
        return;
    }
    
    NSLog(@"服务：%@",service.UUID);
    for (CBCharacteristic *characteristic in service.characteristics)
    {
        //发现特征
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"E7810A71-73AE-499D-8C15-FAA9AEF0C3F2"]]) {
            NSLog(@"监听：%@",characteristic);//监听特征
            [self.peripheral setNotifyValue:YES forCharacteristic:characteristic];
            self.characteristic = characteristic;
            self.navigationItem.rightBarButtonItem.enabled = YES;
        }
        
        
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    self.characteristic = characteristic;
    self.navigationItem.rightBarButtonItem.enabled = YES;
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
