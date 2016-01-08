//
//  MenuViewController.m
//  TinyOrder
//
//  Created by 仙林 on 15/5/6.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "MenuViewController.h"
#import "EditViewCell.h"
#import "MenuModel.h"
#import "DetailsMenuViewController.h"

#define ADDMENUALERT_TAH 5000
#define DELETEALERT_TAG 4000
#define EDITALERT_TAG 3000
#define DELETEBUTTON_TAG 2000
#define EDITBUTTON_TAG 1000
#define HEARDERVIEW_HEIGHT 60
#define CELL_IDENTIFIER @"cell"

@interface MenuViewController ()<UIAlertViewDelegate, HTTPPostDelegate>
{
    BOOL _isEdit;
}
@property (nonatomic, assign)NSInteger changIndex;
@property (nonatomic, strong)NSMutableArray * dataArray;
@property (nonatomic, strong)NSMutableArray * waimaiArray;
@property (nonatomic, assign)int page;
@property (nonatomic, strong)NSNumber * allCount;

@property (nonatomic, strong)NSMutableArray * tangshidataArray;
@property (nonatomic, assign)int tangshipage;
@property (nonatomic, strong)NSNumber * tangshiallCount;

@property (nonatomic, strong)UISegmentedControl * segment;
@property (nonatomic, strong)UIView * segmentView;

@end

@implementation MenuViewController

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (NSMutableArray *)waimaiArray
{
    if (!_waimaiArray) {
        self.waimaiArray = [NSMutableArray array];
    }
    return _waimaiArray;
}
- (NSMutableArray *)tangshidataArray
{
    if (!_tangshidataArray) {
        self.tangshidataArray = [NSMutableArray array];
    }
    return _tangshidataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = MAINCOLOR;
    self.navigationItem.title = @"商品分类";
   
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStyleDone target:self action:@selector(startEditMenuAction:)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"addicon.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(createNewActivity:)];
    
    _isEdit = NO;
    
//    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - self.navigationController.tabBarController.tabBar.height) style:UITableViewStylePlain];
//    self.tableView.delegate = self;
//    self.tableView.dataSource = self;
    //    self.menuTableView.backgroundColor = [UIColor orangeColor];
//    [self.view addSubview:self.tableView];
//    self.tableView.tableFooterView = [[UIView alloc] init];
//    NSLog(@"%g, %g", self.navigationController.tabBarController.tabBar.bottom, self.navigationController.tabBarController.tabBar.top);
//    UIView * addView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height - self.navigationController.navigationBar.bottom - self.navigationController.tabBarController.tabBar.height - 60, self.view.width, 60)];
//    //    addView.backgroundColor = [UIColor greenColor];
//    UIButton * button = [UIButton buttonWithType:UIButtonTypeSystem];
//    button.frame = CGRectMake(50, 10, self.view.width - 100, 40);
//    [button setTitle:@"添加分类" forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(AddMenuAction:) forControlEvents:UIControlEventTouchUpInside];
//    button.tintColor = [UIColor whiteColor];
//    button.backgroundColor = [UIColor orangeColor];
//    [addView addSubview:button];
//    [self.view addSubview:addView];
    [self.tableView registerClass:[EditViewCell class] forCellReuseIdentifier:CELL_IDENTIFIER];
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
        _page = 1;
    _tangshipage = 1;
    if (self.segment.selectedSegmentIndex) {
        [self downloadDataWithCommand:@1 page:_tangshipage count:COUNT];
    }else
    {
        [self downloadDataWithCommand:@1 page:_page count:COUNT];
    }
    [self.tableView headerBeginRefreshing];
    [SVProgressHUD showWithStatus:@"正在加载..." maskType:SVProgressHUDMaskTypeBlack];
    
    [self addHearderView];
    
    
    if ([self respondsToSelector:@selector(headerBeginRefreshing)]) {
                self.automaticallyAdjustsScrollViewInsets = NO;
                UIEdgeInsets insets = self.tableView.contentInset;
                insets.top = self.navigationController.navigationBar.bounds.size.height +        [UIApplication sharedApplication].statusBarFrame.size.height;
                self.tableView.contentInset = insets;
                self.tableView.scrollIndicatorInsets = insets;
            }
    
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"1px.png"] forBarMetrics:UIBarMetricsDefault];
    if (self.segment.selectedSegmentIndex) {
        [self downloadDataWithCommand:@1 page:_tangshipage count:COUNT];
    }else
    {
        [self downloadDataWithCommand:@1 page:_page count:COUNT];
    }
}
 
