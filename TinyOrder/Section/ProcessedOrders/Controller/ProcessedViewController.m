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
#import "VerifyOrderViewController.h"
#import "GeneralBlueTooth.h"
#import "Refresh.h"
#import "Meal.h"
#import "QRCode.h"
#import "TangshiCell.h"
#import "DiscarViewCell.h"

#import "OrderDetailsViewController.h"

//#import "RefundTableViewCell.h"
#define CELL_IDENTIFIER @"cell"
#define TANGSHI_IDENTIFIER @"tangshicell"
#define REFUND_IDENTIFIRE @"refundcell"
#define DISCELL_IDENTIFIER @"discell"

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
#define DETAILSBUTTON_TAG 100000
#define SELECTCOLOR [UIColor colorWithRed:255 / 255.0 green:212 / 255.0 blue:180 / 255.0 alpha:1]
#define WAITCOLOR [UIColor colorWithRed:250 / 255.0 green:65 / 255.0 blue:32 / 255.0 alpha:1]

@interface ProcessedViewController ()<HTTPPostDelegate, UIAlertViewDelegate, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong)UILabel * waitNumLB;
@property (nonatomic, strong)UILabel * didNumLB;
@property (nonatomic, strong)UISegmentedControl * segment;
@property (nonatomic, strong)UIView * segmentView;

@property (nonatomic, strong)NSIndexPath * seleteIndexPath;
//@property (nonatomic, strong)NSIndexPath * refundIndexPath;

@property (nonatomic, strong)NSMutableArray * dataArray;
// 代配送
@property (nonatomic, strong)UITableView * waitdeliveryTableview;
@property (nonatomic, assign)int waitDeliveryPage;//代配送当前页
@property (nonatomic, strong)NSNumber * waitDeliveryAllCount;//代配送总个数
@property (nonatomic, strong)NSMutableArray * waitDeliveryArray;//代配送数组
// 已配送
@property (nonatomic, strong)UITableView * diddeliveryTableview;
@property (nonatomic, assign)int didDeliveryPage;//已配送当前页
@property (nonatomic, strong)NSNumber * didDeliveryAllCount;//已配送总个数
@property (nonatomic, strong)NSMutableArray * didDeliveryArray;//

//已作废
@property (nonatomic, strong)UITableView * discarTableview;
@property (nonatomic, strong)NSMutableArray * discardAry;
@property (nonatomic, assign)int discarPage;
@property (nonatomic, strong)NSNumber * discarAllCount;
// 堂食
@property (nonatomic, strong)UITableView * tangshiTableView;
@property (nonatomic, strong)NSMutableArray * tangshiArray;
@property (nonatomic, assign)int tangshiPag;
@property (nonatomic, strong)NSNumber * tangshiAllCount;

// 已退款
//@property (nonatomic, strong)UITableView * refundTableview;
//@property (nonatomic, strong)NSMutableArray * refundArray;
//@property (nonatomic, assign)int refundPag;
//@property (nonatomic, strong)NSNumber * refundCount;

@property (nonatomic, strong)PrintTypeViewController * printTypeVC;
@property (nonatomic, assign)NSInteger printRow;

@property (nonatomic, strong)UIScrollView * aScrollView;

@property (nonatomic, assign)int aprint ;// 记录点击打印时，是否gprs与蓝牙同时打印
@property (nonatomic, strong) NSDate * date;

@property (nonatomic, strong)NewOrderModel * nOrderModel; //记录打印的订单
@property (nonatomic, strong)DealOrderModel * dealOrderModel;

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

- (NSMutableArray *)discardAry
{
    if (!_discardAry) {
        self.discardAry = [NSMutableArray array];
    }
    return _discardAry;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.aprint = 0;
    self.date = [NSDate date];
    self.date = [NSDate dateWithTimeIntervalSinceNow:0];
    
    [self addHearderView];
    
    self.aScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64 - self.tabBarController.tabBar.height )];
    _aScrollView.delegate = self;
    _aScrollView.pagingEnabled = YES;
    _aScrollView.showsHorizontalScrollIndicator = NO;
    _aScrollView.bounces = NO;
    _aScrollView.contentSize = CGSizeMake(_aScrollView.width * 4, _aScrollView.height);
    [self.view addSubview:_aScrollView];
    
    // 代配送
    self.waitdeliveryTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, _aScrollView.width, _aScrollView.height)];
    self.waitdeliveryTableview.delegate = self;
    self.waitdeliveryTableview.dataSource = self;
    _waitDeliveryPage = 1;
    [_waitdeliveryTableview addHeaderWithTarget:self action:@selector(headerRereshing)];
    [_waitdeliveryTableview addFooterWithTarget:self action:@selector(footerRereshing)];
    _waitdeliveryTableview.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    [self.waitdeliveryTableview registerClass:[ProcessedViewCell class] forCellReuseIdentifier:CELL_IDENTIFIER];
    _waitdeliveryTableview.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    self.waitdeliveryTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_aScrollView addSubview:_waitdeliveryTableview];
    
    // 已配送
    self.diddeliveryTableview = [[UITableView alloc]initWithFrame:CGRectMake(_aScrollView.width, 0, _aScrollView.width, _aScrollView.height)];
    self.diddeliveryTableview.delegate = self;
    self.diddeliveryTableview.dataSource = self;
    _didDeliveryPage = 1;
    [_diddeliveryTableview addHeaderWithTarget:self action:@selector(headerRereshing)];
    [_diddeliveryTableview addFooterWithTarget:self action:@selector(footerRereshing)];
    _diddeliveryTableview.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    [self.diddeliveryTableview registerClass:[ProcessedViewCell class] forCellReuseIdentifier:CELL_IDENTIFIER];
    self.diddeliveryTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_aScrollView addSubview:_diddeliveryTableview];
    
    // 已作废
    self.discarTableview = [[UITableView alloc]initWithFrame:CGRectMake(_aScrollView.width * 3, 0, _aScrollView.width, _aScrollView.height)];
    self.discarTableview.delegate = self;
    self.discarTableview.dataSource = self;
    _discarPage = 1;
    [_discarTableview addHeaderWithTarget:self action:@selector(headerRereshing)];
    [_discarTableview addFooterWithTarget:self action:@selector(footerRereshing)];
    _discarTableview.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    [self.discarTableview registerClass:[DiscarViewCell class] forCellReuseIdentifier:DISCELL_IDENTIFIER];
    self.discarTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_aScrollView addSubview:_discarTableview];

    
    // 堂食
    self.tangshiTableView = [[UITableView alloc]initWithFrame:CGRectMake(_aScrollView.width * 2, 0, _aScrollView.width, _aScrollView.height)];
    self.tangshiTableView.delegate = self;
    self.tangshiTableView.dataSource = self;
    _tangshiPag = 1;
    [_tangshiTableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    [_tangshiTableView addFooterWithTarget:self action:@selector(footerRereshing)];
    _tangshiTableView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    [self.tangshiTableView registerClass:[TangshiCell class] forCellReuseIdentifier:TANGSHI_IDENTIFIER];
    self.tangshiTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_aScrollView addSubview:_tangshiTableView];
    
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
    
