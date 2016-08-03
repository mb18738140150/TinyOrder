//
//  RevenueViewController.m
//  TinyOrder
//
//  Created by 仙林 on 15/4/10.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

//收入流水
#import "RevenueViewController.h"
#import "RevenueViewCell.h"
#import "RevewnueModel.h"
#import "PrintRevenueController.h"
#import "OrderDetailsViewController.h"
#import "VPaydetaileViewController.h"

#define CELL_INDENtTIFIER @"cell"

@interface RevenueViewController ()<HTTPPostDelegate>

@property (nonatomic, strong)NSMutableArray * dataArray;
@property (nonatomic, assign)int page;
@property (nonatomic, strong)NSNumber * allCount;



@end

@implementation RevenueViewController


- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self.tableView registerClass:[RevenueViewCell class] forCellReuseIdentifier:CELL_INDENtTIFIER];
    
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    [self.tableView headerBeginRefreshing];
    self.tableView.tableFooterView = [[UIView alloc] init];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backLastVC:)];
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"申请入驻" style:UIBarButtonItemStyleDone target:self action:@selector(pushAllPublicNumVC:)];
//    NSDictionary* selectedTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:16],
//                                             NSForegroundColorAttributeName: [UIColor blackColor]};
//    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:selectedTextAttributes forState:UIControlStateNormal];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"打印" style:UIBarButtonItemStyleDone target:self action:@selector(printRevenueAction:)];
    NSDictionary * seletedTextAttribute = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:16], NSForegroundColorAttributeName:[UIColor blackColor]};
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:seletedTextAttribute forState:UIControlStateNormal];
}

- (void)backLastVC:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)printRevenueAction:(UIBarButtonItem *)sender
{
    PrintRevenueController * printRevenueVC = [[PrintRevenueController alloc]init];
    [self.navigationController pushViewController:printRevenueVC animated:YES];
}
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
    //    self.dataArray = nil;
    [self downloadDataWithCommand:@7 page:_page count:COUNT];
}


- (void)footerRereshing
{
    [self tableViewEndRereshing];
    if (self.dataArray.count < [_allCount integerValue]) {
        self.tableView.footerRefreshingText = @"正在加载数据";
        [self downloadDataWithCommand:@7 page:++_page count:COUNT];
    }else
    {
        self.tableView.footerRefreshingText = @"数据已经加载完";
        [self.tableView performSelector:@selector(footerEndRefreshing) withObject:nil afterDelay:1];
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
    NSString * jsonStr = [jsonDic JSONString];
    NSString * str = [NSString stringWithFormat:@"%@231618", jsonStr];
    NSString * md5Str = [str md5];
    //    NSLog(@"////%@", md5Str);
    NSString * urlString = [NSString stringWithFormat:@"%@%@", POST_URL, md5Str];
    HTTPPost * httpPost = [HTTPPost shareHTTPPost];
    [httpPost post:urlString HTTPBody:[jsonStr dataUsingEncoding:NSUTF8StringEncoding]];
    httpPost.delegate = self;
}


- (void)refresh:(id)data
{
    NSLog(@"%@, %@", data, [data objectForKey:@"ErrorMsg"]);
    if ([[data objectForKey:@"Result"] isEqual:@1]) {
        self.allCount = [data objectForKey:@"CurCount"];
        if (_page == 1) {
            if (self.dataArray.count != 0) {
                [self.dataArray removeAllObjects];
            }
        }
        NSArray * dataArray = [data objectForKey:@"FlowList"];
        for (NSDictionary * dic in dataArray) {
            RevewnueModel * revewnue = [[RevewnueModel alloc] initWithDictionary:dic];
            [self.dataArray addObject:revewnue];
        }
        [self.tableView reloadData];
    }else
    {
//        UIAlertView * alerV = [[UIAlertView alloc] initWithTitle:@"提示" message:[data objectForKey:@"ErrorMsg"] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
//        [alerV show];
//        [alerV performSelector:@selector(dismiss) withObject:nil afterDelay:1.5];
    }
    [self tableViewEndRereshing];
}

- (void)failWithError:(NSError *)error
{
    [self tableViewEndRereshing];
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
    RevewnueModel * revewnueMD = [self.dataArray objectAtIndex:indexPath.row];
    RevenueViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_INDENtTIFIER forIndexPath:indexPath];
    [cell createSubView:self.tableView.bounds];
    cell.revewnueMD = revewnueMD;
    
    __block RevenueViewController * reVC = self;
    [cell orderdetailes:^(NSString *ordertype) {
        OrderDetailsViewController * orderVC = [[OrderDetailsViewController alloc]init];
        orderVC.orderID = revewnueMD.orderId;
        if ([ordertype isEqualToString:@"z"]) {
            orderVC.isWaimaiorTangshi = Waimai;
            [reVC.navigationController pushViewController:orderVC animated:YES];
        }else if ([ordertype isEqualToString:@"e"])
        {
            orderVC.isWaimaiorTangshi = Tangshi;
            [reVC.navigationController pushViewController:orderVC animated:YES];
        }else if ([ordertype isEqualToString:@"v"])
        {
            VPaydetaileViewController * vPayVC = [[VPaydetaileViewController alloc]initWithNibName:@"VPaydetaileViewController" bundle:nil];
            vPayVC.orderID = revewnueMD.orderId;
            [reVC.navigationController pushViewController:vPayVC animated:YES];
        }
    }];
    
    // Configure the cell...
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
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