- (void)addHearderView
{
    self.segment = [[UISegmentedControl alloc] initWithItems:@[@"外卖", @"堂食"]];
    
    self.segment.tintColor = [UIColor clearColor];//去掉颜色,现在整个segment都看不见
    self.segment.backgroundColor = [UIColor whiteColor];;
    //    self.segment.tintColor = [UIColor colorWithRed:222.0/255.0 green:7.0/255.0 blue:28.0/255.0 alpha:1.0];
    NSDictionary* selectedTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:16],
                                             NSForegroundColorAttributeName: [UIColor orangeColor]};
    [self.segment setTitleTextAttributes:selectedTextAttributes forState:UIControlStateSelected];//设置文字属性
    NSDictionary* unselectedTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:16],
                                               NSForegroundColorAttributeName: [UIColor grayColor]};
    [self.segment setTitleTextAttributes:unselectedTextAttributes forState:UIControlStateNormal];
    
    self.segment.selectedSegmentIndex = 0;
    self.segment.layer.cornerRadius = 5;
    
    _segment.frame = CGRectMake(20, 15, 100, 30);
    [_segment addTarget:self action:@selector(changeDeliveryState:) forControlEvents:UIControlEventValueChanged];
    
    self.segmentView = [[UIView alloc]initWithFrame:CGRectMake(20, 50, 50, 2)];
    self.segmentView.backgroundColor = [UIColor orangeColor];
    
    UIView * hearderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, HEARDERVIEW_HEIGHT)];
    hearderView.backgroundColor = [UIColor clearColor];
    [hearderView addSubview:_segment];
    [hearderView addSubview:_segmentView];
    
    UINavigationBar * bar = self.navigationController.navigationBar;
//    [bar setShadowImage:[UIImage imageNamed:@"1px.png"]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"1px.png"] forBarMetrics:UIBarMetricsDefault];
    
    self.navigationItem.titleView = hearderView;
}
- (void)changeDeliveryState:(UISegmentedControl *)segment
{
    if (segment.selectedSegmentIndex) {
        [self downloadDataWithCommand:@1 page:_tangshipage count:COUNT];
        [UIView animateWithDuration:0.35 animations:^{
            _segmentView.frame = CGRectMake(70, 50, 50, 2);
            
        }];
        
    }else
    {
        [self downloadDataWithCommand:@1 page:_page count:COUNT];
        [UIView animateWithDuration:0.35 animations:^{
            _segmentView.frame = CGRectMake(20, 50, 50, 2);
            
        }];
    }
    
}
- (void)startEditMenuAction:(UIBarButtonItem *)sender
{
    if ([self.navigationItem.leftBarButtonItem.title isEqualToString:@"编辑"]) {
        _isEdit = YES;
//        self.navigationItem.leftBarButtonItem.customView.hidden = NO;
//        self.navigationItem.rightBarButtonItem.customView.hidden = YES;
        [sender setTitle:@"完成"];
        [self.tableView reloadData];
    }else
    {
        _isEdit = NO;
//        self.navigationItem.leftBarButtonItem.customView.hidden = NO;
//        self.navigationItem.rightBarButtonItem.customView.hidden = YES;
        
        [sender setTitle:@"编辑"];

        [self.tableView reloadData];
 
    }
//    _isEdit = YES;
//    self.navigationItem.leftBarButtonItem.customView.hidden = NO;
//    self.navigationItem.rightBarButtonItem.customView.hidden = YES;
//    [self.menuTableView reloadData];
}

- (void)cancelMenuEdit:(UIButton *)sender
{
    _isEdit = NO;
    self.navigationItem.rightBarButtonItem.customView.hidden = NO;
    self.navigationItem.leftBarButtonItem.customView.hidden = YES;
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    _tangshipage = 1;
    //    self.dataArray = nil;
    if (self.segment.selectedSegmentIndex) {
        [self downloadDataWithCommand:@1 page:_tangshipage count:COUNT];
    }else
    {
        [self downloadDataWithCommand:@1 page:_page count:COUNT];
    }
}


