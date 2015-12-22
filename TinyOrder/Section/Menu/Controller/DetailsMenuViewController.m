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
#import "MealPropertyViewController.h"
#import "DishDetailViewController.h"

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

@end

@implementation DetailsMenuViewController



- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"addicon.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(newAddMenuAction:)];
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
//    _page = 1;
//    [self downloadDataWithCommand:@2 page:_page count:COUNT];
    [self.tableView headerBeginRefreshing];
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
    NSDictionary * jsonDic = @{
                               @"UserId":[UserInfo shareUserInfo].userId,
                               @"Command":@2,
                               @"ClassifyId":self.classifyId,
                               @"CurPage":[NSNumber numberWithInt:1],
                               @"CurCount":[NSNumber numberWithInt:COUNT]
                               };
    [self playPostWithDictionary:jsonDic];
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



- (void)newAddMenuAction:(UIBarButtonItem *)barBI
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
    /*
//    NSLog(@"%@, %@", self.classifyId, [UserInfo shareUserInfo].userId);
    NSString * jsonStr = [jsonDic JSONString];
    NSString * str = [NSString stringWithFormat:@"%@231618", jsonStr];
    NSLog(@"%@", str);
    NSString * md5Str = [str md5];
    NSString * urlString = [NSString stringWithFormat:@"http://p.vlifee.com/getdata.ashx?md5=%@",md5Str];
    
    HTTPPost * httpPost = [HTTPPost shareHTTPPost];
    [httpPost post:urlString HTTPBody:[jsonStr dataUsingEncoding:NSUTF8StringEncoding]];
    httpPost.delegate = self;
    */
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
    NSLog(@"%@, error = %@", data, [data objectForKey:@"ErrorMsg"]);
    //    NSDictionary * dataDic = (NSDictionary *)data;
    if ([[data objectForKey:@"Result"] isEqual:@1]) {
        int command = [[data objectForKey:@"Command"] intValue];
        if (command == 10002) {
            [SVProgressHUD dismiss];
            self.allCount = [data objectForKey:@"AllCount"];
            if (_page == 1) {
                self.dataArray = nil;
            }
            NSArray * array = [data objectForKey:@"MealList"];
            for (NSDictionary * dic in array) {
                DetailModel * detaiMD = [[DetailModel alloc] initWithDictionary:dic];
                [self.dataArray addObject:detaiMD];
                NSLog(@"++%@", detaiMD.name);
            }

//            self.automaticallyAdjustsScrollViewInsets = NO;
//            UIEdgeInsets insets = self.tableView.contentInset;
//            insets.top = self.navigationController.navigationBar.bounds.size.height +        [UIApplication sharedApplication].statusBarFrame.size.height;
//            self.tableView.contentInset = insets;
//            self.tableView.scrollIndicatorInsets = insets;
            
            
//            self.tableView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.origin.y + 64, self.view.width, self.view.height );
//            NSLog(@"%ld", self.dataArray.count);
        }else if (command == 10014)
        {
//            if (self.dataArray.count == 1) {
//                self.dataArray = nil;
//            }
//            _page = 1;
//            [self.tableView headerBeginRefreshing];
//            DetailEditViewCell * cell = (DetailEditViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[self.seleteIndex integerValue] inSection:0]];
//            cell.clearButton.selected = !cell.clearButton.isSelected;
//            self.seleteIndex = nil;
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
        }
        
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
        [weakself.tableView headerBeginRefreshing];
    }];
    
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
