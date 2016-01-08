//
//  NewOrdersViewController.m
//  TinyOrder
//
//  Created by 仙林 on 15/4/8.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "NewOrdersViewController.h"
#import "NewOrdersiewCell.h"
#import "GeneralBlueTooth.h"
#import "BluetoothViewController.h"
#import "NewOrderModel.h"
#import "Meal.h"
#import "DealOrderModel.h"
#import "DiscarViewCell.h"
#import "TangshiCell.h"
#import "AppDelegate.h"
//#import "QRCodeGenerator.h"

#import "PrintTypeViewController.h"

#define CELL_IDENTIFIER @"cell"
#define DISCELL_IDENTIFIER @"discell"
#define TANGSHI_IDENTIFIER @"tangshicell"
#define DEALBUTTON_TAG 1000
#define NULLIYBUTTON_TAG 2000
#define SEGMENT_HEIGHT 40
#define SEGMENT_WIDTH 240
#define SEGMENT_X self.view.width / 2 - SEGMENT_WIDTH / 2
#define TOP_SPACE 10
#define HEARDERVIEW_HEIGHT TOP_SPACE * 2 + SEGMENT_HEIGHT

#define SELECTCOLOR [UIColor colorWithRed:255 / 255.0 green:212 / 255.0 blue:180 / 255.0 alpha:1]
#define WAITCOLOR [UIColor colorWithRed:250 / 255.0 green:65 / 255.0 blue:32 / 255.0 alpha:1]

@interface NewOrdersViewController ()<HTTPPostDelegate, UIAlertViewDelegate>

@property (nonatomic, strong)NSMutableArray * dataArray;
@property (nonatomic, strong)NSMutableArray * discardAry;
@property (nonatomic, strong)NSMutableArray * newsArray;
@property (nonatomic, strong)NSMutableArray * tangshiArray;
@property (nonatomic, strong)UILabel * neNumLB;
@property (nonatomic, strong)UILabel * cancleNumLB;
@property (nonatomic, assign)int discarPage;
@property (nonatomic, assign)int newsPage;
@property (nonatomic, assign)int tangshiPag;
@property (nonatomic, strong)NSNumber * discarAllCount;
@property (nonatomic, strong)NSNumber * newsAllCount;
@property (nonatomic, strong)NSNumber * tangshiAllCount;
@property (nonatomic, assign)NSInteger printRow;
@property (nonatomic, strong)UISegmentedControl * segment;
@property (nonatomic, strong)UIView * segmentView;

@property (nonatomic, strong)PrintTypeViewController *printTypeVC;

@end

@implementation NewOrdersViewController


- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getPush:) name:@"push" object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)getPush:(NSNotification *)noti
{
    int count = [self.navigationController.tabBarItem.badgeValue intValue];
    if (self.navigationController.tabBarItem.badgeValue) {
        self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d", ++count];
    }else
    {
        self.navigationController.tabBarItem.badgeValue = @"1";
    }
    NSLog(@"%@", [noti userInfo]);
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)discardAry
{
    if (!_discardAry) {
        self.discardAry = [NSMutableArray array];
    }
    return _discardAry;
}

- (NSMutableArray *)newsArray
{
    if (!_newsArray) {
        self.newsArray = [NSMutableArray array];
    }
    return _newsArray;
}

- (NSMutableArray *)tangshiArray
{
    if (!_tangshiArray) {
        self.tangshiArray = [NSMutableArray array];
    }
    return _tangshiArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.navigationController.tabBarItem.badgeValue = @"123";
    self.tableView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    [self.tableView registerClass:[NewOrdersiewCell class] forCellReuseIdentifier:CELL_IDENTIFIER];
    [self.tableView registerClass:[DiscarViewCell class] forCellReuseIdentifier:DISCELL_IDENTIFIER];
    [self.tableView registerClass:[TangshiCell class] forCellReuseIdentifier:TANGSHI_IDENTIFIER];
//    [self.tableView headerBeginRefreshing];
    _newsPage = 1;
    [self downloadDataWithCommand:@3 page:1 count:COUNT];
    [SVProgressHUD showWithStatus:@"正在加载..." maskType:SVProgressHUDMaskTypeBlack];
    [self downloadDataWithCommand:@28 page:1 count:COUNT];
    [self downloadDataWithCommand:@68 page:1 count:COUNT];
    [self addHearderView];
    self.printTypeVC = [[PrintTypeViewController alloc]init];
    
//    [self.tableView headerBeginRefreshing];
    
//    if ([self respondsToSelector:@selector(headerBeginRefreshing)]) {
//        self.automaticallyAdjustsScrollViewInsets = NO;
//        UIEdgeInsets insets = self.tableView.contentInset;
////        insets.top = self.navigationController.navigationBar.bounds.size.height +        [UIApplication sharedApplication].statusBarFrame.size.height;
//        insets.top = self.navigationController.navigationBar.bounds.size.height;
//        self.tableView.contentInset = insets;
//        self.tableView.scrollIndicatorInsets = insets;
//    }
}

