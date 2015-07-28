//
//  ProcessedViewController.m
//  TinyOrder
//
//  Created by 仙林 on 15/4/8.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "ProcessedViewController.h"
#import "ProcessedViewCell.h"
#import "DealOrderModel.h"


#define CELL_IDENTIFIER @"cell"


#define SEGMENT_HEIGHT 45
#define SEGMENT_WIDTH 287
#define SEGMENT_X self.view.width / 2 - SEGMENT_WIDTH / 2
#define TOP_SPACE 10
#define HEARDERVIEW_HEIGHT TOP_SPACE * 2 + SEGMENT_HEIGHT
#define NUMLB_COLOR [UIColor colorWithRed:120 / 255.0 green:174 / 255.0 blue:38 / 255.0 alpha:1.0].CGColor
#define NUMLB_TEXT_COLOR [UIColor colorWithRed:120 / 255.0 green:174 / 255.0 blue:38 / 255.0 alpha:1.0]
#define DEALBUTTON_TAG 1000
#define NULLIYBUTTON_TAG 2000



@interface ProcessedViewController ()<HTTPPostDelegate>

@property (nonatomic, strong)UILabel * waitNumLB;
@property (nonatomic, strong)UILabel * didNumLB;
@property (nonatomic, strong)UISegmentedControl * segment;
@property (nonatomic, strong)NSIndexPath * seleteIndexPath;


@property (nonatomic, strong)NSMutableArray * dataArray;

@property (nonatomic, assign)int waitDeliveryPage;//代配送当前页
@property (nonatomic, strong)NSNumber * waitDeliveryAllCount;//代配送总个数
@property (nonatomic, strong)NSMutableArray * waitDeliveryArray;//代配送数组

@property (nonatomic, assign)int didDeliveryPage;//已配送当前页
@property (nonatomic, strong)NSNumber * didDeliveryAllCount;//已配送总个数
@property (nonatomic, strong)NSMutableArray * didDeliveryArray;//

@end

@implementation ProcessedViewController


- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


- (NSMutableArray *)waitDeliveryArray
{
    if (!_waitDeliveryArray) {
        self.waitDeliveryArray = [NSMutableArray array];
    }
    return _waitDeliveryArray;
}


