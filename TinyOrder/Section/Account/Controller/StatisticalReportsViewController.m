//
//  StatisticalReportsViewController.m
//  TinyOrder
//
//  Created by 仙林 on 16/6/13.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "StatisticalReportsViewController.h"
#import "MenuActivityMD.h"
#import "FMTagsView.h"
#import "StatisticalReportsView.h"
#import "AppDelegate.h"

#import "MealStatisticalModel.h"
#import "MealStatisticalTableViewCell.h"

#define CELL_IDENTIFIER @"cell"

#define HEARDERVIEW_HEIGHT 60

#define ViewWidth [UIScreen mainScreen].bounds.size.width
#define ViewHeight [UIScreen mainScreen].bounds.size.height
@interface StatisticalReportsViewController ()<HTTPPostDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)StatisticalReportsView * stastView;

// 筛选菜品列表
@property (nonatomic, strong)NSMutableArray * dataArray;// 存放菜品的信息数组
@property (nonatomic, strong)NSMutableArray * waimaiArray;
@property (nonatomic, strong)NSMutableArray * tangshiArray;
@property (nonatomic, assign)int waimaimealsCount;
@property (nonatomic, assign)int tangshiMealsCount;

// 请求数据
@property (nonatomic, strong)NSArray * payMathLiat;// 支付方式数组
@property (nonatomic, copy)NSString * payMathListStr;
@property (nonatomic, strong)NSArray * mealIDList;// 筛选菜品id数组
@property (nonatomic, copy)NSString * mealIDListStr;

@property (nonatomic, copy)NSString * startDate;
@property (nonatomic, copy)NSString * endDate;
@property (nonatomic, strong)NSDictionary * requestParametersDic;


@property (nonatomic, strong)NSMutableArray * selectsdArr;

// 导航条头部控件
@property (nonatomic, strong)UISegmentedControl * segment;
@property (nonatomic, strong)UIView * segmentView;

// 筛选主界面
@property (nonatomic, strong)UITableView * tableView;
@property (nonatomic, strong)NSMutableArray * mealsStatisticalArray;// 菜品统计信息数据
@property (nonatomic, assign)int page;
@property (nonatomic, strong)NSNumber * allCount;


@end

@implementation StatisticalReportsViewController
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)waimaiArray
{
    if (!_waimaiArray) {
        self.waimaiArray = [NSMutableArray array];
    }
    return _waimaiArray;
}
- (NSMutableArray *)tangshiArray
{
    if (!_tangshiArray) {
        self.tangshiArray = [NSMutableArray array];
    }
    return _tangshiArray;
}

- (NSMutableArray *)selectsdArr
{
    if (!_selectsdArr) {
        self.selectsdArr = [NSMutableArray array];
    }
    return _selectsdArr;
}