- (void)addHearderView
{
//    UIView * hearderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, HEARDERVIEW_HEIGHT)];
//    hearderView.backgroundColor = [UIColor clearColor];
//    
//    self.segment = [[UISegmentedControl alloc] initWithItems:@[@"", @""]];
//    _segment.tintColor = [UIColor clearColor];
//    [_segment setImage:[[UIImage imageNamed:@"newOrder_press.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forSegmentAtIndex:0];
//    [_segment setImage:[[UIImage imageNamed:@"cancleOrder_normal.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forSegmentAtIndex:1];
//    _segment.frame = CGRectMake(SEGMENT_X, TOP_SPACE, SEGMENT_WIDTH, SEGMENT_HEIGHT);
//    _segment.selectedSegmentIndex = 0;
//    [_segment addTarget:self action:@selector(changeDeliveryState:) forControlEvents:UIControlEventValueChanged];
//    [hearderView addSubview:_segment];
//    
//    self.neNumLB = [[UILabel alloc] initWithFrame:CGRectMake(_segment.left + 87, 9 + TOP_SPACE, 22, 22)];
//    _neNumLB.text = @"0";
//    _neNumLB.font = [UIFont systemFontOfSize:12];
//    _neNumLB.textAlignment = NSTextAlignmentCenter;
//    _neNumLB.textColor = SELECTCOLOR;
//    _neNumLB.layer.cornerRadius = 11;
//    _neNumLB.layer.backgroundColor = WAITCOLOR.CGColor;
//    [hearderView addSubview:_neNumLB];
//    self.cancleNumLB = [[UILabel alloc] initWithFrame:CGRectMake(self.view.width / 2 + 87, 9 + TOP_SPACE, 22, 22)];
//    _cancleNumLB.font = [UIFont systemFontOfSize:12];
//    _cancleNumLB.textAlignment = NSTextAlignmentCenter;
//    _cancleNumLB.text = @"0";
//    _cancleNumLB.layer.cornerRadius = 11;
//    _cancleNumLB.layer.backgroundColor = SELECTCOLOR.CGColor;
//    self.cancleNumLB.textColor = WAITCOLOR;
//    [hearderView addSubview:_cancleNumLB];

    
    self.segment = [[UISegmentedControl alloc] initWithItems:@[@"新订单", @"已作废", @"堂  食"]];
    
    self.segment.tintColor = [UIColor clearColor];//去掉颜色,现在整个segment都看不见
    self.segment.backgroundColor = [UIColor whiteColor];;
    //    self.segment.tintColor = [UIColor colorWithRed:222.0/255.0 green:7.0/255.0 blue:28.0/255.0 alpha:1.0];
    NSDictionary* selectedTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:16],
                                             NSForegroundColorAttributeName: [UIColor orangeColor]};
    [self.segment setTitleTextAttributes:selectedTextAttributes forState:UIControlStateSelected];//设置文字属性
    NSDictionary* unselectedTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:16],
                                               NSForegroundColorAttributeName: [UIColor grayColor]};
    [self.segment setTitleTextAttributes:unselectedTextAttributes forState:UIControlStateNormal];
    
    self.segment.selectedSegmentIndex = 0;
    self.segment.layer.cornerRadius = 5;
    
    _segment.frame = CGRectMake(20, 15, 180, 30);
    [_segment addTarget:self action:@selector(changeDeliveryState:) forControlEvents:UIControlEventValueChanged];
    
    self.segmentView = [[UIView alloc]initWithFrame:CGRectMake(20, 50, 60, 2)];
    self.segmentView.backgroundColor = [UIColor orangeColor];
    
    UIView * hearderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, HEARDERVIEW_HEIGHT)];
    hearderView.backgroundColor = [UIColor clearColor];
    [hearderView addSubview:_segment];
    [hearderView addSubview:_segmentView];
    
    UINavigationBar * bar = self.navigationController.navigationBar;
    [bar setShadowImage:[UIImage imageNamed:@"1px.png"]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"1px.png"] forBarMetrics:UIBarMetricsDefault];

    
    self.navigationItem.titleView = hearderView;
}

