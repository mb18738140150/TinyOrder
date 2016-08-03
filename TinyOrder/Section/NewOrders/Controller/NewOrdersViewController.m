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
#import "Refresh.h"
#import "NewOrderModel.h"
#import "Meal.h"
#import "DealOrderModel.h"
#import "DiscarViewCell.h"
#import "TangshiCell.h"
#import "AppDelegate.h"
#import "VerifyOrderViewController.h"
#import "OrderDetailsViewController.h"
//#import "RefundTableViewCell.h"
//#import "QRCodeGenerator.h"

#import "PrintTypeViewController.h"

#define CELL_IDENTIFIER @"cell"
#define DISCELL_IDENTIFIER @"discell"
#define TANGSHI_IDENTIFIER @"tangshicell"
#define REFUND_IDENTIFIRE @"refundcell"

#define DEALBUTTON_TAG 1000
#define NULLIYBUTTON_TAG 2000
#define DETAILSBUTTON_TAG 100000


#define SEGMENT_HEIGHT 40
#define SEGMENT_WIDTH 240
#define SEGMENT_X self.view.width / 2 - SEGMENT_WIDTH / 2
#define TOP_SPACE 10
#define HEARDERVIEW_HEIGHT TOP_SPACE * 2 + SEGMENT_HEIGHT

#define SELECTCOLOR [UIColor colorWithRed:255 / 255.0 green:212 / 255.0 blue:180 / 255.0 alpha:1]
#define WAITCOLOR [UIColor colorWithRed:250 / 255.0 green:65 / 255.0 blue:32 / 255.0 alpha:1]

@interface NewOrdersViewController ()<HTTPPostDelegate, UIAlertViewDelegate, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong)NSMutableArray * dataArray;
//新订单
@property (nonatomic, strong)UITableView * nTableview;
@property (nonatomic, strong)NSMutableArray * newsArray;
@property (nonatomic, assign)int newsPage;
@property (nonatomic, strong)NSNumber * newsAllCount;
//已作废
@property (nonatomic, strong)UITableView * discarTableview;
@property (nonatomic, strong)NSMutableArray * discardAry;
@property (nonatomic, assign)int discarPage;
@property (nonatomic, strong)NSNumber * discarAllCount;
//堂食
@property (nonatomic, strong)UITableView * tangshiTableview;
@property (nonatomic, strong)NSMutableArray * tangshiArray;
@property (nonatomic, assign)int tangshiPag;
@property (nonatomic, strong)NSNumber * tangshiAllCount;

// 退款
//@property (nonatomic, strong)UITableView * refundTableview;
//@property (nonatomic, strong)NSMutableArray * refundArray;
//@property (nonatomic, assign)int refundPag;
//@property (nonatomic, strong)NSNumber * refundCount;
//@property (nonatomic, strong)NSIndexPath * refundIndexPath;


@property (nonatomic, strong)UILabel * neNumLB;
@property (nonatomic, strong)UILabel * cancleNumLB;

@property (nonatomic, assign)NSInteger printRow;
@property (nonatomic, strong)UISegmentedControl * segment;
@property (nonatomic, strong)UIView * segmentView;

@property (nonatomic, strong)PrintTypeViewController *printTypeVC;

@property (nonatomic, strong)UIScrollView * aScrollView;

@property (nonatomic, assign)int aprint ;// 记录点击打印时，是否gprs与蓝牙同时打印
@property (nonatomic, strong) NSDate * date;

@property (nonatomic, strong)NewOrderModel * nOrderModel; //记录打印的订单

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

//- (NSMutableArray *)refundArray
//{
//    if (!_refundArray) {
//        self.refundArray = [NSMutableArray array];
//    }
//    return _refundArray;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.aprint = 0;
    self.date = [NSDate date];
    self.date = [NSDate dateWithTimeIntervalSinceNow:0];
    
    self.aScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64 - self.tabBarController.tabBar.height )];
    _aScrollView.delegate = self;
    _aScrollView.pagingEnabled = YES;
    _aScrollView.showsHorizontalScrollIndicator = NO;
    _aScrollView.bounces = NO;
    _aScrollView.contentSize = CGSizeMake(_aScrollView.width * 3, _aScrollView.height);
    [self.view addSubview:_aScrollView];
    
    // 新订单
    self.nTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, _aScrollView.width, _aScrollView.height)];
    self.nTableview.delegate = self;
    self.nTableview.dataSource = self;
    _newsPage = 1;
    [_nTableview addHeaderWithTarget:self action:@selector(headerRereshing)];
    [_nTableview addFooterWithTarget:self action:@selector(footerRereshing)];
    _nTableview.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    [self.nTableview registerClass:[NewOrdersiewCell class] forCellReuseIdentifier:CELL_IDENTIFIER];
    [_aScrollView addSubview:_nTableview];

    // 已作废
    self.discarTableview = [[UITableView alloc]initWithFrame:CGRectMake(_aScrollView.width, 0, _aScrollView.width, _aScrollView.height)];
    self.discarTableview.delegate = self;
    self.discarTableview.dataSource = self;
    _discarPage = 1;
    [_discarTableview addHeaderWithTarget:self action:@selector(headerRereshing)];
    [_discarTableview addFooterWithTarget:self action:@selector(footerRereshing)];
    _discarTableview.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    [self.discarTableview registerClass:[DiscarViewCell class] forCellReuseIdentifier:DISCELL_IDENTIFIER];
    [_aScrollView addSubview:_discarTableview];
    
    // 堂食
    self.tangshiTableview = [[UITableView alloc]initWithFrame:CGRectMake(_aScrollView.width * 2, 0, _aScrollView.width, _aScrollView.height)];
    self.tangshiTableview.delegate = self;
    self.tangshiTableview.dataSource = self;
    _tangshiPag = 1;
    [_tangshiTableview addHeaderWithTarget:self action:@selector(headerRereshing)];
    [_tangshiTableview addFooterWithTarget:self action:@selector(footerRereshing)];
    _tangshiTableview.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    [self.tangshiTableview registerClass:[TangshiCell class] forCellReuseIdentifier:TANGSHI_IDENTIFIER];
    [_aScrollView addSubview:_tangshiTableview];
    
    // 已退款
//    self.refundTableview = [[UITableView alloc]initWithFrame:CGRectMake(_aScrollView.width * 3, 0, _aScrollView.width, _aScrollView.height)];
//    self.refundTableview.delegate = self;
//    self.refundTableview.dataSource = self;
//    _refundPag = 1;
//    [_refundTableview addHeaderWithTarget:self action:@selector(headerRereshing)];
//    [_refundTableview addFooterWithTarget:self action:@selector(footerRereshing)];
//    _refundTableview.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
//    [self.refundTableview registerClass:[RefundTableViewCell class] forCellReuseIdentifier:REFUND_IDENTIFIRE];
//    [_aScrollView addSubview:_refundTableview];
    