//    [self downloadDataWithCommand:@4 page:1 count:10];
//    [SVProgressHUD showWithStatus:@"正在加载..." maskType:SVProgressHUDMaskTypeBlack];
//    [self downloadDataWithCommand:@21 page:1 count:10];
//    [self downloadDataWithCommand:@68 page:1 count:10];
//    [self downloadDataWithCommand:@28 page:1 count:10];
    
    
    
//    [self.waitdeliveryTableview headerBeginRefreshing];
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"1px.png"] forBarMetrics:UIBarMetricsDefault];
    if ([Refresh shareRefresh].processOrder == 1) {
        if (self.segment.selectedSegmentIndex == 0) {
            [self.waitdeliveryTableview headerBeginRefreshing];
        }else if (self.segment.selectedSegmentIndex == 1)
        {
            [self.diddeliveryTableview headerBeginRefreshing];
        }else if (self.segment.selectedSegmentIndex == 2)
        {
            [self.tangshiTableView headerBeginRefreshing];
        }
        else if (self.segment.selectedSegmentIndex == 3)
        {
            [self.discarTableview headerBeginRefreshing];
        }
        [SVProgressHUD showWithStatus:@"正在加载..." maskType:SVProgressHUDMaskTypeBlack];
    }else
    {
        [Refresh shareRefresh].processOrder = 1;
    }
}

//- (void)viewWillDisappear:(BOOL)animated
//{
//    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
//}

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
    
    self.segment = [[UISegmentedControl alloc] initWithItems:@[@"待配送", @"已配送", @"堂  食", @"已作废"]];
    
    self.segment.tintColor = [UIColor colorWithRed:250 / 255.0 green:250 / 255.0 blue:250 / 255.0 alpha:1];//去掉颜色,现在整个segment都看不见
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
    
    _segment.frame = CGRectMake(5, 15, 240, 35);
    [_segment addTarget:self action:@selector(changeDeliveryState:) forControlEvents:UIControlEventValueChanged];
    
    self.segmentView = [[UIView alloc]initWithFrame:CGRectMake(20, 50, 60, 0)];
    self.segmentView.backgroundColor = [UIColor orangeColor];
    
    UIView * hearderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, HEARDERVIEW_HEIGHT)];
    hearderView.backgroundColor = [UIColor clearColor];
    [hearderView addSubview:_segment];
//    [hearderView addSubview:_segmentView];
    
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
        [self.aScrollView setContentOffset:CGPointMake(self.segment.selectedSegmentIndex * _aScrollView.width, 0) animated:YES];
        [UIView animateWithDuration:0.35 animations:^{
            _segmentView.frame = CGRectMake(140, 50, 60, 2);
            
        }];
        [self.tangshiTableView performSelector:@selector(headerBeginRefreshing) withObject:nil afterDelay:0.35];
    }else if (segment.selectedSegmentIndex == 1) {
        [self.aScrollView setContentOffset:CGPointMake(self.segment.selectedSegmentIndex * _aScrollView.width, 0) animated:YES];
        [UIView animateWithDuration:0.35 animations:^{
            _segmentView.frame = CGRectMake(80, 50, 60, 2);
            
        }];
        [self.diddeliveryTableview performSelector:@selector(headerBeginRefreshing) withObject:nil afterDelay:0.35];
    }else if (segment.selectedSegmentIndex == 0)
    {
        [self.aScrollView setContentOffset:CGPointMake(self.segment.selectedSegmentIndex * _aScrollView.width, 0) animated:YES];
        [UIView animateWithDuration:0.35 animations:^{
            _segmentView.frame = CGRectMake(20, 50, 60, 2);
            
        }];
        [self.waitdeliveryTableview performSelector:@selector(headerBeginRefreshing) withObject:nil afterDelay:0.35];
    }
    else if (segment.selectedSegmentIndex == 3)
    {
        [self.aScrollView setContentOffset:CGPointMake(self.segment.selectedSegmentIndex * _aScrollView.width, 0) animated:YES];
        [UIView animateWithDuration:0.35 animations:^{
            _segmentView.frame = CGRectMake(200, 50, 60, 2);
            
        }];
        [self.discarTableview performSelector:@selector(headerBeginRefreshing) withObject:nil afterDelay:0.35];
    }
}