- (void)changeDeliveryState:(UISegmentedControl *)segment
{
    if (segment.selectedSegmentIndex == 2) {
//        if (_tangshiArray == nil) {
//            _tangshiPag = 1;
//            [self downloadDataWithCommand:@68 page:1 count:10];
//            [SVProgressHUD showWithStatus:@"正在加载..." maskType:SVProgressHUDMaskTypeBlack];
//        }
        self.dataArray = self.tangshiArray;
        [self.tableView headerBeginRefreshing];
//        self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld", (long)[self.tangshiAllCount integerValue]];
        [UIView animateWithDuration:0.35 animations:^{
            _segmentView.frame = CGRectMake(140, 50, 60, 2);
            
        }];
    }else if (segment.selectedSegmentIndex == 1) {
//        if (_discardAry == nil) {
//            _discarPage = 1;
//            [self downloadDataWithCommand:@28 page:1 count:10];
//            [SVProgressHUD showWithStatus:@"正在加载..." maskType:SVProgressHUDMaskTypeBlack];
//        }
//        self.neNumLB.layer.backgroundColor = SELECTCOLOR.CGColor;
//        self.cancleNumLB.layer.backgroundColor = WAITCOLOR.CGColor;
//        self.cancleNumLB.textColor = SELECTCOLOR;
//        self.neNumLB.textColor = WAITCOLOR;
        self.dataArray = self.discardAry;
        
        [self.tableView headerBeginRefreshing];
        
//        self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld", (long)[self.discarAllCount integerValue]];
        [UIView animateWithDuration:0.35 animations:^{
            _segmentView.frame = CGRectMake(80, 50, 60, 2);
            
        }];
        
    }else
    {
        self.dataArray = self.newsArray;
        [self.tableView headerBeginRefreshing];
//        self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld", (long)[self.newsAllCount integerValue]];
        [UIView animateWithDuration:0.35 animations:^{
            _segmentView.frame = CGRectMake(20, 50, 60, 2);
            
        }];
        
    }
    [self.tableView reloadData];
}