//    self.navigationController.tabBarItem.badgeValue = @"123";
//    self.tableView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
//    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
//    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
//    [self.tableView registerClass:[NewOrdersiewCell class] forCellReuseIdentifier:CELL_IDENTIFIER];
//    [self.tableView registerClass:[DiscarViewCell class] forCellReuseIdentifier:DISCELL_IDENTIFIER];
//    [self.tableView registerClass:[TangshiCell class] forCellReuseIdentifier:TANGSHI_IDENTIFIER];
//    [self.tableView headerBeginRefreshing];
    
//    [self downloadDataWithCommand:@3 page:1 count:COUNT];
//    [SVProgressHUD showWithStatus:@"正在加载..." maskType:SVProgressHUDMaskTypeBlack];
//    [self downloadDataWithCommand:@80 page:1 count:COUNT];
//    [self downloadDataWithCommand:@68 page:1 count:COUNT];
//    [self downloadDataWithCommand:@80 page:1 count:10];
    
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

    
    self.segment = [[UISegmentedControl alloc] initWithItems:@[@"新订单", @"退款中", @"堂  食"]];
    
    self.segment.tintColor = [UIColor colorWithRed:250 / 255.0 green:250 / 255.0 blue:250 / 255.0 alpha:1];// 设置颜色
    self.segment.backgroundColor = [UIColor whiteColor];;
    //    self.segment.tintColor = [UIColor colorWithRed:222.0/255.0 green:7.0/255.0 blue:28.0/255.0 alpha:1.0];
    NSDictionary* selectedTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:16],
                                             NSForegroundColorAttributeName: [UIColor colorWithRed:253 / 255.0 green:91 / 255.0 blue:53 / 255.0 alpha:1]};
    [self.segment setTitleTextAttributes:selectedTextAttributes forState:UIControlStateSelected];//设置文字属性
    NSDictionary* unselectedTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:16],
                                               NSForegroundColorAttributeName: [UIColor grayColor]};
    [self.segment setTitleTextAttributes:unselectedTextAttributes forState:UIControlStateNormal];
    
    self.segment.selectedSegmentIndex = 0;
    self.segment.layer.cornerRadius = 5;
    
    _segment.frame = CGRectMake(5, 15, 180, 35);
    [_segment addTarget:self action:@selector(changeDeliveryState:) forControlEvents:UIControlEventValueChanged];
    
    self.segmentView = [[UIView alloc]initWithFrame:CGRectMake(20, 50, 60, 0)];
    self.segmentView.backgroundColor = [UIColor whiteColor];
    
    UIView * hearderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, HEARDERVIEW_HEIGHT)];
    hearderView.backgroundColor = [UIColor clearColor];
    [hearderView addSubview:_segment];
//    [hearderView addSubview:_segmentView];
    
    UINavigationBar * bar = self.navigationController.navigationBar;
    [bar setShadowImage:[UIImage imageNamed:@"1px.png"]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"1px.png"] forBarMetrics:UIBarMetricsDefault];

    
    self.navigationItem.titleView = hearderView;
}



