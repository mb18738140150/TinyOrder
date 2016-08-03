//
//  PrintTestViewController.m
//  TinyOrder
//
//  Created by 仙林 on 15/4/16.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "PrintTestViewController.h"
#import "PeripheralViewCell.h"
#import "PrintNumViewCell.h"
#import "BluetoothViewController.h"
#import "CustomIOSAlertView.h"
#import "UIViewAdditions.h"
#import "GeneralBlueTooth.h"
#import "AutomaticPrintTableViewCell.h"

#import "Meal.h"
#import "NewOrderModel.h"

#define TOP_SPACE 20
#define LEFT_SPACE 20
#define BUTTON_WIDTH 40
#define BUTTON_HEIGHT 40
#define VIEW_HEIGT 2 + 2 * BUTTON_HEIGHT
#define VIEW_WIDTH LEFT_SPACE * 2 + BUTTON_WIDTH * 6

@interface PrintTestViewController ()<CustomIOSAlertViewDelegate, HTTPPostDelegate, GeneralBlueToothDelegate>


@property (nonatomic, strong)UITextField * numberTF;

@property (nonatomic, strong)GeneralBlueTooth *blueteeth;

@property (nonatomic, strong)UISwitch *autoSwitch;
@property (nonatomic, strong)NSTimer *searchTimer;
@property (nonatomic, strong)NSTimer *connectTimer;


@property (nonatomic, strong)UILabel *printNumLabel;

@property (nonatomic, assign)int a;

@end

@implementation PrintTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"蓝牙打印";
    
    UILabel * hintLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, self.view.width - 40, 60)];
    hintLabel.numberOfLines = 0;
    hintLabel.font = [UIFont systemFontOfSize:14];
    hintLabel.textColor = [UIColor redColor];
    hintLabel.text = @"温馨提示:建议您使用MobilPrinter小票机。如果您没有蓝牙打印机，请到配置蓝牙处设定打印份数为0，即可处理订单";
    
    UIView *printNumView = [[UIView alloc]initWithFrame:CGRectMake(20, hintLabel.bottom + 10, self.tableView.frame.size.width - 40, 40)];
    printNumView.backgroundColor = [UIColor colorWithRed:249 / 255.0 green:72 / 255.0 blue:47 / 255.0 alpha:1];
    printNumView.layer.cornerRadius = 5;
    printNumView.layer.masksToBounds = YES;
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(0, 0, 150, 40);
    [button setTitle:@"设置打印份数" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor colorWithRed:249 / 255.0 green:72 / 255.0 blue:47 / 255.0 alpha:1];
    button.layer.cornerRadius = 5;
    button.layer.masksToBounds = YES;
    button.titleLabel.font = [UIFont systemFontOfSize:20];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //    [button addTarget:self action:@selector(printTest:) forControlEvents:UIControlEventTouchUpInside];
    
    self.printNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.width - 100, 0, 80, 40)];
    _printNumLabel.text = [NSString stringWithFormat:@"%@份", [self getPrintNum]];
    _printNumLabel.textAlignment = NSTextAlignmentCenter;
    [printNumView addSubview:button];
    [printNumView addSubview:_printNumLabel];
    
    UITapGestureRecognizer *printNumTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(printNumTapAction:)];
    [printNumView addGestureRecognizer:printNumTap];
    
    UIView *autoPrintView = [[UIView alloc]initWithFrame:CGRectMake(20, printNumView.bottom + 10, self.tableView.frame.size.width - 40, 40)];
    autoPrintView.backgroundColor = [UIColor colorWithRed:249 / 255.0 green:72 / 255.0 blue:47 / 255.0 alpha:1];
    autoPrintView.layer.cornerRadius = 5;
    autoPrintView.layer.masksToBounds = YES;
    
    UIButton * autoButton = [UIButton buttonWithType:UIButtonTypeSystem];
    autoButton.frame = CGRectMake(0, 0, 150, 40);
    [autoButton setTitle:@"设置自动打印" forState:UIControlStateNormal];
    autoButton.backgroundColor = [UIColor colorWithRed:249 / 255.0 green:72 / 255.0 blue:47 / 255.0 alpha:1];
    autoButton.layer.cornerRadius = 5;
    autoButton.layer.masksToBounds = YES;
    autoButton.titleLabel.font = [UIFont systemFontOfSize:20];
    [autoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //    [button addTarget:self action:@selector(printTest:) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.autoSwitch = [GeneralSwitch shareGeneralSwitch].bluetoothSwitch;
    _autoSwitch.frame = CGRectMake(self.view.width - 100, 5 , 80, BUTTON_WIDTH);
    [_autoSwitch addTarget:self action:@selector(autoPrint:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [autoPrintView addSubview:autoButton];
    [autoPrintView addSubview:_autoSwitch];
    
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, autoPrintView.bottom + 10)];
    [headerView addSubview:hintLabel];
    [headerView addSubview:printNumView];
    [headerView addSubview:autoPrintView];
    self.tableView.tableHeaderView = headerView;
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, hintLabel.bottom, self.tableView.frame.size.width, 60)];
    
    
    [GeneralBlueTooth shareGeneralBlueTooth].delegate = self;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backLastVC:)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"启用" style:UIBarButtonItemStylePlain target:self action:@selector(startOrTtop:)];
    NSDictionary* selectedTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:16],
                                             NSForegroundColorAttributeName: [UIColor blackColor]};
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:selectedTextAttributes forState:UIControlStateNormal];
    if ([PrintType sharePrintType].isBlutooth) {
        [self.navigationItem.rightBarButtonItem setTitle:@"停止"];
    }else
    {
        [self.navigationItem.rightBarButtonItem setTitle:@"启用"];
    }
    
    self.blueteeth = [GeneralBlueTooth shareGeneralBlueTooth];
    [self addObserver:self forKeyPath:@"self.blueteeth.myPeripheral.state" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:NULL];
    self.a = 1;
}

