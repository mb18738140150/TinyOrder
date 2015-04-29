//
//  AccountViewController.m
//  TinyOrder
//
//  Created by 仙林 on 15/4/8.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "AccountViewController.h"
#import "AccountViewCell.h"
#import "AccountModel.h"
#import "HeaderView.h"
#import "UIViewAdditions.h"
#import "RevenueViewController.h"
#import "BulletinViewController.h"
#import "PrintTestViewController.h"
#import "LoginViewController.h"
#import <AFNetworking.h>

#define CELL_IDENTIFIER @"cell"

@interface AccountViewController ()<HTTPPostDelegate, UIAlertViewDelegate>


@property (nonatomic, strong)NSMutableArray * dataArray;
@property (nonatomic, strong)NSMutableArray * imageArray;

@end

@implementation AccountViewController



- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;
    
    HeaderView * headerView = [[HeaderView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.width, 100)];
    [headerView.exitButton addTarget:self action:@selector(exitLogin:) forControlEvents:UIControlEventTouchUpInside];
    self.tableView.tableHeaderView = headerView;
    [self.tableView registerClass:[AccountViewCell class] forCellReuseIdentifier:CELL_IDENTIFIER];
    self.tableView.rowHeight = 60;
    [self postData:nil];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [self downloadData];
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


- (void)headerRereshing
{
    [self downloadData];
}

- (void)exitLogin:(UIButton *)button
{
    LoginViewController * loginVC = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    UINavigationController * loginNav = [[UINavigationController alloc] initWithRootViewController:loginVC];
    loginNav.navigationBar.translucent = NO;
    [self.navigationController.tabBarController dismissViewControllerAnimated:YES completion:nil];
}

- (void)downloadData
{
    NSDictionary * jsonDic = @{
                               @"UserId":[UserInfo shareUserInfo].userId,
                               @"Command":@6
                               };
    [self playPostWithDictionary:jsonDic];
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
    //    NSLog(@"%@", jsonStr);
    NSString * str = [NSString stringWithFormat:@"%@231618", jsonStr];
    NSString * md5Str = [str md5];
    NSString * urlString = [NSString stringWithFormat:@"http://p.vlifee.com/getdata.ashx?md5=%@",md5Str];
    
    HTTPPost * httpPost = [HTTPPost shareHTTPPost];
    [httpPost post:urlString HTTPBody:[jsonStr dataUsingEncoding:NSUTF8StringEncoding]];
    httpPost.delegate = self;
}

- (void)refresh:(id)data
{
    NSLog(@"++%@", data);
    int command = [[data objectForKey:@"Command"] intValue];
    //    NSDictionary * dataDic = (NSDictionary *)data;
    if ([[data objectForKey:@"Result"] isEqual:@1]) {
        if (command == 10006) {
            AccountModel * accountMD0 = [self.dataArray objectAtIndex:0];
            accountMD0.state = [data objectForKey:@"State"];
            AccountModel * accountMD1 = [self.dataArray objectAtIndex:1];
            accountMD1.detail = [NSString stringWithFormat:@"%@", [data objectForKey:@"TodayOrder"]];
            AccountModel * accountMD2 = [self.dataArray objectAtIndex:2];
            accountMD2.detail = [NSString stringWithFormat:@"%@", [data objectForKey:@"TodayMoney"]];
            [self.tableView reloadData];
        }else if (command == 10020)
        {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"营业状态改变成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }
    }else
    {
        if (command == 10020)
        {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"营业状态改变失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
            AccountViewCell * cell = (AccountViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            cell.isBusinessSW.on = !cell.isBusinessSW.isOn;
        }
    }
    [self.tableView headerEndRefreshing];
}

- (void)failWithError:(NSError *)error
{
    AccountViewCell * cell = (AccountViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    cell.isBusinessSW.on = !cell.isBusinessSW.isOn;
    [self.tableView headerEndRefreshing];
    NSLog(@"%@", error);
}





- (void)postData:(NSString *)urlString
{
    NSArray * array = @[@"是否营业",@"今日订单数", @"今日销售额", @"配置打印蓝牙打印机", @"商家公告", @"收入流水", @"检查更新"];
    for (int i = 0; i < array.count; i++) {
        AccountModel * accountModel = [[AccountModel alloc] init];
        accountModel.title = [array objectAtIndex:i];
        if (i == 1) {
//            accountModel.detail = @"88单";
        }
        if (i == 2) {
//            accountModel.detail = @"594.30元";
        }
        if (i == array.count - 1) {
            NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
            NSString *appVersion = [infoDic objectForKey:@"CFBundleVersion"];
            accountModel.detail = [NSString stringWithFormat:@"当前版本%@", appVersion];
        }
        accountModel.iconName = [NSString stringWithFormat:@"account_%d", i];
        [self.dataArray addObject:accountModel];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AccountModel * accountModel = [self.dataArray objectAtIndex:indexPath.row];
    AccountViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
    if (indexPath.row == 0) {
        [cell createSUbViewAndSwith:self.tableView.bounds];
        [cell.isBusinessSW addTarget:self action:@selector(isDoBusiness:) forControlEvents:UIControlEventValueChanged];
    }else
    {
        [cell createSubView:self.tableView.bounds];
    }
    cell.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.7];
    cell.accountModel = accountModel;
    // Configure the cell...
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    AccountModel * accountModel = [self.dataArray objectAtIndex:indexPath.row];
    switch (indexPath.row) {
        case 3:
        {
            PrintTestViewController * printTestVC = [[PrintTestViewController alloc] init];
            [self.navigationController pushViewController:printTestVC animated:YES];
        }
            break;
        case 4:
        {
            BulletinViewController * bulletinVC = [[BulletinViewController alloc] init];
            bulletinVC.navigationItem.title = accountModel.title;
            [self.navigationController pushViewController:bulletinVC animated:YES];
        }
            break;
        case 5:
        {
            RevenueViewController * revenueVC = [[RevenueViewController alloc] init];
            revenueVC.navigationItem.title = accountModel.title;
            [self.navigationController pushViewController:revenueVC animated:YES];
        }
            break;
        case 6:
        {
            [self checkUpdate];
        }
            break;
        default:
            break;
    }     
}

- (void)checkUpdate
{
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [infoDic objectForKey:@"CFBundleVersion"];
    NSString * urlString = @"http://itunes.apple.com/lookup?id=com.lanou.henan13BLH";
    NSString * str = @"https://itunes.apple.com/cn/app/your-jia-ju-guan/id963720462?mt=8";
    NSString * url = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject = %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@", error);
    }];
//    [manager operationQueue];
}


- (void)isDoBusiness:(UISwitch *)aSwitch
{
    if (aSwitch.isOn) {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"开始营业" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.tag = 1000;
        [alertView show];
    }else
    {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"开始休息" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.tag = 2000;
        [alertView show];
    }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex) {
        if (alertView.tag == 1000) {
            NSDictionary * jsonDic = @{
                                       @"UserId":[UserInfo shareUserInfo].userId,
                                       @"Command":@20,
                                       @"State":@1
                                       };
            [self playPostWithDictionary:jsonDic];
        }else if (alertView.tag == 2000)
        {
            NSDictionary * jsonDic = @{
                                       @"UserId":[UserInfo shareUserInfo].userId,
                                       @"Command":@20,
                                       @"State":@0
                                       };
            [self playPostWithDictionary:jsonDic];
        }
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
