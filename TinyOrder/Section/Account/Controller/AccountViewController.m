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
#import "BulletinTypeViewController.h"
#import "PrintTypeViewController.h"
#import "LoginViewController.h"
#import <AFNetworking.h>
#import "ActivityViewController.h"
#import "CommentViewController.h"
#import "BankCarController.h"
#import "SwithAccountViewCell.h"
#import "PublicWXNumViewController.h"
#import "PersonInformationViewController.h"
#import "StoreCreateViewController.h"
#import <UIImageView+WebCache.h>
#import "VerifyOrderViewController.h"

#define CELL_IDENTIFIER @"cell"
#define SWITH_CELL @"swithCell"

#define SWITH_TAG 3000

@interface AccountViewController ()<HTTPPostDelegate, UIAlertViewDelegate>

@property (nonatomic, strong)PrintTypeViewController *printTypeVC;

@property (nonatomic, strong)NSMutableArray * dataArray;
@property (nonatomic, strong)NSMutableArray * imageArray;

@property (nonatomic, strong)AccountModel *accountModel;

@property (nonatomic, strong)HeaderView * headerView;

@property (nonatomic, copy)NSString * logoURL;
@property (nonatomic, copy)NSString * barcodeURL;

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
    
    // 取消导航栏模糊效果
    self.navigationController.navigationBar.translucent = NO;
//    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:249 / 255.0 green:72 / 255.0 blue:47 / 255.0 alpha:1];
    self.headerView = [[HeaderView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.width, 170)];
    [_headerView.informationButton addTarget:self action:@selector(informationAction:) forControlEvents:UIControlEventTouchUpInside];
    self.tableView.tableHeaderView = _headerView;
    [self.tableView registerClass:[AccountViewCell class] forCellReuseIdentifier:CELL_IDENTIFIER];
    [self.tableView registerClass:[SwithAccountViewCell class] forCellReuseIdentifier:SWITH_CELL];
    self.tableView.rowHeight = 60;
    [self postData:nil];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self downloadData];
    [SVProgressHUD showWithStatus:@"正在加载..." maskType:SVProgressHUDMaskTypeBlack];
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
//    [self.tableView headerBeginRefreshing];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.printTypeVC = [[PrintTypeViewController alloc]init];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"验证" style:UIBarButtonItemStylePlain target:self action:@selector(verifyOrderAction:)];
}

- (void)viewWillAppear:(BOOL)animated
{
    NSDictionary * jsonDic = @{
                               @"Command":@64,
                               @"UserId":[UserInfo shareUserInfo].userId
                               };
    [self playPostWithDictionary:jsonDic];

}


- (void)headerRereshing
{
    [self downloadData];
}

