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

#define DETAILSCELL_IDENTIFIER @"detailsCell"
#define EDITCELL_IDENTIFIER @"editCell"

#define CLEARALERT_TAH 6000
#define DELETEALERT_TAG 5000
#define EDITALERT_TAG 4000
#define CLEARBUTTON_TAG 3000
#define DELETEBUTTON_TAG 2000
#define EDITBUTTON_TAG 1000


@interface DetailsMenuViewController ()<UIAlertViewDelegate, HTTPPostDelegate>


@property (nonatomic, copy)NSString * seleteIndex;
@property (nonatomic, strong)NSMutableArray * dataArray;
@property (nonatomic, assign)int page;
@property (nonatomic, strong)NSNumber * allCount;

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
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"新增" style:UIBarButtonItemStylePlain target:self action:@selector(newAddMenuAction:)];
    self.navigationItem.title = @"菜单列表";
    
    [self.tableView registerClass:[DetailsViewCell class] forCellReuseIdentifier:DETAILSCELL_IDENTIFIER];
    
    [self.tableView registerClass:[DetailEditViewCell class] forCellReuseIdentifier:EDITCELL_IDENTIFIER];
    _page = 1;
    [self downloadDataWithCommand:@2 page:_page count:COUNT];
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    self.seleteIndex = nil;
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
    addMenuVC.classifyId = self.classifyId;
    [addMenuVC returnMenuValue:^{
        [detailsVC.tableView headerEndRefreshing];
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
    //    NSLog(@"%@", jsonStr);
    NSString * str = [NSString stringWithFormat:@"%@231618", jsonStr];
    NSString * md5Str = [str md5];
    NSString * urlString = [NSString stringWithFormat:@"http://p.vlifee.com/getdata.ashx?md5=%@",md5Str];
    
    HTTPPost * httpPost = [HTTPPost shareHTTPPost];
    [httpPost post:urlString HTTPBody:[jsonStr dataUsingEncoding:NSUTF8StringEncoding]];
    httpPost.delegate = self;
}

- (void)refresh:(id)data
{
    NSLog(@"%@, error = %@", data, [data objectForKey:@"ErrorMsg"]);
    //    NSDictionary * dataDic = (NSDictionary *)data;
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
                [self.dataArray addObject:detaiMD];
            }
            NSLog(@"%ld", self.dataArray.count);
        }else if (command == 10013 | command == 10014)
        {
            _page = 1;
            [self downloadDataWithCommand:@2 page:_page count:COUNT];
        }
        
        [self.tableView reloadData];
    }else
    {
        UIAlertView * alerV = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请求失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alerV show];
    }
    [self tableViewEndRereshing];
}

- (void)failWithError:(NSError *)error
{
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
    DetailModel * detaiMD = [self.dataArray objectAtIndex:[self.seleteIndex integerValue] - 1];
    if (buttonIndex == 1) {
//        self.seleteIndex = nil;
        if (alertView.tag == DELETEALERT_TAG) {
            NSDictionary * jsonDic = @{
                                       @"UserId":[UserInfo shareUserInfo].userId,
                                       @"Command":@13,
                                       @"MealId":detaiMD.mealId
                                       };
            [self playPostWithDictionary:jsonDic];
        }else if (alertView.tag == CLEARALERT_TAH) {
            NSDictionary * jsonDic = @{
                                       @"UserId":[UserInfo shareUserInfo].userId,
                                       @"Command":@14,
                                       @"MealId":detaiMD.mealId
                                       };
            [self playPostWithDictionary:jsonDic];
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
        DetailEditViewCell * editCell = [tableView dequeueReusableCellWithIdentifier:EDITCELL_IDENTIFIER forIndexPath:indexPath];
        [editCell createSubView:self.tableView.bounds];
        //-1是为了对应编辑的cell
        editCell.deleteButton.tag = indexPath.row + DELETEBUTTON_TAG - 1;
        editCell.clearButton.tag = indexPath.row + CLEARBUTTON_TAG - 1;
        editCell.editButton.tag = indexPath.row + EDITBUTTON_TAG - 1;
        [editCell.deleteButton addTarget:self action:@selector(deleteMenuAction:) forControlEvents:UIControlEventTouchUpInside];
        [editCell.clearButton addTarget:self action:@selector(clearMenuAction:) forControlEvents:UIControlEventTouchUpInside];
        [editCell.editButton addTarget:self action:@selector(editMenuAction:) forControlEvents:UIControlEventTouchUpInside];
        return editCell;
    }
    
    DetailsViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DETAILSCELL_IDENTIFIER forIndexPath:indexPath];
    [cell createSubView:self.tableView.bounds];
    if ([_seleteIndex integerValue] < indexPath.row) {
        cell.detailModel = [self.dataArray objectAtIndex:indexPath.row - 1];
    }else if ([_seleteIndex integerValue] > indexPath.row || _seleteIndex == nil)
    {
        cell.detailModel = [self.dataArray objectAtIndex:indexPath.row];
    }/*else if (_seleteIndex == nil)
    {
        cell.detailModel = [self.dataArray objectAtIndex:indexPath.row];
    }*/
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
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"估清" message:@"确定要估清?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = CLEARALERT_TAH;
    [alert show];
}

- (void)editMenuAction:(UIButton *)button
{
    NSLog(@"%d", button.tag - EDITBUTTON_TAG);
    __weak DetailsMenuViewController * detaiVC = self;
    AddMenuViewController * addMenuVC = [[AddMenuViewController alloc] init];
    addMenuVC.navigationItem.title = @"编辑";
    addMenuVC.detailMD = [self.dataArray objectAtIndex:button.tag - EDITBUTTON_TAG];
    [addMenuVC returnMenuValue:^{
        [detaiVC.tableView headerEndRefreshing];
    }];
    [self.navigationController pushViewController:addMenuVC animated:YES];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld", indexPath.row);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([[tableView cellForRowAtIndexPath:indexPath] isKindOfClass:[DetailsViewCell class]]) {
        if (!_seleteIndex) {
            self.seleteIndex = [NSString stringWithFormat:@"%ld", indexPath.row + 1];
            NSIndexPath * path = [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section];
            [tableView insertRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationMiddle];
        }else{
            NSInteger index = [_seleteIndex integerValue];
            self.seleteIndex = nil;
            NSIndexPath * path = [NSIndexPath indexPathForRow:index inSection:0];
            [tableView deleteRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationMiddle];
            if (index - 1 != indexPath.row) {
                if (index > indexPath.row) {
                    self.seleteIndex = [NSString stringWithFormat:@"%ld", indexPath.row + 1];
                    NSIndexPath * smallPath = [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section];
                    [tableView insertRowsAtIndexPaths:@[smallPath] withRowAnimation:UITableViewRowAnimationMiddle];
                }else
                {
                    self.seleteIndex = [NSString stringWithFormat:@"%ld", indexPath.row];
                    [tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
                }
            }
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [_seleteIndex integerValue] && _seleteIndex != nil) {
        return NO;
    }
    return YES;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


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
