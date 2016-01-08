//
//  ProcessedViewController.m
//  TinyOrder
//
//  Created by 仙林 on 15/4/8.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "ProcessedViewController.h"
#import "ProcessedViewCell.h"
#import "DealOrderModel.h"
#import "NewOrderModel.h"
#import "PrintTypeViewController.h"
#import "GeneralBlueTooth.h"
#import "Meal.h"
#import "QRCode.h"
#import "TangshiCell.h"
#define CELL_IDENTIFIER @"cell"
#define TANGSHI_IDENTIFIER @"tangshicell"

#define SEGMENT_HEIGHT 40
#define SEGMENT_WIDTH 240
#define SEGMENT_X self.view.width / 2 - SEGMENT_WIDTH / 2
#define TOP_SPACE 10
#define HEARDERVIEW_HEIGHT TOP_SPACE * 2 + SEGMENT_HEIGHT
#define NUMLB_COLOR [UIColor colorWithRed:120 / 255.0 green:174 / 255.0 blue:38 / 255.0 alpha:1.0].CGColor
#define NUMLB_TEXT_COLOR [UIColor colorWithRed:120 / 255.0 green:174 / 255.0 blue:38 / 255.0 alpha:1.0]
#define DEALBUTTON_TAG 1000
#define PRINTBUTTON_TAG 3000
#define NULLIYBUTTON_TAG 2000
#define SELECTCOLOR [UIColor colorWithRed:255 / 255.0 green:212 / 255.0 blue:180 / 255.0 alpha:1]
#define WAITCOLOR [UIColor colorWithRed:250 / 255.0 green:65 / 255.0 blue:32 / 255.0 alpha:1]

@interface ProcessedViewController ()<HTTPPostDelegate, UIAlertViewDelegate>

@property (nonatomic, strong)UILabel * waitNumLB;
@property (nonatomic, strong)UILabel * didNumLB;
@property (nonatomic, strong)UISegmentedControl * segment;
@property (nonatomic, strong)UIView * segmentView;

@property (nonatomic, strong)NSIndexPath * seleteIndexPath;


@property (nonatomic, strong)NSMutableArray * dataArray;

@property (nonatomic, assign)int waitDeliveryPage;//代配送当前页
@property (nonatomic, strong)NSNumber * waitDeliveryAllCount;//代配送总个数
@property (nonatomic, strong)NSMutableArray * waitDeliveryArray;//代配送数组

@property (nonatomic, assign)int didDeliveryPage;//已配送当前页
@property (nonatomic, strong)NSNumber * didDeliveryAllCount;//已配送总个数
@property (nonatomic, strong)NSMutableArray * didDeliveryArray;//
// 堂食
@property (nonatomic, strong)NSMutableArray * tangshiArray;
@property (nonatomic, assign)int tangshiPag;
@property (nonatomic, strong)NSNumber * tangshiAllCount;

@property (nonatomic, strong)PrintTypeViewController * printTypeVC;
@property (nonatomic, assign)NSInteger printRow;

@end

@implementation ProcessedViewController


- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


- (NSMutableArray *)waitDeliveryArray
{
    if (!_waitDeliveryArray) {
        self.waitDeliveryArray = [NSMutableArray array];
    }
    return _waitDeliveryArray;
}