- (void)informationAction:(UIButton *)button
{
//    [[UIApplication sharedApplication] unregisterForRemoteNotifications];
////    LoginViewController * loginVC = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
////    UINavigationController * loginNav = [[UINavigationController alloc] initWithRootViewController:loginVC];
////    loginNav.navigationBar.translucent = NO;
//    [self.navigationController.tabBarController dismissViewControllerAnimated:YES completion:nil];
//    [[NSUserDefaults standardUserDefaults] setValue:@NO forKey:@"haveLogin"];
    
    PersonInformationViewController *personInformationVC = [[PersonInformationViewController alloc]init];
    personInformationVC.phoneNumber = self.accountModel.tel;
    personInformationVC.iconImage= self.headerView.icon.image;
    personInformationVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:personInformationVC animated:YES];
    
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
//        NSLog(@"%@", jsonStr);
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
    NSLog(@"++%@", data);
    int command = [[data objectForKey:@"Command"] intValue];
    //    NSDictionary * dataDic = (NSDictionary *)data;
    if ([[data objectForKey:@"Result"] isEqual:@1]) {
        if (command == 10006) {
             __weak AccountViewController * accountVC = self;
            self.accountModel = [[AccountModel alloc]initWithDictionary:data];
            NSString * logostr = [NSString stringWithFormat:@"http://image.vlifee.com%@", _accountModel.StoreIcon];
            [_headerView.icon sd_setImageWithURL:[NSURL URLWithString:logostr] placeholderImage:[UIImage imageNamed:@"touxiang.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if (image) {
                    accountVC.headerView.icon.image = image;
                }
            }];
            
            
            self.headerView.todayOrderNum.text = [NSString stringWithFormat:@"%d", _accountModel.todayOrder];
            self.headerView.todayMoney.text = [NSString stringWithFormat:@"%.2f", _accountModel.todayMoney];
            self.headerView.bankCardNum.text = [NSString stringWithFormat:@"%d", _accountModel.bankCardCount];
            self.headerView.phoneLabel.text = [NSString stringWithFormat:@"id:%@", [UserInfo shareUserInfo].userId];
            
            int state = [_accountModel.state intValue];
            if (state == 0) {
                self.headerView.storeStateLabel.text = @"休息中";
            }else
            {
                self.headerView.storeStateLabel.text = @"营业中";
            }
            
            AccountModel * accountMD0 = [self.dataArray objectAtIndex:0];
            accountMD0.state = [data objectForKey:@"State"];
            AccountModel * accountMD1 = [self.dataArray objectAtIndex:1];
//            accountMD1.detail = [NSString stringWithFormat:@"%@单", [data objectForKey:@"TodayOrder"]];
            AccountModel * accountMD2 = [self.dataArray objectAtIndex:2];
//            accountMD2.detail = [NSString stringWithFormat:@"%@元", [data objectForKey:@"TodayMoney"]];
            AccountModel * accountMD6 = [self.dataArray objectAtIndex:6];
            accountMD6.detail = [NSString stringWithFormat:@"总%@条评论", [data objectForKey:@"CommentCount"]];
            [self.tableView reloadData];
        }else if (command == 10020)
        {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"营业状态改变成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alertView show];
            [alertView performSelector:@selector(dismiss) withObject:nil afterDelay:1.5];
            if ([self.headerView.storeStateLabel.text isEqualToString:@"休息中"]) {
                self.headerView.storeStateLabel.text = @"营业中";
            }else
            {
                self.headerView.storeStateLabel.text = @"休息中";
            }
            
        }else if (command == 10064)
        {
            self.logoURL = [data objectForKey:@"StoreIcon"];
            self.barcodeURL = [data objectForKey:@"StoreCodeIcon"];
        }
    }else
    {
        if (command == 10020)
        {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"营业状态改变失败" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alertView show];
            [alertView performSelector:@selector(dismiss) withObject:nil afterDelay:1.5];
            AccountViewCell * cell = (AccountViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            cell.isBusinessSW.on = !cell.isBusinessSW.isOn;
        }
    }
    [self.tableView headerEndRefreshing];
}

