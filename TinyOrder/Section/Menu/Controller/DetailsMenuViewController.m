//
//  DetailsMenuViewController.m
//  TinyOrder
//
//  Created by 仙林 on 15/4/10.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "DetailsMenuViewController.h"
#import "DetailsViewCell.h"
#import "DetailEditViewCell.h"
#import "AddMenuViewController.h"
#import "DetailModel.h"
#import "Refresh.h"
#import "MealPropertyViewController.h"
#import "DishDetailViewController.h"
#import "KxMenu.h"
#import "BatchoperationView.h"

#define DETAILSCELL_IDENTIFIER @"detailsCell"
#define EDITCELL_IDENTIFIER @"editCell"

#define CLEARALERT_TAH 6000
#define DELETEALERT_TAG 5000
#define EDITALERT_TAG 4000
#define CLEARBUTTON_TAG 3000
#define DELETEBUTTON_TAG 2000
#define EDITBUTTON_TAG 1000

@interface DetailsMenuViewController ()<UIAlertViewDelegate, HTTPPostDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, copy)NSString * seleteIndex;
@property (nonatomic, strong)NSMutableArray * dataArray;
@property (nonatomic, assign)int page;
@property (nonatomic, strong)NSNumber * allCount;

@property (nonatomic, strong)DetailModel * model;
@property (nonatomic, strong)NSMutableArray * batchArray;
@property (nonatomic, strong)BatchoperationView * batchOperationView;
@end

@implementation DetailsMenuViewController



- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)batchArray
{
    if (!_batchArray) {
        self.batchArray = [NSMutableArray array];
    }
    return _batchArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    UIButton * rightbarbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightbarbutton.frame = CGRectMake(0, 0, 30, 30);
    [rightbarbutton setImage:[[UIImage imageNamed:@"addicon.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [rightbarbutton addTarget:self action:@selector(newAddMenuAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightbarbutton];
//    self.navigationItem.title = @"菜单列表";
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64)];
    
    
//    self.automaticallyAdjustsScrollViewInsets = NO;
//    UIEdgeInsets insets = self.tableView.contentInset;
//    insets.top = self.navigationController.navigationBar.bounds.size.height +        [UIApplication sharedApplication].statusBarFrame.size.height;
//    self.tableView.contentInset = insets;
//    self.tableView.scrollIndicatorInsets = insets;
    
//    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
//    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    
    [self.tableView registerClass:[DetailsViewCell class] forCellReuseIdentifier:DETAILSCELL_IDENTIFIER];
    
    [self.tableView registerClass:[DetailEditViewCell class] forCellReuseIdentifier:EDITCELL_IDENTIFIER];
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:_tableView];
//    [self.tableView headerBeginRefreshing];
    
    NSDictionary * jsonDic = @{
                               @"UserId":[UserInfo shareUserInfo].userId,
                               @"Command":@2,
                               @"ClassifyId":self.classifyId,
                               @"CurPage":[NSNumber numberWithInt:1],
                               @"CurCount":[NSNumber numberWithInt:COUNT]
                               };
    [self playPostWithDictionary:jsonDic];
    
    self.seleteIndex = nil;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backLastVC:)];
    
    
//    if ([self respondsToSelector:@selector(headerBeginRefreshing)]) {
//        self.automaticallyAdjustsScrollViewInsets = NO;
//        UIEdgeInsets insets = self.tableView.contentInset;
//        insets.top = self.navigationController.navigationBar.bounds.size.height +        [UIApplication sharedApplication].statusBarFrame.size.height;
//        self.tableView.contentInset = insets;
//        self.tableView.scrollIndicatorInsets = insets;
//    }        //修复下拉刷新位置错误  代码结束        __block RootViewController *bSelf = self;        [self.tableView addPullToRefreshWithActionHandler:^{                [bSelf addRows];    }];            /**     *  拉到最后 加载更多，增加一个；     */    [self.tableView addInfiniteScrollingWithActionHandler:^{        [bSelf addMoreRow];    }];

    
}

- (void)backLastVC:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"1px.png"] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:nil];