- (void)backLastVC:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)printTest:(UIButton *)button
{
    if (self.nOrderModel) {
        if (![GeneralBlueTooth shareGeneralBlueTooth].myPeripheral.state) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"尚未连接蓝牙,请先连接蓝牙打印机" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
        }else{
            
            int printNum = [[self getPrintNum] intValue];
            if (printNum == 0) {
                UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"如果需要测试打印机,请不要设置打印份数为0" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
                [alertView show];
                [alertView performSelector:@selector(dismiss) withObject:nil afterDelay:1.5];
            }else
            {
                        NSString * lineStr = @"--------------------------------\r";
                        NSString * str = [NSString stringWithFormat:@"1号  微生活外卖\r商家:%@\r%@下单时间:3/4 11:34:33\r%@\r预期送达时间12:10\r地址:上海浦东新区陆家嘴东路12号1204\r联系人:王先生\r电话:13388553308\r%@白菜肉丝+例汤+赠品  4份  24元\r%@其他费用\r配送费   0元\r%@总计 24元  已付款\r%@备注:本订单测试数据\n\n\n\n", [UserInfo shareUserInfo].userName,lineStr, lineStr, lineStr, lineStr, lineStr, lineStr];
                        NSMutableArray * printArray = [NSMutableArray array];
                        for (int i = 0; i < printNum; i++) {
                            [printArray addObject:str];
                        }
//                NSDictionary * jsonDic = @{
//                                           @"UserId":[UserInfo shareUserInfo].userId,
//                                           @"Command":@15,
//                                           @"OrderId":_nOrderModel.orderId,
//                                           @"PrintType":@2
//                                           };
//                [self playPostWithDictionary:jsonDic];
//                [SVProgressHUD showWithStatus:@"正在请求处理..." maskType:SVProgressHUDMaskTypeBlack];
                        [[GeneralBlueTooth shareGeneralBlueTooth] printWithArray:printArray];
            }
            
        }

    }else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"无订单,请选择订单" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }
}

- (void)playPostWithDictionary:(NSDictionary *)dic
{
    NSString * jsonStr = [dic JSONString];
    NSString * str = [NSString stringWithFormat:@"%@231618", jsonStr];
    NSString * md5Str = [str md5];
    NSString * urlString = [NSString stringWithFormat:@"%@%@", POST_URL, md5Str];
    
    HTTPPost * httpPost = [HTTPPost shareHTTPPost];
    [httpPost post:urlString HTTPBody:[jsonStr dataUsingEncoding:NSUTF8StringEncoding]];
    httpPost.delegate = self;
}