- (NSMutableArray *)didDeliveryArray
{
    if (!_didDeliveryArray) {
        self.didDeliveryArray = [NSMutableArray array];
    }
    return _didDeliveryArray;
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
    
    [self addHearderView];
    [self.tableView registerClass:[ProcessedViewCell class] forCellReuseIdentifier:CELL_IDENTIFIER];
    [self.tableView registerClass:[TangshiCell class] forCellReuseIdentifier:TANGSHI_IDENTIFIER];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    self.tableView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    _waitDeliveryPage = 1;
    _didDeliveryPage = 1;
    
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
//    [self.tableView headerBeginRefreshing];
    _didDeliveryPage = 1;
    _waitDeliveryPage = 1;
    _tangshiPag = 1;
    [self downloadDataWithCommand:@4 page:1 count:10];
    [SVProgressHUD showWithStatus:@"正在加载..." maskType:SVProgressHUDMaskTypeBlack];
    [self downloadDataWithCommand:@21 page:1 count:10];
    [self downloadDataWithCommand:@68 page:1 count:10];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    [self.tableView headerBeginRefreshing];
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"1px.png"] forBarMetrics:UIBarMetricsDefault];
    [self.tableView headerBeginRefreshing];
}
- (void)addHearderView
{
    
//    self.segment = [[UISegmentedControl alloc] initWithItems:@[@"", @""]];
//    _segment.tintColor = [UIColor clearColor];
//    [_segment setImage:[[UIImage imageNamed:@"delivery_press.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forSegmentAtIndex:0];
//    [_segment setImage:[[UIImage imageNamed:@"didDelivery_normal.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forSegmentAtIndex:1];
////    _segment.layer.cornerRadius = 11;
////    _segment.layer.masksToBounds = YES;
////    _segment.layer.borderWidth = 2;
//    _segment.layer.borderColor = SELECTCOLOR.CGColor;
//    _segment.frame = CGRectMake(SEGMENT_X, TOP_SPACE, SEGMENT_WIDTH, SEGMENT_HEIGHT);
//    _segment.selectedSegmentIndex = 0;
//    [_segment addTarget:self action:@selector(changeDeliveryState:) forControlEvents:UIControlEventValueChanged];
//    
//    UIView * hearderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, HEARDERVIEW_HEIGHT)];
//    hearderView.backgroundColor = [UIColor clearColor];
//    [hearderView addSubview:_segment];
//    self.waitNumLB = [[UILabel alloc] initWithFrame:CGRectMake(_segment.left + 87, 9 + TOP_SPACE, 22, 22)];
//    _waitNumLB.text = @"0";
//    _waitNumLB.font = [UIFont systemFontOfSize:12];
//    _waitNumLB.textAlignment = NSTextAlignmentCenter;
//    _waitNumLB.textColor = SELECTCOLOR;
//    _waitNumLB.layer.cornerRadius = 11;
//    _waitNumLB.layer.backgroundColor = WAITCOLOR.CGColor;
//    [hearderView addSubview:_waitNumLB];
//    self.didNumLB = [[UILabel alloc] initWithFrame:CGRectMake(self.view.width / 2 + 87, 9 + TOP_SPACE, 22, 22)];
//    _didNumLB.font = [UIFont systemFontOfSize:12];
//    _didNumLB.textAlignment = NSTextAlignmentCenter;
//    _didNumLB.text = @"0";
//    _didNumLB.layer.cornerRadius = 11;
//    _didNumLB.layer.backgroundColor = SELECTCOLOR.CGColor;
//    self.didNumLB.textColor = WAITCOLOR;
//    [hearderView addSubview:_didNumLB];
    
    self.segment = [[UISegmentedControl alloc] initWithItems:@[@"待配送", @"已配送", @"堂  食"]];
    
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
    
//    self.tableView.tableHeaderView = hearderView;
    [self.navigationItem setTitleView:hearderView];
    
    self.printTypeVC = [[PrintTypeViewController alloc]init];
    
}