- (void)footerRereshing
{
    [self tableViewEndRereshing];
    if (self.segment.selectedSegmentIndex) {
        if (self.waimaiArray.count < [_tangshiallCount integerValue]) {
            self.tableView.footerRefreshingText = @"正在加载数据";
            [self downloadDataWithCommand:@1 page:++_tangshipage count:COUNT];
        }else
        {
            self.tableView.footerRefreshingText = @"数据已经加载完";
            [self.tableView performSelector:@selector(footerEndRefreshing) withObject:nil afterDelay:1];
        }
    }else
    {
        if (self.waimaiArray.count < [_allCount integerValue]) {
            self.tableView.footerRefreshingText = @"正在加载数据";
            [self downloadDataWithCommand:@1 page:++_page count:COUNT];
        }else
        {
            self.tableView.footerRefreshingText = @"数据已经加载完";
            [self.tableView performSelector:@selector(footerEndRefreshing) withObject:nil afterDelay:1];
        }
    }
}


- (void)downloadDataWithCommand:(NSNumber *)command page:(int)page count:(int)count
{
    if (self.segment.selectedSegmentIndex) {
        NSDictionary * jsonDic = @{
                                   @"UserId":[UserInfo shareUserInfo].userId,
                                   @"CurPage":[NSNumber numberWithInt:page],
                                   @"Command":command,
                                   @"CurCount":[NSNumber numberWithInt:count],
                                   @"ClassifyType":@2
                                   };
        [self playPostWithDictionary:jsonDic];
    }else
    {
        NSDictionary * jsonDic = @{
                                   @"UserId":[UserInfo shareUserInfo].userId,
                                   @"CurPage":[NSNumber numberWithInt:page],
                                   @"Command":command,
                                   @"CurCount":[NSNumber numberWithInt:count],
                                   @"ClassifyType":@1
                                   };
        [self playPostWithDictionary:jsonDic];
    }
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
    NSLog(@"请求参数：%@", jsonStr);
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
            if (self.segment.selectedSegmentIndex) {
                self.tangshiallCount = [data objectForKey:@"AllCount"];
                if (_tangshipage == 1) {
                    self.tangshidataArray = nil;
                }
                NSArray * menuArray = [data objectForKey:@"ClassifyList"];
                for (NSDictionary * dic in menuArray) {
                    MenuModel * menuMD = [[MenuModel alloc] initWithDictionary:dic];
                    [self.tangshidataArray addObject:menuMD];
                }
                self.dataArray = self.tangshidataArray;
                [self.tableView reloadData];

            }else
            {
                self.allCount = [data objectForKey:@"AllCount"];
                if (_page == 1) {
                    self.waimaiArray = nil;
                }
                NSArray * menuArray = [data objectForKey:@"ClassifyList"];
                for (NSDictionary * dic in menuArray) {
                    MenuModel * menuMD = [[MenuModel alloc] initWithDictionary:dic];
                    [self.waimaiArray addObject:menuMD];
                }
                self.dataArray = self.waimaiArray;
                [self.tableView reloadData];
            }
            
//            self.automaticallyAdjustsScrollViewInsets = NO;
//            UIEdgeInsets insets = self.tableView.contentInset;
//            insets.top = self.navigationController.navigationBar.bounds.size.height +        [UIApplication sharedApplication].statusBarFrame.size.height;
//            self.tableView.contentInset = insets;
//            self.tableView.scrollIndicatorInsets = insets;
            
        }else if (command == 10010 || command == 10009 || command == 10008)
        {
            _page = 1;
            [self downloadDataWithCommand:@1 page:_page count:COUNT];
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"操作成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alertView show];
            [alertView performSelector:@selector(dismiss) withObject:nil afterDelay:1.5];
        }
        [self.tableView reloadData];
    }else
    {
        [SVProgressHUD dismiss];
        NSLog(@"删除失败");
        NSString * errorStr = [data objectForKey:@"ErrorMsg"];
        if (errorStr.length != 0) {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:errorStr delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alertView show];
            [alertView performSelector:@selector(dismiss) withObject:nil afterDelay:1.5];
        }else
        {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"操作失败" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alertView show];
            [alertView performSelector:@selector(dismiss) withObject:nil afterDelay:1.5];
        }
        
    }
    [self.tableView headerEndRefreshing];
    [self.tableView footerEndRefreshing];
    NSLog(@"%@", [data objectForKey:@"ErrorMsg"]);
}