- (void)viewWillAppear:(BOOL)animated
{
    
    if ([Refresh shareRefresh].nOrder == 1) {
        if (self.segment.selectedSegmentIndex == 0) {
            [self.nTableview headerBeginRefreshing];
        }else if (self.segment.selectedSegmentIndex == 1)
        {
            [self.discarTableview headerBeginRefreshing];
        }else if (self.segment.selectedSegmentIndex == 2)
        {
            [self.tangshiTableview headerBeginRefreshing];
        }
        [SVProgressHUD showWithStatus:@"正在加载..." maskType:SVProgressHUDMaskTypeBlack];
    }else
    {
        [Refresh shareRefresh].nOrder = 1;
    }
    
//    else if (self.segment.selectedSegmentIndex == 3)
//    {
//        [self.refundTableview headerBeginRefreshing];
//    }
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

#pragma mark - segment
- (void)changeDeliveryState:(UISegmentedControl *)segment
{
    if (self.segment.selectedSegmentIndex == 2) {
        [self.aScrollView setContentOffset:CGPointMake(self.segment.selectedSegmentIndex * _aScrollView.width, 0) animated:YES];
        [UIView animateWithDuration:0.35 animations:^{
            _segmentView.frame = CGRectMake(140, 50, 60, 2);
            
        }];
        [self.tangshiTableview performSelector:@selector(headerBeginRefreshing) withObject:nil afterDelay:0.35];
    }else if (segment.selectedSegmentIndex == 1) {
        [self.aScrollView setContentOffset:CGPointMake(self.segment.selectedSegmentIndex * _aScrollView.width, 0) animated:YES];
        [UIView animateWithDuration:0.35 animations:^{
            _segmentView.frame = CGRectMake(80, 50, 60, 2);
            
        }];
        [self.discarTableview performSelector:@selector(headerBeginRefreshing) withObject:nil afterDelay:0.35];
    }else if (segment.selectedSegmentIndex == 0)
    {
        [self.aScrollView setContentOffset:CGPointMake(self.segment.selectedSegmentIndex * _aScrollView.width, 0) animated:YES];
        [UIView animateWithDuration:0.35 animations:^{
            _segmentView.frame = CGRectMake(20, 50, 60, 2);
            
        }];
        [self.nTableview performSelector:@selector(headerBeginRefreshing) withObject:nil afterDelay:0.35];
    }
    //    else if (segment.selectedSegmentIndex == 3)
    //    {
    //        [self.aScrollView setContentOffset:CGPointMake(self.segment.selectedSegmentIndex * _aScrollView.width, 0) animated:YES];
    //        [UIView animateWithDuration:0.35 animations:^{
    //            _segmentView.frame = CGRectMake(200, 50, 60, 2);
    //
    //        }];
    //        [self.refundTableview performSelector:@selector(headerBeginRefreshing) withObject:nil afterDelay:0.35];
    //    }
}
#pragma mark - 刷新
- (void)tableViewEndRereshing
{
    if (self.segment.selectedSegmentIndex == 0) {
        
        if (self.nTableview.isHeaderRefreshing) {
            [self.nTableview headerEndRefreshing];
        }
        if (self.nTableview.isFooterRefreshing) {
            [self.nTableview footerEndRefreshing];
        }
    }else if (self.segment.selectedSegmentIndex == 1)
    {
        if (self.discarTableview.isHeaderRefreshing) {
            [self.discarTableview headerEndRefreshing];
        }
        if (self.discarTableview.isFooterRefreshing) {
            [self.discarTableview footerEndRefreshing];
        }
    }else if (self.segment.selectedSegmentIndex == 2)
    {
        if (self.tangshiTableview.isHeaderRefreshing) {
            [self.tangshiTableview headerEndRefreshing];
        }
        if (self.tangshiTableview.isFooterRefreshing) {
            [self.tangshiTableview footerEndRefreshing];
        }
    }
    //    else if (self.segment.selectedSegmentIndex == 3)
    //    {
    //        if (self.refundTableview.isHeaderRefreshing) {
    //            [self.refundTableview headerEndRefreshing];
    //        }
    //        if (self.refundTableview.isFooterRefreshing) {
    //            [self.refundTableview footerEndRefreshing];
    //        }
    //    }
}
- (void)headerRereshing
{
    [self tableViewEndRereshing];
     if (self.segment.selectedSegmentIndex == 2) {
        _tangshiPag = 1;
         [self.aScrollView setContentOffset:CGPointMake(self.segment.selectedSegmentIndex * _aScrollView.width, 0) animated:YES];
        [self downloadDataWithCommand:@68 page:_tangshiPag count:COUNT];
    }else if (self.segment.selectedSegmentIndex == 1) {
        _discarPage = 1;
        [self.aScrollView setContentOffset:CGPointMake(self.segment.selectedSegmentIndex * _aScrollView.width, 0) animated:YES];
        [self downloadDataWithCommand:@80 page:_discarPage count:COUNT];
    }else
    {
        _newsPage = 1;
        [self.aScrollView setContentOffset:CGPointMake(self.segment.selectedSegmentIndex * _aScrollView.width, 0) animated:YES];
        [self downloadDataWithCommand:@3 page:_newsPage count:COUNT];
    }

}


- (void)footerRereshing
{
    [self tableViewEndRereshing];
    if (self.segment.selectedSegmentIndex == 2) {
        [self.aScrollView setContentOffset:CGPointMake(self.segment.selectedSegmentIndex * _aScrollView.width, 0) animated:YES];
        if (self.tangshiArray.count < [_tangshiAllCount integerValue]) {
            self.tangshiTableview.footerRefreshingText = @"正在加载数据";
            [self downloadDataWithCommand:@68 page:++_tangshiPag count:COUNT];
        }else
        {
            self.tangshiTableview.footerRefreshingText = @"数据已经加载完";
            [self.tangshiTableview performSelector:@selector(footerEndRefreshing) withObject:nil afterDelay:1];
        }
    }else if (self.segment.selectedSegmentIndex == 1) {
        [self.aScrollView setContentOffset:CGPointMake(self.segment.selectedSegmentIndex * _aScrollView.width, 0) animated:YES];
        if (self.discardAry.count < [_discarAllCount integerValue]) {
            self.discarTableview.footerRefreshingText = @"正在加载数据";
            [self downloadDataWithCommand:@80 page:++_discarPage count:COUNT];
        }else
        {
            self.discarTableview.footerRefreshingText = @"数据已经加载完";
            [self.discarTableview performSelector:@selector(footerEndRefreshing) withObject:nil afterDelay:1];
        }
    }else
    {
        [self.aScrollView setContentOffset:CGPointMake(self.segment.selectedSegmentIndex * _aScrollView.width, 0) animated:YES];
        if (self.newsArray.count < [_newsAllCount integerValue]) {
            self.nTableview.footerRefreshingText = @"正在加载数据";
            [self downloadDataWithCommand:@3 page:++_newsPage count:COUNT];
        }else
        {
            self.nTableview.footerRefreshingText = @"数据已经加载完";
            [self.nTableview performSelector:@selector(footerEndRefreshing) withObject:nil afterDelay:1];
        }
    }
}

#pragma mark - 数据请求
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
                [self.newsArray removeAllObjects];
            }
            NSArray * array = [data objectForKey:@"OrderList"];
            for (NSDictionary * dic in array) {
                NewOrderModel * newOrder = [[NewOrderModel alloc] initWithDictionary:dic];
                [self.newsArray addObject:newOrder];
            }
            [self.nTableview reloadData];
            self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld", (long)[self.newsAllCount integerValue]];
            
            [SVProgressHUD dismiss];
        }else if(command == 10080)
        {
            self.discarAllCount = [data objectForKey:@"AllCount"];
            self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld", (long)[self.discarAllCount integerValue]];
            self.cancleNumLB.text = [NSString stringWithFormat:@"%@", [data objectForKey:@"AllCount"]];
            if (_discarPage == 1) {
                [self.discardAry removeAllObjects];
            }
            NSArray * array = [data objectForKey:@"OrderList"];
            for (NSDictionary * dic in array) {
                DealOrderModel * discarOrder = [[DealOrderModel alloc] initWithDictionary:dic];
                [self.discardAry addObject:discarOrder];
            }
            [self.discarTableview reloadData];
            self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld", (long)[self.discarAllCount integerValue]];
            
            [SVProgressHUD dismiss];
        }else if(command == 10015)
        {
            
            if ([PrintType sharePrintType].isGPRSenable) {

            }
            if ([PrintType sharePrintType].isBlutooth)
            {
                // 蓝牙未连接，不作处理
                if (![GeneralBlueTooth shareGeneralBlueTooth].myPeripheral.state){
                }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"printNum"] integerValue] == 0)
                {
                    // 打印份数为0，不作处理
                }
                else if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"printNum"] integerValue] != 0){
                    
                    
                    NewOrderModel * order = [self.newsArray objectAtIndex:self.printRow];
                    NSString * printStr = [self getPrintStringWithNewOrder:order];
                    NSMutableArray * printAry = [NSMutableArray array];
                    int num = [[[NSUserDefaults standardUserDefaults] objectForKey:@"printNum"] intValue];
                    for (int j = 0; j < num; j++) {
                        [printAry addObject:printStr];
                        
                        [[GeneralBlueTooth shareGeneralBlueTooth] printWithString:printStr];
                        
                        if ([UserInfo shareUserInfo].isShowPayCode.intValue == 3) {
                            [[GeneralBlueTooth shareGeneralBlueTooth] printPng:[UserInfo shareUserInfo].customPayCodeContent];
                        }else if ([UserInfo shareUserInfo].isShowPayCode.intValue == 1){
                            // 显示付款二维码
                            if ([order.PayMath intValue] == 3) {
                                
                                NSString * str = [NSString stringWithFormat:@"http://wap.vlifee.com/eat/ScanCodeChangeMoney.aspx?ordersn=%@&busiid=%@&from=app", order.orderId, [UserInfo shareUserInfo].userId];
                                [[GeneralBlueTooth shareGeneralBlueTooth] printPng:str];
                            }
                        }
                    }
                }
            }
            _newsPage = 1;
            [self downloadDataWithCommand:@3 page:_newsPage count:COUNT];
            UIAlertView * alertV = [[UIAlertView alloc] initWithTitle:@"提示" message:@"处理成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alertV show];
            [alertV performSelector:@selector(dismiss) withObject:nil afterDelay:1.5];
        }else if (command == 10023 || command == 10026 )
        {
            _newsPage = 1;
            [self downloadDataWithCommand:@3 page:_newsPage count:COUNT];
            UIAlertView * alertV = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请求成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alertV show];
            [alertV performSelector:@selector(dismiss) withObject:nil afterDelay:1.5];
        }else if (command == 10027){
            _discarPage = 1;
            UIAlertView * alertV = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请求成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alertV show];
            [alertV performSelector:@selector(dismiss) withObject:nil afterDelay:1.5];
            [self downloadDataWithCommand:@80 page:_discarPage count:COUNT];
        }
        else if (command == 10068)
        {
            self.tangshiAllCount = [data objectForKey:@"AllCount"];
            self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld", (long)[self.tangshiAllCount integerValue]];
            if (_tangshiPag == 1) {
                [self.tangshiArray removeAllObjects];
            }
            NSArray * array = [data objectForKey:@"OrderList"];
            for (NSDictionary * dic in array) {
                NewOrderModel * discarOrder = [[NewOrderModel alloc] initWithDictionary:dic];
                [self.tangshiArray addObject:discarOrder];
            }
            [self.tangshiTableview reloadData];
            self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld", (long)[self.tangshiAllCount integerValue]];
            [SVProgressHUD dismiss];
        }else if (command == 10069)
        {
            if ([PrintType sharePrintType].isGPRSenable) {
                
            }
            if ([PrintType sharePrintType].isBlutooth)
            {
                if (![GeneralBlueTooth shareGeneralBlueTooth].myPeripheral.state) {
                    ;
                }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"printNum"] integerValue] == 0){
                }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"printNum"] integerValue] != 0){
                    
                    NewOrderModel * order = [self.tangshiArray objectAtIndex:self.printRow];
                    NSString * printStr = [self getPrintStringWithTangshiOrder:order];
                    NSMutableArray * printAry = [NSMutableArray array];
                    int num = [[[NSUserDefaults standardUserDefaults] objectForKey:@"printNum"] intValue];
                    for (int j = 0; j < num; j++) {
                        [printAry addObject:printStr];
                        
                        [[GeneralBlueTooth shareGeneralBlueTooth] printWithString:printStr];
                        
                        if ([UserInfo shareUserInfo].isShowPayCode.intValue == 3) {
                            [[GeneralBlueTooth shareGeneralBlueTooth] printPng:[UserInfo shareUserInfo].customPayCodeContent];
                        }else if ([UserInfo shareUserInfo].isShowPayCode.intValue == 1){
                            // 显示付款二维码
                            if (order.pays == 0) {
                                
                                NSString * str = [NSString stringWithFormat:@"http://wap.vlifee.com/eat/ScanCodeChangeMoney.aspx?ordersn=%@&busiid=%@&from=app", order.orderId, [UserInfo shareUserInfo].userId];
                                [[GeneralBlueTooth shareGeneralBlueTooth] printPng:str];
                            }
                        }
                    }
                }
            }
            _tangshiPag = 1;
            [self downloadDataWithCommand:@68 page:_tangshiPag count:COUNT];
            UIAlertView * alertV = [[UIAlertView alloc] initWithTitle:@"提示" message:@"处理成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alertV show];
            [alertV performSelector:@selector(dismiss) withObject:nil afterDelay:1.5];
        }else if(command == 10075)
        {
            NSDictionary * dic = [data objectForKey:@"OrderObject"];
            NewOrderModel * model = [[NewOrderModel alloc]initWithDictionary:dic];
            NSLog(@"******%@", model.name);
        }
    }else
    {
        [SVProgressHUD dismiss];
        int command = [[data objectForKey:@"Command"] intValue];
        if (command == 10015 || command == 10069) {
            
            if ([[data objectForKey:@"ErrorMsg"] isEqualToString:@"您没有可用的GPRS打印机"] && [PrintType sharePrintType].isBlutooth) {
                if (command == 10069) {
                    NSDictionary * jsonDic = @{
                                               @"UserId":[UserInfo shareUserInfo].userId,
                                               @"Command":@69,
                                               @"OrderId":self.nOrderModel.orderId,
                                               @"PrintType":@2,
                                               @"DealPrint":@0
                                               };
                    
                    [self playPostWithDictionary:jsonDic];
                }else
                {
                    NSDictionary * jsonDic = @{
                                               @"UserId":[UserInfo shareUserInfo].userId,
                                               @"Command":@15,
                                               @"OrderId":self.nOrderModel.orderId,
                                               @"PrintType":@2
                                               };
                    
                    [self playPostWithDictionary:jsonDic];
                }
            }
            
//            NSDate * nowDate = [NSDate date];
//            nowDate = [NSDate dateWithTimeIntervalSinceNow:0];
//            
//            NSTimeInterval time = [nowDate timeIntervalSinceDate:self.date];
//            
//            if (time < 1) {
////                NSLog(@"时间间隔太短");
//            }else
//            {
//                if ([data objectForKey:@"ErrorMsg"]) {
//                    UIAlertView * alertV = [[UIAlertView alloc] initWithTitle:@"提示" message:[data objectForKey:@"ErrorMsg"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//                    [alertV show];
//                }
//            }
//            self.date = nowDate;
        }else
        {
            
            if ([data objectForKey:@"ErrorMsg"]) {
                UIAlertView * alertV = [[UIAlertView alloc] initWithTitle:@"提示" message:[data objectForKey:@"ErrorMsg"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alertV show];
            }
        }
        
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
    
    if ([[error.userInfo objectForKey:@"Reason"] isEqualToString:@"服务器处理失败"]) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"服务器处理失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil ];
        [alert show];
    }else
    {
        
        UIAlertView * alerV = [[UIAlertView alloc] initWithTitle:@"提示" message:@"连接服务器失败请重新连接" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alerV show];
    }
    
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
    if ([tableView isEqual:_nTableview]) {
        return self.newsArray.count;
    }else if ([tableView isEqual:_discarTableview])
    {
        return self.discardAry.count;
    }else
    {
        return self.tangshiArray.count ;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([tableView isEqual:_tangshiTableview]) {
        NewOrderModel * tangshiModel = [self.tangshiArray objectAtIndex:indexPath.row];
        TangshiCell * tangshicell = [tableView dequeueReusableCellWithIdentifier:TANGSHI_IDENTIFIER forIndexPath:indexPath];
        [tangshicell createSubView:tableView.bounds mealCoutn:tangshiModel];
        tangshicell.orderModel = tangshiModel;
        tangshicell.totalPriceView.printButton.hidden = YES;
        [tangshicell.totalPriceView.dealButton addTarget:self action:@selector(dealAndPrint:) forControlEvents:UIControlEventTouchUpInside];
        tangshicell.totalPriceView.dealButton.tag = indexPath.row + DEALBUTTON_TAG;
        tangshicell.totalPriceView.detailsButton.tag = DETAILSBUTTON_TAG + indexPath.row ;
        [tangshicell.totalPriceView.detailsButton addTarget:self action:@selector(orderDetailsAction:) forControlEvents:UIControlEventTouchUpInside];
        tangshicell.selectionStyle = UITableViewCellSelectionStyleNone;
        return tangshicell;
    }else if ([tableView isEqual:_discarTableview]) {
        DealOrderModel * discarOD = [self.discardAry objectAtIndex:indexPath.row];
        DiscarViewCell * disCell = [tableView dequeueReusableCellWithIdentifier:DISCELL_IDENTIFIER forIndexPath:indexPath];
        [disCell createSubView:tableView.bounds mealCount:discarOD.mealArray.count];
        disCell.dealOrder = discarOD;
        disCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
//        if (discarOD.isSelete) {
//            [disCell disHiddenSubView:self.discarTableview.bounds mealCount:discarOD.mealArray.count andHiddenImage:NO];
//        }else
//        {
//            [disCell hiddenSubView:self.discarTableview.bounds mealCount:discarOD.mealArray.count];
//        }
        
        disCell.totalPriceView.dealButton.tag = indexPath.row + DEALBUTTON_TAG;
        disCell.totalPriceView.printButton.tag = indexPath.row + NULLIYBUTTON_TAG;
//        if (disCell.dealOrder.dealState.intValue == 5 )  {
            [disCell.totalPriceView.dealButton addTarget:self action:@selector(agreeRefundAction:) forControlEvents:UIControlEventTouchUpInside];
            [disCell.totalPriceView.printButton addTarget:self action:@selector(refuseRefungAction:) forControlEvents:UIControlEventTouchUpInside];
        disCell.totalPriceView.detailsButton.tag = DETAILSBUTTON_TAG+ indexPath.row;
        [disCell.totalPriceView.detailsButton addTarget:self action:@selector(orderDetailsAction:) forControlEvents:UIControlEventTouchUpInside];
        
//        }else
//        {
//            
//            disCell.totalPriceView.dealButton.frame = CGRectMake(disCell.totalPriceView.dealButton.frame.origin.x, disCell.totalPriceView.dealButton.frame.origin.y, 0, disCell.totalPriceView.dealButton.frame.size.height);
//            disCell.totalPriceView.printButton.hidden = YES;
//            disCell.totalPriceView.totalLabel.frame = CGRectMake(self.view.width - 120 - 15, disCell.totalPriceView.totalLabel.frame.origin.y, 40, 30);
//            disCell.totalPriceView.totalPriceLabel.frame = CGRectMake(disCell.totalPriceView.totalLabel.right, disCell.totalPriceView.totalPriceLabel.frame.origin.y, 80, 30);
//        }
        
        return disCell;
    }else
    {
        
        NewOrderModel * newOrder = [self.newsArray objectAtIndex:indexPath.row];
        
        NewOrdersiewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
        
        [cell createSubView:self.nTableview.bounds mealCoutn:newOrder.mealArray.count];
        [cell.totalView.dealButton addTarget:self action:@selector(dealAndPrint:) forControlEvents:UIControlEventTouchUpInside];
        [cell.totalView.nulliyButton addTarget:self action:@selector(nulliyOrder:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.totalView.detailsButton.tag = DETAILSBUTTON_TAG+ indexPath.row;
        [cell.totalView.detailsButton addTarget:self action:@selector(orderDetailsAction:) forControlEvents:UIControlEventTouchUpInside];
//        [cell.orderView.isOrNOBT addTarget:self action:@selector(Order:) forControlEvents:UIControlEventTouchUpInside];
        cell.totalView.dealButton.tag = indexPath.row + DEALBUTTON_TAG;
        cell.totalView.nulliyButton.tag = indexPath.row + NULLIYBUTTON_TAG;
//        cell.orderView.isOrNOBT.tag = indexPath.row + NULLIYBUTTON_TAG;
        cell.orderModel = newOrder;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
}

#pragma mark - 退款
- (void)refuseRefungAction:(UIButton *)button
{
    DealOrderModel * model = [self.discardAry objectAtIndex:button.tag - NULLIYBUTTON_TAG ];
    
    NSLog(@"拒绝退款，订单号%@", model.orderId);
    
    NSDictionary * jsonDic = nil;
    NSString * string = nil;
        jsonDic = @{
                    @"UserId":[UserInfo shareUserInfo].userId,
                    @"Command":@27,
                    @"OrderId":model.orderId,
                    @"Type":@1
                    };
        string = @"正在处理...";
    [self playPostWithDictionary:jsonDic];
    [SVProgressHUD showWithStatus:string maskType:SVProgressHUDMaskTypeBlack];
    
}

- (void)agreeRefundAction:(UIButton *)button
{
    DealOrderModel * model = [self.discardAry objectAtIndex:button.tag - DEALBUTTON_TAG ];
    
    NSLog(@"同意退款，订单号%@", model.orderId);
    NSDictionary * jsonDic = nil;
    NSString * string = nil;
    jsonDic = @{
                @"UserId":[UserInfo shareUserInfo].userId,
                @"Command":@27,
                @"OrderId":model.orderId,
                @"Type":@0
                };
    string = @"正在退款...";
    [self playPostWithDictionary:jsonDic];
    [SVProgressHUD showWithStatus:string maskType:SVProgressHUDMaskTypeBlack];
}

#pragma mark - 处理订单
- (void)dealAndPrint:(UIButton *)button
{
    if ([button.titleLabel.text isEqualToString:@"去验证"]) {
        VerifyOrderViewController * verifyVC = [[VerifyOrderViewController alloc]init];
        verifyVC.hidesBottomBarWhenPushed = YES;
        verifyVC.isfrome = 1;
        [self.navigationController pushViewController:verifyVC animated:YES];
    }else
    {
        
        if (self.segment.selectedSegmentIndex == 0) {
            ;
            self.printRow = button.tag - DEALBUTTON_TAG;
            NewOrderModel * order = [self.newsArray objectAtIndex:button.tag - DEALBUTTON_TAG];
            self.nOrderModel = order;
            
            if ([PrintType sharePrintType].isGPRSenable && [PrintType sharePrintType].isBlutooth) {
                NSDictionary * jsonDic = @{
                                           @"UserId":[UserInfo shareUserInfo].userId,
                                           @"Command":@15,
                                           @"OrderId":order.orderId,
                                           @"PrintType":@3
                                           };
                
                [self playPostWithDictionary:jsonDic];
            }else if ([PrintType sharePrintType].isGPRSenable) {
                
                NSNumber *num = nil;
                NSDictionary * jsonDic = @{
                                           @"UserId":[UserInfo shareUserInfo].userId,
                                           @"Command":@15,
                                           @"OrderId":order.orderId,
                                           @"PrintType":@3
                                           };
                
                [self playPostWithDictionary:jsonDic];
                
                
            }else if ( [PrintType sharePrintType].isBlutooth)
            {
                self.aprint = 1;
                //            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"printNum"] integerValue] == 0) {
                //                    NSDictionary * jsonDic = @{
                //                                               @"UserId":[UserInfo shareUserInfo].userId,
                //                                               @"Command":@15,
                //                                               @"OrderId":order.orderId,
                //                                               @"PrintType":@2
                //                                               };
                //
                //                    [self playPostWithDictionary:jsonDic];
                //
                //
                //            }else if ([GeneralBlueTooth shareGeneralBlueTooth].myPeripheral.state) {
                //                    NSDictionary * jsonDic = @{
                //                                               @"UserId":[UserInfo shareUserInfo].userId,
                //                                               @"Command":@15,
                //                                               @"OrderId":order.orderId,
                //                                               @"PrintType":@2
                //                                               };
                //
                //                    [self playPostWithDictionary:jsonDic];
                //
                //                [SVProgressHUD showWithStatus:@"正在请求处理..." maskType:SVProgressHUDMaskTypeBlack];
                //            }else
                //            {
                //                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"蓝牙打印机未连接" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                //                [alert show];
                //            }
                NSDictionary * jsonDic = @{
                                           @"UserId":[UserInfo shareUserInfo].userId,
                                           @"Command":@15,
                                           @"OrderId":order.orderId,
                                           @"PrintType":@2
                                           };
                
                [self playPostWithDictionary:jsonDic];
                
            }
            if (![PrintType sharePrintType].isGPRSenable && ![PrintType sharePrintType].isBlutooth)
            {
                //            _printTypeVC.nOrderModel = order;
                //            _printTypeVC.fromWitchController = 2;
                //            _printTypeVC.hidesBottomBarWhenPushed = YES;
                //            [self.navigationController pushViewController:_printTypeVC animated:YES];
                NSDictionary * jsonDic = @{
                                           @"UserId":[UserInfo shareUserInfo].userId,
                                           @"Command":@15,
                                           @"OrderId":order.orderId,
                                           @"PrintType":@1
                                           };
                
                [self playPostWithDictionary:jsonDic];
                
                [SVProgressHUD showWithStatus:@"正在请求处理..." maskType:SVProgressHUDMaskTypeBlack];
                
            }
            
            NSLog(@"订单号%d", order.orderNum);
        }else if (self.segment.selectedSegmentIndex == 2)
        {
            ;
            self.printRow = button.tag - DEALBUTTON_TAG;
            NewOrderModel * order = [self.tangshiArray objectAtIndex:button.tag - DEALBUTTON_TAG];
            self.nOrderModel = order;
            
            if ([PrintType sharePrintType].isGPRSenable && [PrintType sharePrintType].isBlutooth) {
                NSDictionary * jsonDic = @{
                                           @"UserId":[UserInfo shareUserInfo].userId,
                                           @"Command":@69,
                                           @"OrderId":order.orderId,
                                           @"PrintType":@3,
                                           @"DealPrint":@0
                                           };
                
                [self playPostWithDictionary:jsonDic];
            }else if ([PrintType sharePrintType].isGPRSenable) {
                
                NSNumber *num = nil;
                
                NSDictionary * jsonDic = @{
                                           @"UserId":[UserInfo shareUserInfo].userId,
                                           @"Command":@69,
                                           @"OrderId":order.orderId,
                                           @"PrintType":@3,
                                           @"DealPrint":@0
                                           };
                
                [self playPostWithDictionary:jsonDic];
                
            }else if ( [PrintType sharePrintType].isBlutooth)
            {
                self.aprint = 1;
                //            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"printNum"] integerValue] == 0) {
                //
                //                    NSDictionary * jsonDic = @{
                //                                               @"UserId":[UserInfo shareUserInfo].userId,
                //                                               @"Command":@69,
                //                                               @"OrderId":order.orderId,
                //                                               @"PrintType":@2
                //                                               };
                //
                //                    [self playPostWithDictionary:jsonDic];
                //
                //            }else if ([GeneralBlueTooth shareGeneralBlueTooth].myPeripheral.state) {
                //
                //                    NSDictionary * jsonDic = @{
                //                                               @"UserId":[UserInfo shareUserInfo].userId,
                //                                               @"Command":@69,
                //                                               @"OrderId":order.orderId,
                //                                               @"PrintType":@2
                //                                               };
                //
                //                    [self playPostWithDictionary:jsonDic];
                //                [SVProgressHUD showWithStatus:@"正在请求处理..." maskType:SVProgressHUDMaskTypeBlack];
                //            }else
                //            {
                //                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"蓝牙打印机未连接" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                //                [alert show];
                //            }
                NSDictionary * jsonDic = @{
                                           @"UserId":[UserInfo shareUserInfo].userId,
                                           @"Command":@69,
                                           @"OrderId":order.orderId,
                                           @"PrintType":@2,
                                           @"DealPrint":@0
                                           };
                
                [self playPostWithDictionary:jsonDic];
                
            }
            if (![PrintType sharePrintType].isGPRSenable && ![PrintType sharePrintType].isBlutooth)
            {
                //            _printTypeVC.nOrderModel = order;
                //            _printTypeVC.fromWitchController = 2;
                //            _printTypeVC.hidesBottomBarWhenPushed = YES;
                //            [self.navigationController pushViewController:_printTypeVC animated:YES];
                
                NSDictionary * jsonDic = @{
                                           @"UserId":[UserInfo shareUserInfo].userId,
                                           @"Command":@69,
                                           @"OrderId":order.orderId,
                                           @"PrintType":@1,
                                           @"DealPrint":@0
                                           };
                
                [self playPostWithDictionary:jsonDic];
                [SVProgressHUD showWithStatus:@"正在请求处理..." maskType:SVProgressHUDMaskTypeBlack];
            }
            
            NSLog(@"订单号%d", order.orderNum);
        }
    }
    
    
}


- (void)nulliyOrder:(UIButton *)button
{
//     NewOrderModel * order = [self.newsArray objectAtIndex:button.tag - NULLIYBUTTON_TAG];
//    NSDictionary * jsonDic = @{
//                               @"UserId":[UserInfo shareUserInfo].userId,
//                               @"Command":@75,
//                               @"OrderId":order.orderId
//                               };
//    [self playPostWithDictionary:jsonDic];
    NSDictionary * jsonDic = nil;
    NSString * string = nil;
    NewOrderModel * order = [self.newsArray objectAtIndex:button.tag - NULLIYBUTTON_TAG];
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

#pragma mark - tableview delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:_tangshiTableview]) {
        NewOrderModel * tangshiNeworder = [self.tangshiArray objectAtIndex:indexPath.row];
        return [TangshiCell cellHeightWithMealCount:(NewOrderModel *)tangshiNeworder];
    }else
    {
        if ([tableView isEqual:_discarTableview]) {
            DealOrderModel * discarOD = [self.discardAry objectAtIndex:indexPath.row];
//            if (discarOD.isSelete) {
                return [DiscarViewCell cellHeightWithMealCount:(int)discarOD.mealArray.count];
//            }
//            return [DiscarViewCell didDeliveryCellHeight];
        }
        NewOrderModel * newOrder = [self.newsArray objectAtIndex:indexPath.row];
        return [NewOrdersiewCell cellHeightWithMealCount:(int)newOrder.mealArray.count];
    }
}

//- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//    if ([tableView isEqual:_discarTableview]) {
//        return YES;
//    }
//    return NO;
//}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    OrderDetailsViewController * orderVC = [[OrderDetailsViewController alloc]init];
//    
//    if ([tableView isEqual:_discarTableview]) {
//        
//        DealOrderModel * discarOD = [self.discardAry objectAtIndex:indexPath.row];
//        orderVC.orderID = discarOD.orderId;
//        orderVC.isWaimaiorTangshi = Waimai;
//        orderVC.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:orderVC animated:YES];
////        discarOD.isSelete = !discarOD.isSelete;
////        [tableView reloadData];
//    }else if ([tableView isEqual:_tangshiTableview])
//    {
//        NewOrderModel * tangshiOD = [self.tangshiArray objectAtIndex:indexPath.row];
//        orderVC.isWaimaiorTangshi = Tangshi;
//        orderVC.orderID = tangshiOD.orderId;
//        orderVC.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:orderVC animated:YES];
//    }else
//    {
//        NewOrderModel * tangshiOD = [self.newsArray objectAtIndex:indexPath.row];
//        orderVC.isWaimaiorTangshi = Waimai;
//        orderVC.orderID = tangshiOD.orderId;
//        orderVC.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:orderVC animated:YES];
//    }
}

//- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if ([tableView isEqual:_discarTableview]) {
//        
//        DealOrderModel * discard = [self.discardAry objectAtIndex:indexPath.row];
//        if (discard.isSelete) {
//            discard.isSelete = !discard.isSelete;
//            [tableView reloadData];
//        }
//    }else
//    {
//    }
//}

- (NSString *)getPrintStringWithNewOrder:(NewOrderModel *)order
{
    NSString * spaceString = @"                           ";
    NSString * lineStr = @"--------------------------------\r";
    NSMutableString * str = [NSMutableString string];
    [str appendFormat:@"%d号    %@\r", order.orderNum, [UserInfo shareUserInfo].StroeName];
//    [str appendFormat:@"店铺:%@\r%@", [UserInfo shareUserInfo].userName, lineStr];
    
    [str appendString:[self dataString1]];
    if ([order.PayMath isEqualToNumber:@3]) {
        NSString * space = [spaceString substringWithRange:NSMakeRange(0, 12)];
        [str appendFormat:@"%@未支付\r", space];
    }else
    {
        NSString * str1 = [NSString stringWithFormat:@"在线支付[%@]\r", order.allMoney];
        if (str1.length < 16) {
            NSInteger length = 16 - str1.length;
            //            NSLog(@"%lu *** %lu", meal.name.length, length);
            NSString * space = [spaceString substringWithRange:NSMakeRange(0, length)];
            [str appendFormat:@"%@在线支付[%@元]\r",space, order.allMoney];
        }else
        {
            NSInteger length = 32 - str1.length;
            NSString * space = [spaceString substringWithRange:NSMakeRange(0, length)];
            
            [str appendFormat:@"%@在线支付[%@元]\r",space, order.allMoney];
        }
    }
    [str appendString:[self normalString1]];
    
    [str appendFormat:@"下单时间:%@\r", order.orderTime];
    [str appendFormat:@"送达时间:%@\r%@", order.hopeTime, lineStr];
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
        
        
        if (meal.name.length < 16) {
            NSInteger length = 16 - meal.name.length;
            NSString * space = [spaceString substringWithRange:NSMakeRange(0, length)];
            [str appendFormat:@"%@%@%@%@  %@元\r", meal.name, space, meal.count,meal.units, meal.money];
        }else
        {
            NSInteger length = 32 - meal.name.length;
            NSString * space = [spaceString substringWithRange:NSMakeRange(0, length)];
            [str appendFormat:@"%@%@%@%@  %@元\r", meal.name, space, meal.count,meal.units, meal.money];
        }
        
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
        [str appendFormat:@"优惠券           -%@元\r%@", order.reduceCard, lineStr];
    }
    if ([order.internal intValue] != 0) {
        double integral = order.internal.doubleValue / 100;
        [str appendFormat:@"积分           -%.2f元\r%@", integral, lineStr];
    }
    if (order.discount != 0) {
        
        [str appendFormat:@"打折           %.1f折\r%@", order.discount, lineStr];
    }
    if (order.tablewareFee != 0) {
        [str appendFormat:@"餐具费           +%f元\r%@", order.tablewareFee, lineStr];
    }
    if ([order.otherMoney doubleValue] != 0) {
        [str appendFormat:@"其他费用           +%@元\r%@", order.otherMoney, lineStr];
    }
    if ([order.PayMath isEqualToNumber:@3]) {
        [str appendFormat:@"总计     %@元      现金支付\r%@", order.allMoney, lineStr];
    }else
    {
        [str appendFormat:@"总计     %@元          已付款\r%@", order.allMoney, lineStr];
    }
    
    [str appendFormat:@"\n"];
    return [str copy];
}

- (NSString *)getPrintStringWithTangshiOrder:(NewOrderModel *)order
{
    NSString * spaceString = @"                           ";
    NSString * lineStr = @"--------------------------------\r";
    NSMutableString * str = [NSMutableString string];
    [str appendFormat:@"%d号    %@\r", order.orderNum, [UserInfo shareUserInfo].StroeName];
    
    [str appendString:[self dataString1]];
    if (order.pays == 0) {
        NSString * space = [spaceString substringWithRange:NSMakeRange(0, 12)];
        [str appendFormat:@"%@未支付\r", space];
    }else
    {
        NSString * str1 = [NSString stringWithFormat:@"在线支付[%@]\r", order.allMoney];
        if (str1.length < 16) {
            NSInteger length = 16 - str1.length;
            NSString * space = [spaceString substringWithRange:NSMakeRange(0, length)];
            [str appendFormat:@"%@在线支付[%@元]\r",space, order.allMoney];
        }else
        {
            NSInteger length = 32 - str1.length;
            NSString * space = [spaceString substringWithRange:NSMakeRange(0, length)];
            [str appendFormat:@"%@在线支付[%@元]\r",space, order.allMoney];
        }
    }
    [str appendString:[self normalString1]];
    
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
        [str appendFormat:@"%@%@%@%@  %@元\r", meal.name, space, meal.count, meal.units, meal.money];
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
        [str appendFormat:@"优惠券           -%@元\r%@", order.reduceCard, lineStr];
    }
    if ([order.internal intValue] != 0) {
        double integral = order.internal.doubleValue / 100;
        [str appendFormat:@"积分           -%.2f元\r%@", integral, lineStr];
    }
    if (order.discount != 0) {
        
        [str appendFormat:@"打折           %.1f折\r%@", order.discount, lineStr];
    }
    if (order.tablewareFee != 0) {
        [str appendFormat:@"餐具费           +%f元\r%@", order.tablewareFee, lineStr];
    }
    if ([order.otherMoney doubleValue] != 0) {
        [str appendFormat:@"其他费用           +%@元\r%@", order.otherMoney, lineStr];
    }
    if (order.pays == 0) {
        [str appendFormat:@"总计     %@元      未付款\r%@", order.allMoney, lineStr];
    }else
    {
        [str appendFormat:@"总计     %@元          已付款\r%@", order.allMoney, lineStr];
    }
    
    [str appendFormat:@"\n"];
    return [str copy];

}
- (NSString *)dataString1
{
    Byte caPrintFmt[5];
    
    /*初始化命令：ESC @ 即0x1b,0x40*/
    caPrintFmt[0] = 0x1b;
    caPrintFmt[1] = 0x40;
    
    /*字符设置命令：ESC ! n即0x1b,0x21,n*/
    caPrintFmt[2] = 0x1d;
    caPrintFmt[3] = 0x21;
    
    caPrintFmt[4] = 0x16;
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString * str = [[NSString alloc] initWithBytes:caPrintFmt length:5 encoding:enc];
    return  str;
}
- (NSString *)normalString1
{
    Byte caPrintFmt[5];
    
    /*初始化命令：ESC @ 即0x1b,0x40*/
    caPrintFmt[0] = 0x1b;
    caPrintFmt[1] = 0x40;
    
    /*字符设置命令：ESC ! n即0x1b,0x21,n*/
    caPrintFmt[2] = 0x1d;
    caPrintFmt[3] = 0x21;
    
    caPrintFmt[4] = 0x00;
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString * str = [[NSString alloc] initWithBytes:caPrintFmt length:5 encoding:enc];
    return  str;
}