- (void)refresh:(id)data
{
    [SVProgressHUD dismiss];
    NSLog(@"%@  error = %@", data, [data objectForKey:@"ErrorMsg"]);
    //    NSDictionary * dataDic = (NSDictionary *)data;
    if ([[data objectForKey:@"Result"] isEqual:@1]) {
        int command = [[data objectForKey:@"Command"] intValue];
         if(command == 10015)
        {
            if (![[NSUserDefaults standardUserDefaults] objectForKey:@"printNum"]){
                //            NewOrdersiewCell * cell = (NewOrdersiewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.printRow inSection:0]];
                NewOrderModel * order = self.nOrderModel;
                //            NSString * printStr = [cell getPrintStringWithMealCount:order.mealArray.count];
                NSString * printStr = [self getPrintStringWithNewOrder:order];
                [[GeneralBlueTooth shareGeneralBlueTooth] printWithString:printStr];
            }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"printNum"] integerValue] != 0){
                NewOrderModel * order = self.nOrderModel;
                NSString * printStr = [self getPrintStringWithNewOrder:order];
                NSMutableArray * printAry = [NSMutableArray array];
                int num = [[[NSUserDefaults standardUserDefaults] objectForKey:@"printNum"] intValue];
                for (int j = 0; j < num; j++) {
                    [printAry addObject:printStr];
                }
                
                [[GeneralBlueTooth shareGeneralBlueTooth] printWithArray:printAry];
            }
            UIAlertView * alertV = [[UIAlertView alloc] initWithTitle:@"提示" message:@"处理成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alertV show];
            [alertV performSelector:@selector(dismiss) withObject:nil afterDelay:1.5];
        }
//         else if (command == 10055)
//        {
//            [self.navigationItem.rightBarButtonItem setTitle:@"停止"];
//            [PrintType sharePrintType].printType = 1;
//            [PrintType sharePrintType].printState = 2;
//        }
    }else
    {
        [SVProgressHUD dismiss];
        UIAlertView * alertV = [[UIAlertView alloc] initWithTitle:@"提示" message:[data objectForKey:@"ErrorMsg"] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alertV show];
        [alertV performSelector:@selector(dismiss) withObject:nil afterDelay:1.5];//单线程方法,也就是说只有当前调用此方法的函数执行完毕后，selector方法才会被调用.可能会因为某些原因,不被调用,而导致不会执行dismiss方法
//        alertV performSelectorOnMainThread:<#(SEL)#> withObject:<#(id)#> waitUntilDone:<#(BOOL)#>//多线程方法,可以正常执行延迟方法
    }
}

- (void)failWithError:(NSError *)error
{
    [SVProgressHUD dismiss];
//    if (error.code == -1009) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"友情提示" message:@"网络不给力,请检查网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alert show];
//    }else
//    {
    if ([[error.userInfo objectForKey:@"Reason"] isEqualToString:@"服务器处理失败"]) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"服务器处理失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil ];
        [alert show];
    }else
    {
        
        UIAlertView * alerV = [[UIAlertView alloc] initWithTitle:@"提示" message:@"连接服务器失败请重新连接" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alerV show];
    }
//    }
}

- (NSString *)getPrintStringWithNewOrder:(NewOrderModel *)order
{
    NSString * spaceString = @"                           ";
    NSString * lineStr = @"--------------------------------\r";
    NSMutableString * str = [NSMutableString string];
    //    [str appendString:[self dataString]];
    [str appendFormat:@"%d号    微生活外卖\r", order.orderNum];
    //    [str appendString:[self normalString]];
    [str appendFormat:@"店铺:%@\r%@", [UserInfo shareUserInfo].userName, lineStr];
    [str appendFormat:@"下单时间:%@\r%@", order.orderTime, lineStr];
    //    [str appendFormat:@"%@\r", self.orderView.expectLabel.text];
    [str appendFormat:@"地址:%@\r", order.address];
    //    [str appendFormat:@"联系人:%@\r", order.contect];
    [str appendString:[self dataString]];
    [str appendFormat:@"电话:%@\r%@", order.tel, lineStr];
    [str appendString:[self normalString]];
    //    [str appendFormat:@"%@\r", self.menuView.numMenuLabel.text];
    for (Meal * meal in order.mealArray) {
        NSInteger length = 16 - meal.name.length;
        //        NSLog(@"--%ld, %d", (unsigned long)meal.name.length, length);
        NSString * space = [spaceString substringWithRange:NSMakeRange(0, length)];
        [str appendFormat:@"%@%@%@%@  %@元\r", meal.name, space, meal.count, meal.units, meal.money];
        //        NSLog(@"++%@", [NSString stringWithFormat:@"%@%@%@份  %@元\r", meal.name, space, meal.count, meal.money]);
    }
    [str appendString:lineStr];
    [str appendFormat:@"其他费用           %@元\r%@", order.otherMoney, lineStr];
    if ([order.PayMath isEqualToNumber:@3]) {
        [str appendFormat:@"总计     %@元      现金支付\r%@", order.allMoney, lineStr];
    }else
    {
        [str appendFormat:@"总计     %@元          已付款\r%@", order.allMoney, lineStr];
    }
    [str appendFormat:@"\n\n\n"];
    return [str copy];
}