- (void)changeDeliveryState:(UISegmentedControl *)segment
{
    if (self.segment.selectedSegmentIndex == 2) {
//        if (_tangshiArray == nil) {
//            _tangshiPag = 1;
//            [self downloadDataWithCommand:@68 page:1 count:10];
//        }
        [self.tableView headerBeginRefreshing];
        self.dataArray = self.tangshiArray;
//        self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld", (long)[self.tangshiAllCount integerValue]];
        [UIView animateWithDuration:0.35 animations:^{
            _segmentView.frame = CGRectMake(140, 50, 60, 2);
            
        }];
    }else if (segment.selectedSegmentIndex == 1) {
//        if (_didDeliveryArray == nil) {
//            _didDeliveryPage = 1;
//            [self downloadDataWithCommand:@21 page:1 count:10];
//            [SVProgressHUD showWithStatus:@"正在加载..." maskType:SVProgressHUDMaskTypeBlack];
//        }
//
        [self.tableView headerBeginRefreshing];
        self.dataArray = self.didDeliveryArray;
//        self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld", (long)[self.didDeliveryAllCount integerValue]];
        [UIView animateWithDuration:0.35 animations:^{
            _segmentView.frame = CGRectMake(80, 50, 60, 2);
            
        }];
    }else
    {
        [self.tableView headerBeginRefreshing];
        self.dataArray = self.waitDeliveryArray;
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

- (void)headerRereshing
{
    [self tableViewEndRereshing];
    [self rereshData];
//    self.navigationController.tabBarItem.badgeValue = nil;
//    if (self.segment.selectedSegmentIndex) {
//        _didDeliveryPage = 1;
//        self.didDeliveryArray = nil;
//        [self downloadDataWithCommand:@21 page:_waitDeliveryPage count:COUNT];
//    }else
//    {
//        _waitDeliveryPage = 1;
//        self.waitDeliveryArray = nil;
//        [self downloadDataWithCommand:@4 page:_waitDeliveryPage count:COUNT];
//    }
    
}

- (void)rereshData
{
    self.navigationController.tabBarItem.badgeValue = nil;
    if (self.segment.selectedSegmentIndex == 2) {
        _tangshiPag = 1;
        _tangshiArray = nil;
        [self downloadDataWithCommand:@68 page:_tangshiPag count:COUNT];
    }else if (self.segment.selectedSegmentIndex == 1) {
        _didDeliveryPage = 1;
        self.didDeliveryArray = nil;
        [self downloadDataWithCommand:@21 page:_didDeliveryPage count:COUNT];
    }else
    {
        _waitDeliveryPage = 1;
        self.waitDeliveryArray = nil;
        [self downloadDataWithCommand:@4 page:_waitDeliveryPage count:COUNT];
    }
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
        if (self.dataArray.count < [_didDeliveryAllCount integerValue]) {
            self.tableView.footerRefreshingText = @"正在加载数据";
            [self downloadDataWithCommand:@21 page:++_didDeliveryPage count:COUNT];
        }else
        {
            self.tableView.footerRefreshingText = @"数据已经加载完";
            [self.tableView performSelector:@selector(footerEndRefreshing) withObject:nil afterDelay:1];
        }
    }else
    {
        if (self.dataArray.count < [_waitDeliveryAllCount integerValue]) {
            self.tableView.footerRefreshingText = @"正在加载数据";
            [self downloadDataWithCommand:@4 page:++_waitDeliveryPage count:COUNT];
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
                                   @"TangshiType":@2,
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
    NSLog(@"%@", [data description]);
    //    NSDictionary * dataDic = (NSDictionary *)data;
    if ([[data objectForKey:@"Result"] isEqual:@1]) {
        [SVProgressHUD dismiss];
        NSArray * orderArray = [data objectForKey:@"OrderList"];
        NSInteger command = [[data objectForKey:@"Command"] integerValue];
        NSNumber * allCount = [data objectForKey:@"AllCount"];
        if (command == 10004) {
            [SVProgressHUD dismiss];
            for (NSDictionary * dic in orderArray) {
                DealOrderModel * dealOrder = [[DealOrderModel alloc] initWithDictionary:dic];
                [self.waitDeliveryArray addObject:dealOrder];
            }
            self.waitDeliveryAllCount = allCount;
            self.dataArray = self.waitDeliveryArray;
            self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld", (long)[self.waitDeliveryAllCount integerValue]];
//            self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld", [self.navigationController.tabBarItem.badgeValue integerValue] + [self.waitDeliveryAllCount integerValue]];
            self.waitNumLB.text = [NSString stringWithFormat:@"%@", allCount];
        }else if(command == 10021)
        {
            [SVProgressHUD dismiss];
            for (NSDictionary * dic in orderArray) {
                DealOrderModel * dealOrder = [[DealOrderModel alloc] initWithDictionary:dic];
                [self.didDeliveryArray addObject:dealOrder];
            }
            self.didDeliveryAllCount = allCount;
//            self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld", [self.navigationController.tabBarItem.badgeValue integerValue] + [self.didDeliveryAllCount integerValue]];
//            self.didNumLB.text = [NSString stringWithFormat:@"%@", allCount];
            self.dataArray = self.didDeliveryArray;
            self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld", (long)[self.didDeliveryAllCount integerValue]];
            
        }else if (command == 10016 || command == 10023)
        {
//            if (self.dataArray.count == 1) {
//                self.dataArray = nil;
//            }
            [self rereshData];
            UIAlertView * alertV = [[UIAlertView alloc] initWithTitle:@"提示" message:@"处理成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alertV show];
            [alertV performSelector:@selector(dismiss) withObject:nil afterDelay:1.5];
        }else if(command == 10015)
        {
            [SVProgressHUD dismiss];
            
            if ([PrintType sharePrintType].printType == 2) {
                
            }else
            {
                if (![[NSUserDefaults standardUserDefaults] objectForKey:@"printNum"]){
                    DealOrderModel * order = [self.dataArray objectAtIndex:self.printRow];
                    NSString * printStr = [self getPrintStringWithNewOrder:order];
                    [[GeneralBlueTooth shareGeneralBlueTooth] printWithString:printStr];
                }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"printNum"] integerValue] != 0){
                    DealOrderModel * order = [self.dataArray objectAtIndex:self.printRow];
                    NSString * printStr = [self getPrintStringWithNewOrder:order];
                    NSMutableArray * printAry = [NSMutableArray array];
                    int num = [[[NSUserDefaults standardUserDefaults] objectForKey:@"printNum"] intValue];
                    for (int j = 0; j < num; j++) {
                        [printAry addObject:printStr];
                        
                        //                        [[GeneralBlueTooth shareGeneralBlueTooth] printWithArray:printAry];
                        [[GeneralBlueTooth shareGeneralBlueTooth] printWithString:printStr];
                        
                        if ([order.payMath intValue] == 3) {
                            
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
        }else if (command == 10068)
        {
            self.tangshiAllCount = [data objectForKey:@"AllCount"];
            NSArray * array = [data objectForKey:@"OrderList"];
            for (NSDictionary * dic in array) {
                NewOrderModel * discarOrder = [[NewOrderModel alloc] initWithDictionary:dic];
                [self.tangshiArray addObject:discarOrder];
            }
            self.dataArray = self.tangshiArray;
            self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld", (long)[self.tangshiAllCount integerValue]];
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
            [self downloadDataWithCommand:@3 page:1 count:COUNT];
            UIAlertView * alertV = [[UIAlertView alloc] initWithTitle:@"提示" message:@"处理成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alertV show];
            [alertV performSelector:@selector(dismiss) withObject:nil afterDelay:1.5];
        }
        
        if (self.segment.selectedSegmentIndex == 2) {
            self.dataArray = self.tangshiArray;
        }else if (self.segment.selectedSegmentIndex == 1) {
            self.dataArray = self.didDeliveryArray;
        }else
        {
            self.dataArray = self.waitDeliveryArray;
        }
        self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld", (long)[allCount integerValue]];
        
        [self.tableView reloadData];
    }else
    {
        [SVProgressHUD dismiss];
        UIAlertView * alertV = [[UIAlertView alloc] initWithTitle:@"提示" message:[data objectForKey:@"ErrorMsg"] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alertV show];
        [alertV performSelector:@selector(dismiss) withObject:nil afterDelay:1.5];
    }
}

- (void)failWithError:(NSError *)error
{
    NSLog(@"%@", error);
    [SVProgressHUD dismiss];
    UIAlertView * alertV = [[UIAlertView alloc] initWithTitle:@"提示" message:@"连接服务器失败" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [alertV show];
    [alertV performSelector:@selector(dismiss) withObject:nil afterDelay:1.5];
    [self tableViewEndRereshing];
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
//        [tangshicell.totalPriceView.printButton addTarget:self action:@selector(printMeallist:) forControlEvents:UIControlEventTouchUpInside];
        tangshicell.totalPriceView.printButton.hidden = NO;
        tangshicell.totalPriceView.dealButton.hidden = NO;
        [tangshicell.totalPriceView.dealButton setTitle:@"打印" forState:UIControlStateNormal];
        [tangshicell.totalPriceView.dealButton addTarget:self action:@selector(printMeallist:) forControlEvents:UIControlEventTouchUpInside];
        tangshicell.totalPriceView.dealButton.tag = indexPath.row + PRINTBUTTON_TAG;
        return tangshicell;

    }else
    {
    DealOrderModel * dealOrder = [self.dataArray objectAtIndex:indexPath.row];
    ProcessedViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
    [cell createSubView:self.tableView.bounds mealCount:dealOrder.mealArray.count];
    [cell.totalPriceView.dealButton addTarget:self action:@selector(markMealSentOut:) forControlEvents:UIControlEventTouchUpInside];
    [cell.totalPriceView.printButton addTarget:self action:@selector(printMeallist:) forControlEvents:UIControlEventTouchUpInside];

    cell.totalPriceView.dealButton.tag = indexPath.row + DEALBUTTON_TAG;
    cell.totalPriceView.printButton.tag = indexPath.row + PRINTBUTTON_TAG;
    cell.dealOrder = dealOrder;
    
    if (self.segment.selectedSegmentIndex) {
        cell.totalPriceView.dealButton.frame = CGRectMake(cell.totalPriceView.dealButton.frame.origin.x, cell.totalPriceView.dealButton.frame.origin.y, 0, cell.totalPriceView.dealButton.frame.size.height);
        cell.totalPriceView.printButton.hidden = YES;
        cell.totalPriceView.totalLabel.frame = CGRectMake(self.view.width - 120 - 15, cell.totalPriceView.totalLabel.frame.origin.y, 40, 30);
        cell.totalPriceView.totalPriceLabel.frame = CGRectMake(cell.totalPriceView.totalLabel.right, cell.totalPriceView.totalPriceLabel.frame.origin.y, 80, 30);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (self.segment.selectedSegmentIndex) {

        if (self.seleteIndexPath != nil && self.seleteIndexPath.row == indexPath.row) {
            [cell disHiddenSubView:self.tableView.bounds mealCount:dealOrder.mealArray.count andHiddenImage:NO];
        }else
        {
            [cell hiddenSubView:self.tableView.bounds mealCount:dealOrder.mealArray.count];
        }
    }else
    {
        [cell disHiddenSubView:self.tableView.bounds mealCount:dealOrder.mealArray.count andHiddenImage:YES];
    }
    

    cell.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];

    return cell;
    }
}

#pragma mark - 打印`标记餐已送出 处理
- (void)printMeallist:(UIButton *)button
{
    NSLog(@"打印订单");
    
    
    
    self.printRow = button.tag - PRINTBUTTON_TAG;
    if (self.segment.selectedSegmentIndex == 2) {
        NewOrderModel * order = [self.dataArray objectAtIndex:button.tag - PRINTBUTTON_TAG];
        
        
        if ([PrintType sharePrintType].printType == 2 && [PrintType sharePrintType].gprsPrintNum != 0) {
            
            NSDictionary * jsonDic = @{
                                       @"UserId":[UserInfo shareUserInfo].userId,
                                       @"Command":@69,
                                       @"OrderId":order.orderId,
                                       @"PrintType":@3,
                                       @"DealPrint":@1
                                       };
            
            [self playPostWithDictionary:jsonDic];
            
        }else if ( [PrintType sharePrintType].printType == 1 && [[[NSUserDefaults standardUserDefaults] objectForKey:@"printNum"] integerValue] != 0)
        {
            if ([GeneralBlueTooth shareGeneralBlueTooth].myPeripheral.state) {
                NSDictionary * jsonDic = @{
                                           @"UserId":[UserInfo shareUserInfo].userId,
                                           @"Command":@69,
                                           @"OrderId":order.orderId,
                                           @"PrintType":@2,
                                           @"DealPrint":@1
                                           };
                [self playPostWithDictionary:jsonDic];
                [SVProgressHUD showWithStatus:@"正在请求处理..." maskType:SVProgressHUDMaskTypeBlack];
            }else
            {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"蓝牙打印机未连接" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alert show];
            }
            
        } else
        {
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"printNum"] integerValue] == 0 || [PrintType sharePrintType].gprsPrintNum == 0) {
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"打印份数不能为0" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }else
            {
                _printTypeVC.fromWitchController = 2;
                _printTypeVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:_printTypeVC animated:YES];
            }
        }
    }else
    {
        
        DealOrderModel * order = [self.dataArray objectAtIndex:button.tag - PRINTBUTTON_TAG];
        
        
        if ([PrintType sharePrintType].printType == 2 && [PrintType sharePrintType].gprsPrintNum != 0) {
            
            NSDictionary * jsonDic = @{
                                       @"UserId":[UserInfo shareUserInfo].userId,
                                       @"Command":@15,
                                       @"OrderId":order.orderId,
                                       @"PrintType":@3,
                                       @"DealPrint":@1
                                       };
            
            [self playPostWithDictionary:jsonDic];
            
        }else if ( [PrintType sharePrintType].printType == 1 && [[[NSUserDefaults standardUserDefaults] objectForKey:@"printNum"] integerValue] != 0)
        {
            if ([GeneralBlueTooth shareGeneralBlueTooth].myPeripheral.state) {
                NSDictionary * jsonDic = @{
                                           @"UserId":[UserInfo shareUserInfo].userId,
                                           @"Command":@15,
                                           @"OrderId":order.orderId,
                                           @"PrintType":@2,
                                           @"DealPrint":@1
                                           };
                [self playPostWithDictionary:jsonDic];
                [SVProgressHUD showWithStatus:@"正在请求处理..." maskType:SVProgressHUDMaskTypeBlack];
            }else
            {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"蓝牙打印机未连接" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alert show];
            }
            
        } else
        {
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"printNum"] integerValue] == 0 || [PrintType sharePrintType].gprsPrintNum == 0) {
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"打印份数不能为0" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }else
            {
                _printTypeVC.fromWitchController = 2;
                _printTypeVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:_printTypeVC animated:YES];
            }
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    _printTypeVC.fromWitchController = 2;
    _printTypeVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:_printTypeVC animated:YES];
}