- (void)tableViewEndRereshing
{
    if (self.tableView.isHeaderRefreshing) {
        [self.tableView headerEndRefreshing];
    }
    if (self.tableView.isFooterRefreshing) {
        [self.tableView footerEndRefreshing];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.tableView headerBeginRefreshing];
//    [self.tableView reloadData];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)headerRereshing
{
    [self tableViewEndRereshing];
     if (self.segment.selectedSegmentIndex == 2) {
        _tangshiPag = 1;
        [self downloadDataWithCommand:@68 page:_tangshiPag count:COUNT];
    }else if (self.segment.selectedSegmentIndex == 1) {
        _discarPage = 1;
        [self downloadDataWithCommand:@28 page:_discarPage count:COUNT];
    }else
    {
        _newsPage = 1;
        [self downloadDataWithCommand:@3 page:_newsPage count:COUNT];
    }
//    [self.tableView footerEndRefreshing];
//    self.navigationController.tabBarItem.badgeValue = nil;
//    _newsPage = 1;
//    self.dataArray = nil;
//    [self downloadDataWithCommand:@3 page:_newsPage count:COUNT];
}


- (void)footerRereshing
{
    [self tableViewEndRereshing];
    if (self.segment.selectedSegmentIndex == 2) {
        if (self.dataArray.count < [_tangshiAllCount integerValue]) {
            self.tableView.footerRefreshingText = @"正在加载数据";
            [self downloadDataWithCommand:@68 page:++_tangshiPag count:COUNT];
        }else
        {
            self.tableView.footerRefreshingText = @"数据已经加载完";
            [self.tableView performSelector:@selector(footerEndRefreshing) withObject:nil afterDelay:1];
        }
    }else if (self.segment.selectedSegmentIndex == 1) {
        if (self.dataArray.count < [_discarAllCount integerValue]) {
            self.tableView.footerRefreshingText = @"正在加载数据";
            [self downloadDataWithCommand:@28 page:++_discarPage count:COUNT];
        }else
        {
            self.tableView.footerRefreshingText = @"数据已经加载完";
            [self.tableView performSelector:@selector(footerEndRefreshing) withObject:nil afterDelay:1];
        }
    }else
    {
        if (self.dataArray.count < [_newsAllCount integerValue]) {
            self.tableView.footerRefreshingText = @"正在加载数据";
            [self downloadDataWithCommand:@3 page:++_newsPage count:COUNT];
        }else
        {
            self.tableView.footerRefreshingText = @"数据已经加载完";
            [self.tableView performSelector:@selector(footerEndRefreshing) withObject:nil afterDelay:1];
        }
    }
}


- (void)downloadDataWithCommand:(NSNumber *)command page:(int)page count:(int)count
{
    if (self.segment.selectedSegmentIndex == 2) {
        NSDictionary * jsonDic = @{
                                   @"UserId":[UserInfo shareUserInfo].userId,
                                   @"CurPage":[NSNumber numberWithInt:page],
                                   @"TangshiType":@1,
                                   @"Command":command,
                                   @"CurCount":[NSNumber numberWithInt:count]
                                   };
        [self playPostWithDictionary:jsonDic];
    }else
    {
        NSDictionary * jsonDic = @{
                                   @"UserId":[UserInfo shareUserInfo].userId,
                                   @"CurPage":[NSNumber numberWithInt:page],
                                   @"Command":command,
                                   @"CurCount":[NSNumber numberWithInt:count]
                                   };
        [self playPostWithDictionary:jsonDic];
    }
    /*
    NSString * jsonStr = [jsonDic JSONString];
    NSString * str = [NSString stringWithFormat:@"%@231618", jsonStr];
    NSString * md5Str = [str md5];
    //    NSLog(@"////%@", md5Str);
    NSString * urlString = [NSString stringWithFormat:@"http://p.vlifee.com/getdata.ashx?md5=%@",md5Str];
    HTTPPost * httpPost = [HTTPPost shareHTTPPost];
    [httpPost post:urlString HTTPBody:[jsonStr dataUsingEncoding:NSUTF8StringEncoding]];
    httpPost.delegate = self;
     */
}

- (void)playPostWithDictionary:(NSDictionary *)dic
{
    NSString * jsonStr = [dic JSONString];
    NSLog(@"%@", jsonStr);

    NSString * str = [NSString stringWithFormat:@"%@231618", jsonStr];
    NSString * md5Str = [str md5];
    NSString * urlString = [NSString stringWithFormat:@"%@%@", POST_URL, md5Str];
    
    HTTPPost * httpPost = [HTTPPost shareHTTPPost];
    [httpPost post:urlString HTTPBody:[jsonStr dataUsingEncoding:NSUTF8StringEncoding]];
    httpPost.delegate = self;
}

- (void)refresh:(id)data
{
    [self tableViewEndRereshing];
    NSLog(@"%@  error = %@", [data description], [data objectForKey:@"ErrorMsg"]);
//        NSDictionary * dataDic = (NSDictionary *)data;
    if ([[data objectForKey:@"Result"] isEqual:@1]) {
        int command = [[data objectForKey:@"Command"] intValue];
        if (command == 10003) {
            self.newsAllCount = [data objectForKey:@"AllCount"];
            self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld", (long)[self.newsAllCount integerValue]];
            self.neNumLB.text = [NSString stringWithFormat:@"%@", self.newsAllCount];
            if (_newsPage == 1) {
                self.newsArray = nil;
            }
            NSArray * array = [data objectForKey:@"OrderList"];
            for (NSDictionary * dic in array) {
                NewOrderModel * newOrder = [[NewOrderModel alloc] initWithDictionary:dic];
                [self.newsArray addObject:newOrder];
            }
            self.dataArray = self.newsArray;
            self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld", (long)[self.newsAllCount integerValue]];
//            self.automaticallyAdjustsScrollViewInsets = NO;
//            UIEdgeInsets insets = self.tableView.contentInset;
////            insets.top = self.navigationController.navigationBar.bounds.size.height +        [UIApplication sharedApplication].statusBarFrame.size.height;
//            insets.top = self.navigationController.navigationBar.bounds.size.height;
//            self.tableView.contentInset = insets;
//            self.tableView.scrollIndicatorInsets = insets;
            
            [SVProgressHUD dismiss];
        }else if(command == 10028)
        {
            self.discarAllCount = [data objectForKey:@"AllCount"];
            self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld", (long)[self.discarAllCount integerValue]];
            self.cancleNumLB.text = [NSString stringWithFormat:@"%@", [data objectForKey:@"AllCount"]];
            if (_discarPage == 1) {
                self.discardAry = nil;
            }
            NSArray * array = [data objectForKey:@"OrderList"];
            for (NSDictionary * dic in array) {
                DealOrderModel * discarOrder = [[DealOrderModel alloc] initWithDictionary:dic];
                [self.discardAry addObject:discarOrder];
            }
            self.dataArray = self.discardAry;
            self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld", (long)[self.discarAllCount integerValue]];
//            self.automaticallyAdjustsScrollViewInsets = NO;
//            UIEdgeInsets insets = self.tableView.contentInset;
////            insets.top = self.navigationController.navigationBar.bounds.size.height +        [UIApplication sharedApplication].statusBarFrame.size.height;
//            insets.top = self.navigationController.navigationBar.bounds.size.height;
//            self.tableView.contentInset = insets;
//            self.tableView.scrollIndicatorInsets = insets;
            
            [SVProgressHUD dismiss];
        }else if(command == 10015)
        {
            if ([PrintType sharePrintType].printType == 2) {

            }else
            {
                if (![[NSUserDefaults standardUserDefaults] objectForKey:@"printNum"]){
                    NewOrderModel * order = [self.dataArray objectAtIndex:self.printRow];
                    NSString * printStr = [self getPrintStringWithNewOrder:order];
                    [[GeneralBlueTooth shareGeneralBlueTooth] printWithString:printStr];
                }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"printNum"] integerValue] != 0){
                    
                    
                    NewOrderModel * order = [self.dataArray objectAtIndex:self.printRow];
                    NSString * printStr = [self getPrintStringWithNewOrder:order];
                    NSMutableArray * printAry = [NSMutableArray array];
                    int num = [[[NSUserDefaults standardUserDefaults] objectForKey:@"printNum"] intValue];
                    for (int j = 0; j < num; j++) {
                        [printAry addObject:printStr];
                        
                        [[GeneralBlueTooth shareGeneralBlueTooth] printWithString:printStr];
                        
                        if ([order.PayMath intValue] == 3) {
                            
                            
//                            UIImage * image = [[QRCode shareQRCode] createQRCodeForString:
//                                               [NSString stringWithFormat:@"http://wap.vlifee.com/eat/ScanCodeChangeMoney.aspx?ordersn=%@&busiid=%@&from=app", order.orderId, [UserInfo shareUserInfo].userId]];
//                            NSData * inageData = UIImageJPEGRepresentation(image, 1.0);
//                            UIImage * image1 = [UIImage imageWithData:inageData];
                            
                            
                            NSString * str = [NSString stringWithFormat:@"http://wap.vlifee.com/eat/ScanCodeChangeMoney.aspx?ordersn=%@&busiid=%@&from=app", order.orderId, [UserInfo shareUserInfo].userId];
                            [[GeneralBlueTooth shareGeneralBlueTooth] printPng:str];
                            
                        }

                    }
                    
                    
                }
                
            }
            [self downloadDataWithCommand:@3 page:1 count:COUNT];
            UIAlertView * alertV = [[UIAlertView alloc] initWithTitle:@"提示" message:@"处理成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alertV show];
            [alertV performSelector:@selector(dismiss) withObject:nil afterDelay:1.5];
        }else if (command == 10023 || command == 10026 || command == 10027)
        {
            [self downloadDataWithCommand:@3 page:1 count:COUNT];
            UIAlertView * alertV = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请求成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alertV show];
            [alertV performSelector:@selector(dismiss) withObject:nil afterDelay:1.5];
        }else if (command == 10068)
        {
            self.tangshiAllCount = [data objectForKey:@"AllCount"];
            self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld", (long)[self.tangshiAllCount integerValue]];
            if (_tangshiPag == 1) {
                self.tangshiArray = nil;
            }
            NSArray * array = [data objectForKey:@"OrderList"];
            for (NSDictionary * dic in array) {
                NewOrderModel * discarOrder = [[NewOrderModel alloc] initWithDictionary:dic];
                [self.tangshiArray addObject:discarOrder];
            }
            self.dataArray = self.tangshiArray;
            self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld", (long)[self.tangshiAllCount integerValue]];
            [SVProgressHUD dismiss];
        }else if (command == 10069)
        {
            if ([PrintType sharePrintType].printType == 2) {
                
            }else
            {
                if (![[NSUserDefaults standardUserDefaults] objectForKey:@"printNum"]){
                    NewOrderModel * order = [self.dataArray objectAtIndex:self.printRow];
                    NSString * printStr = [self getPrintStringWithTangshiOrder:order];
                    [[GeneralBlueTooth shareGeneralBlueTooth] printWithString:printStr];
                }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"printNum"] integerValue] != 0){
                    
                    
                    NewOrderModel * order = [self.dataArray objectAtIndex:self.printRow];
                    NSString * printStr = [self getPrintStringWithTangshiOrder:order];
                    NSMutableArray * printAry = [NSMutableArray array];
                    int num = [[[NSUserDefaults standardUserDefaults] objectForKey:@"printNum"] intValue];
                    for (int j = 0; j < num; j++) {
                        [printAry addObject:printStr];
                        
                        [[GeneralBlueTooth shareGeneralBlueTooth] printWithString:printStr];
                        
                        if (!order.pay) {
                            
                            
//                            UIImage * image = [[QRCode shareQRCode] createQRCodeForString:
//                                               [NSString stringWithFormat:@"http://wap.vlifee.com/eat/ScanCodeChangeMoney.aspx?ordersn=%@&busiid=%@&from=app", order.orderId, [UserInfo shareUserInfo].userId]];
//                            NSData * inageData = UIImageJPEGRepresentation(image, 1.0);
//                            UIImage * image1 = [UIImage imageWithData:inageData];
                            
                            NSString * str = [NSString stringWithFormat:@"http://wap.vlifee.com/eat/ScanCodeChangeMoney.aspx?ordersn=%@&busiid=%@&from=app", order.orderId, [UserInfo shareUserInfo].userId];
                            [[GeneralBlueTooth shareGeneralBlueTooth] printPng:str];
                            
                            
                        }
                        
                    }
                    
                    
                }
                
            }
            [self downloadDataWithCommand:@68 page:1 count:COUNT];
            UIAlertView * alertV = [[UIAlertView alloc] initWithTitle:@"提示" message:@"处理成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alertV show];
            [alertV performSelector:@selector(dismiss) withObject:nil afterDelay:1.5];
        }
        if (self.segment.selectedSegmentIndex == 1) {
            self.dataArray = self.discardAry;
        }else if(self.segment.selectedSegmentIndex == 0)
        {
            self.dataArray = self.newsArray;
        }else
        {
            self.dataArray = self.tangshiArray;
        }
        [self.tableView reloadData];
    }else
    {
        [SVProgressHUD dismiss];
        UIAlertView * alertV = [[UIAlertView alloc] initWithTitle:@"提示" message:[data objectForKey:@"ErrorMsg"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertV show];
        
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        if ([alertView.message isEqualToString:@"您没有可用的GPRS打印机"]) {
            _printTypeVC.fromWitchController = 2;
            _printTypeVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:_printTypeVC animated:YES];
        }else if ([alertView.message isEqualToString:@"蓝牙打印机未连接"])
        {
            _printTypeVC.fromWitchController = 2;
            _printTypeVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:_printTypeVC animated:YES];
        }
    }
}