//    NSDictionary * jsonDic = @{
//                               @"UserId":[UserInfo shareUserInfo].userId,
//                               @"Command":@2,
//                               @"ClassifyId":self.classifyId,
//                               @"CurPage":[NSNumber numberWithInt:1],
//                               @"CurCount":[NSNumber numberWithInt:COUNT]
//                               };
//    [self playPostWithDictionary:jsonDic];
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
    [self downloadDataWithCommand:@2 page:_page count:COUNT];
    
}


- (void)footerRereshing
{
    [self tableViewEndRereshing];
    if (self.dataArray.count < [_allCount integerValue]) {
        self.tableView.footerRefreshingText = @"正在加载数据";
        [self downloadDataWithCommand:@2 page:++_page count:COUNT];
    }else
    {
        self.tableView.footerRefreshingText = @"数据已经加载完";
        [self.tableView performSelector:@selector(footerEndRefreshing) withObject:nil afterDelay:1];
    }
}


- (void)newAddMenuAction:(UIButton *)barBI
{
    NSArray *menuItems = @[
                           [KxMenuItem menuItem:@"批量估清"
                                          image:[UIImage imageNamed:@"batchStock"]
                                         target:self
                                         action:@selector(batchStock:)],
                           
                           [KxMenuItem menuItem:@"批量上架"
                                          image:[UIImage imageNamed:@"batchSheleves"]
                                         target:self
                                         action:@selector(batchShelves:)],
                           
                           [KxMenuItem menuItem:@"添加商品"
                                          image:[UIImage imageNamed:@"addMeal"]
                                         target:self
                                         action:@selector(addcommodity:)],
                           ];
    
    UIBarButtonItem *rightBarButton = self.navigationItem.rightBarButtonItem;
    CGRect targetFrame = rightBarButton.customView.frame;
    targetFrame.origin.y = targetFrame.origin.y + 15;
    [KxMenu setTintColor:[UIColor blackColor]];
    [KxMenu setTitleFont:[UIFont systemFontOfSize:17]];
    [KxMenu showMenuInView:self.navigationController
     .navigationBar.superview
                  fromRect:targetFrame
                 menuItems:menuItems];
    
}

- (void)batchStock:(id)sender
{
    NSLog(@"批量沽清");
    [self.batchArray removeAllObjects];
    for (DetailModel * model in self.dataArray) {
        if (model.mealState.intValue == 1) {
            model.selectType = Select_nomal;
        }else
        {
            model.selectType = Select_no;
        }
    }
    
    
    [self.tableView reloadData];
    if (self.batchOperationView) {
        [self.batchOperationView removeFromSuperview];
        self.batchOperationView = nil;
    }
    self.batchOperationView = [[BatchoperationView alloc]initWithFrame:CGRectMake(0, self.view.height - 45, self.view.width, 45) batchOperationType:1];
    [self.view addSubview:self.batchOperationView];
    __weak DetailsMenuViewController * weakSelf = self;
    [self.batchOperationView allOperationAction:^(int selectType) {
        if (selectType == 0) {
            for (DetailModel * model in weakSelf.dataArray) {
                if (model.mealState.intValue == 1) {
                    model.selectType = Select_nomal;
                }else
                {
                    model.selectType = Select_no;
                }
            }
            [weakSelf.batchArray removeAllObjects];
        }else
        {
            for (DetailModel * model in weakSelf.dataArray) {
                if (model.mealState.intValue == 1) {
                    model.selectType = Select_nomal;
                }else
                {
                    model.selectType = Select_select;
                    [weakSelf.batchArray addObject:model];
                }
            }
        }
        [weakSelf.tableView reloadData];
    }];
    [self.batchOperationView detaileOperation:^(int detaileOperationType) {
        if (detaileOperationType == 1) {
            NSLog(@"沽清");
            NSString * mealsId = @"";
            for (int i = 0; i < weakSelf.batchArray.count; i++) {
                DetailModel * model = weakSelf.batchArray[i];
                if (i == 0) {
                    mealsId = [NSString stringWithFormat:@"%@", model.mealId];
                }else
                {
                    mealsId = [mealsId stringByAppendingFormat:@",%@", model.mealId];
                }
            }
            NSDictionary * jsonDic = @{
                                       @"UserId":[UserInfo shareUserInfo].userId,
                                       @"Command":@92,
                                       @"MealId":mealsId,
                                       @"MealState":@1
                                       };
            [self playPostWithDictionary:jsonDic];
        }
    }];
}