- (void)failWithError:(NSError *)error
{
    [SVProgressHUD dismiss];
    UIAlertView * alerV = [[UIAlertView alloc] initWithTitle:@"提示" message:@"连接服务器失败" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [alerV show];
    [alerV performSelector:@selector(dismiss) withObject:nil afterDelay:1.5];
    [self.tableView headerEndRefreshing];
    [self.tableView footerEndRefreshing];
    NSLog(@"%@", error);
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
    [cell createSubViews:self.tableView.bounds withIsEdit:_isEdit];
    if (_isEdit) {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }else
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    }
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
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [[alert textFieldAtIndex:0] setText:menuMD.name];
    [[alert textFieldAtIndex:0] setPlaceholder:@"请输入分类名"];
//    [[alert textFieldAtIndex:1] setText:menuMD.describe];
//    [alert textFieldAtIndex:1].secureTextEntry = NO;
    [alert show];
    
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        if (alertView.tag == EDITALERT_TAG) {
            MenuModel * menuMD = [self.dataArray objectAtIndex:self.changIndex];
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
            MenuModel * menuMD = [self.dataArray objectAtIndex:self.changIndex];
            NSDictionary * jsonDic = @{
                                       @"UserId":[UserInfo shareUserInfo].userId,
                                       @"Command":@9,
                                       @"ClassifyId":menuMD.classifyId,
                                       };
            [self playPostWithDictionary:jsonDic];
            [SVProgressHUD showWithStatus:@"正在删除..." maskType:SVProgressHUDMaskTypeBlack];
        }
//        else if (alertView.tag == ADDMENUALERT_TAH)
//        {
//            int sortCode = 1000;
//            if ([alertView textFieldAtIndex:1].text.length != 0) {
//                sortCode = [[alertView textFieldAtIndex:1].text intValue];
//            }else
//            {
//                sortCode = 100;
//            }
//            if (self.segment.selectedSegmentIndex) {
//                NSDictionary * jsonDic = @{
//                                           @"UserId":[UserInfo shareUserInfo].userId,
//                                           @"ClassifyName":[alertView textFieldAtIndex:0].text,
//                                           @"Command":@8,
//                                           @"SortCode":@(sortCode),
//                                           @"ClassifyType":@2
//                                           };
//                [self playPostWithDictionary:jsonDic];
//
//            }else
//            {
//                NSDictionary * jsonDic = @{
//                                           @"UserId":[UserInfo shareUserInfo].userId,
//                                           @"ClassifyName":[alertView textFieldAtIndex:0].text,
//                                           @"Command":@8,
//                                           @"SortCode":@(sortCode),
//                                           @"ClassifyType":@1
//                                           };
//                [self playPostWithDictionary:jsonDic];
//            }
//            
//            [SVProgressHUD showWithStatus:@"正在添加..." maskType:SVProgressHUDMaskTypeBlack];
//        }
    }
}

//- (void)AddMenuAction:(UIButton *)button
//{
//    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"编辑" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//    alert.delegate = self;
//    alert.tag = ADDMENUALERT_TAH;
//    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
//    [[alert textFieldAtIndex:0] setPlaceholder:@"请输入菜单名"];
////    [[alert textFieldAtIndex:1] setPlaceholder:@"请输入活动名"];
////    [alert textFieldAtIndex:1].secureTextEntry = NO;
//    [alert show];
//}