- (NSMutableArray *)mealsStatisticalArray
{
    if (!_mealsStatisticalArray) {
        self.mealsStatisticalArray = [NSMutableArray array];
    }
    return _mealsStatisticalArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
//    UIImageView * leftImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 44)];
//    leftImageView.image = [UIImage imageNamed:@"back.png"];
//    UITapGestureRecognizer * backTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backLastVC:)];
//    leftImageView.userInteractionEnabled = YES;
//    [leftImageView addGestureRecognizer:backTap];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftImageView];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backLastVC:)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"筛选" style:UIBarButtonItemStyleDone target:self action:@selector(screeningAction:)];
    NSDictionary * seletedTextAttribute = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:16], NSForegroundColorAttributeName:[UIColor blackColor]};
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:seletedTextAttribute forState:UIControlStateNormal];
    
    [self addHearderView];
    
    self.payMathLiat =[NSArray array];
    self.mealIDList = [NSArray array];
    self.startDate = @"";
    self.endDate = @"";
    self.payMathListStr = @"";
    self.mealIDListStr = @"";
    
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 10, self.view.width, self.view.height - 64)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    _page = 1;
    [_tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    [_tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    _tableView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    [self.tableView registerClass:[MealStatisticalTableViewCell class] forCellReuseIdentifier:CELL_IDENTIFIER];
    [self.view addSubview:self.tableView];
    
    self.stastView = [[StatisticalReportsView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    
    NSDictionary * jsonDic = @{
                               @"UserId":[UserInfo shareUserInfo].userId,
                               @"Command":@31,
                               @"Type":@(1),
                               };
    [self playPostWithDictionary:jsonDic];
    
    [self downloadDataWithCommand:@88 page:_page count:COUNT];
    
    [SVProgressHUD showWithStatus:@"更新数据..." maskType:SVProgressHUDMaskTypeBlack];
}
- (void)backLastVC:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addHearderView
{
    UIView * hearderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width - self.navigationItem.leftBarButtonItem.customView.bounds.size.width - self.navigationItem.rightBarButtonItem.customView.bounds.size.width, HEARDERVIEW_HEIGHT)];
    hearderView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    
    hearderView.autoresizesSubviews = YES;
    hearderView.backgroundColor = [UIColor clearColor];
    self.segment = [[UISegmentedControl alloc] initWithItems:@[@"外  卖", @"堂  食"]];
    
    self.segment.tintColor = [UIColor clearColor];//去掉颜色,现在整个segment都看不见
    self.segment.backgroundColor = [UIColor whiteColor];;
    //    self.segment.tintColor = [UIColor colorWithRed:222.0/255.0 green:7.0/255.0 blue:28.0/255.0 alpha:1.0];
    NSDictionary* selectedTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:16],
                                             NSForegroundColorAttributeName: BACKGROUNDCOLOR};
    [self.segment setTitleTextAttributes:selectedTextAttributes forState:UIControlStateSelected];//设置文字属性
    NSDictionary* unselectedTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:16],
                                               NSForegroundColorAttributeName: [UIColor grayColor]};
    [self.segment setTitleTextAttributes:unselectedTextAttributes forState:UIControlStateNormal];
    
    self.segment.selectedSegmentIndex = 0;
    self.segment.layer.cornerRadius = 5;
    NSLog(@"***%f**%f, ^^^%f", hearderView.center.x, self.navigationItem.rightBarButtonItem.customView.bounds.size.width, hearderView.width / 2 - 60);
    _segment.frame = CGRectMake( hearderView.center.x - 44 - 60, 15, 120, 30);
    [_segment addTarget:self action:@selector(changeDeliveryState:) forControlEvents:UIControlEventValueChanged];
    
    self.segmentView = [[UIView alloc]initWithFrame:CGRectMake(20, 50, 50, 2)];
    self.segmentView.backgroundColor = [UIColor orangeColor];
    
    [hearderView addSubview:_segment];
    //    [hearderView addSubview:_segmentView];
    
    UINavigationBar * bar = self.navigationController.navigationBar;
    //    [bar setShadowImage:[UIImage imageNamed:@"1px.png"]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"1px.png"] forBarMetrics:UIBarMetricsDefault];
    
    self.navigationItem.titleView = hearderView;
}


- (void)changeDeliveryState:(UISegmentedControl *)segment
{
    if (segment.selectedSegmentIndex) {
//        [self downloadDataWithCommand:@88 page:_page count:COUNT];
        
        [self.tableView headerBeginRefreshing];
        [UIView animateWithDuration:0.35 animations:^{
            _segmentView.frame = CGRectMake(70, 50, 50, 2);
            
        }];
        
        
        if (self.tangshiArray.count != 0) {
            self.dataArray = self.tangshiArray;
        }else
        {
            
            NSDictionary * jsonDic = @{
                                       @"UserId":[UserInfo shareUserInfo].userId,
                                       @"Command":@31,
                                       @"Type":@(2),
                                       };
            [self playPostWithDictionary:jsonDic];
        }
    }else
    {
        [self.tableView headerBeginRefreshing];
//        [self downloadDataWithCommand:@88 page:_page count:COUNT];
        [UIView animateWithDuration:0.35 animations:^{
            _segmentView.frame = CGRectMake(20, 50, 50, 2);
            
        }];
        
        if (self.waimaiArray.count != 0) {
            self.dataArray = self.waimaiArray;
        }else
        {
            
            NSDictionary * jsonDic = @{
                                       @"UserId":[UserInfo shareUserInfo].userId,
                                       @"Command":@31,
                                       @"Type":@(1),
                                       };
            [self playPostWithDictionary:jsonDic];
        }
        
    }
    
}

