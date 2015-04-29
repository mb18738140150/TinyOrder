//
//  NewOrdersViewController.m
//  TinyOrder
//
//  Created by 仙林 on 15/4/8.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "NewOrdersViewController.h"
#import "NewOrdersiewCell.h"
#import "GeneralBlueTooth.h"
#import "BluetoothViewController.h"
#import "NewOrderModel.h"
#import "Meal.h"

#define CELL_IDENTIFIER @"cell"
#define DEALBUTTON_TAG 1000
#define NULLIYBUTTON_TAG 2000

@interface NewOrdersViewController ()<HTTPPostDelegate>

@property (nonatomic, strong)NSMutableArray * dataArray;
@property (nonatomic, assign)int page;
@property (nonatomic, strong)NSNumber * allCount;
@property (nonatomic, assign)NSInteger printRow;

@end

@implementation NewOrdersViewController


- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getPush:) name:@"push" object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)getPush:(NSNotification *)noti
{
    int count = [self.navigationController.tabBarItem.badgeValue intValue];
    if (self.navigationController.tabBarItem.badgeValue) {
        self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d", ++count];
    }else
    {
        self.navigationController.tabBarItem.badgeValue = @"1";
    }
    NSLog(@"%@", [noti userInfo]);
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.navigationController.tabBarItem.badgeValue = @"123";
    
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    [self.tableView registerClass:[NewOrdersiewCell class] forCellReuseIdentifier:CELL_IDENTIFIER];
    [self.tableView headerBeginRefreshing];
//    [self downloadDataWithCommand:@3 page:1 count:COUNT];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)headerRereshing
{
    [self tableViewEndRereshing];
//    [self.tableView footerEndRefreshing];
//    self.navigationController.tabBarItem.badgeValue = nil;
    _page = 1;
//    self.dataArray = nil;
    [self downloadDataWithCommand:@3 page:_page count:COUNT];
}


- (void)footerRereshing
{
    [self tableViewEndRereshing];
    if (self.dataArray.count < [_allCount integerValue]) {
        self.tableView.footerRefreshingText = @"正在加载数据";
        [self downloadDataWithCommand:@3 page:++_page count:COUNT];
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
    NSString * str = [NSString stringWithFormat:@"%@231618", jsonStr];
    NSString * md5Str = [str md5];
    NSString * urlString = [NSString stringWithFormat:@"http://p.vlifee.com/getdata.ashx?md5=%@",md5Str];
    
    HTTPPost * httpPost = [HTTPPost shareHTTPPost];
    [httpPost post:urlString HTTPBody:[jsonStr dataUsingEncoding:NSUTF8StringEncoding]];
    httpPost.delegate = self;
}

- (void)refresh:(id)data
{
    [self tableViewEndRereshing];
    NSLog(@"%@  error = %@", data, [data objectForKey:@"ErrorMsg"]);
    //    NSDictionary * dataDic = (NSDictionary *)data;
    if ([[data objectForKey:@"Result"] isEqual:@1]) {
        int command = [[data objectForKey:@"Command"] intValue];
        if (command == 10003) {
            self.allCount = [data objectForKey:@"AllCount"];
            self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld", [self.allCount integerValue]];
            if (_page == 1) {
                self.dataArray = nil;
            }
            NSArray * array = [data objectForKey:@"OrderList"];
            for (NSDictionary * dic in array) {
                NewOrderModel * newOrder = [[NewOrderModel alloc] initWithDictionary:dic];
                [self.dataArray addObject:newOrder];
            }
            [self.tableView reloadData];
        }else if(command == 10015)
        {
            NewOrdersiewCell * cell = (NewOrdersiewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.printRow inSection:0]];
            NewOrderModel * order = [self.dataArray objectAtIndex:self.printRow];
            NSString * printStr = [cell getPrintStringWithMealCount:order.mealArray.count];
            [[GeneralBlueTooth shareGeneralBlueTooth] printWithString:printStr];
            [self.tableView headerBeginRefreshing];
        }else if (command == 10023)
        {
            [self.tableView headerBeginRefreshing];
        }
        NSLog(@"11%@", self.dataArray);
    }
}

- (void)failWithError:(NSError *)error
{
    NSLog(@"%@", error);
    [self tableViewEndRereshing];
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
    NewOrderModel * newOrder = [self.dataArray objectAtIndex:indexPath.row];
    newOrder.orderNum = [NSString stringWithFormat:@"%ld", indexPath.row + 1];
    NewOrdersiewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
//    [cell createSubView:self.tableView.bounds mealCoutn:3];
    [cell createSubView:self.tableView.bounds mealCoutn:newOrder.mealArray.count];
    [cell.dealButton addTarget:self action:@selector(dealAndPrint:) forControlEvents:UIControlEventTouchUpInside];
    [cell.nulliyButton addTarget:self action:@selector(nulliyOrder:) forControlEvents:UIControlEventTouchUpInside];
    cell.dealButton.tag = indexPath.row + DEALBUTTON_TAG;
    cell.nulliyButton.tag = indexPath.row + NULLIYBUTTON_TAG;
    cell.orderModel = newOrder;
//    cell.textLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
//    cell.backgroundColor = [UIColor blueColor];

    // Configure the cell...
    
    return cell;
}

- (void)dealAndPrint:(UIButton *)button
{
    self.printRow = button.tag - DEALBUTTON_TAG;
//    NewOrdersiewCell * cell = (NewOrdersiewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:button.tag - DEALBUTTON_TAG inSection:0]];
    NewOrderModel * order = [self.dataArray objectAtIndex:button.tag - DEALBUTTON_TAG];
    if ([GeneralBlueTooth shareGeneralBlueTooth].myPeripheral.state) {
//        NSString * printStr = [cell getPrintStringWithMealCount:order.mealArray.count];
//        [[GeneralBlueTooth shareGeneralBlueTooth] printWithString:printStr];
        NSDictionary * jsonDic = @{
                                   @"UserId":[UserInfo shareUserInfo].userId,
                                   @"Command":@15,
                                   @"OrderId":order.orderId
                                   };
        [self playPostWithDictionary:jsonDic];
    }else
    {
        BluetoothViewController * bluetoothVC = [[BluetoothViewController alloc] init];
        [self.navigationController pushViewController:bluetoothVC animated:YES];
    }
}

- (void)nulliyOrder:(UIButton *)button
{
    NewOrderModel * order = [self.dataArray objectAtIndex:button.tag - NULLIYBUTTON_TAG];
    NSDictionary * jsonDic = @{
                               @"UserId":[UserInfo shareUserInfo].userId,
                               @"Command":@23,
                               @"OrderId":order.orderId
                               };
    [self playPostWithDictionary:jsonDic];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewOrderModel * newOrder = [self.dataArray objectAtIndex:indexPath.row];
    return [NewOrdersiewCell cellHeightWithMealCount:newOrder.mealArray.count];
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}


- (NSString *)getPrintStringWithNewOrder:(NewOrderModel *)order
{
    NSString * lineStr = @"--------------------------------\r";
    NSMutableString * str = [NSMutableString string];
    [str appendFormat:@"%@    微生活外卖\r", order.orderNum];
    [str appendFormat:@"店铺:%@\r%@", [UserInfo shareUserInfo].userName, lineStr];
    [str appendFormat:@"%@\r%@", order.orderTime, lineStr];
    //    [str appendFormat:@"%@\r", self.orderView.expectLabel.text];
    [str appendFormat:@"%@\r", order.address];
    [str appendFormat:@"%@\r", order.contect];
    [str appendFormat:@"%@\r%@", order.tel, lineStr];
    //    [str appendFormat:@"%@\r", self.menuView.numMenuLabel.text];
    for (Meal * meal in order.mealArray) {
        [str appendFormat:@"%@  %@份  %@元\r", meal.name, meal.count, meal.money];
    }
    [str appendString:lineStr];
    [str appendFormat:@"配送费           %@\r%@", order.otherMoney, lineStr];
    [str appendFormat:@"总计     %@     已付款\r%@", order.allMoney, lineStr];
    [str appendFormat:@"\n\n\n"];
    return [str copy];
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