- (void)createNewActivity:(UIBarButtonItem *)button
{
//    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"编辑" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//    alert.delegate = self;
//    alert.tag = ADDMENUALERT_TAH;
//    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
//    [[alert textFieldAtIndex:0] setPlaceholder:@"请输入菜单名"];
//    [[alert textFieldAtIndex:1]setPlaceholder:@"请输入菜单序号，越小越靠前(选填)"];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"新增" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *field)
     {
         field.placeholder = @"请输入菜单名";
         
     }];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *field)
     {
         field.placeholder = @"请输入菜单序号，越小越靠前(选填)";
         field.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
     }];
    
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                               {
                                   int sortCode = 1000;
                                   if (alert.textFields.lastObject.text.length != 0) {
                                       sortCode = [alert.textFields.lastObject.text intValue];
                                   }else
                                   {
                                       sortCode = 100;
                                   }
                                   if (self.segment.selectedSegmentIndex) {
                                       NSDictionary * jsonDic = @{
                                                                  @"UserId":[UserInfo shareUserInfo].userId,
                                                                  @"ClassifyName":alert.textFields.firstObject.text,
                                                                  @"Command":@8,
                                                                  @"SortCode":@(sortCode),
                                                                  @"ClassifyType":@2
                                                                  };
                                       [self playPostWithDictionary:jsonDic];
                                       
                                   }else
                                   {
                                       NSDictionary * jsonDic = @{
                                                                  @"UserId":[UserInfo shareUserInfo].userId,
                                                                  @"ClassifyName":alert.textFields.firstObject.text,
                                                                  @"Command":@8,
                                                                  @"SortCode":@(sortCode),
                                                                  @"ClassifyType":@1
                                                                  };
                                       [self playPostWithDictionary:jsonDic];
                                   }
                                   
                                   [SVProgressHUD showWithStatus:@"正在添加..." maskType:SVProgressHUDMaskTypeBlack];

                                   
                               }];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action)
                               {
                                   
                               }];
    [alert addAction:cancleAction];
    [alert addAction:OKAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.dataArray.count) {
        return 60;
    }
    return [EditViewCell cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MenuModel * menuMD = [self.dataArray objectAtIndex:indexPath.row];
    DetailsMenuViewController * detailsMenuVC = [[DetailsMenuViewController alloc] init];
    if (self.segment.selectedSegmentIndex == 1) {
        detailsMenuVC.isFromeWaimaiOrTangshi = 2;
    }else
    {
        detailsMenuVC.isFromeWaimaiOrTangshi = 1;
    }
    detailsMenuVC.classifyId = menuMD.classifyId;
    detailsMenuVC.hidesBottomBarWhenPushed = YES;
    detailsMenuVC.navigationItem.title = menuMD.name;
    [self.navigationController pushViewController:detailsMenuVC animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isEdit) {
        return NO;
    }
    return YES;
}

- (NSArray<UITableViewRowAction*>*)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction * deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"删除" message:@"确定要删除?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = DELETEALERT_TAG;
        [alert show];
    }];
    deleteAction.backgroundColor = [UIColor redColor];
    
    UITableViewRowAction * editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"编辑" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        self.changIndex = indexPath.row;
        MenuModel * menuMD = [self.dataArray objectAtIndex:indexPath.row];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"编辑" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alert addTextFieldWithConfigurationHandler:^(UITextField *field)
         {
             field.text = menuMD.name;
             
         }];
        
        [alert addTextFieldWithConfigurationHandler:^(UITextField *field)
         {
             field.text = [NSString stringWithFormat:@"%d", menuMD.SortCode];
             field.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
         }];
        
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                                   {
                                       int sortCode = 1000;
                                       if (alert.textFields.lastObject.text.length != 0) {
                                           sortCode = [alert.textFields.lastObject.text intValue];
                                       }else
                                       {
                                           sortCode = 100;
                                       }
                                       if (alert.textFields.firstObject.text.length != 0) {
                                           NSDictionary * jsonDic = @{
                                                                      @"UserId":[UserInfo shareUserInfo].userId,
                                                                      @"Command":@10,
                                                                      @"ClassifyId":menuMD.classifyId,
                                                                      @"ClassifyName":alert.textFields.firstObject.text,
                                                                      @"SortCode":@(sortCode),
                                                                      };
                                           [self playPostWithDictionary:jsonDic];
                                           [SVProgressHUD showWithStatus:@"正在添加..." maskType:SVProgressHUDMaskTypeBlack];
                                       }else
                                       {
                                           ;
                                       }
                                       
                                       
                                   }];
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action)
                                       {
                                          
                                       }];
        [alert addAction:cancleAction];
        [alert addAction:OKAction];
        [self presentViewController:alert animated:YES completion:nil];
        
    }];
    editAction.backgroundColor = [UIColor orangeColor];
    
    NSArray * arr = @[deleteAction, editAction];
    return arr;
}

// Override to support conditional editing of the table view.
//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
//    // Return NO if you do not want the specified item to be editable.
//    return NO;
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
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