- (void)failWithError:(NSError *)error
{
    [SVProgressHUD dismiss];
    UIAlertView * alertV = [[UIAlertView alloc] initWithTitle:@"提示" message:@"连接服务器失败" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [alertV show];
    [alertV performSelector:@selector(dismiss) withObject:nil afterDelay:1.5];
    NSLog(@"%@", error);
    [self tableViewEndRereshing];
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
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.segment.selectedSegmentIndex == 2) {
        NewOrderModel * tangshiModel = [self.dataArray objectAtIndex:indexPath.row];
        TangshiCell * tangshicell = [tableView dequeueReusableCellWithIdentifier:TANGSHI_IDENTIFIER forIndexPath:indexPath];
        [tangshicell createSubView:tableView.bounds mealCoutn:tangshiModel.mealArray.count];
        tangshicell.orderModel = tangshiModel;
        [tangshicell.totalPriceView.dealButton addTarget:self action:@selector(dealAndPrint:) forControlEvents:UIControlEventTouchUpInside];
        tangshicell.totalPriceView.dealButton.tag = indexPath.row + DEALBUTTON_TAG;
        tangshicell.selectionStyle = UITableViewCellSelectionStyleNone;
        return tangshicell;
    }else if (self.segment.selectedSegmentIndex == 1) {
        DealOrderModel * discarOD = [self.dataArray objectAtIndex:indexPath.row];
        DiscarViewCell * disCell = [tableView dequeueReusableCellWithIdentifier:DISCELL_IDENTIFIER forIndexPath:indexPath];
        [disCell createSubView:tableView.bounds mealCount:discarOD.mealArray.count];
        disCell.dealOrder = discarOD;
        if (discarOD.isSelete) {
            [disCell disHiddenSubView:self.tableView.bounds mealCount:discarOD.mealArray.count andHiddenImage:NO];
        }else
        {
            [disCell hiddenSubView:self.tableView.bounds mealCount:discarOD.mealArray.count];
        }
        disCell.totalPriceView.dealButton.frame = CGRectMake(disCell.totalPriceView.dealButton.frame.origin.x, disCell.totalPriceView.dealButton.frame.origin.y, 0, disCell.totalPriceView.dealButton.frame.size.height);
        disCell.totalPriceView.printButton.hidden = YES;
        disCell.totalPriceView.totalLabel.frame = CGRectMake(self.view.width - 120 - 15, disCell.totalPriceView.totalLabel.frame.origin.y, 40, 30);
        disCell.totalPriceView.totalPriceLabel.frame = CGRectMake(disCell.totalPriceView.totalLabel.right, disCell.totalPriceView.totalPriceLabel.frame.origin.y, 80, 30);
        disCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return disCell;
    }else
    {
        
        NewOrderModel * newOrder = [self.dataArray objectAtIndex:indexPath.row];
        
        NewOrdersiewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
        
        [cell createSubView:self.tableView.bounds mealCoutn:newOrder.mealArray.count];
        [cell.totalView.dealButton addTarget:self action:@selector(dealAndPrint:) forControlEvents:UIControlEventTouchUpInside];
        [cell.totalView.nulliyButton addTarget:self action:@selector(nulliyOrder:) forControlEvents:UIControlEventTouchUpInside];
        cell.totalView.dealButton.tag = indexPath.row + DEALBUTTON_TAG;
        cell.totalView.nulliyButton.tag = indexPath.row + NULLIYBUTTON_TAG;
        cell.orderModel = newOrder;
        
        
        return cell;
    }
}

