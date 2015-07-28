//
//  CommentViewController.m
//  TinyOrder
//
//  Created by 仙林 on 15/7/24.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "CommentViewController.h"
#import "CommentViewCell.h"
#import "CommentModel.h"
#import "ReplyViewCell.h"

#define CELL_IDENTIFIER @"cell"
#define REPLY_CELL @"replyCell"

@interface CommentViewController ()<HTTPPostDelegate>
{
    int _page;
}
@property (nonatomic, strong)NSNumber * allCount;
@property (nonatomic, strong)NSMutableArray * dataArray;

@property (nonatomic, strong)NSNumber * selectIndex;

@end

@implementation CommentViewController


- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self.tableView registerClass:[CommentViewCell class] forCellReuseIdentifier:CELL_IDENTIFIER];
    [self.tableView registerClass:[ReplyViewCell class] forCellReuseIdentifier:REPLY_CELL];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backLastVC:)];
    _page = 1;
    [self downloadDataWithCommand:@33 page:_page count:COUNT];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
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
    if (self.selectIndex != nil) {
        return self.dataArray.count + 1;
    }
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_selectIndex != nil && _selectIndex.integerValue == indexPath.row) {
        ReplyViewCell * replyCell = [tableView dequeueReusableCellWithIdentifier:REPLY_CELL forIndexPath:indexPath];
        [replyCell.ensureBT addTarget:self action:@selector(ensureReplyAction:) forControlEvents:UIControlEventTouchUpInside];
        [replyCell.cancelBT addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
        replyCell.tag = indexPath.row + 2001;
        return replyCell;
    }
    
    
    CommentViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
    [cell.replyBT addTarget:self action:@selector(replyAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.replyBT.tag = 1000 + indexPath.row;
    
    if (_selectIndex == nil)
    {
        cell.commentMD = [self.dataArray objectAtIndex:indexPath.row];
    }else if ([_selectIndex integerValue] < indexPath.row) {
        cell.commentMD = [self.dataArray objectAtIndex:indexPath.row - 1];
    }else if ([_selectIndex integerValue] > indexPath.row)
    {
        cell.commentMD = [self.dataArray objectAtIndex:indexPath.row];
    }
    if (_selectIndex != nil && _selectIndex.integerValue == indexPath.row + 1) {
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, WINDOW_WIDHT);
    }else
    {
        cell.separatorInset = UIEdgeInsetsZero;
        cell.preservesSuperviewLayoutMargins = NO;
        cell.layoutMargins = UIEdgeInsetsZero;
    }
    
//    cell.textLabel.text = @"123455";
    // Configure the cell...
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_selectIndex != nil && _selectIndex.integerValue == indexPath.row) {
        return [ReplyViewCell cellHeigth];
    }
    CommentModel * commentMD = nil;
    if (_selectIndex == nil)
    {
        commentMD = [self.dataArray objectAtIndex:indexPath.row];
    }else if ([_selectIndex integerValue] < indexPath.row) {
        commentMD = [self.dataArray objectAtIndex:indexPath.row - 1];
    }else if ([_selectIndex integerValue] > indexPath.row)
    {
        commentMD = [self.dataArray objectAtIndex:indexPath.row];
    }
    return [CommentViewCell cellHeightWithCommentMD:commentMD];
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}



#pragma mark - cell button 触发事件
- (void)replyAction:(UIButton *)button
{
    NSLog(@"回复评论");
    self.selectIndex = [NSNumber numberWithInteger:button.tag - 1000 + 1];
    [self.tableView reloadData];
}

- (void)ensureReplyAction:(UIButton *)button
{
    ReplyViewCell * cell = (ReplyViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.selectIndex.integerValue inSection:0]];
    CommentModel * commentMD = [self.dataArray objectAtIndex:self.selectIndex.integerValue - 1];
    if (cell.replyContentV.text.length != 0) {
        NSDictionary * jsonDic = @{
                                   @"Command":@34,
                                   @"CommentContent":cell.replyContentV.text,
                                   @"CommentId":commentMD.commentId
                                   };
        [self playPostWithDictionary:jsonDic];
    }else
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"请输入回复内容" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:2];
    }
}

- (void)cancelAction:(UIButton *)button
{
    NSLog(@"取消");
    self.selectIndex = nil;
    [self.tableView reloadData];
}

#pragma mark - 数据请求
- (void)downloadDataWithCommand:(NSNumber *)command page:(int)page count:(int)count
{
    NSDictionary * jsonDic = @{
                               @"Command":command,
                               @"CurPage":[NSNumber numberWithInt:page],
                               @"CurCount":[NSNumber numberWithInt:count],
                               @"UserId":[UserInfo shareUserInfo].userId,
                               @"BusType":@2
                               };
    [self playPostWithDictionary:jsonDic];
}



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
    NSLog(@"%@", data);
    if ([[data objectForKey:@"Result"] isEqualToNumber:@1]) {
        if ([[data objectForKey:@"Command"] isEqualToNumber:@10033]) {
            NSArray * array = [data objectForKey:@"CommentList"];
            if (_page == 1) {
                self.dataArray = nil;
            }
            for (NSDictionary * dic in array) {
                CommentModel * commentMD  = [[CommentModel alloc] initWithDictionary:dic];
                [self.dataArray addObject:commentMD];
            }
            [self.tableView reloadData];
        }else if ([[data objectForKey:@"Command"] isEqualToNumber:@10034])
        {
            self.selectIndex = nil;
            [self downloadDataWithCommand:@33 page:_page count:COUNT];
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
    UIAlertView * alertV = [[UIAlertView alloc] initWithTitle:@"提示" message:@"连接服务器失败" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [alertV show];
    [alertV performSelector:@selector(dismiss) withObject:nil afterDelay:1.5];
    NSLog(@"%@", error);
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