- (NSMutableArray *)didDeliveryArray
{
    if (!_didDeliveryArray) {
        self.didDeliveryArray = [NSMutableArray array];
    }
    return _didDeliveryArray;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addHearderView];
    [self.tableView registerClass:[ProcessedViewCell class] forCellReuseIdentifier:CELL_IDENTIFIER];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    self.tableView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    _waitDeliveryPage = 1;
    _didDeliveryPage = 1;
    
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
//    [self.tableView headerBeginRefreshing];
    _didDeliveryPage = 1;
    _waitDeliveryPage = 1;
    [self downloadDataWithCommand:@4 page:1 count:10];
    [SVProgressHUD showWithStatus:@"正在加载..." maskType:SVProgressHUDMaskTypeBlack];
    [self downloadDataWithCommand:@21 page:1 count:10];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)addHearderView
{
    self.segment = [[UISegmentedControl alloc] initWithItems:@[@"", @""]];
    _segment.tintColor = [UIColor clearColor];
    [_segment setImage:[[UIImage imageNamed:@"delivery_s.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forSegmentAtIndex:0];
    [_segment setImage:[[UIImage imageNamed:@"didDelivery_n.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forSegmentAtIndex:1];
    _segment.frame = CGRectMake(SEGMENT_X, TOP_SPACE, SEGMENT_WIDTH, SEGMENT_HEIGHT);
    _segment.selectedSegmentIndex = 0;
    [_segment addTarget:self action:@selector(changeDeliveryState:) forControlEvents:UIControlEventValueChanged];
    UIView * hearderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, HEARDERVIEW_HEIGHT)];
    [hearderView addSubview:_segment];
    self.waitNumLB = [[UILabel alloc] initWithFrame:CGRectMake(_segment.left + 94, 3 + TOP_SPACE, 22, 22)];
    _waitNumLB.text = @"0";
    _waitNumLB.font = [UIFont systemFontOfSize:12];
    _waitNumLB.textAlignment = NSTextAlignmentCenter;
    _waitNumLB.layer.cornerRadius = 11;
    _waitNumLB.layer.backgroundColor = [UIColor whiteColor].CGColor;
    [hearderView addSubview:_waitNumLB];
    self.didNumLB = [[UILabel alloc] initWithFrame:CGRectMake(self.view.width / 2 + 98, 3 + TOP_SPACE, 22, 22)];
    _didNumLB.font = [UIFont systemFontOfSize:12];
    _didNumLB.textAlignment = NSTextAlignmentCenter;
    _didNumLB.text = @"0";
    _didNumLB.layer.cornerRadius = 11;
    _didNumLB.layer.backgroundColor = NUMLB_COLOR;
    self.waitNumLB.textColor = NUMLB_TEXT_COLOR;
    self.didNumLB.textColor = [UIColor whiteColor];
    [hearderView addSubview:_didNumLB];
    self.tableView.tableHeaderView = hearderView;
}

- (void)changeDeliveryState:(UISegmentedControl *)segment
{
    if (segment.selectedSegmentIndex) {
        if (_didDeliveryArray == nil) {
            _didDeliveryPage = 1;
            [self downloadDataWithCommand:@21 page:1 count:10];
            [SVProgressHUD showWithStatus:@"正在加载..." maskType:SVProgressHUDMaskTypeBlack];
        }
        [segment setImage:[[UIImage imageNamed:@"delivery_n.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forSegmentAtIndex:0];
        [segment setImage:[[UIImage imageNamed:@"didDelivery_s.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forSegmentAtIndex:1];
        self.waitNumLB.layer.backgroundColor = NUMLB_COLOR;
        self.didNumLB.layer.backgroundColor = [UIColor whiteColor].CGColor;
        self.didNumLB.textColor = NUMLB_TEXT_COLOR;
        self.waitNumLB.textColor = [UIColor whiteColor];
        self.dataArray = self.didDeliveryArray;
    }else
    {
        [segment setImage:[[UIImage imageNamed:@"delivery_s.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forSegmentAtIndex:0];
        [segment setImage:[[UIImage imageNamed:@"didDelivery_n.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forSegmentAtIndex:1];
        self.didNumLB.layer.backgroundColor = NUMLB_COLOR;
        self.waitNumLB.layer.backgroundColor = [UIColor whiteColor].CGColor;
        self.waitNumLB.textColor = NUMLB_TEXT_COLOR;
        self.didNumLB.textColor = [UIColor whiteColor];
        self.dataArray = self.waitDeliveryArray;
    }
    [self.tableView reloadData];
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
    [self rereshData];
//    self.navigationController.tabBarItem.badgeValue = nil;
//    if (self.segment.selectedSegmentIndex) {
//        _didDeliveryPage = 1;
//        self.didDeliveryArray = nil;
//        [self downloadDataWithCommand:@21 page:_waitDeliveryPage count:COUNT];
//    }else
//    {
//        _waitDeliveryPage = 1;
//        self.waitDeliveryArray = nil;
//        [self downloadDataWithCommand:@4 page:_waitDeliveryPage count:COUNT];
//    }
    
}

- (void)rereshData
{
    self.navigationController.tabBarItem.badgeValue = nil;
    if (self.segment.selectedSegmentIndex) {
        _didDeliveryPage = 1;
        self.didDeliveryArray = nil;
        [self downloadDataWithCommand:@21 page:_didDeliveryPage count:COUNT];
    }else
    {
        _waitDeliveryPage = 1;
        self.waitDeliveryArray = nil;
        [self downloadDataWithCommand:@4 page:_waitDeliveryPage count:COUNT];
    }
}

- (void)footerRereshing
{
    [self tableViewEndRereshing];
    if (self.segment.selectedSegmentIndex) {
        if (self.dataArray.count < [_didDeliveryAllCount integerValue]) {
            self.tableView.footerRefreshingText = @"正在加载数据";
            [self downloadDataWithCommand:@21 page:++_didDeliveryPage count:COUNT];
        }else
        {
            self.tableView.footerRefreshingText = @"数据已经加载完";
            [self.tableView performSelector:@selector(footerEndRefreshing) withObject:nil afterDelay:1];
        }
    }else
    {
        if (self.dataArray.count < [_waitDeliveryAllCount integerValue]) {
            self.tableView.footerRefreshingText = @"正在加载数据";
            [self downloadDataWithCommand:@4 page:++_waitDeliveryPage count:COUNT];
        }else
        {
            self.tableView.footerRefreshingText = @"数据已经加载完";
            [self.tableView performSelector:@selector(footerEndRefreshing) withObject:nil afterDelay:1];
        }
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
    NSString * urlString = [NSString stringWithFormat:@"%@%@", POST_URL, md5Str];
    
    HTTPPost * httpPost = [HTTPPost shareHTTPPost];
    [httpPost post:urlString HTTPBody:[jsonStr dataUsingEncoding:NSUTF8StringEncoding]];
    httpPost.delegate = self;
}

- (void)refresh:(id)data
{
    [self tableViewEndRereshing];
    NSLog(@"%@", data);
    //    NSDictionary * dataDic = (NSDictionary *)data;
    if ([[data objectForKey:@"Result"] isEqual:@1]) {
        NSArray * orderArray = [data objectForKey:@"OrderList"];
        NSInteger command = [[data objectForKey:@"Command"] integerValue];
        NSNumber * allCount = [data objectForKey:@"AllCount"];
        if (command == 10004) {
            [SVProgressHUD dismiss];
            for (NSDictionary * dic in orderArray) {
                DealOrderModel * dealOrder = [[DealOrderModel alloc] initWithDictionary:dic];
                [self.waitDeliveryArray addObject:dealOrder];
            }
            self.waitDeliveryAllCount = allCount;
//            self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld", [self.navigationController.tabBarItem.badgeValue integerValue] + [self.waitDeliveryAllCount integerValue]];
            self.waitNumLB.text = [NSString stringWithFormat:@"%@", allCount];
        }else if(command == 10021)
        {
            [SVProgressHUD dismiss];
            for (NSDictionary * dic in orderArray) {
                DealOrderModel * dealOrder = [[DealOrderModel alloc] initWithDictionary:dic];
                [self.didDeliveryArray addObject:dealOrder];
            }
            self.didDeliveryAllCount = allCount;
//            self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld", [self.navigationController.tabBarItem.badgeValue integerValue] + [self.didDeliveryAllCount integerValue]];
            self.didNumLB.text = [NSString stringWithFormat:@"%@", allCount];
        }else if (command == 10016 || command == 10023)
        {
//            if (self.dataArray.count == 1) {
//                self.dataArray = nil;
//            }
            [self rereshData];
            UIAlertView * alertV = [[UIAlertView alloc] initWithTitle:@"提示" message:@"设置成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alertV show];
            [alertV performSelector:@selector(dismiss) withObject:nil afterDelay:1.5];
        }
        if (self.segment.selectedSegmentIndex) {
            self.dataArray = self.didDeliveryArray;
        }else
        {
            self.dataArray = self.waitDeliveryArray;
        }
        self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld", (long)[self.waitDeliveryAllCount integerValue]];
        [self.tableView reloadData];
    }else
    {
        [SVProgressHUD dismiss];
        UIAlertView * alertV = [[UIAlertView alloc] initWithTitle:@"提示" message:[data objectForKey:@"ErrorMsg"] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alertV show];
        [alertV performSelector:@selector(dismiss) withObject:nil afterDelay:1.5];
    }
}

- (void)failWithError:(NSError *)error
{
    NSLog(@"%@", error);
    [SVProgressHUD dismiss];
    UIAlertView * alertV = [[UIAlertView alloc] initWithTitle:@"提示" message:@"连接服务器失败" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [alertV show];
    [alertV performSelector:@selector(dismiss) withObject:nil afterDelay:1.5];
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
    DealOrderModel * dealOrder = [self.dataArray objectAtIndex:indexPath.row];
    dealOrder.orderNumber = [NSNumber numberWithInteger:indexPath.row + 1];
    ProcessedViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
    [cell createSubView:self.tableView.bounds mealCount:dealOrder.mealArray.count];
    [cell.dealButton addTarget:self action:@selector(markMealSentOut:) forControlEvents:UIControlEventTouchUpInside];
    [cell.nulliyButton addTarget:self action:@selector(nulliyOrder:) forControlEvents:UIControlEventTouchUpInside];

    cell.dealButton.tag = indexPath.row + DEALBUTTON_TAG;
    cell.nulliyButton.tag = indexPath.row + NULLIYBUTTON_TAG;
    if (self.segment.selectedSegmentIndex) {
//        cell.dealButton.enabled = NO;
        if (self.seleteIndexPath != nil & self.seleteIndexPath.row == indexPath.row) {
            [cell disHiddenSubView:self.tableView.bounds mealCount:dealOrder.mealArray.count andHiddenImage:NO];
        }else
        {
            [cell hiddenSubView:self.tableView.bounds mealCount:dealOrder.mealArray.count];
        }
    }else
    {
//        cell.dealButton.enabled = YES;
        [cell disHiddenSubView:self.tableView.bounds mealCount:dealOrder.mealArray.count andHiddenImage:YES];
    }
    cell.dealOrder = dealOrder;
//    cell.textLabel.text = [NSString stringWithFormat:@"%ld", indexPath.row];
    // Configure the cell...
    cell.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];

    return cell;
}

- (void)markMealSentOut:(UIButton *)button
{
    DealOrderModel * order = [self.dataArray objectAtIndex:button.tag - DEALBUTTON_TAG];
    NSDictionary * jsonDic = @{
                               @"UserId":[UserInfo shareUserInfo].userId,
                               @"Command":@16,
                               @"OrderId":order.orderId
                               };
    [self playPostWithDictionary:jsonDic];
    [SVProgressHUD showWithStatus:@"正在标记成已处理..." maskType:SVProgressHUDMaskTypeBlack];
}

- (void)nulliyOrder:(UIButton *)button
{
    DealOrderModel * order = [self.dataArray objectAtIndex:button.tag - NULLIYBUTTON_TAG];
    NSDictionary * jsonDic = @{
                               @"UserId":[UserInfo shareUserInfo].userId,
                               @"Command":@23,
                               @"OrderId":order.orderId
                               };
    [self playPostWithDictionary:jsonDic];
    [SVProgressHUD showWithStatus:@"正在请求订单无效..." maskType:SVProgressHUDMaskTypeBlack];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.segment.selectedSegmentIndex) {
        if (self.seleteIndexPath != nil & self.seleteIndexPath.row == indexPath.row) {
            self.seleteIndexPath = nil;
        }else
        {
            self.seleteIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
        }
        [self.tableView reloadData];
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DealOrderModel * dealOrder = [self.dataArray objectAtIndex:indexPath.row];
    if (self.segment.selectedSegmentIndex) {
        if (indexPath.row == self.seleteIndexPath.row & self.seleteIndexPath != nil) {
            return [ProcessedViewCell cellHeightWithMealCount:dealOrder.mealArray.count];
        }
        return [ProcessedViewCell didDeliveryCellHeight];
    }
    return [ProcessedViewCell cellHeightWithMealCount:dealOrder.mealArray.count];
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.segment.selectedSegmentIndex) {
        return YES;
    }
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