- (NSString *)dataString
{
    Byte caPrintFmt[5];
    
    /*初始化命令：ESC @ 即0x1b,0x40*/
    caPrintFmt[0] = 0x1b;
    caPrintFmt[1] = 0x40;
    
    /*字符设置命令：ESC ! n即0x1b,0x21,n*/
    caPrintFmt[2] = 0x1b;
    caPrintFmt[3] = 0x21;
    
    caPrintFmt[4] = 0x16;
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString * str = [[NSString alloc] initWithBytes:caPrintFmt length:5 encoding:enc];
    return  str;
}

- (NSString *)normalString
{
    Byte caPrintFmt[5];
    
    /*初始化命令：ESC @ 即0x1b,0x40*/
    caPrintFmt[0] = 0x1b;
    caPrintFmt[1] = 0x40;
    
    /*字符设置命令：ESC ! n即0x1b,0x21,n*/
    caPrintFmt[2] = 0x1b;
    caPrintFmt[3] = 0x21;
    
    caPrintFmt[4] = 0x00;
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString * str = [[NSString alloc] initWithBytes:caPrintFmt length:5 encoding:enc];
    return  str;
}

- (void)viewWillAppear:(BOOL)animated
{
    
//    NSLog(@"****%d", [PrintType sharePrintType].isBlutooth);
    [self.tableView reloadData];
    if ([PrintType sharePrintType].isBlutooth ) {
        [self.navigationItem.rightBarButtonItem setTitle:@"停止"];
//        [PrintType sharePrintType].isBlutooth = YES;
//        [PrintType sharePrintType].printType = 1;
//        NSLog(@"***************停止");
    }else
    {
        [self.navigationItem.rightBarButtonItem setTitle:@"启用"];
//        [PrintType sharePrintType].isBlutooth = NO;
//        if ([PrintType sharePrintType].printState == 1) {
////            [PrintType sharePrintType].printType = 2;
//        }else
//        {
////        [PrintType sharePrintType].printType = 0;
//        }
//        NSLog(@"****************启用");
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    if (section) {
        if ([GeneralBlueTooth shareGeneralBlueTooth].myPeripheral) {
            return 1;
        }else{
            return 0;
        }
    }else{
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section) {
        UIView *secondView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 30)];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(secondView.left + 20 , secondView.top, secondView.width, secondView.height)];
        label.text = @"点击可连接";
        label.textColor = [UIColor grayColor];
        label.font = [UIFont systemFontOfSize:12];
        [secondView addSubview:label];
        
        if ([GeneralBlueTooth shareGeneralBlueTooth].myPeripheral) {
            secondView.hidden = NO;
        }else{
            secondView.hidden = YES;
        }
        
        return secondView;
    }
    UIView *firstView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 30)];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(firstView.left + 20, firstView.top, firstView.width, firstView.height)];
    label.text = @"请先选择您的打印机并连接";
    label.textColor = [UIColor grayColor];
    label.font = [UIFont systemFontOfSize:12];
    [firstView addSubview:label];
    return firstView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    
    if (indexPath.section) {
        static NSString * cellIndentifier = @"cell";
        PeripheralViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
        if (!cell) {
            cell = [[PeripheralViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
            [cell createSubView:self.tableView.bounds];
        }
        if ([GeneralBlueTooth shareGeneralBlueTooth].myPeripheral) {
            cell.periheralName.text = [GeneralBlueTooth shareGeneralBlueTooth].deviceName;
            cell.periheralID.text = [GeneralBlueTooth shareGeneralBlueTooth].deviceID;
            if ([GeneralBlueTooth shareGeneralBlueTooth].myPeripheral.state) {
                cell.disconnectButton.hidden = NO;
            }else{
                cell.disconnectButton.hidden = YES;
            }
//            cell.disconnectButton.hidden = NO;
//            [cell.disconnectButton addTarget:self action:@selector(disconnectAction:event:) forControlEvents:UIControlEventTouchUpInside];
//            cell.disconnectButton.tag = 1000 + indexPath.row;
        }
        //    NSLog(@"**********蓝牙cell");
        return cell;
    }else
    {
        static NSString *printcellID = @"cell";
        PrintNumViewCell * printCell = [tableView dequeueReusableCellWithIdentifier:printcellID];
                if (!printCell) {
                    printCell = [[PrintNumViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:printcellID];
                    [printCell createSubView:self.tableView.bounds];
                    
                    [printCell.searchBT addTarget:self action:@selector(searchBTAction:) forControlEvents:UIControlEventTouchUpInside];
                }
        if ([GeneralBlueTooth shareGeneralBlueTooth].myPeripheral.state) {
            printCell.nameLabel.text = [GeneralBlueTooth shareGeneralBlueTooth].deviceName;
        }
                return printCell;
    }
    
}

#pragma mark - 搜索蓝牙
- (void)searchBTAction:(UIButton *)sender
{
    if ([GeneralBlueTooth shareGeneralBlueTooth].myPeripheral.state) {
        
    }else
    {
    NSLog(@"开始搜索蓝牙");
    [GeneralBlueTooth shareGeneralBlueTooth].myPeripheral = nil;
    [self.tableView reloadData];
    [[GeneralBlueTooth shareGeneralBlueTooth] stopScanBluetooth];
//    [SVProgressHUD dismiss];
    [SVProgressHUD showWithStatus:@"正在搜索蓝牙小票机..."];
    [[GeneralBlueTooth shareGeneralBlueTooth] starScanBluetooth];
    
    }
    
    if (self.searchTimer) {
        ;
    }else{
    self.searchTimer =[NSTimer timerWithTimeInterval:5 target:self selector:@selector(searchFail) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:self.searchTimer forMode:NSDefaultRunLoopMode];
    [[NSRunLoop currentRunLoop] run];
    }
    
}
#pragma mark - 搜索失败
- (void)searchFail
{
    if ([GeneralBlueTooth shareGeneralBlueTooth].myPeripheral) {
        [self.searchTimer invalidate];
        self.searchTimer = nil;
        [self.tableView reloadData];
    }else
    {
        [self.searchTimer invalidate];
        self.searchTimer = nil;
        [SVProgressHUD dismiss];
        [[GeneralBlueTooth shareGeneralBlueTooth] stopScanBluetooth];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"未搜索到蓝牙" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
//        [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1];
    }
}

- (void)didConnectBluetooth
{
    [SVProgressHUD dismiss];
        [self.tableView reloadData];
}

- (void)didDiscoverBluetooth
{
    [SVProgressHUD dismiss];
    [self.tableView reloadData];
}

- (void)didDisconnectBlutooth
{
    [self.tableView reloadData];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"蓝牙连接断开,请重新连接" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) {
        return 60;
    }
    return 70;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            // 判断设备是否已连接
            if ([GeneralBlueTooth shareGeneralBlueTooth].myPeripheral.state) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"设备已连接" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
                [alert show];
                [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1.5];
            }else
            {
                [[GeneralBlueTooth shareGeneralBlueTooth] connectBluetooth];
                [SVProgressHUD showWithStatus:@"正在连接蓝牙..." maskType:SVProgressHUDMaskTypeBlack];
                
                if (self.searchTimer) {
                    ;
                }else{
                    self.connectTimer =[NSTimer timerWithTimeInterval:5 target:self selector:@selector(connectFail) userInfo:nil repeats:NO];
                    [[NSRunLoop currentRunLoop] addTimer:self.connectTimer forMode:NSDefaultRunLoopMode];
                    [[NSRunLoop currentRunLoop] run];
                }
                
                
            }
        }else{
            ;
        }
    
        }

}

