//
//  VerifyListViewController.m
//  TinyOrder
//
//  Created by 仙林 on 16/2/2.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "VerifyListViewController.h"
#import "VerifyMealCell.h"
#import "VerifyModel.h"
#import "VerifyMealModel.h"

#import "VerifyDetaileViewController.h"

#define CELLIDENTIFIRE @"cellidentifire"

@interface VerifyListViewController ()<HTTPPostDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong)UITableView * tableView;

@property (nonatomic, strong)NSMutableArray * dataArray;

@end

@implementation VerifyListViewController

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
    
    self.navigationItem.title = @"扫描记录列表";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backLastVC:)];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[VerifyMealCell class] forCellReuseIdentifier:CELLIDENTIFIRE];
    self.tableView.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    [self.view addSubview:self.tableView];
    
    NSDictionary * jsonDic = @{
                               @"UserId":[UserInfo shareUserInfo].userId,
                               @"Command":@77,
                               @"StartDate":self.startDate,
                               @"EndDate":self.endDate
                               };
    [self playPostWithDictionary:jsonDic];
    
    
}
- (void)backLastVC:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
    NSLog(@"data = %@", [data description]);
    
    NSArray * array = [data objectForKey:@"LogList"];
    self.dataArray = nil;
    for (NSDictionary * dic in array) {
        VerifyModel * model  = [[VerifyModel alloc] initWithDictionary:dic];
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
        UIAlertView * alerV = [[UIAlertView alloc] initWithTitle:@"提示" message:@"连接服务器失败请重新连接" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alerV show];
//    }
}
#pragma mark - tableView - datasource delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    VerifyModel * model = [self.dataArray objectAtIndex:section];
    return model.VerifyOrderList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VerifyMealCell * cell = [tableView dequeueReusableCellWithIdentifier:CELLIDENTIFIRE forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    VerifyModel * model = [self.dataArray objectAtIndex:indexPath.section];
    VerifyMealModel * mealModel = [model.VerifyOrderList  objectAtIndex:indexPath.row];
    
    cell.verifymealModel = mealModel;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    VerifyModel * model = [self.dataArray objectAtIndex:section];
    UIView * view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 40)];
    view1.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    
    UILabel * timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, view1.width / 2, 30)];
    timeLabel.text = model.orderDate;
    [view1 addSubview:timeLabel];
    
    UILabel * totlemonryLB = [[UILabel alloc]initWithFrame:CGRectMake(view1.width - 190, 5, 90, 30)];
    totlemonryLB.textAlignment = NSTextAlignmentRight;
    totlemonryLB.text = [NSString stringWithFormat:@"总额:%@", model.totalMoney];
    [view1 addSubview:totlemonryLB];
    
    UILabel * countLabel = [[UILabel alloc]initWithFrame:CGRectMake(view1.width - 100, 5, 90, 30)];
    countLabel.textAlignment = NSTextAlignmentRight;
    countLabel.text = [NSString stringWithFormat:@"%d份", model.orderCount];
    [view1 addSubview:countLabel];
    
    return view1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    VerifyModel * model = [self.dataArray objectAtIndex:indexPath.section];
    VerifyMealModel * mealModel = [model.VerifyOrderList  objectAtIndex:indexPath.row];
    
    VerifyDetaileViewController * vc = [[VerifyDetaileViewController alloc]init];
    vc.orderID = mealModel.orderId;
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
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