- (void)batchShelves:(id)sender
{
    NSLog(@"批量上架");
     [self.batchArray removeAllObjects];
    for (DetailModel * model in self.dataArray) {
        if (model.mealState.intValue == 2) {
            model.selectType = Select_nomal;
        }else
        {
            model.selectType = Select_no;
        }
    }
    [self.tableView reloadData];
    
    if (self.batchOperationView) {
        [self.batchOperationView removeFromSuperview];
        self.batchOperationView = nil;
    }
    self.batchOperationView = [[BatchoperationView alloc]initWithFrame:CGRectMake(0, self.view.height - 45, self.view.width, 45) batchOperationType:2];
    [self.view addSubview:self.batchOperationView];
    __weak DetailsMenuViewController * weakSelf = self;
    [self.batchOperationView allOperationAction:^(int selectType) {
        if (selectType == 0) {
            for (DetailModel * model in weakSelf.dataArray) {
                if (model.mealState.intValue == 2) {
                    model.selectType = Select_nomal;
                }else
                {
                    model.selectType = Select_no;
                }
            }
            [weakSelf.batchArray removeAllObjects];
        }else
        {
            for (DetailModel * model in weakSelf.dataArray) {
                if (model.mealState.intValue == 2) {
                    model.selectType = Select_nomal;
                }else
                {
                    model.selectType = Select_select;
                    [weakSelf.batchArray addObject:model];
                }
            }
        }
        [weakSelf.tableView reloadData];
    }];
    [self.batchOperationView detaileOperation:^(int detaileOperationType) {
        if (detaileOperationType != 1) {
            NSLog(@"上架");
            NSString * mealsId = @"";
            for (int i = 0; i < weakSelf.batchArray.count; i++) {
                DetailModel * model = weakSelf.batchArray[i];
                if (i == 0) {
                    mealsId = [NSString stringWithFormat:@"%@", model.mealId];
                }else
                {
                    mealsId = [mealsId stringByAppendingFormat:@",%@", model.mealId];
                }
            }
            NSDictionary * jsonDic = @{
                                       @"UserId":[UserInfo shareUserInfo].userId,
                                       @"Command":@92,
                                       @"MealId":mealsId,
                                       @"MealState":@2
                                       };
            [self playPostWithDictionary:jsonDic];
        }
    }];
}

- (void)addcommodity:(id)sender
{
    __weak DetailsMenuViewController * detailsVC = self;
    AddMenuViewController * addMenuVC = [[AddMenuViewController alloc] init];
    addMenuVC.navigationItem.title = @"新增";
    addMenuVC.isFromeWaimaiOrTangshi = self.isFromeWaimaiOrTangshi;
    addMenuVC.classifyId = self.classifyId;
    [addMenuVC returnMenuValue:^{
        //        detailsVC.seleteIndex = nil;
        [detailsVC.tableView headerBeginRefreshing];
        //        [detailsVC downloadDataWithCommand:@2 page:1 count:COUNT];
    }];
    [self.navigationController pushViewController:addMenuVC animated:YES];
}

- (void)downloadDataWithCommand:(NSNumber *)command page:(int)page count:(int)count
{
    
    NSDictionary * jsonDic = @{
                               @"UserId":[UserInfo shareUserInfo].userId,
                               @"Command":command,
                               @"ClassifyId":self.classifyId,
                               @"CurPage":[NSNumber numberWithInt:page],
                               @"CurCount":[NSNumber numberWithInt:count]
                               };
    [self playPostWithDictionary:jsonDic];
}