#pragma mark - scrollView Deletage
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //        [self.segment changeSegmentedControlWithIndex:scrollView.contentOffset.x / scrollView.width];
    if ([scrollView isEqual:_aScrollView]) {
        
        self.segment.selectedSegmentIndex = scrollView.contentOffset.x / scrollView.width;
        
        
        if (self.segment.selectedSegmentIndex == 2) {
            [self.tangshiTableview headerBeginRefreshing];
            //        [self.aScrollView setContentOffset:CGPointMake(self.segment.selectedSegmentIndex * _aScrollView.width, 0) animated:YES];
            [UIView animateWithDuration:0.35 animations:^{
                _segmentView.frame = CGRectMake(140, 50, 60, 2);
                
            }];
        }else if (self.segment.selectedSegmentIndex == 1) {
            [self.discarTableview headerBeginRefreshing];
            //        [self.aScrollView setContentOffset:CGPointMake(self.segment.selectedSegmentIndex * _aScrollView.width, 0) animated:YES];
            [UIView animateWithDuration:0.35 animations:^{
                _segmentView.frame = CGRectMake(80, 50, 60, 2);
                
            }];
        }else
        {
            [self.nTableview headerBeginRefreshing];
            [UIView animateWithDuration:0.35 animations:^{
                _segmentView.frame = CGRectMake(20, 50, 60, 2);
                
            }];
        }
    }
    
}


