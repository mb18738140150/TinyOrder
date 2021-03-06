//
//  ActivityViewController.m
//  TinyOrder
//
//  Created by 仙林 on 15/7/20.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "ActivityViewController.h"
#import "TypeViewController.h"
#import "ActivityViewCell.h"
#import "ActivityModel.h"
#import "ActivitySortController.h"
#define CELL_INDENTIFER @"cell"

@interface ActivityViewController ()<UITableViewDataSource, UITableViewDelegate, HTTPPostDelegate, UIAlertViewDelegate>


@property (nonatomic, strong)UITableView * activityTableView;
@property (nonatomic, strong)NSMutableArray * dataArray;
@property (nonatomic, strong)ActivityModel *deleteModel;
@property (nonatomic, assign)BOOL isHaveFirst;

@end

@implementation ActivityViewController

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _isHaveFirst = NO;
    
    self.activityTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - self.navigationController.navigationBar.bottom) style:UITableViewStylePlain];
    self.activityTableView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    
    self.activityTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _activityTableView.dataSource = self;
    _activityTableView.delegate = self;
    [_activityTableView registerClass:[ActivityViewCell class] forCellReuseIdentifier:CELL_INDENTIFER];
    [self.view addSubview:_activityTableView];
    
//    UIButton * createAtyBT = [UIButton buttonWithType:UIButtonTypeCustom];
//    createAtyBT.frame = CGRectMake(10, 10, self.view.width - 20, 40);
////    createAtyBT.backgroundColor = [UIColor orangeColor];
//    createAtyBT.layer.cornerRadius = 7;
//    createAtyBT.layer.backgroundColor = [UIColor orangeColor].CGColor;
//    [createAtyBT setTitle:@"创建新活动" forState:UIControlStateNormal];
//    [createAtyBT addTarget:self action:@selector(createNewActivity:) forControlEvents:UIControlEventTouchUpInside];
//    
//    UIView * footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, createAtyBT.height + 20)];
//    [footView addSubview:createAtyBT];
//    self.activityTableView.tableFooterView = footView;
    
    
    
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backLastVC:)];
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(createNewActivity:)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"addicon.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(createNewActivity:)];
    
    // Do any additional setup after loading the view.
}

- (void)backLastVC:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSDictionary * jsonDic = @{
                               @"UserId":[UserInfo shareUserInfo].userId,
                               @"Command":@29
                               };
    [self playPostWithDictionary:jsonDic];
    [SVProgressHUD showWithStatus:@"更新数据..." maskType:SVProgressHUDMaskTypeBlack];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createNewActivity:(UIBarButtonItem *)button
{
    ActivitySortController * activityVC = [[ActivitySortController alloc] init];
    
    for (ActivityModel * model in self.dataArray) {
        //判断是否有首减
        if ([model.actionType intValue] == 2) {
            //判断首减来源
            if ([model.actionSort intValue] == 1) {
                activityVC.isWaimaiFirstCut = YES;
            }else
            {
                activityVC.isTangshiFirstCut = YES;
            }
        }
    }
    
    
    [self.navigationController pushViewController:activityVC animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ActivityViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CELL_INDENTIFER ];
    if (!cell) {
        cell = [[ActivityViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_INDENTIFER];
    }
    [cell.deleteBT addTarget:self action:@selector(deleteActivity:) forControlEvents:UIControlEventTouchUpInside];
    cell.deleteBT.tag = 1000 + indexPath.row;
    cell.activityMD = [self.dataArray objectAtIndex:indexPath.row];
//    [cell cellheightof];
//    NSLog(@"************ %d ************", indexPath.row);
//    cell.textLabel.text = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
        ActivityViewCell *cell = (ActivityViewCell *)[self tableView:self.activityTableView cellForRowAtIndexPath:indexPath];
    
//    [cell cellheightof];
    
//        return cell.frame.size.height;
    
    return [ActivityViewCell cellHeight];
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}


- (void)deleteActivity:(UIButton *)button
{
    ActivityModel * activityMD = [self.dataArray objectAtIndex:button.tag - 1000];
    self.deleteModel = activityMD;
    
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您确定要删除该活动" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex) {
        NSDictionary * jsonDic = @{
                                   @"UserId":[UserInfo shareUserInfo].userId,
                                   @"Command":@32,
                                   @"ActionId":self.deleteModel.actionId
                                   };
        [self playPostWithDictionary:jsonDic];
        [SVProgressHUD showWithStatus:@"删除中..." maskType:SVProgressHUDMaskTypeBlack];
    }else
    {
        
    }
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
    [SVProgressHUD dismiss];
    NSLog(@"%@", data);
    if ([[data objectForKey:@"Result"] isEqualToNumber:@1]) {
        NSNumber * command = [data objectForKey:@"Command"];
        if ([command isEqualToNumber:@10029]) {
            NSArray * array = [data objectForKey:@"ActionList"];
            self.dataArray = nil;
            _isHaveFirst = NO;
            for (NSDictionary * dic in array) {
                ActivityModel * activityMD = [[ActivityModel alloc] initWithDictionary:dic];
                if ([activityMD.actionType isEqualToNumber:@2]) {
                    self.isHaveFirst = YES;
                }
                [self.dataArray addObject:activityMD];
            }
            [self.activityTableView reloadData];
        }else if ([command isEqualToNumber:@10032])
        {
            NSDictionary * jsonDic = @{
                                       @"UserId":[UserInfo shareUserInfo].userId,
                                       @"Command":@29
                                       };
            [self playPostWithDictionary:jsonDic];
            [SVProgressHUD showWithStatus:@"更新数据..." maskType:SVProgressHUDMaskTypeBlack];
        }
    }else
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"失败" message:[data objectForKey:@"ErrorMsg"] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
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



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