- (void)playPostWithDictionary:(NSDictionary *)dic
{
    NSString * jsonStr = [dic JSONString];
    NSLog(@"%@", jsonStr);
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
    if (self.batchOperationView) {
        [self.batchOperationView removeFromSuperview];
        self.batchOperationView = nil;
    }
    [SVProgressHUD dismiss];
    NSLog(@"%@, error = %@", data, [data objectForKey:@"ErrorMsg"]);
    if ([[data objectForKey:@"Result"] isEqual:@1]) {
        int command = [[data objectForKey:@"Command"] intValue];
        if (command == 10002) {
            self.allCount = [data objectForKey:@"AllCount"];
            if (_page == 1) {
                self.dataArray = nil;
            }
            NSArray * array = [data objectForKey:@"MealList"];
            for (NSDictionary * dic in array) {
                DetailModel * detaiMD = [[DetailModel alloc] initWithDictionary:dic];
                detaiMD.selectType = Select_nomal;
                [self.dataArray addObject:detaiMD];
                NSLog(@"++%@", detaiMD.name);
            }
            
        }else if (command == 10014)
        {
            _page = 1;
            [self downloadDataWithCommand:@2 page:_page count:COUNT];
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"操作成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alertView show];
            [alertView performSelector:@selector(dismiss) withObject:nil afterDelay:1.5];
        }else if (command == 10013) {
            self.seleteIndex = nil;
//            [self.tableView headerBeginRefreshing];
            _page = 1;
            [self downloadDataWithCommand:@2 page:_page count:COUNT];
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"删除成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alertView show];
            [alertView performSelector:@selector(dismiss) withObject:nil afterDelay:1.5];
        }else if (command == 10092) {
            _page = 1;
            [self downloadDataWithCommand:@2 page:1 count:COUNT];
        }
        
        [self.tableView reloadData];
    }else
    {
        [SVProgressHUD dismiss];
        if ([data objectForKey:@"ErrorMsg"]) {
            UIAlertView * alertV = [[UIAlertView alloc] initWithTitle:@"提示" message:[data objectForKey:@"ErrorMsg"] delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alertV show];
            [alertV performSelector:@selector(dismiss) withObject:nil afterDelay:1.5];
        }
    }
}

