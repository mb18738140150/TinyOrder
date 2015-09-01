//
//  BankCarController.m
//  TinyOrder
//
//  Created by 仙林 on 15/7/28.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "BankCarController.h"
#import "BankViewCell.h"
#import "AddBankViewController.h"
#import "WithdrawalViewController.h"
#import "BankCarModel.h"

#define CELL_INDENTIFIER @"CELL"

@interface BankCarController ()<HTTPPostDelegate>

@property (nonatomic, copy)NSString * verifyName;

@property (nonatomic, strong)NSMutableArray * dataArray;

@end

@implementation BankCarController

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[BankViewCell class] forCellReuseIdentifier:CELL_INDENTIFIER];
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    UIView * footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.width, 70)];
    footView.backgroundColor = [UIColor whiteColor];
    
    
    UIButton * addBankCarBT = [UIButton buttonWithType:UIButtonTypeCustom];
    addBankCarBT.frame = CGRectMake(10, 15, footView.width - 20, 40);
    [addBankCarBT setImage:[UIImage imageNamed:@"addBank.png"] forState:UIControlStateNormal];
    [addBankCarBT setTitle:@"添加银行卡" forState:UIControlStateNormal];
    addBankCarBT.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    addBankCarBT.contentEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    addBankCarBT.backgroundColor = [UIColor orangeColor];
    [addBankCarBT addTarget:self action:@selector(addBankCarAciton:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:addBankCarBT];
    self.tableView.tableFooterView = footView;
    
    
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backLastVC:)];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)backLastVC:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSDictionary * jsonDic = @{
                               @"Command":@35,
                               @"UserId":[UserInfo shareUserInfo].userId
                               };
    [self playPostWithDictionary:jsonDic];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addBankCarAciton:(UIButton *)button
{
    AddBankViewController * addBankVC = [[AddBankViewController alloc] init];
    addBankVC.verifyName = self.verifyName;
    [self.navigationController pushViewController:addBankVC animated:YES];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BankViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_INDENTIFIER forIndexPath:indexPath];
    cell.bankCarMD = [self.dataArray objectAtIndex:indexPath.row];
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [BankViewCell cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WithdrawalViewController * withdrawalVC = [[WithdrawalViewController alloc] init];
    withdrawalVC.bankCarMD = [self.dataArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:withdrawalVC animated:YES];
}


- (void)playPostWithDictionary:(NSDictionary *)dic
{
    NSString * jsonStr = [dic JSONString];
    NSLog(@"--%@", jsonStr);
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
    NSLog(@"%@", data);
    if ([[data objectForKey:@"Result"] isEqualToNumber:@1]) {
        if ([[data objectForKey:@"Command"] isEqualToNumber:@10035]) {
            self.verifyName = [data objectForKey:@"VerifyName"];
            NSArray * array = [data objectForKey:@"BankCardList"];
            self.dataArray = nil;
            for (NSDictionary * dic in array) {
                BankCarModel * bankCarMD  = [[BankCarModel alloc] initWithDictionary:dic];
                NSLog(@"carNum = %@", bankCarMD.bankCardNumber);
                [self.dataArray addObject:bankCarMD];
            }
            [self.tableView reloadData];
        }
    }else
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:[data objectForKey:@"ErrorMsg"] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:2];
    }
}

- (void)failWithError:(NSError *)error
{
    [SVProgressHUD dismiss];
    //    AccountViewCell * cell = (AccountViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    //    cell.isBusinessSW.on = !cell.isBusinessSW.isOn;
    //    [self.tableView headerEndRefreshing];
    UIAlertView * alertV = [[UIAlertView alloc] initWithTitle:@"提示" message:@"连接服务器失败" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [alertV show];
    [alertV performSelector:@selector(dismiss) withObject:nil afterDelay:1.5];
    NSLog(@"%@", error);
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
