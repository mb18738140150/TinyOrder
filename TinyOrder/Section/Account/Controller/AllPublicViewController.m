//
//  AllPublicViewController.m
//  TinyOrder
//
//  Created by 仙林 on 15/8/31.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "AllPublicViewController.h"
#import "PublicWXViewCell.h"
#import "PublicResultViewController.h"
#import "PublicNumModel.h"
#import "ShopDescribViewController.h"

#define CELL_INDENTIFIER @"cell"

#define CELL_BT_TAG 10000

@interface AllPublicViewController ()<UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate, HTTPPostDelegate>
{
    int _page;
}

@property (nonatomic, strong)UISearchController * searchVC;

@property (nonatomic, strong)PublicResultViewController * resultVC;


@property (nonatomic, strong)NSMutableArray * dataArray;

@end

@implementation AllPublicViewController


- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    self.tableView.backgroundColor = [UIColor colorWithRed:237 / 255.0 green:247 / 255.0 blue:242 / 255.0 alpha:1];
    [self.tableView registerClass:[PublicWXViewCell class] forCellReuseIdentifier:CELL_INDENTIFIER];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//
    
    self.resultVC = [[PublicResultViewController alloc] init];
    _resultVC.action = @selector(searchHotTaglibWithKeyWord:);
    _resultVC.target = self;
    
    self.searchVC = [[UISearchController alloc] initWithSearchResultsController:_resultVC];
    _searchVC.hidesNavigationBarDuringPresentation = NO;
    [self.searchVC.searchBar sizeToFit];
    [self.searchVC.searchBar sizeThatFits:CGSizeMake(150, 30)];

    _searchVC.searchBar.backgroundColor = [UIColor whiteColor];
    //直接将搜索框放到UITableView的headerView上
    self.tableView.tableHeaderView = _searchVC.searchBar;
    self.definesPresentationContext = YES;
    _searchVC.searchResultsUpdater = self;
    _searchVC.searchBar.delegate = self;
    _searchVC.searchResultsUpdater = self.resultVC;
    _searchVC.searchBar.placeholder = @"请输入公众号进行搜索";
    
    _page = 1;
    NSDictionary * jsonDic = @{
                               @"Command":@46,
                               @"UserId":[UserInfo shareUserInfo].userId,
                               @"CurPage":[NSNumber numberWithInt:_page],
                               @"CurCount":[NSNumber numberWithInt:COUNT]
                               };
    
    [self playPostWithDictionary:jsonDic];
    
    
    
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
    PublicNumModel * pubilcNumMD = [self.dataArray objectAtIndex:indexPath.row];
    PublicWXViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_INDENTIFIER];
    cell.publicNumMD = pubilcNumMD;
    cell.applyBT.tag = CELL_BT_TAG + indexPath.row;
    [cell.applyBT addTarget:self action:@selector(applyPublicNum:) forControlEvents:UIControlEventTouchUpInside];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    // Configure the cell...
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
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
    
    NSLog(@"lnk;");
    
    return headerView;
}


- (void)applyPublicNum:(UIButton *)button
{
    PublicNumModel *model = [self.dataArray objectAtIndex:button.tag - CELL_BT_TAG];
    ShopDescribViewController * describVC = [[ShopDescribViewController alloc] init];
    describVC.publicNumModel= model;
    [self.navigationController pushViewController:describVC animated:YES];
}



#pragma mark - 搜索
- (void)searchHotTaglibWithKeyWord:(NSString *)keyWords
{
    self.searchVC.active = NO;
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if (searchBar.text.length) {
        NSDictionary * jsonDic = @{
                                   @"Command":@49,
                                   @"UserId":[UserInfo shareUserInfo].userId,
                                   @"KeyWord":searchBar.text,
                                   };
        [self playPostWithDictionary:jsonDic];
        searchBar.text = nil;
    }else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"搜索内容不能为空" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }
    self.searchVC.active = NO;
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    
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
    httpPost.delegate = self;
}

- (void)refresh:(id)data
{
    [SVProgressHUD dismiss];
    NSLog(@"%@", [data description]);
    if ([[data objectForKey:@"Result"] isEqualToNumber:@1]) {
        if ([[data objectForKey:@"Command"] isEqualToNumber:@10046]) {
            NSArray * array = [data objectForKey:@"PublicNumList"];
//            if (_page == 1) {
//                self.dataArray = nil;
//            }
            if (self.dataArray.count != 0) {
                [self.dataArray removeAllObjects];
            }
            for (NSDictionary * dic in array) {
                PublicNumModel * model = [[PublicNumModel alloc] initWithDictionary:dic];
                [self.dataArray addObject:model];
            }
            NSLog(@"%@", self.dataArray);
            [self.tableView reloadData];
        }else if ([[data objectForKey:@"Command"] isEqualToNumber:@10049])
        {
            if (self.dataArray.count != 0) {
                [self.dataArray removeAllObjects];
            }
            NSArray *array = [data objectForKey:@"PublicNumList"];
            
            for (NSDictionary *dic in array) {
                PublicNumModel *model = [[PublicNumModel alloc]initWithDictionary:dic];
                [self.dataArray addObject:model];
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
