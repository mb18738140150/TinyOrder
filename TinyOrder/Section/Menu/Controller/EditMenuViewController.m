//
//  EditMenuViewController.m
//  TinyOrder
//
//  Created by 仙林 on 15/4/8.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "EditMenuViewController.h"
#import "EditViewCell.h"
#import "AddMenuCell.h"
#import "MenuModel.h"
#import "AddMenuViewController.h"

#define ADDMENUALERT_TAH 5000
#define DELETEALERT_TAG 4000
#define EDITALERT_TAG 3000
#define DELETEBUTTON_TAG 2000
#define EDITBUTTON_TAG 1000



@interface EditMenuViewController ()<UIAlertViewDelegate, HTTPPostDelegate>

@property (nonatomic, assign)NSInteger changIndex;
@property (nonatomic, strong)NSMutableArray * dataArray;
@property (nonatomic, assign)int page;
@property (nonatomic, strong)NSNumber * allCount;

@end

@implementation EditMenuViewController

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.view.backgroundColor = [UIColor redColor];
    [self.tableView registerClass:[EditViewCell class] forCellReuseIdentifier:@"cell"];
//    [self.tableView registerClass:[AddMenuCell class] forCellReuseIdentifier:@"addCell"];
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
//    _page = 1;
//    [self downloadDataWithCommand:@1 page:_page count:COUNT];
    [self.tableView headerBeginRefreshing];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation  bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backLastVC:)];
}

- (void)backLastVC:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
    [self downloadDataWithCommand:@1 page:_page count:COUNT];
}


- (void)footerRereshing
{
    [self tableViewEndRereshing];
    if (self.dataArray.count < [_allCount integerValue]) {
        self.tableView.footerRefreshingText = @"正在加载数据";
        [self downloadDataWithCommand:@1 page:++_page count:COUNT];
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
        }else if (command == 10010 || command == 10009 || command == 10008)
        {
            _page = 1;
            [self downloadDataWithCommand:@1 page:_page count:COUNT];
//            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"操作成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            [alertView show];
        }
        [self.tableView reloadData];
    }else
    {
        [SVProgressHUD dismiss];
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"操作失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
    [self.tableView headerEndRefreshing];
    [self.tableView footerEndRefreshing];
    NSLog(@"%@", [data objectForKey:@"ErrorMsg"]);
}

- (void)failWithError:(NSError *)error
{
    [SVProgressHUD dismiss];
//    if (error.code == -1009) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"友情提示" message:@"网络不给力,请检查网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alert show];
//    }else
//    {
        UIAlertView * alerV = [[UIAlertView alloc] initWithTitle:@"提示" message:@"连接服务器失败请重新连接" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alerV show];
//    }
    [self.tableView headerEndRefreshing];
    [self.tableView footerEndRefreshing];
    NSLog(@"%@", error);
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
//    if (indexPath.row == self.dataArray.count) {
//        AddMenuCell * addMenuCell = [tableView dequeueReusableCellWithIdentifier:@"addCell" forIndexPath:indexPath];
//        [addMenuCell createSubview:self.tableView.bounds];
//        [addMenuCell.addButton addTarget:self action:@selector(AddMenuAction:) forControlEvents:UIControlEventTouchUpInside];
////        addMenuCell.backgroundColor = [UIColor greenColor];
//        return addMenuCell;
//    }
    MenuModel * menuModel = [self.dataArray objectAtIndex:indexPath.row];
    EditViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    [cell createSubViews:self.tableView.bounds withIsEdit:YES];
    cell.menuModel = menuModel;
    cell.editButton.tag = indexPath.row + EDITBUTTON_TAG;
    cell.deleteButton.tag = indexPath.row + DELETEBUTTON_TAG;
    [cell.deleteButton addTarget:self action:@selector(deleteMenuAciton:) forControlEvents:UIControlEventTouchUpInside];
    [cell.editButton addTarget:self action:@selector(editMenuAction:) forControlEvents:UIControlEventTouchUpInside];
    // Configure the cell...
    
    return cell;
}

- (void)deleteMenuAciton:(UIButton *)button
{
    self.changIndex = button.tag - DELETEBUTTON_TAG;
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"确定要删除?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = DELETEALERT_TAG;
    [alert show];
}

- (void)editMenuAction:(UIButton *)button
{
    self.changIndex = button.tag - EDITBUTTON_TAG;
    MenuModel * menuMD = [self.dataArray objectAtIndex:button.tag - EDITBUTTON_TAG];
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"编辑" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = EDITALERT_TAG;
    alert.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
    [[alert textFieldAtIndex:0] setText:menuMD.name];
    [[alert textFieldAtIndex:1] setText:menuMD.describe];
    [alert textFieldAtIndex:1].secureTextEntry = NO;
    [alert show];
    
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    MenuModel * menuMD = [self.dataArray objectAtIndex:self.changIndex];
    if (buttonIndex == 1) {
        if (alertView.tag == EDITALERT_TAG) {
            if ([alertView textFieldAtIndex:0].text.length) {
                NSDictionary * jsonDic = @{
                                           @"UserId":[UserInfo shareUserInfo].userId,
                                           @"Command":@10,
                                           @"ClassifyId":menuMD.classifyId,
                                           @"ClassifyName":[alertView textFieldAtIndex:0].text
                                           };
                [self playPostWithDictionary:jsonDic];
                [SVProgressHUD showWithStatus:@"正在修改..." maskType:SVProgressHUDMaskTypeBlack];
            }else
            {
                UIAlertView * alertV = [[UIAlertView alloc] initWithTitle:@"提示" message:@"编辑失败,商品名不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertV show];
            }
            
        }else if (alertView.tag == DELETEALERT_TAG)
        {
            NSDictionary * jsonDic = @{
                                       @"UserId":[UserInfo shareUserInfo].userId,
                                       @"Command":@9,
                                       @"ClassifyId":menuMD.classifyId,
                                       };
            [self playPostWithDictionary:jsonDic];
            [SVProgressHUD showWithStatus:@"正在删除..." maskType:SVProgressHUDMaskTypeBlack];
        }else if (alertView.tag == ADDMENUALERT_TAH)
        {
            NSDictionary * jsonDic = @{
                                       @"UserId":[UserInfo shareUserInfo].userId,
                                       @"ClassifyName":[alertView textFieldAtIndex:0].text,
                                       @"Command":@8
                                       };
            [self playPostWithDictionary:jsonDic];
            [SVProgressHUD showWithStatus:@"正在添加..." maskType:SVProgressHUDMaskTypeBlack];
        }
    }
}

- (void)AddMenuAction:(UIButton *)button
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"编辑" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.delegate = self;
    alert.tag = ADDMENUALERT_TAH;
    alert.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
    [[alert textFieldAtIndex:0] setPlaceholder:@"请输入菜单名"];
    [[alert textFieldAtIndex:1] setPlaceholder:@"请输入活动名"];
    [alert textFieldAtIndex:1].secureTextEntry = NO;
    [alert show];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.dataArray.count) {
        return 60;
    }
    return [EditViewCell cellHeight];
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
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