- (void)connectFail
{
    if ([GeneralBlueTooth shareGeneralBlueTooth].myPeripheral.state) {
        [self.connectTimer invalidate];
        self.connectTimer = nil;
    }else
    {
        [self.connectTimer invalidate];
        self.connectTimer = nil;
        [SVProgressHUD dismiss];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"蓝牙连接失败" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }
}

#pragma mark - 是否启用蓝牙打印
- (void)startOrTtop:(UIBarButtonItem *)sender
{
    
    if ([self.navigationItem.rightBarButtonItem.title isEqualToString:@"启用"]) {
        
//        if ([PrintType sharePrintType].printState == 1) {
//            NSDictionary * jsondis = @{
//                                       @"Command":@55,
//                                       @"UserId":[UserInfo shareUserInfo].userId,
//                                       @"PrintState":@2
//                                       };
//            [self playPostWithDictionary:jsondis];
//        }else
//        {
            [self.navigationItem.rightBarButtonItem setTitle:@"停止"];
        [[NSUserDefaults standardUserDefaults] setObject:@1 forKey:@"isBlutooth"];
            [PrintType sharePrintType].isBlutooth = YES;
//        }
    }else{
        [self.navigationItem.rightBarButtonItem setTitle:@"启用"];
        [[NSUserDefaults standardUserDefaults] setObject:@0 forKey:@"isBlutooth"];
        [PrintType sharePrintType].isBlutooth = NO;
//        [PrintType sharePrintType].printType = 0;
    }
//    NSLog(@"****%d", [PrintType sharePrintType].printType);
}