#pragma mark - 刷新
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
    _page = 1;
    [self downloadDataWithCommand:@88 page:_page count:COUNT];
    
}


- (void)footerRereshing
{
    [self tableViewEndRereshing];
    
    if (self.segment.selectedSegmentIndex == 0) {
        
        if (self.mealsStatisticalArray.count < _waimaimealsCount) {
            self.tableView.footerRefreshingText = @"正在加载数据";
            [self downloadDataWithCommand:@88 page:++_page count:COUNT];
        }else
        {
            self.tableView.footerRefreshingText = @"数据已经加载完";
            [self.tableView performSelector:@selector(footerEndRefreshing) withObject:nil afterDelay:1];
        }
    }else
    {
        if (self.mealsStatisticalArray.count < _tangshiMealsCount) {
            self.tableView.footerRefreshingText = @"正在加载数据";
            [self downloadDataWithCommand:@88 page:++_page count:COUNT];
        }else
        {
            self.tableView.footerRefreshingText = @"数据已经加载完";
            [self.tableView performSelector:@selector(footerEndRefreshing) withObject:nil afterDelay:1];
        }
    }
    
    
}

#pragma mark - 数据请求
- (void)downloadDataWithCommand:(NSNumber *)command page:(int)page count:(int)count
{
    if (self.segment.selectedSegmentIndex) {
        NSDictionary * jsonDic = @{
                                   @"UserId":[UserInfo shareUserInfo].userId,
                                   @"CurPage":[NSNumber numberWithInt:page],
                                   @"Command":command,
                                   @"CurCount":[NSNumber numberWithInt:count],
                                   @"StartDate":_startDate,
                                   @"EndDate":_endDate,
                                   @"PayMathList":_payMathListStr,
                                   @"MealList":_mealIDListStr,
                                   @"StatisticalType":@2
                                   };
        [self playPostWithDictionary:jsonDic];
    }else
    {
        NSDictionary * jsonDic = @{
                                   @"UserId":[UserInfo shareUserInfo].userId,
                                   @"CurPage":[NSNumber numberWithInt:page],
                                   @"Command":command,
                                   @"CurCount":[NSNumber numberWithInt:count],
                                   @"StartDate":_startDate,
                                   @"EndDate":_endDate,
                                   @"PayMathList":_payMathListStr,
                                   @"MealList":_mealIDListStr,
                                   @"StatisticalType":@1
                                   };
        [self playPostWithDictionary:jsonDic];
    }
}
- (void)playPostWithDictionary:(NSDictionary *)dic
{
    NSString * jsonStr = [dic JSONString];
    NSLog(@"%@", jsonStr);
    NSString * str = [NSString stringWithFormat:@"%@231618", jsonStr];
    NSString * md5Str = [str md5];
    NSString * urlString = [NSString stringWithFormat:@"%@%@",  POST_URL, md5Str];
    
    HTTPPost * httpPost = [HTTPPost shareHTTPPost];
    [httpPost post:urlString HTTPBody:[jsonStr dataUsingEncoding:NSUTF8StringEncoding]];
    httpPost.delegate = self;
}
- (void)refresh:(id)data
{
    [SVProgressHUD dismiss];
    NSLog(@"——————%@", [data description]);
    if ([[data objectForKey:@"Result"] isEqualToNumber:@1]) {
        NSNumber * command = [data objectForKey:@"Command"];
        if ([command isEqualToNumber:@10031])
        {
            //            if (self.dataArray.count != 0) {
            //                [self.dataArray removeAllObjects];
            //            }
            NSArray * array = [data objectForKey:@"FoodList"];
            if (![array isKindOfClass:[NSNull class]]) {
                for (NSDictionary * dic in array) {
                    MenuActivityMD * menu = [[MenuActivityMD alloc] initWithDictionary:dic];
                    
                    if (self.segment.selectedSegmentIndex ) {
                        [self.tangshiArray addObject:menu];
                        self.dataArray = self.tangshiArray;
                        self.tangshiMealsCount = self.tangshiArray.count;
                    }else
                    {
                        [self.waimaiArray addObject:menu];
                        self.dataArray = self.waimaiArray;
                        self.waimaimealsCount = self.waimaiArray.count;
                    }
                    
                }
                
            }else{
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"暂无数据"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:2];
            }
            
            //            NSLog(@"array = %@", self.dataArray);
        }else if ([command isEqualToNumber:@10088])
        {
            [self tableViewEndRereshing];
            NSArray * array = [data objectForKey:@"OrderDetailList"];
            if (![array isKindOfClass:[NSNull class]]) {
                
                if (_page == 1) {
                    [self.mealsStatisticalArray removeAllObjects];
                }
                
                for (NSDictionary * dic in array) {
                    MealStatisticalModel * mealModel = [[MealStatisticalModel alloc] initWithDictionary:dic];
                    [self.mealsStatisticalArray addObject:mealModel];
                }
                
                
            }else{
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"暂无数据"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:2];
            }
            
            NSLog(@"self.mealsStatisticalArray.count = %d", self.mealsStatisticalArray.count);
            [self.tableView reloadData];
        }
    }else
    {
        [self tableViewEndRereshing];;
        //        NSLog(@"%@", [data objectForKey:@"ErrorMsg"]);
    }
}

