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
    
    self.navigationItem.title = @"搜索蓝牙";
    self.tableView.rowHeight = 60;
    
    UILabel * hintLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, self.view.width - 40, 60)];
    hintLabel.numberOfLines = 0;
    hintLabel.font = [UIFont systemFontOfSize:14];
    hintLabel.textColor = [UIColor redColor];
    hintLabel.text = @"温馨提示:建议您使用MobilPrinter小票机。如果您没有蓝牙打印机，请到配置蓝牙处设定打印份数为0，即可处理订单";
    UIButton * searchButton = [UIButton buttonWithType:UIButtonTypeSystem];
    searchButton.frame = CGRectMake(50, hintLabel.bottom + 5, self.view.width - 100, 30);
    [searchButton setTitle:@"搜索蓝牙小票机" forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(StarSearchBluetooth:) forControlEvents:UIControlEventTouchUpInside];
    searchButton.backgroundColor = [UIColor orangeColor];
    searchButton.tintColor = [UIColor whiteColor];
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, searchButton.bottom + 10)];
    [headerView addSubview:hintLabel];
    [headerView addSubview:searchButton];
    self.tableView.tableHeaderView = headerView;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CELL_INDENTIFIER];
    
    self.bluetooth = [GeneralBlueTooth shareGeneralBlueTooth];
    self.bluetooth.delegate = self;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"停止搜索" style:UIBarButtonItemStylePlain target:self action:@selector(stopSearchBluetooth:)];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backLastVC:)];
    
    
}
- (void)backLastVC:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)stopSearchBluetooth:(id)sender
{
    [self.bluetooth stopScanBluetooth];
    [SVProgressHUD dismiss];
}

- (void)StarSearchBluetooth:(UIButton *)button
{
    self.bluetooth.myPeripheral = nil;
    [self.tableView reloadData];
    [self.bluetooth stopScanBluetooth];
    [SVProgressHUD dismiss];
    [SVProgressHUD showWithStatus:@"正在搜索蓝牙小票机..."];
    [self.bluetooth starScanBluetooth];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.bluetooth stopScanBluetooth];
    [SVProgressHUD dismiss];
}


- (void)didConnectBluetooth
{
    [SVProgressHUD dismiss];
    [self.navigationController popViewControllerAnimated:YES];
//    [self.tableView reloadData];
}

- (void)didDiscoverBluetooth
{
    [SVProgressHUD dismiss];
    [self.tableView reloadData];
}
- (void)didDisconnectBlutooth
{
    
}

- (void)printData:(id)sender
{
    NSLog(@"daying]]]]");
    NSString * str = @"打印是偶家问问你疯了另外你发来呢";
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    // 给蓝牙发数据
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
    // 判断设备是否已连接
    if (self.bluetooth.myPeripheral.state) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"设备已连接" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1.5];
    }else
    {
    [self.bluetooth connectBluetooth];
    [SVProgressHUD showWithStatus:@"正在连接蓝牙..." maskType:SVProgressHUDMaskTypeBlack];
//        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(svPHUDDismiss) userInfo:nil repeats:NO];
//        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
//        [[NSRunLoop currentRunLoop] run];
    }
//    if (self.bluetooth.myPeripheral.state) {
//        [self.navigationController popViewControllerAnimated:YES];
//    }
}

//- (void)svPHUDDismiss
//{
//    [SVProgressHUD dismiss];
//    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"蓝牙连接失败" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
//    [alertView show];
//    [alertView performSelector:@selector(dismiss) withObject:nil afterDelay:1];
//}


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

/* 发现一个蓝牙设备,也就是收到了一个周围的蓝牙发来的广告信息，这时CBCentralManager会通知代理来处理,如果周围的蓝牙有多个，则这个方法会被调用多次，你可以通过tableView或其他的控件把这些周围的蓝牙的信息打印出来
 */
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    NSLog(@"%@, %@", peripheral.name, [[advertisementData objectForKey:@"kCBAdvDataServiceUUIDs"] firstObject]);
    [self.peripheralArray addObject:peripheral];
    [self.tableView reloadData];
}
// 连接一个蓝牙
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@"已经连接%@", peripheral.identifier);
    [self.cbCentral stopScan];
//    self.peripheral = peripheral;
    [peripheral setDelegate:self];
    // 查询蓝牙服务
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
    [self.tableView reloadData];
    NSLog(@"++++%@",error);
}

- (void)centralManager:(CBCentralManager *)central didRetrievePeripherals:(NSArray *)peripherals
{
    
}

- (void)centralManager:(CBCentralManager *)central didRetrieveConnectedPeripherals:(NSArray *)peripherals
{
    
}

// 查询蓝牙服务 返回的服务通知通过代理实现
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    NSLog(@"didDiscoverServices");
    
    
    for (CBService *service in peripheral.services)
    {
        NSLog(@"+++++++%@", service.UUID);
        if ([service.UUID isEqual:[CBUUID UUIDWithString:@"E7810A71-73AE-499D-8C15-FAA9AEF0C3F2"]])
        {
            NSLog(@"Service found with UUID: %@", service.UUID);
            // 查询服务所带的特征值
            [peripheral discoverCharacteristics:[service.characteristics firstObject] forService:service];
            [peripheral discoverCharacteristics:nil forService:service];
            break;
        }
        
        
    }
}

// 返回的蓝牙特征值通知通过代理实现
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

// 处理蓝牙发过来的数据
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