- (void)dealAndPrint:(UIButton *)button
{
    
    
    
    

    self.printRow = button.tag - DEALBUTTON_TAG;
    NewOrderModel * order = [self.dataArray objectAtIndex:button.tag - DEALBUTTON_TAG];
    
    
    if ([PrintType sharePrintType].printType == 2) {
        
        NSNumber *num = nil;
        if (self.segment.selectedSegmentIndex == 0) {
            NSDictionary * jsonDic = @{
                                       @"UserId":[UserInfo shareUserInfo].userId,
                                       @"Command":@15,
                                       @"OrderId":order.orderId,
                                       @"PrintType":@3
                                       };
            
            [self playPostWithDictionary:jsonDic];
        }else if (self.segment.selectedSegmentIndex == 2)
        {
            NSDictionary * jsonDic = @{
                                       @"UserId":[UserInfo shareUserInfo].userId,
                                       @"Command":@69,
                                       @"OrderId":order.orderId,
                                       @"PrintType":@3
                                       };
            
            [self playPostWithDictionary:jsonDic];
        }
        
    }else if ( [PrintType sharePrintType].printType == 1)
    {
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"printNum"] integerValue] == 0) {
            if (self.segment.selectedSegmentIndex == 0) {
                NSDictionary * jsonDic = @{
                                           @"UserId":[UserInfo shareUserInfo].userId,
                                           @"Command":@15,
                                           @"OrderId":order.orderId,
                                           @"PrintType":@2
                                           };
                
                [self playPostWithDictionary:jsonDic];
            }else if (self.segment.selectedSegmentIndex == 2)
            {
                NSDictionary * jsonDic = @{
                                           @"UserId":[UserInfo shareUserInfo].userId,
                                           @"Command":@69,
                                           @"OrderId":order.orderId,
                                           @"PrintType":@2
                                           };
                
                [self playPostWithDictionary:jsonDic];
            }

        }else if ([GeneralBlueTooth shareGeneralBlueTooth].myPeripheral.state) {
            if (self.segment.selectedSegmentIndex == 0) {
                NSDictionary * jsonDic = @{
                                           @"UserId":[UserInfo shareUserInfo].userId,
                                           @"Command":@15,
                                           @"OrderId":order.orderId,
                                           @"PrintType":@2
                                           };
                
                [self playPostWithDictionary:jsonDic];
            }else if (self.segment.selectedSegmentIndex == 2)
            {
                NSDictionary * jsonDic = @{
                                           @"UserId":[UserInfo shareUserInfo].userId,
                                           @"Command":@69,
                                           @"OrderId":order.orderId,
                                           @"PrintType":@2
                                           };
                
                [self playPostWithDictionary:jsonDic];
            }
            [SVProgressHUD showWithStatus:@"正在请求处理..." maskType:SVProgressHUDMaskTypeBlack];
        }else
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"蓝牙打印机未连接" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
        }
        
    } else
    {
        _printTypeVC.nOrderModel = order;
        _printTypeVC.fromWitchController = 2;
        _printTypeVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:_printTypeVC animated:YES];
        
    }
 
    NSLog(@"订单号%d", order.orderNum);
    
}