#pragma mark - 轻拍手势设置打印份数
- (void)printNumTapAction:(UITapGestureRecognizer *)sender
{
    [self createCustomAlertView];
}

- (void)createCustomAlertView
{
    CustomIOSAlertView * cunstomAlert = [[CustomIOSAlertView alloc] init];
    cunstomAlert.containerView = [self createAlertSubview];
    [cunstomAlert setButtonTitles:@[@"取消", @"确定"]];
    cunstomAlert.delegate = self;
    cunstomAlert.useMotionEffects = YES;
    [cunstomAlert show];
}

- (UIView *)createAlertSubview
{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, VIEW_WIDTH, VIEW_HEIGT)];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.cornerRadius = 10;
    
    UILabel *setUplabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, VIEW_WIDTH, BUTTON_HEIGHT)];
    setUplabel.text = @"打印设置";
    setUplabel.textAlignment = NSTextAlignmentCenter;
    [view addSubview:setUplabel];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, setUplabel.bottom, VIEW_WIDTH , 1)];
    line.backgroundColor = [UIColor grayColor];
    [view addSubview:line];
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(10, line.bottom, 150, BUTTON_HEIGHT)];
    label1.text = @"请设置打印份数";
    [view addSubview:label1];
    
    UIButton * subtractButton = [UIButton buttonWithType:UIButtonTypeSystem];
    subtractButton.frame = CGRectMake(label1.right, label1.top, BUTTON_WIDTH, BUTTON_HEIGHT);
    [subtractButton addTarget:self action:@selector(subtractPrintNumber:) forControlEvents:UIControlEventTouchUpInside];
    [subtractButton setBackgroundImage:[UIImage imageNamed:@"reduce_normal.png"] forState:UIControlStateNormal];
    [subtractButton setBackgroundImage:[UIImage imageNamed:@"reduce_press.png"] forState:UIControlStateHighlighted];
//    subtractButton.backgroundColor = [UIColor orangeColor];
    [view addSubview:subtractButton];
    
    self.numberTF = [[UITextField alloc] initWithFrame:CGRectMake(subtractButton.right, subtractButton.top, subtractButton.width, subtractButton.height)];
    _numberTF.keyboardType = UIKeyboardTypeNumberPad;
    _numberTF.borderStyle = UITextBorderStyleLine;
    _numberTF.textAlignment = NSTextAlignmentCenter;
    _numberTF.text = [self getPrintNum];
    [view addSubview:_numberTF];
    
    UIButton * addButton = [UIButton buttonWithType:UIButtonTypeSystem];
    addButton.frame = CGRectMake(_numberTF.right, _numberTF.top, subtractButton.width, subtractButton.height);
    [addButton addTarget:self action:@selector(addPrintNumber:) forControlEvents:UIControlEventTouchUpInside];
    [addButton setBackgroundImage:[UIImage imageNamed:@"add_normal.png"] forState:UIControlStateNormal];
    [addButton setBackgroundImage:[UIImage imageNamed:@"add_press.png"] forState:UIControlStateHighlighted];