- (void)Order:(UIButton *)button
{
    button.backgroundColor = [UIColor redColor];
    NewOrderModel * order = [self.newsArray objectAtIndex:button.tag - NULLIYBUTTON_TAG];
    order.isOrNo = YES;
}

#pragma mark - 订单详情
- (void)orderDetailsAction:(UIButton *)button
{
    OrderDetailsViewController * orderVC = [[OrderDetailsViewController alloc]init];
    orderVC.isWaimaiorTangshi = Waimai;
    
    if (self.segment.selectedSegmentIndex == 1) {
        
        DealOrderModel * discarOD = [self.discardAry objectAtIndex:button.tag - DETAILSBUTTON_TAG];
        orderVC.orderID = discarOD.orderId;
        orderVC.isWaimaiorTangshi = Waimai;
        [Refresh shareRefresh].nOrder = 2;
        orderVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:orderVC animated:YES];
        //        discarOD.isSelete = !discarOD.isSelete;
        //        [tableView reloadData];
    }else if (self.segment.selectedSegmentIndex == 2)
    {
        NewOrderModel * tangshiOD = [self.tangshiArray objectAtIndex:button.tag - DETAILSBUTTON_TAG];
        orderVC.isWaimaiorTangshi = Tangshi;
        [Refresh shareRefresh].nOrder = 2;
        orderVC.orderID = tangshiOD.orderId;
        orderVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:orderVC animated:YES];
    }else
    {
        NewOrderModel * tangshiOD = [self.newsArray objectAtIndex:button.tag - DETAILSBUTTON_TAG];
        orderVC.isWaimaiorTangshi = Waimai;
        [Refresh shareRefresh].nOrder = 2;
        orderVC.orderID = tangshiOD.orderId;
        orderVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:orderVC animated:YES];
    }

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