- (void)tableViewEndRereshing
{
    if (self.segment.selectedSegmentIndex == 0) {
        
        if (self.waitdeliveryTableview.isHeaderRefreshing) {
            [self.waitdeliveryTableview headerEndRefreshing];
        }
        if (self.waitdeliveryTableview.isFooterRefreshing) {
            [self.waitdeliveryTableview footerEndRefreshing];
        }
    }else if (self.segment.selectedSegmentIndex == 1)
    {
        if (self.diddeliveryTableview.isHeaderRefreshing) {
            [self.diddeliveryTableview headerEndRefreshing];
        }
        if (self.diddeliveryTableview.isFooterRefreshing) {
            [self.diddeliveryTableview footerEndRefreshing];
        }
    }else if (self.segment.selectedSegmentIndex == 2)
    {
        if (self.tangshiTableView.isHeaderRefreshing) {
            [self.tangshiTableView headerEndRefreshing];
        }
        if (self.tangshiTableView.isFooterRefreshing) {
            [self.tangshiTableView footerEndRefreshing];
        }
    }
    else if (self.segment.selectedSegmentIndex == 3)
    {
        if (self.discarTableview.isHeaderRefreshing) {
            [self.discarTableview headerEndRefreshing];
        }
        if (self.discarTableview.isFooterRefreshing) {
            [self.discarTableview footerEndRefreshing];
        }
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
        //        _tangshiArray = nil;
        [self.aScrollView setContentOffset:CGPointMake(self.segment.selectedSegmentIndex * _aScrollView.width, 0) animated:YES];
        [self downloadDataWithCommand:@68 page:_tangshiPag count:COUNT];
    }else if (self.segment.selectedSegmentIndex == 1) {
        _didDeliveryPage = 1;
        //        self.didDeliveryArray = nil;
        [self.aScrollView setContentOffset:CGPointMake(self.segment.selectedSegmentIndex * _aScrollView.width, 0) animated:YES];
        [self downloadDataWithCommand:@21 page:_didDeliveryPage count:COUNT];
    }else if (self.segment.selectedSegmentIndex == 0)
    {
        _waitDeliveryPage = 1;
        //        self.waitDeliveryArray = nil;
        [self.aScrollView setContentOffset:CGPointMake(self.segment.selectedSegmentIndex * _aScrollView.width, 0) animated:YES];
        [self downloadDataWithCommand:@4 page:_waitDeliveryPage count:COUNT];
    }
    else if (self.segment.selectedSegmentIndex == 3)
    {
        _discarPage = 1;
        [self.aScrollView setContentOffset:CGPointMake(self.segment.selectedSegmentIndex * _aScrollView.width, 0) animated:YES];
        [self downloadDataWithCommand:@28 page:_discarPage count:COUNT];
    }
}

