//
//  VerifyDetaileViewController.m
//  TinyOrder
//
//  Created by 仙林 on 16/2/3.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "VerifyDetaileViewController.h"
#import "VerifyMealCell.h"
#import "VerifyMealModel.h"

#define CELL_IDENTIFIRE @"cellidentifire"

@interface VerifyDetaileViewController ()<HTTPPostDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong)UILabel * totleMoneyLB;
@property (nonatomic, strong)UILabel * totleCountLB;
@property (nonatomic, copy)NSString * autoDate;
@property (nonatomic, strong)UITableView * tableView;
@property (nonatomic, strong)NSMutableArray * dataArray;

@end

@implementation VerifyDetaileViewController

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"扫描记录详情";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"account_left_icon.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backLastVC:)];
    self.view.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    
    UIView * headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 150)];
    headView.backgroundColor = [UIColor colorWithRed:247 /255.0 green:102 / 255.0 blue:69 / 255.0 alpha:1.0];
    [self.view addSubview:headView];
    
    UIView * lineview = [[UIView alloc]initWithFrame:CGRectMake(headView.width / 2, 25, 1, 100)];
    lineview.backgroundColor = [UIColor redColor];
    [headView addSubview:lineview];
    
    UILabel * totleMoneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(lineview.left - headView.width / 2 + 20, lineview.top, headView.width / 2 - 40, 30)];
    totleMoneyLabel.text = @"总金额(元)";
    totleMoneyLabel.textColor = [UIColor whiteColor];
    [headView addSubview:totleMoneyLabel];
    
    self.totleMoneyLB = [[UILabel alloc]initWithFrame:CGRectMake(totleMoneyLabel.left, totleMoneyLabel.bottom, totleMoneyLabel.width, 70)];
    _totleMoneyLB.font = [UIFont systemFontOfSize:40];
    self.totleMoneyLB.textColor = [UIColor whiteColor];
    [headView addSubview:_totleMoneyLB];
    
    UILabel * totleCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(lineview.right + 20, lineview.top, _totleMoneyLB.width, 30)];
    totleCountLabel.text = @"总分数(份)";
    totleCountLabel.textColor = [UIColor whiteColor];
    [headView addSubview:totleCountLabel];
    
    self.totleCountLB = [[UILabel alloc]initWithFrame:CGRectMake(totleCountLabel.left, totleCountLabel.bottom, totleCountLabel.width, 70)];
    _totleCountLB.font = [UIFont systemFontOfSize:40];
    self.totleCountLB.textColor = [UIColor whiteColor];
    [headView addSubview:_totleCountLB];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, headView.bottom, self.view.width, self.view.height - headView.height - 64)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[VerifyMealCell class] forCellReuseIdentifier:CELL_IDENTIFIRE];
    [self.view addSubview:self.tableView];
    
    NSDictionary * dic = @{
                           @"UserId":[UserInfo shareUserInfo].userId,
                           @"Command":@78,
                           @"OrderId":self.orderID
                           };
    [self playPostWithDictionary:dic];
}
- (void)backLastVC:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"tm.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage imageNamed:@"tm.png"]];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:17],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:17],
       NSForegroundColorAttributeName:[UIColor blackColor]}];
    [self.navigationController.navigationBar setShadowImage:nil];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"1px.png"] forBarMetrics:UIBarMetricsDefault];
}

#pragma mark - 数据请求
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
    NSLog(@"data = %@", [data description]);
    
    self.totleMoneyLB.text = [NSString stringWithFormat:@"%.2f", [[data objectForKey:@"TotalMoney"] doubleValue]];
    self.totleCountLB.text = [NSString stringWithFormat:@"%d", [[data objectForKey:@"TotalCount"] intValue]];
    self.autoDate = [NSString stringWithFormat:@"%@", [data objectForKey:@"AutoDate"]];
    
    NSArray * array = [data objectForKey:@"FoodList"];
    self.dataArray = nil;
    for (NSDictionary * dic in array) {
        VerifyMealModel * model  = [[VerifyMealModel alloc] initWithDictionary:dic];
        [self.dataArray addObject:model];
    }
    [self.tableView reloadData];
    
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

#pragma mark - tableView - datasource delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VerifyMealCell * cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIRE forIndexPath:indexPath];
    
    VerifyMealModel * model = [self.dataArray objectAtIndex:indexPath.row];
    cell.verifymealModel = model;
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 80)];
    view1.backgroundColor = [UIColor whiteColor];
    
    UILabel * dateLAbel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, view1.width - 20, 30)];
    dateLAbel.text = [NSString stringWithFormat:@"扫描时间: %@", self.autoDate];
    [view1 addSubview:dateLAbel];
    
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, dateLAbel.bottom, view1.width, 1)];
    line.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    [view1 addSubview:line];
    
    UIView * vline = [[UIView alloc]initWithFrame:CGRectMake(10, line.bottom + 10, 2, 30)];
    vline.backgroundColor = [UIColor colorWithRed:247 /255.0 green:102 / 255.0 blue:69 / 255.0 alpha:1.0];
    [view1 addSubview:vline];
    
    UILabel * detaileLB = [[UILabel alloc]initWithFrame:CGRectMake(vline.right + 10, line.bottom + 5, view1.width - 40, 40)];
    detaileLB.text = @"详情";
    detaileLB.font = [UIFont systemFontOfSize:24];
    [view1 addSubview:detaileLB];
    
    return view1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 80;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