- (void)failWithError:(NSError *)error
{
    [SVProgressHUD dismiss];
    if ([[error.userInfo objectForKey:@"Reason"] isEqualToString:@"服务器处理失败"]) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"服务器处理失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil ];
        [alert show];
    }else
    {
        
        UIAlertView * alerV = [[UIAlertView alloc] initWithTitle:@"提示" message:@"连接服务器失败请重新连接" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alerV show];
    }
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    DetailModel * detaiMD = self.model;
    if (buttonIndex == 1) {
//        self.seleteIndex = nil;
        if (alertView.tag == DELETEALERT_TAG) {
            NSDictionary * jsonDic = @{
                                       @"UserId":[UserInfo shareUserInfo].userId,
                                       @"Command":@13,
                                       @"MealId":detaiMD.mealId
                                       };
            [self playPostWithDictionary:jsonDic];
            [SVProgressHUD showWithStatus:@"正在删除..." maskType:SVProgressHUDMaskTypeBlack];
        }else if (alertView.tag == CLEARALERT_TAH) {
            NSNumber * state = nil;
            if ([detaiMD.mealState isEqual:@1]) {
                state = @2;
            }else if ([detaiMD.mealState isEqual:@2])
            {
                state = @1;
            }
            NSDictionary * jsonDic = @{
                                       @"UserId":[UserInfo shareUserInfo].userId,
                                       @"Command":@14,
                                       @"MealId":detaiMD.mealId,
                                       @"MealState":state
                                       };
            [self playPostWithDictionary:jsonDic];
            if ([state isEqualToNumber:@1]) {
                [SVProgressHUD showWithStatus:@"正在估清..." maskType:SVProgressHUDMaskTypeBlack];
            }else if ([state isEqualToNumber:@2])
            {
                [SVProgressHUD showWithStatus:@"正在上架..." maskType:SVProgressHUDMaskTypeBlack];
            }
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    if (_seleteIndex != nil) {
        return self.dataArray.count + 1;
    }
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([_seleteIndex isEqualToString:[NSString stringWithFormat:@"%ld", indexPath.row]]) {
        DetailModel * detailMD = [self.dataArray objectAtIndex:indexPath.row - 1];
        DetailEditViewCell * editCell = [tableView dequeueReusableCellWithIdentifier:EDITCELL_IDENTIFIER forIndexPath:indexPath];
        [editCell createSubView];
        if ([detailMD.mealState isEqual:@1]) {
            editCell.clearButton.selected = YES;
        }else if ([detailMD.mealState isEqual:@2])
        {
            editCell.clearButton.selected = NO;
        }
        //-1是为了对应编辑的cell
        editCell.deleteButton.tag = indexPath.row + DELETEBUTTON_TAG - 1;
        editCell.clearButton.tag = indexPath.row + CLEARBUTTON_TAG - 1;
        editCell.editButton.tag = indexPath.row + EDITBUTTON_TAG - 1;
        editCell.propertyButton.tag = indexPath.row + EDITBUTTON_TAG - 1;
        [editCell.deleteButton addTarget:self action:@selector(deleteMenuAction:) forControlEvents:UIControlEventTouchUpInside];
        [editCell.clearButton addTarget:self action:@selector(clearMenuAction:) forControlEvents:UIControlEventTouchUpInside];
        [editCell.editButton addTarget:self action:@selector(editMenuAction:) forControlEvents:UIControlEventTouchUpInside];
        [editCell.propertyButton addTarget:self action:@selector(propertyAction:) forControlEvents:UIControlEventTouchUpInside];
        return editCell;
    }
    
    DetailsViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DETAILSCELL_IDENTIFIER forIndexPath:indexPath];
    [cell createSubView:self.tableView.bounds];
    if (_seleteIndex == nil)
    {
        cell.detailModel = [self.dataArray objectAtIndex:indexPath.row];
    }else if ([_seleteIndex integerValue] < indexPath.row) {
        cell.detailModel = [self.dataArray objectAtIndex:indexPath.row - 1];
    }else if ([_seleteIndex integerValue] > indexPath.row)
    {
        cell.detailModel = [self.dataArray objectAtIndex:indexPath.row];
    }
    __weak DetailsMenuViewController * weakSelf = self;
    [cell exchangeSelectTypeAction:^(int selectType) {
        if (selectType == Select_no) {
            NSLog(@"取消选中");
            [weakSelf.batchArray removeObject:[weakSelf.dataArray objectAtIndex:indexPath.row]];
            weakSelf.batchOperationView.selectType = 0;
        }else if (selectType == Select_select)
        {
            NSLog(@"选中");
            [weakSelf.batchArray addObject:[weakSelf.dataArray objectAtIndex:indexPath.row]];
            int number = 0;
            for (DetailModel * model in weakSelf.dataArray) {
                if (model.selectType != Select_nomal) {
                    number++;
                }
            }
            if (number == weakSelf.batchArray.count) {
                weakSelf.batchOperationView.selectType = 1;
            }
        }
        
        for (DetailModel * model in weakSelf.batchArray) {
            NSLog(@"%@, %d", model.name, model.selectType);
        }
        
    }];
    
    // Configure the cell...
    
    return cell;
}

- (void)deleteMenuAction:(UIButton *)button
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"删除" message:@"确定要删除?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = DELETEALERT_TAG;
    [alert show];
}

- (void)clearMenuAction:(UIButton *)button
{
    if (button.selected) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"上架" message:@"确定要上架?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = CLEARALERT_TAH;
        [alert show];
    }else
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"估清" message:@"确定要估清?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = CLEARALERT_TAH;
        [alert show];
    }
    
}

- (void)editMenuAction:(UIButton *)button
{
    NSLog(@"%d", button.tag - EDITBUTTON_TAG);
    __weak DetailsMenuViewController * detaiVC = self;
    AddMenuViewController * addMenuVC = [[AddMenuViewController alloc] init];
    addMenuVC.navigationItem.title = @"编辑";
    addMenuVC.detailMD = [self.dataArray objectAtIndex:button.tag - EDITBUTTON_TAG];
//    [addMenuVC returnMenuValue:^{
//        detaiVC.seleteIndex  = nil;
//        [detaiVC.tableView headerBeginRefreshing];
//    }];
    [self.navigationController pushViewController:addMenuVC animated:YES];
}