- (void)footerRereshing
{
    [self tableViewEndRereshing];
    
    if (self.segment.selectedSegmentIndex == 2) {
        [self.aScrollView setContentOffset:CGPointMake(self.segment.selectedSegmentIndex * _aScrollView.width, 0) animated:YES];
        if (self.tangshiArray.count < [_tangshiAllCount integerValue]) {
            self.tangshiTableView.footerRefreshingText = @"正在加载数据";
            [self downloadDataWithCommand:@68 page:++_tangshiPag count:COUNT];
        }else
        {
            self.tangshiTableView.footerRefreshingText = @"数据已经加载完";
            [self.tangshiTableView performSelector:@selector(footerEndRefreshing) withObject:nil afterDelay:1];
        }
    }else if (self.segment.selectedSegmentIndex == 1) {
        [self.aScrollView setContentOffset:CGPointMake(self.segment.selectedSegmentIndex * _aScrollView.width, 0) animated:YES];
        if (self.didDeliveryArray.count < [_didDeliveryAllCount integerValue]) {
            self.diddeliveryTableview.footerRefreshingText = @"正在加载数据";
            [self downloadDataWithCommand:@21 page:++_didDeliveryPage count:COUNT];
        }else
        {
            self.diddeliveryTableview.footerRefreshingText = @"数据已经加载完";
            [self.diddeliveryTableview performSelector:@selector(footerEndRefreshing) withObject:nil afterDelay:1];
        }
    }else if (self.segment.selectedSegmentIndex == 0)
    {
        [self.aScrollView setContentOffset:CGPointMake(self.segment.selectedSegmentIndex * _aScrollView.width, 0) animated:YES];
        if (self.waitDeliveryArray.count < [_waitDeliveryAllCount integerValue]) {
            self.waitdeliveryTableview.footerRefreshingText = @"正在加载数据";
            [self downloadDataWithCommand:@4 page:++_waitDeliveryPage count:COUNT];
        }else
        {
            self.waitdeliveryTableview.footerRefreshingText = @"数据已经加载完";
            [self.waitdeliveryTableview performSelector:@selector(footerEndRefreshing) withObject:nil afterDelay:1];
        }
    }
    else if (self.segment.selectedSegmentIndex == 3)
    {
        [self.aScrollView setContentOffset:CGPointMake(self.segment.selectedSegmentIndex * _aScrollView.width, 0) animated:YES];
        if (self.discardAry.count < [_discarAllCount integerValue]) {
            self.discarTableview.footerRefreshingText = @"正在加载数据";
            [self downloadDataWithCommand:@28 page:++_discarPage count:COUNT];
        }else
        {
            self.discarTableview.footerRefreshingText = @"数据已经加载完";
            [self.discarTableview performSelector:@selector(footerEndRefreshing) withObject:nil afterDelay:1];
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
            NSLog(@"%@", [data description]);
            if (_waitDeliveryPage == 1) {
                [self.waitDeliveryArray removeAllObjects];
            }
            [SVProgressHUD dismiss];
            NSArray * array = [data objectForKey:@"OrderList"];
            for (NSDictionary * dic in array) {
                DealOrderModel * dealOrder = [[DealOrderModel alloc] initWithDictionary:dic];
                [self.waitDeliveryArray addObject:dealOrder];
            }
            [self.waitdeliveryTableview reloadData];
            
            self.waitDeliveryAllCount = allCount;
            NSLog(@"***%d", self.waitDeliveryArray.count);
            self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld", (long)[self.waitDeliveryAllCount integerValue]];
        }else if(command == 10021)
        {
            [SVProgressHUD dismiss];
            if (_didDeliveryPage == 1) {
                [self.didDeliveryArray removeAllObjects];
            }
            for (NSDictionary * dic in orderArray) {
                DealOrderModel * dealOrder = [[DealOrderModel alloc] initWithDictionary:dic];
                [self.didDeliveryArray addObject:dealOrder];
            }
            self.didDeliveryAllCount = allCount;
            self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld", (long)[self.didDeliveryAllCount integerValue]];
            [self.diddeliveryTableview reloadData];
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
            
            if ([PrintType sharePrintType].isGPRSenable) {
                
            }
            if ([PrintType sharePrintType].isBlutooth)
            {
                if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"printNum"] integerValue] == 0) {
                    ;
                }
                else if (![GeneralBlueTooth shareGeneralBlueTooth].myPeripheral.state){
                    //                        DealOrderModel * order = [self.waitDeliveryArray objectAtIndex:self.printRow];
                    //                        NSString * printStr = [self getPrintStringWithNewOrder:order];
                    //                        [[GeneralBlueTooth shareGeneralBlueTooth] printWithString:printStr];
                }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"printNum"] integerValue] != 0){
                    DealOrderModel * order = [self.waitDeliveryArray objectAtIndex:self.printRow];
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
                            if ([order.payMath intValue] == 3) {
                                // 现金支付情况下才会打印二维码
                                NSString * str = [NSString stringWithFormat:@"http://wap.vlifee.com/eat/ScanCodeChangeMoney.aspx?ordersn=%@&busiid=%@&from=app", order.orderId, [UserInfo shareUserInfo].userId];
                                
                                [[GeneralBlueTooth shareGeneralBlueTooth] printPng:str];
                            }
                        }
                    }
                    
                }
            }
            [self downloadDataWithCommand:@3 page:1 count:COUNT];
            
        }else if (command == 10068)
        {
            [SVProgressHUD dismiss];
            if (_tangshiPag == 1) {
                [self.tangshiArray removeAllObjects];
            }
            self.tangshiAllCount = [data objectForKey:@"AllCount"];
            NSArray * array = [data objectForKey:@"OrderList"];
            for (NSDictionary * dic in array) {
                NewOrderModel * discarOrder = [[NewOrderModel alloc] initWithDictionary:dic];
                [self.tangshiArray addObject:discarOrder];
            }
            self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld", (long)[self.tangshiAllCount integerValue]];
            [self.tangshiTableView reloadData];
        }else if (command == 10069)
        {
            if ([PrintType sharePrintType].isGPRSenable) {
                
            }
            if ([PrintType sharePrintType].isBlutooth)
            {
                if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"printNum"] integerValue] == 0) {
                    ;
                }
                else if (![GeneralBlueTooth shareGeneralBlueTooth].myPeripheral.state){
                    
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
            [self downloadDataWithCommand:@3 page:1 count:COUNT];
            
        }
        else if (command == 10028)
        {
            [SVProgressHUD dismiss];
            if (_discarPage == 1) {
                [self.discardAry removeAllObjects];
            }
            for (NSDictionary * dic in orderArray) {
                DealOrderModel * dealOrder = [[DealOrderModel alloc] initWithDictionary:dic];
                [self.discardAry addObject:dealOrder];
            }
            self.discarAllCount = allCount;
            self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld", (long)[self.discarAllCount integerValue]];
            [self.discarTableview reloadData];
        }
        
        //        self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld", (long)[allCount integerValue]];
        
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
                                               @"DealPrint":@1
                                               };
                    [self playPostWithDictionary:jsonDic];
                }else
                {
                    NSDictionary * jsonDic = @{
                                               @"UserId":[UserInfo shareUserInfo].userId,
                                               @"Command":@15,
                                               @"OrderId":self.dealOrderModel.orderId,
                                               @"PrintType":@2,
                                               @"DealPrint":@1
                                               };
                    [self playPostWithDictionary:jsonDic];
                }
            }else
            {
                UIAlertView * alertV = [[UIAlertView alloc] initWithTitle:@"提示" message:[data objectForKey:@"ErrorMsg"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alertV show];
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

- (void)failWithError:(NSError *)error
{
    NSLog(@"%@", error);
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
    if ([tableView isEqual:_waitdeliveryTableview]) {
        return self.waitDeliveryArray.count;
    }else if ([tableView isEqual:_diddeliveryTableview])
    {
        return self.didDeliveryArray.count;
    }else if([tableView isEqual:_tangshiTableView])
    {
        return self.tangshiArray.count ;
    }
    else
    {
        return self.discardAry.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:_tangshiTableView]) {
        NewOrderModel * tangshiModel = [self.tangshiArray objectAtIndex:indexPath.row];
        TangshiCell * tangshicell = [tableView dequeueReusableCellWithIdentifier:TANGSHI_IDENTIFIER forIndexPath:indexPath];
        [tangshicell createSubView:tableView.bounds mealCoutn:tangshiModel];
        tangshicell.orderModel = tangshiModel;
        tangshicell.totalPriceView.printButton.hidden = YES;
        tangshicell.totalPriceView.dealButton.hidden = NO;
        
        if ([tangshicell.totalPriceView.dealButton.titleLabel.text isEqualToString:@"打印并处理"]) {
            [tangshicell.totalPriceView.dealButton setTitle:@"打印" forState:UIControlStateNormal];
        }
        [tangshicell.totalPriceView.dealButton addTarget:self action:@selector(printMeallist:) forControlEvents:UIControlEventTouchUpInside];
        tangshicell.totalPriceView.dealButton.tag = indexPath.row + PRINTBUTTON_TAG;
        tangshicell.totalPriceView.detailsButton.tag = DETAILSBUTTON_TAG + indexPath.row ;
        [tangshicell.totalPriceView.detailsButton addTarget:self action:@selector(orderDetailsAction:) forControlEvents:UIControlEventTouchUpInside];
        tangshicell.selectionStyle = UITableViewCellSelectionStyleNone;
        return tangshicell;
        
    }else if ([tableView isEqual:_diddeliveryTableview])
    {
        DealOrderModel * dealOrder = [self.didDeliveryArray objectAtIndex:indexPath.row];
        
        ProcessedViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
        
        [cell createSubView:self.diddeliveryTableview.bounds mealCount:dealOrder.mealArray.count];
        [cell.totalPriceView.dealButton addTarget:self action:@selector(markMealSentOut:) forControlEvents:UIControlEventTouchUpInside];
        [cell.totalPriceView.printButton addTarget:self action:@selector(printMeallist:) forControlEvents:UIControlEventTouchUpInside];
        cell.dealOrder = dealOrder;
        
//        cell.totalPriceView.dealButton.hidden = YES;
//        cell.totalPriceView.printButton.hidden = YES;
//        cell.totalPriceView.dealButton.tag = indexPath.row + DEALBUTTON_TAG;
//        cell.totalPriceView.printButton.tag = indexPath.row + PRINTBUTTON_TAG;
        
//        cell.totalPriceView.dealButton.frame = CGRectMake(cell.totalPriceView.dealButton.frame.origin.x, cell.totalPriceView.dealButton.frame.origin.y, 0, cell.totalPriceView.dealButton.frame.size.height);
//        cell.totalPriceView.totalLabel.frame = CGRectMake(self.view.width - 120 - 15, cell.totalPriceView.totalLabel.frame.origin.y, 40, 30);
//        cell.totalPriceView.totalPriceLabel.frame = CGRectMake(cell.totalPriceView.totalLabel.right, cell.totalPriceView.totalPriceLabel.frame.origin.y, 80, 30);
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
//        if (self.seleteIndexPath != nil && self.seleteIndexPath.row == indexPath.row) {
//            [cell disHiddenSubView:self.diddeliveryTableview.bounds mealCount:dealOrder.mealArray.count andHiddenImage:NO];
//        }else
//        {
//            [cell hiddenSubView:self.diddeliveryTableview.bounds mealCount:dealOrder.mealArray.count];
//        }
        cell.totalPriceView.detailsButton.tag = DETAILSBUTTON_TAG + indexPath.row ;
        [cell.totalPriceView.detailsButton addTarget:self action:@selector(orderDetailsAction:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if ([tableView isEqual:_waitdeliveryTableview])
    {
        DealOrderModel * dealOrder = [self.waitDeliveryArray objectAtIndex:indexPath.row];
        
        ProcessedViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
        [cell createSubView:tableView.bounds mealCount:dealOrder.mealArray.count];
        
        [cell.totalPriceView.dealButton addTarget:self action:@selector(markMealSentOut:) forControlEvents:UIControlEventTouchUpInside];
        [cell.totalPriceView.printButton addTarget:self action:@selector(printMeallist:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.totalPriceView.dealButton.tag = indexPath.row + DEALBUTTON_TAG;
        cell.totalPriceView.printButton.tag = indexPath.row + PRINTBUTTON_TAG;
        
        cell.totalPriceView.detailsButton.tag = DETAILSBUTTON_TAG + indexPath.row ;
        [cell.totalPriceView.detailsButton addTarget:self action:@selector(orderDetailsAction:) forControlEvents:UIControlEventTouchUpInside];
        cell.dealOrder = dealOrder;
        //        [cell disHiddenSubView:self.waitdeliveryTableview.bounds mealCount:dealOrder.mealArray.count andHiddenImage:YES];
        
        
        cell.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else
    {
//        DealOrderModel * dealOrder = [self.refundArray objectAtIndex:indexPath.row];
//        
//        RefundTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:REFUND_IDENTIFIRE forIndexPath:indexPath];
//        
//        [cell createSubView:self.refundTableview.bounds mealCount:dealOrder.mealArray.count];
//        [cell.totalPriceView.dealButton addTarget:self action:@selector(markMealSentOut:) forControlEvents:UIControlEventTouchUpInside];
//        [cell.totalPriceView.printButton addTarget:self action:@selector(printMeallist:) forControlEvents:UIControlEventTouchUpInside];
//        
//        cell.totalPriceView.dealButton.tag = indexPath.row + DEALBUTTON_TAG;
//        cell.totalPriceView.printButton.tag = indexPath.row + PRINTBUTTON_TAG;
//        cell.dealOrder = dealOrder;
//        
//        cell.totalPriceView.dealButton.frame = CGRectMake(cell.totalPriceView.dealButton.frame.origin.x, cell.totalPriceView.dealButton.frame.origin.y, 0, cell.totalPriceView.dealButton.frame.size.height);
//        cell.totalPriceView.printButton.hidden = YES;
//        cell.totalPriceView.totalLabel.frame = CGRectMake(self.view.width - 120 - 15, cell.totalPriceView.totalLabel.frame.origin.y, 40, 30);
//        cell.totalPriceView.totalPriceLabel.frame = CGRectMake(cell.totalPriceView.totalLabel.right, cell.totalPriceView.totalPriceLabel.frame.origin.y, 80, 30);
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        
//        if (self.refundIndexPath != nil && self.refundIndexPath.row == indexPath.row) {
//            [cell disHiddenSubView:self.refundTableview.bounds mealCount:dealOrder.mealArray.count andHiddenImage:NO];
//        }else
//        {
//            [cell hiddenSubView:self.refundTableview.bounds mealCount:dealOrder.mealArray.count];
//        }
//        
//        cell.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
//        
//        return cell;
        
        DealOrderModel * discarOD = [self.discardAry objectAtIndex:indexPath.row];
        DiscarViewCell * disCell = [tableView dequeueReusableCellWithIdentifier:DISCELL_IDENTIFIER forIndexPath:indexPath];
        [disCell createSubView:tableView.bounds mealCount:discarOD.mealArray.count];
        disCell.dealOrder = discarOD;
        disCell.selectionStyle = UITableViewCellSelectionStyleNone;
        disCell.totalPriceView.detailsButton.tag = DETAILSBUTTON_TAG + indexPath.row ;
        [disCell.totalPriceView.detailsButton addTarget:self action:@selector(orderDetailsAction:) forControlEvents:UIControlEventTouchUpInside];
        //        if (discarOD.isSelete) {
        //            [disCell disHiddenSubView:self.discarTableview.bounds mealCount:discarOD.mealArray.count andHiddenImage:NO];
        //        }else
        //        {
        //            [disCell hiddenSubView:self.discarTableview.bounds mealCount:discarOD.mealArray.count];
        //        }
        
//        disCell.totalPriceView.dealButton.tag = indexPath.row + DEALBUTTON_TAG;
//        disCell.totalPriceView.printButton.tag = indexPath.row + NULLIYBUTTON_TAG;
        //        if (disCell.dealOrder.dealState.intValue == 5 )  {
//        [disCell.totalPriceView.dealButton addTarget:self action:@selector(agreeRefundAction:) forControlEvents:UIControlEventTouchUpInside];
//        [disCell.totalPriceView.printButton addTarget:self action:@selector(refuseRefungAction:) forControlEvents:UIControlEventTouchUpInside];
        //        }else
        //        {
        //
        //            disCell.totalPriceView.dealButton.frame = CGRectMake(disCell.totalPriceView.dealButton.frame.origin.x, disCell.totalPriceView.dealButton.frame.origin.y, 0, disCell.totalPriceView.dealButton.frame.size.height);
        //            disCell.totalPriceView.printButton.hidden = YES;
        //            disCell.totalPriceView.totalLabel.frame = CGRectMake(self.view.width - 120 - 15, disCell.totalPriceView.totalLabel.frame.origin.y, 40, 30);
        //            disCell.totalPriceView.totalPriceLabel.frame = CGRectMake(disCell.totalPriceView.totalLabel.right, disCell.totalPriceView.totalPriceLabel.frame.origin.y, 80, 30);
        //        }
        
        return disCell;

    }
}

#pragma mark - 打印`标记餐已送出 处理
- (void)printMeallist:(UIButton *)button
{
    NSLog(@"打印订单");
    
    if ([button.titleLabel.text isEqualToString:@"去验证"]) {
        VerifyOrderViewController * verifyVC = [[VerifyOrderViewController alloc]init];
        verifyVC.hidesBottomBarWhenPushed = YES;
        verifyVC.isfrome = 1;
        [self.navigationController pushViewController:verifyVC animated:YES];
    }else
    {
        
        self.printRow = button.tag - PRINTBUTTON_TAG;
        if (self.segment.selectedSegmentIndex == 2) {
            NewOrderModel * order = [self.tangshiArray objectAtIndex:button.tag - PRINTBUTTON_TAG];
            self.nOrderModel = order;
            
            if ([PrintType sharePrintType].isGPRSenable && [PrintType sharePrintType].isBlutooth) {
                NSDictionary * jsonDic = @{
                                           @"UserId":[UserInfo shareUserInfo].userId,
                                           @"Command":@69,
                                           @"OrderId":order.orderId,
                                           @"PrintType":@3,
                                           @"DealPrint":@1
                                           };
                
                [self playPostWithDictionary:jsonDic];
            }else if ([PrintType sharePrintType].isGPRSenable ) {
                
                NSDictionary * jsonDic = @{
                                           @"UserId":[UserInfo shareUserInfo].userId,
                                           @"Command":@69,
                                           @"OrderId":order.orderId,
                                           @"PrintType":@3,
                                           @"DealPrint":@1
                                           };
                
                [self playPostWithDictionary:jsonDic];
                
            }else if ( [PrintType sharePrintType].isBlutooth )
            {
                self.aprint = 1;
                //            if ([GeneralBlueTooth shareGeneralBlueTooth].myPeripheral.state) {
                //                NSDictionary * jsonDic = @{
                //                                           @"UserId":[UserInfo shareUserInfo].userId,
                //                                           @"Command":@69,
                //                                           @"OrderId":order.orderId,
                //                                           @"PrintType":@2,
                //                                           @"DealPrint":@1
                //                                           };
                //                [self playPostWithDictionary:jsonDic];
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
                                           @"DealPrint":@1
                                           };
                [self playPostWithDictionary:jsonDic];
                [SVProgressHUD showWithStatus:@"正在请求处理..." maskType:SVProgressHUDMaskTypeBlack];
            }
            if  (![PrintType sharePrintType].isGPRSenable && ![PrintType sharePrintType].isBlutooth)
            {
                //            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"printNum"] integerValue] == 0 || [PrintType sharePrintType].gprsPrintNum == 0) {
                //                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"打印份数不能为0" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                //                [alert show];
                //            }else
                //            {
                _printTypeVC.fromWitchController = 2;
                _printTypeVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:_printTypeVC animated:YES];
                //            }
            }
        }else
        {
            
            DealOrderModel * order = [self.waitDeliveryArray objectAtIndex:button.tag - PRINTBUTTON_TAG];
            self.dealOrderModel = order;
            
            if ([PrintType sharePrintType].isGPRSenable && [PrintType sharePrintType].isBlutooth) {
                NSDictionary * jsonDic = @{
                                           @"UserId":[UserInfo shareUserInfo].userId,
                                           @"Command":@15,
                                           @"OrderId":order.orderId,
                                           @"PrintType":@3,
                                           @"DealPrint":@1
                                           };
                
                [self playPostWithDictionary:jsonDic];
            }else if ([PrintType sharePrintType].isGPRSenable ) {
                
                NSDictionary * jsonDic = @{
                                           @"UserId":[UserInfo shareUserInfo].userId,
                                           @"Command":@15,
                                           @"OrderId":order.orderId,
                                           @"PrintType":@3,
                                           @"DealPrint":@1
                                           };
                
                [self playPostWithDictionary:jsonDic];
                
            }
            else if ( [PrintType sharePrintType].isBlutooth )
            {
                self.aprint = 1;
                //            if ([GeneralBlueTooth shareGeneralBlueTooth].myPeripheral.state) {
                //                NSDictionary * jsonDic = @{
                //                                           @"UserId":[UserInfo shareUserInfo].userId,
                //                                           @"Command":@15,
                //                                           @"OrderId":order.orderId,
                //                                           @"PrintType":@2,
                //                                           @"DealPrint":@1
                //                                           };
                //                [self playPostWithDictionary:jsonDic];
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
                                           @"PrintType":@2,
                                           @"DealPrint":@1
                                           };
                [self playPostWithDictionary:jsonDic];
                [SVProgressHUD showWithStatus:@"正在请求处理..." maskType:SVProgressHUDMaskTypeBlack];
            }
            
            if  (![PrintType sharePrintType].isGPRSenable && ![PrintType sharePrintType].isBlutooth)
            {
                //            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"printNum"] integerValue] == 0 || [PrintType sharePrintType].gprsPrintNum == 0) {
                //                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"打印份数不能为0" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                //                [alert show];
                //            }else
                //            {
                _printTypeVC.fromWitchController = 2;
                _printTypeVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:_printTypeVC animated:YES];
                //            }
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
    DealOrderModel * order = [self.waitDeliveryArray objectAtIndex:button.tag - DEALBUTTON_TAG];
    NSDictionary * jsonDic = @{
                               @"UserId":[UserInfo shareUserInfo].userId,
                               @"Command":@16,
                               @"OrderId":order.orderId
                               };
    [self playPostWithDictionary:jsonDic];
    [SVProgressHUD showWithStatus:@"正在标记成已处理..." maskType:SVProgressHUDMaskTypeBlack];
}

//- (void)nulliyOrder:(UIButton *)button
//{
//    DealOrderModel * order = [self.dataArray objectAtIndex:button.tag - NULLIYBUTTON_TAG];
//    NSDictionary * jsonDic = @{
//                               @"UserId":[UserInfo shareUserInfo].userId,
//                               @"Command":@23,
//                               @"OrderId":order.orderId
//                               };
//    [self playPostWithDictionary:jsonDic];
//    [SVProgressHUD showWithStatus:@"正在请求订单无效..." maskType:SVProgressHUDMaskTypeBlack];
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    OrderDetailsViewController * orderVC = [[OrderDetailsViewController alloc]init];
//    
//    if ([tableView isEqual:_diddeliveryTableview]) {
//        DealOrderModel * model = [self.didDeliveryArray objectAtIndex:indexPath.row];
//        orderVC.orderID = model.orderId;
//        orderVC.isWaimaiorTangshi = Waimai;
//        orderVC.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:orderVC animated:YES];
////        if (self.seleteIndexPath != nil && self.seleteIndexPath.row == indexPath.row) {
////            self.seleteIndexPath = nil;
////        }else
////        {
////            self.seleteIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
////        }
////        [self.diddeliveryTableview reloadData];
////        [self.diddeliveryTableview deselectRowAtIndexPath:indexPath animated:YES];
//    }else if ([tableView isEqual:_tangshiTableView])
//    {
//        NewOrderModel * model = [self.tangshiArray objectAtIndex:indexPath.row];
//        orderVC.orderID = model.orderId;
//        orderVC.isWaimaiorTangshi = Tangshi;
//        orderVC.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:orderVC animated:YES];
//    }else if([tableView isEqual:_waitdeliveryTableview])
//    {
//        DealOrderModel * model = [self.waitDeliveryArray objectAtIndex:indexPath.row];
//        orderVC.orderID = model.orderId;
//        orderVC.isWaimaiorTangshi = Waimai;
//        orderVC.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:orderVC animated:YES];
//    }
    
    
//    else if ([tableView isEqual:_refundTableview])
//    {
//#warning *******
//        NSLog(@"dianjile****");
//        if (self.refundIndexPath != nil && self.refundIndexPath.row == indexPath.row) {
//            self.refundIndexPath = nil;
//        }else
//        {
//            self.refundIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
//        }
//        [self.refundTableview reloadData];
//        [self.refundTableview deselectRowAtIndexPath:indexPath animated:YES];
//    }
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:_tangshiTableView]) {
        NewOrderModel * tangshiNeworder = [self.tangshiArray objectAtIndex:indexPath.row];
        return [TangshiCell cellHeightWithMealCount:(NewOrderModel *)tangshiNeworder];
    }else
    {
        if ([tableView isEqual:_diddeliveryTableview]) {
            DealOrderModel * dealOrder = [self.didDeliveryArray objectAtIndex:indexPath.row];
//            if (indexPath.row == self.seleteIndexPath.row && self.seleteIndexPath != nil) {
                return [ProcessedViewCell cellHeightWithMealCount:dealOrder.mealArray.count];
//            }
//            return [ProcessedViewCell didDeliveryCellHeight];
        }else if ([tableView isEqual:_discarTableview])
        {
            DealOrderModel * model = [self.discardAry objectAtIndex:indexPath.row];
            return [DiscarViewCell cellHeightWithMealCount:model.mealArray.count];
        }
//        else if ([tableView isEqual:_refundTableview])
//        {
//            DealOrderModel * dealOrder = [self.refundArray objectAtIndex:indexPath.row];
//            if (indexPath.row == self.refundIndexPath.row && self.refundIndexPath != nil) {
//                return [RefundTableViewCell cellHeightWithMealCount:dealOrder.mealArray.count];
//            }
//            return [RefundTableViewCell didDeliveryCellHeight];
//        }
        DealOrderModel * dealOrder = [self.waitDeliveryArray objectAtIndex:indexPath.row];
        
        return [ProcessedViewCell cellHeightWithMealCount:dealOrder.mealArray.count];
    }
}

//- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if ([tableView isEqual:_diddeliveryTableview] ) {
//        return YES;
//    }
//    return NO;
//}

#pragma mark - 打印
- (NSString *)getPrintStringWithNewOrder:(DealOrderModel *)order
{
    NSString * spaceString = @"                           ";
    NSString * lineStr = @"--------------------------------\r";
    NSMutableString * str = [NSMutableString string];
    [str appendFormat:@"%@号    %@\r", order.orderNum, [UserInfo shareUserInfo].StroeName];
//    [str appendFormat:@"店铺:%@\r%@", [UserInfo shareUserInfo].userName, lineStr];
    
    [str appendString:[self dataString1]];
    if ([order.payMath isEqualToNumber:@3]) {
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
//            NSLog(@"%lu *** %lu", meal.name.length, length);
            NSString * space = [spaceString substringWithRange:NSMakeRange(0, length)];
            [str appendFormat:@"%@%@%@%@  %@元\r", meal.name, space, meal.count, meal.units, meal.money];
        }else
        {
            NSInteger length = 32 - meal.name.length;
            NSString * space = [spaceString substringWithRange:NSMakeRange(0, length)];
            [str appendFormat:@"%@%@%@%@  %@元\r", meal.name, space, meal.count, meal.units, meal.money];
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
    
    if ([order.otherMoney doubleValue] != 0) {
        [str appendFormat:@"其他费用           +%@元\r%@", order.otherMoney, lineStr];
    }
    
    if ([order.payMath isEqualToNumber:@3]) {
        [str appendFormat:@"总计     %@元      现金支付\r%@", order.allMoney, lineStr];
    }else
    {
        [str appendFormat:@"总计     %@元          已付款\r%@", order.allMoney, lineStr];
    }
    
    [str appendFormat:@"\n"];
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
//    if (order.tablewareFee != 0) {
//        [str appendFormat:@"餐具费           %f元\r%@", order.tablewareFee, lineStr];
//    }
    
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

- (void)printpaycodedescribe
{
//    double delaySecond = 2.0;
//    dispatch_time_t waitTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delaySecond * NSEC_PER_SEC));
//    dispatch_after(waitTime, dispatch_get_main_queue(), ^{
//        if ([UserInfo shareUserInfo].isShowPayCode.intValue == 3) {
//            [[GeneralBlueTooth shareGeneralBlueTooth] printWithString:[UserInfo shareUserInfo].payCodeDes];
//        }else if ([UserInfo shareUserInfo].isShowPayCode.intValue == 1){
//           [[GeneralBlueTooth shareGeneralBlueTooth] printWithString:@"扫描上方二维码完成订单支付\n"];
//        }
//    });
}

#pragma mark - scrollView Deletage
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:_aScrollView]) {
        
        self.segment.selectedSegmentIndex = scrollView.contentOffset.x / scrollView.width;
        
        
        if (self.segment.selectedSegmentIndex == 2) {
            [self.tangshiTableView headerBeginRefreshing];
            [UIView animateWithDuration:0.35 animations:^{
                _segmentView.frame = CGRectMake(140, 50, 60, 2);
                
            }];
        }else if (self.segment.selectedSegmentIndex == 1) {
            [self.diddeliveryTableview headerBeginRefreshing];
            [UIView animateWithDuration:0.35 animations:^{
                _segmentView.frame = CGRectMake(80, 50, 60, 2);
                
            }];
        }else if (self.segment.selectedSegmentIndex == 0)
        {
            [self.waitdeliveryTableview headerBeginRefreshing];
            [UIView animateWithDuration:0.35 animations:^{
                _segmentView.frame = CGRectMake(20, 50, 60, 2);
                
            }];
        }
        else
        {
            [self.discarTableview headerBeginRefreshing];
            [UIView animateWithDuration:0.35 animations:^{
                _segmentView.frame = CGRectMake(200, 50, 60, 2);
                
            }];
        }
    }
    
}
#pragma mark - 订单详情
- (void)orderDetailsAction:(UIButton *)button
{
    OrderDetailsViewController * orderVC = [[OrderDetailsViewController alloc]init];
    orderVC.isWaimaiorTangshi = Waimai;
    
    if (self.segment.selectedSegmentIndex == 0) {
        
        DealOrderModel * discarOD = [self.waitDeliveryArray objectAtIndex:button.tag - DETAILSBUTTON_TAG];
        orderVC.orderID = discarOD.orderId;
        orderVC.isWaimaiorTangshi = Waimai;
        [Refresh shareRefresh].processOrder = 2;
        orderVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:orderVC animated:YES];
        //        discarOD.isSelete = !discarOD.isSelete;
        //        [tableView reloadData];
    }else if (self.segment.selectedSegmentIndex == 1)
    {
        DealOrderModel * tangshiOD = [self.didDeliveryArray objectAtIndex:button.tag - DETAILSBUTTON_TAG];
        orderVC.isWaimaiorTangshi = Waimai;
        [Refresh shareRefresh].processOrder = 2;
        orderVC.orderID = tangshiOD.orderId;
        orderVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:orderVC animated:YES];
    }else if (self.segment.selectedSegmentIndex == 2)
    {
        NewOrderModel * tangshiOD = [self.tangshiArray objectAtIndex:button.tag - DETAILSBUTTON_TAG];
        orderVC.isWaimaiorTangshi = Tangshi;
        [Refresh shareRefresh].processOrder = 2;
        orderVC.orderID = tangshiOD.orderId;
        orderVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:orderVC animated:YES];
    }else
    {
        DealOrderModel * discarOD = [self.discardAry objectAtIndex:button.tag - DETAILSBUTTON_TAG];
        orderVC.orderID = discarOD.orderId;
        orderVC.isWaimaiorTangshi = Waimai;
        [Refresh shareRefresh].processOrder = 2;
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