- (void)failWithError:(NSError *)error
{
    [SVProgressHUD dismiss];
    [self.tableView headerEndRefreshing];
//    AccountViewCell * cell = (AccountViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
//    cell.isBusinessSW.on = !cell.isBusinessSW.isOn;
//    [self.tableView headerEndRefreshing];
    UIAlertView * alertV = [[UIAlertView alloc] initWithTitle:@"提示" message:@"连接服务器失败" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [alertV show];
    [alertV performSelector:@selector(dismiss) withObject:nil afterDelay:1.5];
    NSLog(@"%@", error);
}





- (void)postData:(NSString *)urlString
{
    NSArray * array = @[@"营业状态", @"配置打印机",@"门店信息",  @"商家公告", @"收入流水", @"商家活动", @"查看评价", @"余额提现", @"入驻公众号"];
    for (int i = 0; i < array.count; i++) {
        AccountModel * accountModel = [[AccountModel alloc] init];
        accountModel.title = [array objectAtIndex:i];
        if (i == 1) {
//            accountModel.detail = @"88单";
        }
        if (i == 2) {
//            accountModel.detail = @"594.30元";
        }
//        if (i == array.count - 1) {
//            NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
//            NSString *appVersion = [infoDic objectForKey:@"CFBundleVersion"];
//            accountModel.detail = [NSString stringWithFormat:@"当前版本%@", appVersion];
//        }
        accountModel.StoreIcon = [NSString stringWithFormat:@"account_%d", i];
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
    if (indexPath.row == 0) {
        SwithAccountViewCell * swithCell = [tableView dequeueReusableCellWithIdentifier:SWITH_CELL forIndexPath:indexPath];
        [swithCell createSUbViewAndSwith:self.tableView.bounds];
        [swithCell.isBusinessSW addTarget:self action:@selector(isDoBusiness:) forControlEvents:UIControlEventValueChanged];
        swithCell.isBusinessSW.tag = SWITH_TAG;
        swithCell.backgroundColor = [UIColor whiteColor];
        swithCell.accountModel = accountModel;
        return swithCell;
    }
    AccountViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
//    if (indexPath.row == 0) {
//        [cell createSUbViewAndSwith:self.tableView.bounds];
//        [cell.isBusinessSW addTarget:self action:@selector(isDoBusiness:) forControlEvents:UIControlEventValueChanged];
//        cell.isBusinessSW.tag = SWITH_TAG;
//    }else
//    {
        [cell createSubView:self.tableView.bounds];
//    }
    cell.backgroundColor = [UIColor whiteColor];
    cell.accountModel = accountModel;
    // Configure the cell...
    
    return cell;
}

//- (CGFloat)
//{
//    return 20;
//}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    AccountModel * accountModel = [self.dataArray objectAtIndex:indexPath.row];
    switch (indexPath.row) {
        case 1:
        {
            _printTypeVC.hidesBottomBarWhenPushed = YES;
            _printTypeVC.fromWitchController = 1;
            [self.navigationController pushViewController:_printTypeVC animated:YES];
        }
            break;
        case 2:
        {
            StoreCreateViewController * storVC = [[StoreCreateViewController alloc]init];
            storVC.hidesBottomBarWhenPushed = YES;
            storVC.changestore = 1;
            NSString * logostr = [NSString stringWithFormat:@"http://image.vlifee.com%@", self.logoURL];
            NSString * baStr = [NSString stringWithFormat:@"http://image.vlifee.com%@", self.barcodeURL];
            storVC.logoURL = logostr;
            storVC.barcodeURL = baStr;
            storVC.navigationItem.title = accountModel.title;
            [self.navigationController pushViewController:storVC animated:YES];
        }
            break;
        case 3:
        {
            BulletinTypeViewController * bulletinVC = [[BulletinTypeViewController alloc] init];
            bulletinVC.hidesBottomBarWhenPushed = YES;
//            bulletinVC.navigationItem.title = accountModel.title;
            [self.navigationController pushViewController:bulletinVC animated:YES];
        }
            break;
        case 4:
        {
            RevenueViewController * revenueVC = [[RevenueViewController alloc] init];
            revenueVC.hidesBottomBarWhenPushed = YES;
            revenueVC.navigationItem.title = accountModel.title;
            [self.navigationController pushViewController:revenueVC animated:YES];
        }
            break;
        case 5:
        {
            ActivityViewController * activityVC = [[ActivityViewController alloc] init];
            activityVC.hidesBottomBarWhenPushed = YES;
            activityVC.navigationItem.title = accountModel.title;
            [self.navigationController pushViewController:activityVC animated:YES];
        }
        break;
        case 6:
        {
            CommentViewController * commnetVC = [[CommentViewController alloc] init];
            commnetVC.hidesBottomBarWhenPushed = YES;
            commnetVC.navigationItem.title = accountModel.title;
            [self.navigationController pushViewController:commnetVC animated:YES];
        }
            break;
        case 7:
        {
            BankCarController * bankCarVC = [[BankCarController alloc] init];
            bankCarVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:bankCarVC animated:YES];
        }
            break;
        case 8:
        {
            PublicWXNumViewController * publicWXVC = [[PublicWXNumViewController alloc] init];
            publicWXVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:publicWXVC animated:YES];
        }
            break;
        default:
            break;
    }     
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
        [SVProgressHUD showWithStatus:@"正在修改营业状态..." maskType:SVProgressHUDMaskTypeBlack];
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
    }else
    {
        UISwitch * isBusiness = (UISwitch *)[self.view viewWithTag:SWITH_TAG];
//        isBusiness.on = !isBusiness.isOn;
        [isBusiness setOn:!isBusiness.isOn animated:YES];
//        NSLog(@"%@", isBusiness);
    }
}

#pragma mark - 验证订单
- (void)verifyOrderAction:(UIBarButtonItem *)sender
{
    VerifyOrderViewController * verifyVC = [[VerifyOrderViewController alloc]init];
    
    verifyVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:verifyVC animated:YES];
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
 
 query = AFQueryStringFromParametersWithEncoding(parameters, self.stringEncoding);
  [mutableRequest setHTTPBody:[query dataUsingEncoding:self.stringEncoding]];
}
 
*/

@end