- (void)failWithError:(NSError *)error
{
    [SVProgressHUD dismiss];
    //    AccountViewCell * cell = (AccountViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    //    cell.isBusinessSW.on = !cell.isBusinessSW.isOn;
    //    [self.tableView headerEndRefreshing];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)screeningAction:(UIBarButtonItem *)item
{
    StatisticalReportsView * staview = [[StatisticalReportsView alloc]initWithFrame:CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) DataArray:self.dataArray];
    
    __block StatisticalReportsViewController * statisVC = self;
    [staview screenWithDic:^(NSDictionary *dic) {
//        NSLog(@"***dic = %@", [dic description]);
        statisVC.requestParametersDic = dic;
        _startDate = [dic objectForKey:@"StartDate"];
        _endDate = [dic objectForKey:@"EndDate"];
        _payMathLiat = [dic objectForKey:@"PayTypes"];
        _mealIDList = [dic objectForKey:@"Mealids"];
        
        for (NSNumber * num in _payMathLiat) {
            self.payMathListStr = [self.payMathListStr stringByAppendingString:[NSString stringWithFormat:@"%@,", num]];
        }
        if (self.payMathListStr.length != 0) {
            self.payMathListStr = [self.payMathListStr substringToIndex:self.payMathListStr.length - 1];
        }
        
        for (NSNumber * num in _mealIDList) {
            self.mealIDListStr = [self.mealIDListStr stringByAppendingString:[NSString stringWithFormat:@"%@,", num]];
        }
        if (self.mealIDListStr.length != 0) {
            self.mealIDListStr = [self.mealIDListStr substringToIndex:self.mealIDListStr.length - 1];
        }
        
//        NSLog(@"%@, %@", _mealIDListStr, _payMathListStr);
        
        [statisVC downloadDataWithCommand:@88 page:statisVC.page count:COUNT];
    }];
    
    [staview showinSuperView];
    
}


#pragma mark - tableview Delegate And Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.mealsStatisticalArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MealStatisticalTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER];
    if (nil == cell) {
        cell = [[MealStatisticalTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFIER];
    }
    
    cell.mealStatisticalModel = [self.mealsStatisticalArray objectAtIndex:indexPath.row];
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  77;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 77;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
