//
//  PublicWXNumViewController.m
//  TinyOrder
//
//  Created by 仙林 on 15/8/31.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "PublicWXNumViewController.h"
#import "PublicWXViewCell.h"
#import "AllPublicViewController.h"
#import "PublicNumModel.h"
#import "CertificationStatueViewController.h"

#define CELL_INDENTIFIER @"cell"
@interface PublicWXNumViewController ()<HTTPPostDelegate, UIAlertViewDelegate>


@property (nonatomic, strong)NSMutableArray * dataArray;

@property (nonatomic, strong)PublicNumModel *model;

@property (nonatomic, strong)UILabel * tipLabel;

@end

@implementation PublicWXNumViewController

- (PublicNumModel *)model
{
    if (!_model) {
        self.model = [[PublicNumModel alloc]init];
    }
    return _model;
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewWillAppear:(BOOL)animated
{
    NSDictionary * jsonDic = @{
                               @"Command":@45,
                               @"UserId":[UserInfo shareUserInfo].userId
                               };
    [self playPostWithDictionary:jsonDic];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    self.tableView.backgroundColor = [UIColor colorWithRed:237 / 255.0 green:247 / 255.0 blue:242 / 255.0 alpha:1];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[PublicWXViewCell class] forCellReuseIdentifier:CELL_INDENTIFIER];
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"申请入驻" style:UIBarButtonItemStyleDone target:self action:@selector(pushAllPublicNumVC:)];
    NSDictionary* selectedTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:16],
                                             NSForegroundColorAttributeName: [UIColor blackColor]};
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:selectedTextAttributes forState:UIControlStateNormal];
    
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backLastVC:)];
    
    self.tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 30)];
    _tipLabel.text = @"您暂未入驻公众号";
    _tipLabel.textAlignment = NSTextAlignmentCenter;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}



- (void)backLastVC:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)pushAllPublicNumVC:(id)sender
{
    AllPublicViewController * allPublicVC = [[AllPublicViewController alloc] init];
    [self.navigationController pushViewController:allPublicVC animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    PublicNumModel * publicNumMD = [self.dataArray objectAtIndex:indexPath.row];
    PublicWXViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_INDENTIFIER forIndexPath:indexPath];
    cell.publicNumMD = publicNumMD;
    cell.applyBT.tag = 100000 + indexPath.row;
    [cell.applyBT addTarget:self action:@selector(exitPublicNum:) forControlEvents:UIControlEventTouchUpInside];
    // Configure the cell...
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.dataArray.count) {
        return 40;
    }else
    {
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.dataArray.count) {
        
        UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WINDOW_WIDHT, 40)];
        headerView.backgroundColor = [UIColor whiteColor];
        
        UIFont * font = [UIFont systemFontOfSize:14];
        
        UILabel * titleLB = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 20)];
        titleLB.text = @"公众号名称";
        titleLB.font = font;
        [headerView addSubview:titleLB];
        
        UILabel * scaleLB = [[UILabel alloc] initWithFrame:CGRectMake(WINDOW_WIDHT - 160, 10, 70, 20)];
        scaleLB.text = @"佣金比例";
        scaleLB.font = font;
        [headerView addSubview:scaleLB];
        
        UILabel * deliveryLB = [[UILabel alloc]initWithFrame:CGRectMake(scaleLB.left - 60, scaleLB.top, 40, 20)];
        deliveryLB.text = @"配送";
        deliveryLB.textAlignment = NSTextAlignmentCenter;
        deliveryLB.font = font;
        [headerView addSubview:deliveryLB];
        
        UILabel * operateLB = [[UILabel alloc] initWithFrame:CGRectMake(WINDOW_WIDHT - 60, 10, 50, 20)];
        operateLB.text = @"操作";
        operateLB.font = font;
        operateLB.textAlignment = NSTextAlignmentRight;
        [headerView addSubview:operateLB];
        return headerView;
    }else
    {
        UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WINDOW_WIDHT, 0)];
        return headerView;
    }
    
}


#pragma mark -- 数据请求
- (void)playPostWithDictionary:(NSDictionary *)dic
{
    NSString * jsonStr = [dic JSONString];
    NSLog(@"--%@", jsonStr);
    NSString * str = [NSString stringWithFormat:@"%@231618", jsonStr];
    NSString * md5Str = [str md5];
    NSString * urlString = [NSString stringWithFormat:@"%@%@",  POST_URL, md5Str];
    
    HTTPPost * httpPost = [HTTPPost shareHTTPPost];
    [httpPost post:urlString HTTPBody:[jsonStr dataUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"urlstring = %@ , str = %@" , urlString , str);
    httpPost.delegate = self;
}

- (void)refresh:(id)data
{
    [SVProgressHUD dismiss];
    NSLog(@"%@", data);
    if ([[data objectForKey:@"Result"] isEqualToNumber:@1]) {
        if ([[data objectForKey:@"Command"] isEqualToNumber:@10045]) {
            NSArray * array = [data objectForKey:@"PublicNumList"];
            self.dataArray = nil;
            NSMutableArray * didCheckAry = [NSMutableArray array];
            NSMutableArray * willChekAry = [NSMutableArray array];
            for (NSDictionary * dic in array) {
                PublicNumModel * model = [[PublicNumModel alloc] initWithDictionary:dic];
                model.isApply = @1;
                
//                if ([model.numState isEqualToNumber:@1]) {
//                    [didCheckAry addObject:model];
//                }else
//                {
//                    [willChekAry addObject:model];
//                }
                [self.dataArray addObject:model];
            }
//            if (didCheckAry.count) {
//                [self.dataArray addObject:didCheckAry];
//            }
//            if (willChekAry.count) {
//                [self.dataArray addObject:willChekAry];
//            }
            
            if (self.dataArray.count == 0) {
                self.tableView.tableHeaderView = self.tipLabel;
            }else
            {
                [self.tableView.tableHeaderView removeAllSubviews];
                self.tableView.tableHeaderView = nil;
            }
            
            [self.tableView reloadData];
         }else if ([[data objectForKey:@"Command"] isEqualToNumber:@10048])
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"退出申请成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
            
            NSDictionary * jsonDic = @{
                                       @"Command":@45,
                                       @"UserId":[UserInfo shareUserInfo].userId
                                       };
            [self playPostWithDictionary:jsonDic];
            
        }
    }else
    {
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:[data objectForKey:@"ErrorMsg"] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:2];
        
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.tableView reloadData];
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

#pragma mark - 退出申请
- (void)exitPublicNum:(UIButton *)button
{
//    NSInteger section = (button.tag - 100000) / 1000;
    NSInteger row = button.tag - 100000;
    
    PublicNumModel *model = [self.dataArray objectAtIndex:row];
    self.model = model;
    NSInteger numState = [model.numState integerValue];
    if (numState != 2) {
        NSDictionary *jsonDic = @{
                                  @"Command":@48,
                                  @"UserId":[UserInfo shareUserInfo].userId,
                                  @"NumId":model.numId
                                  };
        [self playPostWithDictionary:jsonDic];
    }else{
        
        CertificationStatueViewController *certificationVC = [[CertificationStatueViewController alloc]init];
        certificationVC.publicNumModel = self.model;
        [self.navigationController pushViewController:certificationVC animated:YES];
        
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
