//
//  MenuClassifyViewController.m
//  TinyOrder
//
//  Created by 仙林 on 15/5/5.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "MenuClassifyViewController.h"
#import "MenuViewCell.h"
#import "MenuModel.h"
//#import "AddMenuCell.h"
#import "AddMenuViewController.h"
#import "EditMenuViewController.h"
#import "DetailsMenuViewController.h"


#define CELL_IDENTIFIER @"cell"

@interface MenuClassifyViewController ()<UITableViewDelegate, UITableViewDataSource,HTTPPostDelegate, UIAlertViewDelegate>


@property (nonatomic, strong)NSMutableArray * dataArray;
@property (nonatomic, assign)int page;
@property (nonatomic, strong)NSNumber * allCount;


@end

@implementation MenuClassifyViewController

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"商品分类";
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editMenuAction:)];
    self.navigationItem.rightBarButtonItem.title = @"编辑";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelMenuEdit:)];
    
    
    
    self.menuTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - self.navigationController.navigationBar.bottom - self.navigationController.tabBarController.tabBar.height - 60) style:UITableViewStylePlain];
    self.menuTableView.delegate = self;
    self.menuTableView.dataSource = self;
//    self.menuTableView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:self.menuTableView];
    NSLog(@"%g, %g", self.navigationController.tabBarController.tabBar.bottom, self.navigationController.tabBarController.tabBar.top);
    UIView * addView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height - self.navigationController.navigationBar.bottom - self.navigationController.tabBarController.tabBar.height - 60, self.view.width, 60)];