#pragma mark - 作废

- (void)propertyAction:(UIButton *)button
{
    MealPropertyViewController * mealPropertyVC = [[MealPropertyViewController alloc]init];
    mealPropertyVC.detailMD = [self.dataArray objectAtIndex:button.tag - EDITBUTTON_TAG];
    __weak DetailsMenuViewController * detailVC = self;
//    [mealPropertyVC returnPropertyValue:^{
//        detailVC.seleteIndex = nil;
//        [detailVC.tableView headerBeginRefreshing];
//    }];
    
    [self.navigationController pushViewController:mealPropertyVC animated:YES];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld", indexPath.row);
    
    DishDetailViewController * dishVC = [[DishDetailViewController alloc]init];
    dishVC.detailMD = [self.dataArray objectAtIndex:indexPath.row];
    DetailModel * model = [self.dataArray objectAtIndex:indexPath.row];
    dishVC.isFromeWaimaiOrTangshi = self.isFromeWaimaiOrTangshi;
    dishVC.foodId = [model.mealId intValue];
    __weak DetailsMenuViewController * weakself = self;
    [dishVC returnPropertyValue:^{
        
        if ([Refresh shareRefresh].menuOrder == 1) {
            [weakself.tableView headerBeginRefreshing];
        }else
        {
            [Refresh shareRefresh].menuOrder = 1;
        }
    }];
    [Refresh shareRefresh].menuOrder = 2;
    [self.navigationController pushViewController:dishVC animated:YES];
    
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    if ([[tableView cellForRowAtIndexPath:indexPath] isKindOfClass:[DetailsViewCell class]]) {
//        if (!_seleteIndex) {
//            self.seleteIndex = [NSString stringWithFormat:@"%ld", indexPath.row + 1];
//            NSIndexPath * path = [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section];
//            [tableView insertRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationMiddle];
//        }else{
//            NSInteger index = [_seleteIndex integerValue];
//            self.seleteIndex = nil;
//            NSIndexPath * path = [NSIndexPath indexPathForRow:index inSection:0];
//            [tableView deleteRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationMiddle];
//            if (index - 1 != indexPath.row) {
//                if (index > indexPath.row) {
//                    self.seleteIndex = [NSString stringWithFormat:@"%ld", indexPath.row + 1];
//                    NSIndexPath * smallPath = [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section];
//                    [tableView insertRowsAtIndexPaths:@[smallPath] withRowAnimation:UITableViewRowAnimationMiddle];
//                }else
//                {
//                    self.seleteIndex = [NSString stringWithFormat:@"%ld", indexPath.row];
//                    [tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
//                }
//            }
//        }
//    }
}

- (NSArray<UITableViewRowAction*>* )tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailModel * detaiMD = [self.dataArray objectAtIndex:indexPath.row];
    self.model = detaiMD;
    UITableViewRowAction * deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"删除" message:@"确定要删除?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = DELETEALERT_TAG;
        [alert show];
    }];
    
    deleteAction.backgroundColor= [UIColor redColor];
    
    UITableViewRowAction * clearAction = [[UITableViewRowAction alloc]init];
    
    if ([detaiMD.mealState isEqual:@1]) {
        clearAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"上架" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"上架" message:@"确定要上架?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alert.tag = CLEARALERT_TAH;
            [alert show];
        }];

    }else if ([detaiMD.mealState isEqual:@2])
    {
        clearAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"沽清" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"沽清" message:@"确定要沽清?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alert.tag = CLEARALERT_TAH;
            [alert show];
        }];

    }
    
    clearAction.backgroundColor = [UIColor orangeColor];
    
    NSArray * arr = @[deleteAction, clearAction];
    return arr;
    
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [_seleteIndex integerValue] && _seleteIndex != nil) {
        return NO;
    }
    return YES;
}


// Override to support conditional editing of the table view.
//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
//    // Return NO if you do not want the specified item to be editable.
//    return YES;
//}
//
//
//
//// Override to support editing the table view.
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        // Delete the row from the data source
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
//        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//    }   
//}


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