- (void)nulliyOrder:(UIButton *)button
{
    NSDictionary * jsonDic = nil;
    NSString * string = nil;
    NewOrderModel * order = [self.dataArray objectAtIndex:button.tag - NULLIYBUTTON_TAG];
    if (order.dealState.integerValue == 1) {
        //拒绝接单
        jsonDic = @{
                    @"UserId":[UserInfo shareUserInfo].userId,
                    @"Command":@26,
                    @"OrderId":order.orderId
                    };
        string = @"正在拒绝...";
    }else if (order.dealState.integerValue == 4) {
        //无效
        jsonDic = @{
                    @"UserId":[UserInfo shareUserInfo].userId,
                    @"Command":@23,
                    @"OrderId":order.orderId
                    };
        string = @"正在设置无效...";
    }else if (order.dealState.integerValue == 5) {
        //退款
        jsonDic = @{
                    @"UserId":[UserInfo shareUserInfo].userId,
                    @"Command":@27,
                    @"OrderId":order.orderId
                    };
        string = @"正在退款...";
    }
    [self playPostWithDictionary:jsonDic];
    [SVProgressHUD showWithStatus:string maskType:SVProgressHUDMaskTypeBlack];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.segment.selectedSegmentIndex == 2) {
        NewOrderModel * tangshiNeworder = [self.dataArray objectAtIndex:indexPath.row];
        return [TangshiCell cellHeightWithMealCount:(int)tangshiNeworder.mealArray.count];
    }else
    {
        if (self.segment.selectedSegmentIndex) {
            DealOrderModel * discarOD = [self.dataArray objectAtIndex:indexPath.row];
            if (discarOD.isSelete) {
                return [DiscarViewCell cellHeightWithMealCount:(int)discarOD.mealArray.count];
            }
            return [DiscarViewCell didDeliveryCellHeight];
        }
        NewOrderModel * newOrder = [self.dataArray objectAtIndex:indexPath.row];
        return [NewOrdersiewCell cellHeightWithMealCount:(int)newOrder.mealArray.count];
    }
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.segment.selectedSegmentIndex) {
        return YES;
    }
    return NO;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.segment.selectedSegmentIndex == 1) {
        
        DealOrderModel * discarOD = [self.dataArray objectAtIndex:indexPath.row];
        discarOD.isSelete = !discarOD.isSelete;
        [tableView reloadData];
    }else
    {
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.segment.selectedSegmentIndex == 1) {
        
        DealOrderModel * discard = [self.dataArray objectAtIndex:indexPath.row];
        if (discard.isSelete) {
            discard.isSelete = !discard.isSelete;
            [tableView reloadData];
        }
    }else
    {
    }
}