//    addView.backgroundColor = [UIColor greenColor];
    UIButton * button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(50, 10, self.view.width - 100, 40);
    [button setTitle:@"添加商品" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(AddMenuAction:) forControlEvents:UIControlEventTouchUpInside];
    button.tintColor = [UIColor whiteColor];
    button.backgroundColor = [UIColor colorWithRed:249 / 255.0 green:72 / 255.0 blue:47 / 255.0 alpha:1];
    [addView addSubview:button];
    [self.view addSubview:addView];
    [self.menuTableView registerClass:[MenuViewCell class] forCellReuseIdentifier:CELL_IDENTIFIER];
    [self.menuTableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    [self.menuTableView addFooterWithTarget:self action:@selector(footerRereshing)];
    _page = 1;
    [self downloadDataWithCommand:@1 page:_page count:COUNT];
//    [self.menuTableView headerBeginRefreshing];
    [SVProgressHUD showWithStatus:@"正在加载..." maskType:SVProgressHUDMaskTypeBlack];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableViewEndRereshing
{
    if (self.menuTableView.isHeaderRefreshing) {
        [self.menuTableView headerEndRefreshing];
    }
    if (self.menuTableView.isFooterRefreshing) {
        [self.menuTableView footerEndRefreshing];
    }
}

- (void)headerRereshing
{
    [self tableViewEndRereshing];
    _page = 1;
    //    self.dataArray = nil;
    [self downloadDataWithCommand:@1 page:_page count:COUNT];
}


- (void)footerRereshing
{
    [self tableViewEndRereshing];
    if (self.dataArray.count < [_allCount integerValue]) {
        self.menuTableView.footerRefreshingText = @"正在加载数据";
        [self downloadDataWithCommand:@1 page:++_page count:COUNT];
    }else
    {
        self.menuTableView.footerRefreshingText = @"数据已经加载完";
        [self.menuTableView performSelector:@selector(footerEndRefreshing) withObject:nil afterDelay:1];
    }
}

- (void)downloadDataWithCommand:(NSNumber *)command page:(int)page count:(int)count
{
    NSDictionary * jsonDic = @{
                               @"UserId":[UserInfo shareUserInfo].userId,
                               @"CurPage":[NSNumber numberWithInt:page],
                               @"Command":command,
                               @"CurCount":[NSNumber numberWithInt:count]
                               };
    [self playPostWithDictionary:jsonDic];
    /*
     NSString * jsonStr = [jsonDic JSONString];
     NSString * str = [NSString stringWithFormat:@"%@231618", jsonStr];
     NSString * md5Str = [str md5];
     //    NSLog(@"////%@", md5Str);
     NSString * urlString = [NSString stringWithFormat:@"http://p.vlifee.com/getdata.ashx?md5=%@",md5Str];
     //    NSString * urlStr = @"http://p.vlifee.com/getdata.ashx";
     //    NSLog(@"++%@", urlString);
     
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
    NSString * urlString = [NSString stringWithFormat:@"%@%@", POST_URL, md5Str];
    
    HTTPPost * httpPost = [HTTPPost shareHTTPPost];
    [httpPost post:urlString HTTPBody:[jsonStr dataUsingEncoding:NSUTF8StringEncoding]];
    httpPost.delegate = self;
}



- (void)refresh:(id)data
{
    NSLog(@"data==%@", data);
    //    NSDictionary * dataDic = (NSDictionary *)data;
    if ([[data objectForKey:@"Result"] isEqual:@1]) {
        int command = [[data objectForKey:@"Command"] intValue];
        if (command == 10001) {
            [SVProgressHUD dismiss];
            self.allCount = [data objectForKey:@"AllCount"];
            if (_page == 1) {
                self.dataArray = nil;
            }
            NSArray * menuArray = [data objectForKey:@"ClassifyList"];
            for (NSDictionary * dic in menuArray) {
                MenuModel * menuMD = [[MenuModel alloc] initWithDictionary:dic];
                [self.dataArray addObject:menuMD];
            }
        }else if (command == 10008)
        {
            [self downloadDataWithCommand:@1 page:1 count:(int)self.dataArray.count + 1];
            self.dataArray = nil;
        }
        [self.menuTableView reloadData];
    }else
    {
        [SVProgressHUD dismiss];
        int command = [[data objectForKey:@"Command"] intValue];
        if (command == 10008) {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"添加菜类失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            alertView.tag = 10008;
            [alertView show];
        }
        if (command == 10001) {
            UIAlertView * alerV = [[UIAlertView alloc] initWithTitle:@"提示" message:@"暂无数据" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alerV show];
        }
    }
    [self tableViewEndRereshing];
    NSLog(@"%@", [data objectForKey:@"ErrorMsg"]);
}

- (void)failWithError:(NSError *)error
{
    [SVProgressHUD dismiss];
    [self tableViewEndRereshing];
    NSLog(@"%@", error);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.menuTableView reloadData];
}

- (void)editMenuAction:(id)sender
{
    EditMenuViewController * editMenuVC = [[EditMenuViewController alloc] init];
    editMenuVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:editMenuVC animated:YES];
    //    self.hidesBottomBarWhenPushed = NO;
}

- (void)cancelMenuEdit:(UIBarButtonItem *)barButton
{
    
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
    
    //    if (indexPath.row == self.dataArray.count) {
    //        AddMenuCell * addMenuCell = [tableView dequeueReusableCellWithIdentifier:@"addCell" forIndexPath:indexPath];
    //        [addMenuCell createSubview:self.tableView.bounds];
    //        [addMenuCell.addButton addTarget:self action:@selector(AddMenuAction:) forControlEvents:UIControlEventTouchUpInside];
    ////        addMenuCell.backgroundColor = [UIColor greenColor];
    //        return addMenuCell;
    //    }
    
    MenuModel * menuModel = [self.dataArray objectAtIndex:indexPath.row];
    MenuViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
    [cell createSubViews:self.view.bounds];
    cell.menuModel = menuModel;
    // Configure the cell...
    //    cell.backgroundColor = [UIColor orangeColor];
    return cell;
}


- (void)AddMenuAction:(UIButton *)button
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"编辑" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.delegate = self;
    alert.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
    [[alert textFieldAtIndex:0] setPlaceholder:@"请输入菜单名"];
    [[alert textFieldAtIndex:1] setPlaceholder:@"请输入活动名"];
    [alert textFieldAtIndex:1].secureTextEntry = NO;
    [alert show];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MenuModel * menuMD = [self.dataArray objectAtIndex:indexPath.row];
    DetailsMenuViewController * detailsMenuVC = [[DetailsMenuViewController alloc] init];
    detailsMenuVC.classifyId = menuMD.classifyId;
    detailsMenuVC.hidesBottomBarWhenPushed = YES;
    detailsMenuVC.navigationItem.title = menuMD.name;
    [self.navigationController pushViewController:detailsMenuVC animated:YES];
    //    NSLog(@"%ld", indexPath.row);
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.dataArray.count) {
        return 60;
    }
    return [MenuViewCell cellHeight];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSDictionary * jsonDic = @{
                                   @"UserId":[UserInfo shareUserInfo].userId,
                                   @"ClassifyName":[alertView textFieldAtIndex:0].text,
                                   @"Command":@8
                                   };
        [self playPostWithDictionary:jsonDic];
        [SVProgressHUD showWithStatus:@"正在添加分类..." maskType:SVProgressHUDMaskTypeBlack];
    }
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