- (void)markMealSentOut:(UIButton *)button
{
    DealOrderModel * order = [self.dataArray objectAtIndex:button.tag - DEALBUTTON_TAG];
    NSDictionary * jsonDic = @{
                               @"UserId":[UserInfo shareUserInfo].userId,
                               @"Command":@16,
                               @"OrderId":order.orderId
                               };
    [self playPostWithDictionary:jsonDic];
    [SVProgressHUD showWithStatus:@"正在标记成已处理..." maskType:SVProgressHUDMaskTypeBlack];
}

- (void)nulliyOrder:(UIButton *)button
{
    DealOrderModel * order = [self.dataArray objectAtIndex:button.tag - NULLIYBUTTON_TAG];
    NSDictionary * jsonDic = @{
                               @"UserId":[UserInfo shareUserInfo].userId,
                               @"Command":@23,
                               @"OrderId":order.orderId
                               };
    [self playPostWithDictionary:jsonDic];
    [SVProgressHUD showWithStatus:@"正在请求订单无效..." maskType:SVProgressHUDMaskTypeBlack];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.segment.selectedSegmentIndex) {
        if (self.seleteIndexPath != nil && self.seleteIndexPath.row == indexPath.row) {
            self.seleteIndexPath = nil;
        }else
        {
            self.seleteIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
        }
        [self.tableView reloadData];
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.segment.selectedSegmentIndex == 2) {
        NewOrderModel * tangshiNeworder = [self.dataArray objectAtIndex:indexPath.row];
        return [TangshiCell cellHeightWithMealCount:(int)tangshiNeworder.mealArray.count];
    }else
    {
        DealOrderModel * dealOrder = [self.dataArray objectAtIndex:indexPath.row];
        if (self.segment.selectedSegmentIndex) {
            if (indexPath.row == self.seleteIndexPath.row && self.seleteIndexPath != nil) {
                return [ProcessedViewCell cellHeightWithMealCount:dealOrder.mealArray.count];
            }
            return [ProcessedViewCell didDeliveryCellHeight];
        }
        return [ProcessedViewCell cellHeightWithMealCount:dealOrder.mealArray.count];
    }
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.segment.selectedSegmentIndex) {
        return YES;
    }
    return NO;
}

#pragma mark - 打印
- (NSString *)getPrintStringWithNewOrder:(DealOrderModel *)order
{
    NSString * spaceString = @"                           ";
    NSString * lineStr = @"--------------------------------\r";
    NSMutableString * str = [NSMutableString string];
    [str appendFormat:@"%@号    %@\r", order.orderNum, [UserInfo shareUserInfo].StroeName];
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
    
    if ([order.payMath isEqualToNumber:@3]) {
        [str appendFormat:@"总计     %@元      餐到付款\r%@", order.allMoney, lineStr];
    }else
    {
        [str appendFormat:@"总计     %@元          已付款\r%@", order.allMoney, lineStr];
    }
    if ([order.payMath intValue] == 3) {
        //        NSString * string = @"扫描下方二维码完成订单支付";
        NSLog(@"********%@", order.payMath);
        [str appendFormat:@"扫描下方二维码完成订单支付"];
    }
    [str appendFormat:@"\n\n"];
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
        NSLog(@"********%@", order.PayMath);
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