- (NSString *)getPrintStringWithNewOrder:(NewOrderModel *)order
{
    NSString * spaceString = @"                           ";
    NSString * lineStr = @"--------------------------------\r";
    NSMutableString * str = [NSMutableString string];
    [str appendFormat:@"%d号    %@\r", order.orderNum, [UserInfo shareUserInfo].StroeName];
    [str appendFormat:@"店铺:%@\r%@", [UserInfo shareUserInfo].userName, lineStr];
    [str appendFormat:@"下单时间:%@\r%@", order.orderTime, lineStr];
    [str appendFormat:@"订单号:%@\r", order.orderId];
    [str appendFormat:@"地址:%@\r", order.address];
    [str appendFormat:@"联系人:%@\r", order.contect];
    [str appendString:[self dataString]];
    [str appendFormat:@"电话:%@\r%@", order.tel, lineStr];
    [str appendString:[self normalString]];
    if (order.remark.length != 0) {
        [str appendFormat:@"备注:%@\r%@", order.remark, lineStr];
    }
    
    if (order.gift.length != 0) {
        [str appendFormat:@"奖品:%@\r%@", order.remark, lineStr];
    }
    
    for (Meal * meal in order.mealArray) {
        NSInteger length = 16 - meal.name.length;
        NSString * space = [spaceString substringWithRange:NSMakeRange(0, length)];
        [str appendFormat:@"%@%@%@份  %@元\r", meal.name, space, meal.count, meal.money];
    }
    [str appendString:lineStr];
    if ([order.delivery doubleValue] != 0) {
        [str appendFormat:@"配送费           +%@元\r", order.delivery];
    }
    if ([order.foodBox doubleValue] != 0) {
        [str appendFormat:@"餐盒费           +%@元\r", order.foodBox];
    }
    
    if ([order.firstReduce doubleValue] != 0) {
        [str appendFormat:@"首单立减           -%@元\r", order.firstReduce];
    }
    if ([order.fullReduce doubleValue] != 0) {
        [str appendFormat:@"满减优惠           -%@元\r", order.fullReduce];
    }
    if ([order.reduceCard doubleValue] != 0) {
        [str appendFormat:@"优惠券           %@元\r%@", order.reduceCard, lineStr];
    }
    
    if ([order.PayMath isEqualToNumber:@3]) {
        [str appendFormat:@"总计     %@元      餐到付款\r%@", order.allMoney, lineStr];
    }else
    {
        [str appendFormat:@"总计     %@元          已付款\r%@", order.allMoney, lineStr];
    }
    if ([order.PayMath intValue] == 3) {
        //        NSString * string = @"扫描下方二维码完成订单支付";
        NSLog(@"********%@", order.PayMath);
        [str appendFormat:@"扫描下方二维码完成订单支付"];
    }
    [str appendFormat:@"\n\n"];
    return [str copy];
}

- (NSString *)getPrintStringWithTangshiOrder:(NewOrderModel *)order
{
    NSString * spaceString = @"                           ";
    NSString * lineStr = @"--------------------------------\r";
    NSMutableString * str = [NSMutableString string];
    [str appendFormat:@"%d号    %@\r%@", order.orderNum, [UserInfo shareUserInfo].StroeName, lineStr];
    [str appendFormat:@"下单时间:%@\r%@", order.orderTime, lineStr];
    [str appendFormat:@"订单号:%@\r", order.orderId];
    [str appendFormat:@"用餐位置:%@\r", order.eatLocation];
    [str appendFormat:@"用餐人数:%d\r%@", order.customerCount, lineStr];
    if (order.remark.length != 0) {
        [str appendFormat:@"备注:%@\r%@", order.remark, lineStr];
    }
    
    if (order.gift.length != 0) {
        [str appendFormat:@"奖品:%@\r%@", order.remark, lineStr];
    }
    
    for (Meal * meal in order.mealArray) {
        NSInteger length = 16 - meal.name.length;
        NSString * space = [spaceString substringWithRange:NSMakeRange(0, length)];
        [str appendFormat:@"%@%@%@份  %@元\r", meal.name, space, meal.count, meal.money];
    }
    [str appendString:lineStr];
    if ([order.delivery doubleValue] != 0) {
        [str appendFormat:@"配送费           +%@元\r", order.delivery];
    }
    if ([order.foodBox doubleValue] != 0) {
        [str appendFormat:@"餐盒费           +%@元\r", order.foodBox];
    }
    
    if ([order.firstReduce doubleValue] != 0) {
        [str appendFormat:@"首单立减           -%@元\r", order.firstReduce];
    }
    if ([order.fullReduce doubleValue] != 0) {
        [str appendFormat:@"满减优惠           -%@元\r", order.fullReduce];
    }
    if ([order.reduceCard doubleValue] != 0) {
        [str appendFormat:@"优惠券           %@元\r%@", order.reduceCard, lineStr];
    }
    
    if (!order.pay) {
        [str appendFormat:@"总计     %@元      未付款\r%@", order.allMoney, lineStr];
    }else
    {
        [str appendFormat:@"总计     %@元          已付款\r%@", order.allMoney, lineStr];
    }
    if (!order.pay) {
        //        NSString * string = @"扫描下方二维码完成订单支付";
        NSLog(@"********%d", order.pay);
        [str appendFormat:@"扫描下方二维码完成订单支付"];
    }
    [str appendFormat:@"\n\n"];
    return [str copy];

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