//    addButton.backgroundColor = [UIColor orangeColor];
    [view addSubview:addButton];
    
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, label1.bottom, VIEW_WIDTH , 1)];
    line1.backgroundColor = [UIColor grayColor];
    [view addSubview:line1];
    
//    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10, line1.bottom, 100, BUTTON_HEIGHT)];
//    label.text = @"自动打印";
//    [view addSubview:label];
//    
//    self.autoSwitch = [GeneralSwitch shareGeneralSwitch].bluetoothSwitch;
//    _autoSwitch.frame = CGRectMake(VIEW_WIDTH + label.left - 10 - 40 - 20, label.top + 5 , BUTTON_WIDTH, BUTTON_WIDTH);
//    [_autoSwitch addTarget:self action:@selector(autoPrint:) forControlEvents:UIControlEventTouchUpInside];
//    [view addSubview:_autoSwitch];
    
    return view;
}

- (void)addPrintNumber:(UIButton *)button
{
    self.numberTF.text = [NSString stringWithFormat:@"%d", [self.numberTF.text intValue] + 1];
}

- (void)subtractPrintNumber:(UIButton *)button
{
    if ([self.numberTF.text intValue] != 0) {
        self.numberTF.text = [NSString stringWithFormat:@"%d", [self.numberTF.text intValue] - 1];
    }
}

- (void)customIOS7dialogButtonTouchUpInside: (CustomIOSAlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex
{
    NSLog(@"Delegate: Button at position %d is clicked on alertView %d.", (int)buttonIndex, (int)[alertView tag]);
    if (buttonIndex == 1) {
        
        if ([_numberTF.text intValue] < 0) {
            _numberTF.text = @"0";
        }
        [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithInt:[_numberTF.text intValue]] forKey:@"printNum"];
        self.printNumLabel.text = [NSString stringWithFormat:@"%@份", _numberTF.text];
//        [PrintType sharePrintType].isBlutooth = YES;
//        [PrintType sharePrintType].printType = 1;
//        [self.navigationItem.rightBarButtonItem setTitle:@"停止"];
    }else
    {
//        [PrintType sharePrintType].isBlutooth = NO;
//        [PrintType sharePrintType].printType = 0;
    }
    [alertView close];
}

- (NSString *)getPrintNum
{
//    PrintNumViewCell * cell = (PrintNumViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
//    return [NSString stringWithFormat:@"%ld", [cell.numberLabel.text integerValue]];
    NSLog(@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"printNum"]);
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"printNum"]) {
        
        NSString *str = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"printNum"]];
        
        return str;
    }else
    {
        [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithInt:1] forKey:@"printNum"];
    return @"1";
    }
}

#pragma mark - 断开蓝牙连接
- (void)disconnectAction:(UIButton *)button event:(id)event
{
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:currentTouchPosition];
    if (indexPath!= nil) {
        PeripheralViewCell *cell = (PeripheralViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        cell.periheralName.text = @"蓝牙未连接";
        cell.periheralID.text = @"未连接";
        cell.disconnectButton.hidden = YES;
        [[GeneralBlueTooth shareGeneralBlueTooth] disConnectBluetooth];
        [self.tableView reloadData];
    }
//    NSLog(@"*************蓝牙断开");
}

#pragma mark - 自动打印
- (void)autoPrint:(UISwitch *)autoswitch
{
    NSLog(@"%d", autoswitch.on);
    if (autoswitch.on == YES) {
        if ([GeneralBlueTooth shareGeneralBlueTooth].myPeripheral.state) {
            autoswitch.on = YES;
        }else
        {
            autoswitch.on = NO;
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"蓝牙未连接自动打印功能不可用" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
        }
    }else
    {
        autoswitch.on = NO;
    }
}

#pragma mark - 观察者代理方法
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    id a = [change objectForKey:@"new"];
    NSLog(@"**%@" , [change objectForKey:@"new"]);
    if (![a isKindOfClass:[NSNull class]]) {
        if ([a integerValue] == 0) {
            UISwitch *atswitch = [GeneralSwitch shareGeneralSwitch].bluetoothSwitch;
            atswitch.on = NO;
        }else
        {
            ;
        }
    }
    
}

- (void)dealloc
{
    if (self.a == 1) {
        [self removeObserver:self forKeyPath:@"self.blueteeth.myPeripheral.state"];
    }
    
//    NSLog(@"********观察者已经移除****");
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
