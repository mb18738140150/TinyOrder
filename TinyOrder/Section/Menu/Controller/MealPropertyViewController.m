//
//  MealPropertyViewController.m
//  TinyOrder
//
//  Created by 仙林 on 15/10/30.
//  Copyright © 2015年 仙林. All rights reserved.
//

#import "MealPropertyViewController.h"

#import "TasteView.h"
#import "TasteDetailsCell.h"
#import "TasteDetailModel.h"

#define CELLIDENTIFIRE @"cell"
#define NUM 4


@interface MealPropertyViewController ()<UIAlertViewDelegate,UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate, HTTPPostDelegate>

@property (nonatomic, strong)UITableView * tasteDetailTableView;

@property (nonatomic, copy)ReturnValueBlock returnValueBlock;

// 全部口味数组
@property (nonatomic, strong)NSMutableArray * allTasteDetailsArray;

@property (nonatomic, strong)UIView * helpView;

@property (nonatomic, strong)TasteView * longPressView;

// 弹出框
@property (nonatomic, strong)UIView * tanchuView;

// 添加口味视图
@property (nonatomic, strong)UIView * addTasteView;

// 口味信息设置视图
@property (nonatomic, strong)UIView * tastePriceAndIntegralView;

@property (nonatomic, strong)UITextField * tasteNameTF;
@property (nonatomic, assign)int attID;
@property (nonatomic, strong)UITextField * priceTF;
@property (nonatomic, strong)UITextField * integralTF;

@end

@implementation MealPropertyViewController

- (NSMutableArray *)tasteDetaileArray
{
    if (!_tasteDetaileArray) {
        self.tasteDetaileArray = [NSMutableArray array];
    }
    return _tasteDetaileArray;
}

- (NSMutableArray *)allTasteDetailsArray
{
    if (!_allTasteDetailsArray) {
        self.allTasteDetailsArray = [NSMutableArray array];
    }
    return _allTasteDetailsArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"菜品属性管理";
    
    self.view.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backLastVC:)];
    
    
    self.tasteDetailTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - self.navigationController.tabBarController.tabBar.height - 210)];
    [self.tasteDetailTableView registerClass:[TasteDetailsCell class] forCellReuseIdentifier:CELLIDENTIFIRE];
    
//    [self.menuTableView registerClass:[EditViewCell class] forCellReuseIdentifier:CELL_IDENTIFIER];

    self.tasteDetailTableView.dataSource = self;
    self.tasteDetailTableView.delegate = self;
    self.tasteDetailTableView.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    self.tasteDetailTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:_tasteDetailTableView];
    
    self.addTasteView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.height - 40, self.view.width, 30)];
    _addTasteView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_addTasteView];
    
    UIImageView * vir_line = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 2, 30)];
    vir_line.image = [UIImage imageNamed:@"vir_line.png"];
    [_addTasteView addSubview:vir_line];
    
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 80, 30)];
    titleLabel.text = @"全部口味";
    titleLabel.textColor = [UIColor grayColor];
    [_addTasteView addSubview:titleLabel];
    
    UIButton * addButton = [UIButton buttonWithType:UIButtonTypeSystem];
    addButton.frame = CGRectMake(_addTasteView.width - 50, 0, 50, 30);
//    [addButton setTitle:@"添加" forState:UIControlStateNormal];
//    [addButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [addButton setImage:[[UIImage imageNamed:@"attr_add.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(addTasteAction:) forControlEvents:UIControlEventTouchUpInside];
    [_addTasteView addSubview:addButton];
    
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, titleLabel.bottom, _addTasteView.width, 1)];
    view.backgroundColor = [UIColor grayColor];
    view.tag = 10000;
    view.hidden = YES;
    [_addTasteView addSubview:view];
    
    self.tasteScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, view.bottom, _addTasteView.width, 0)];
    _tasteScroll.contentSize = CGSizeMake(_addTasteView.width, 0);
    _tasteScroll.pagingEnabled = YES;
    _tasteScroll.delegate = self;
    [_addTasteView addSubview:_tasteScroll];
    
    self.tastePageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, _tasteScroll.bottom, _addTasteView.width, 0)];
    _tastePageControl.numberOfPages = 0;
    _tastePageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
    _tastePageControl.pageIndicatorTintColor = [UIColor grayColor];
    [_addTasteView addSubview:_tastePageControl];
    
    self.tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, _tastePageControl.bottom, self.view.width, 0)];
    _tipLabel.text = @"长按可删除";
    _tipLabel.textAlignment = NSTextAlignmentCenter;
    _tipLabel.textColor = [UIColor colorWithRed:249 / 255.0 green:72 / 255.0 blue:47 / 255.0 alpha:1];
    [_addTasteView addSubview:_tipLabel];
    
    self.tanchuView = [[UIView alloc]initWithFrame:self.view.bounds];
    _tanchuView.backgroundColor = [UIColor colorWithWhite:.5 alpha:1];
    _tanchuView.alpha = .1;
    
    self.helpView = [[UIView alloc]init];
    self.helpView.frame = CGRectMake(0, 0, 0, 0);
    
//    NSDictionary * jsonDic = @{
//                               @"UserId":[UserInfo shareUserInfo].userId,
//                               @"Command":@58
//                               };
//    [self playPostWithDictionary:jsonDic];

    
}

- (void)viewWillAppear:(BOOL)animated
{
    NSDictionary * jsonDic = @{
                               @"UserId":[UserInfo shareUserInfo].userId,
                               @"Command":@58
                               };
    [self playPostWithDictionary:jsonDic];
    if ([self.detailMD.mealId intValue]) {
        NSDictionary * jsonDic1 = @{
                                    @"UserId":[UserInfo shareUserInfo].userId,
                                    @"Command":@60,
                                    @"FoodId":self.detailMD.mealId
                                    };
        [self playPostWithDictionary:jsonDic1];
    }else if (self.foodId)
    {
        NSDictionary * jsonDic1 = @{
                                    @"UserId":[UserInfo shareUserInfo].userId,
                                    @"Command":@60,
                                    @"FoodId":@(self.foodId)
                                    };
        [self playPostWithDictionary:jsonDic1];
    }
    
    
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
    NSLog(@"data==%@", data);
    //    NSDictionary * dataDic = (NSDictionary *)data;
    if ([[data objectForKey:@"Result"] isEqual:@1]) {
        if ([[data objectForKey:@"Command"] isEqual:@10058]) {
            
            if (self.allTasteDetailsArray.count != 0) {
                [self.allTasteDetailsArray removeAllObjects];
            }
            
            NSArray * arr = [data objectForKey:@"AttrList"];
            
            for (NSDictionary * dic in arr) {
                TasteDetailModel * model = [[TasteDetailModel alloc]initWithDiationary:dic];
                [self.allTasteDetailsArray addObject:model];
            }
            
            [self showTasteDetails];
        }else if ([[data objectForKey:@"Command"] isEqual:@10057])
        {
            [SVProgressHUD dismiss];
            UIAlertView * alertV = [[UIAlertView alloc] initWithTitle:@"提示" message:@"添加成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alertV show];
            [alertV performSelector:@selector(dismiss) withObject:nil afterDelay:1.5];

            NSDictionary * jsonDic = @{
                                       @"UserId":[UserInfo shareUserInfo].userId,
                                       @"Command":@58
                                       };
            [self playPostWithDictionary:jsonDic];
        }else if ([[data objectForKey:@"Command"] isEqual:@10062])
        {
            [SVProgressHUD dismiss];
            UIAlertView * alertV = [[UIAlertView alloc] initWithTitle:@"提示" message:@"删除成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alertV show];
            [alertV performSelector:@selector(dismiss) withObject:nil afterDelay:1.5];

            NSDictionary * jsonDic = @{
                                       @"UserId":[UserInfo shareUserInfo].userId,
                                       @"Command":@58
                                       };
            [self playPostWithDictionary:jsonDic];
        }else if ([[data objectForKey:@"Command"] isEqual:@10059])
        {
            if (self.detailMD) {
                NSDictionary * jsonDic = @{
                                           @"UserId":[UserInfo shareUserInfo].userId,
                                           @"Command":@60,
                                           @"FoodId":self.detailMD.mealId,
                                           };
                [self playPostWithDictionary:jsonDic];
            }else if (self.foodId)
            {
                NSDictionary * jsonDic = @{
                                           @"UserId":[UserInfo shareUserInfo].userId,
                                           @"Command":@60,
                                           @"FoodId":@(self.foodId)
                                           };
                [self playPostWithDictionary:jsonDic];
            }
            
        }else if ([[data objectForKey:@"Command"] isEqual:@10060])
        {
            
            if (self.tasteDetaileArray.count != 0) {
                [self.tasteDetaileArray removeAllObjects];
            }
            NSArray * array = [data objectForKey:@"AttList"];
            for (NSDictionary * dic in array) {
                TasteDetailModel * model = [[TasteDetailModel alloc]initWithDiationary:dic];
                [self.tasteDetaileArray addObject:model];
            }
            [self.tasteDetailTableView reloadData];
        }else if ([[data objectForKey:@"Command"] isEqual:@10061])
        {
            UIAlertView * alertV = [[UIAlertView alloc] initWithTitle:@"提示" message:@"删除成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alertV show];
            [alertV performSelector:@selector(dismiss) withObject:nil afterDelay:1.5];
            if (self.detailMD) {
                NSDictionary * jsonDic = @{
                                           @"UserId":[UserInfo shareUserInfo].userId,
                                           @"Command":@60,
                                           @"FoodId":self.detailMD.mealId
                                           };
                [self playPostWithDictionary:jsonDic];
            }else if (self.foodId)
            {
                NSDictionary * jsonDic = @{
                                           @"UserId":[UserInfo shareUserInfo].userId,
                                           @"Command":@60,
                                           @"FoodId":@(self.foodId)
                                           };
                [self playPostWithDictionary:jsonDic];
            }
        }
        
    }else
    {
        [SVProgressHUD dismiss];
        UIAlertView * alertV = [[UIAlertView alloc] initWithTitle:@"提示" message:[data objectForKey:@"ErrorMsg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertV show];
        [alertV performSelector:@selector(dismiss) withObject:nil afterDelay:1.5];
    }
    NSLog(@"%@", [data objectForKey:@"ErrorMsg"]);
}


- (void)backLastVC:(id)sender
{
    if (self.detailMD) {
        [self.navigationController popViewControllerAnimated:YES];
    }else
    {
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
    }
    self.foodId = 0;
    self.detailMD = nil;
}

- (void)showTasteDetails
{
    if (self.allTasteDetailsArray.count != 0) {
        
        UIView * view = [_addTasteView viewWithTag:10000];
        view.hidden = NO;
        
        [_tasteScroll removeAllSubviews];
        
        self.helpView.frame = CGRectMake(0, 0, 0, 0);
        
        for (TasteDetailModel * tasteModel in self.allTasteDetailsArray) {
            
//            NSLog(@"***dic = %@***", tasteModel.attName);
            
            TasteView * tasteView = [[TasteView alloc]init];
            
            
            if ((((self.helpView.right - (int)(self.helpView.right / self.view.width) * self.view.width) == 0 ) && self.helpView.bottom == 140) || ((self.view.width - (self.helpView.right - (int)(self.helpView.right / self.view.width) * self.view.width) < 1 ) && self.helpView.bottom == 140)) {
                
                if ((self.helpView.right - (int)(self.helpView.right / self.view.width) * self.view.width) == 0) {
                    tasteView.frame = CGRectMake((self.helpView.right / self.view.width ) * self.view.width , 0, self.view.width / NUM, 70);
                    [tasteView createSubviews];
                }else
                {
                    tasteView.frame = CGRectMake(((int)(self.helpView.right / self.view.width ) +1) * self.view.width , 0, self.view.width / NUM, 70);
                    [tasteView createSubviews];
                }
                
            }else if ((self.helpView.right - (int)(self.helpView.right / self.view.width) * self.view.width) == 0 || (self.view.width - (self.helpView.right - (int)(self.helpView.right / self.view.width) * self.view.width) < 1 ))
            {
//                NSLog(@"***%f***", (self.view.width - (self.helpView.right - (int)(self.helpView.right / self.view.width) * self.view.width)  ));
//                NSLog(@"*****%f******%f*", self.helpView.right, self.helpView.width);
                if ((self.helpView.right - (int)(self.helpView.right / self.view.width) * self.view.width) == 0) {
                    
                    if ((self.helpView.right / self.view.width) == 1 || self.helpView.right  == 0 ) {
                        tasteView.frame = CGRectMake(0, _helpView.bottom, self.view.width / NUM, 70);
                        [tasteView createSubviews];
                    }else
                    {
                        tasteView.frame = CGRectMake(((int)(self.helpView.right / self.view.width) - 1) * self.view.width, _helpView.bottom, self.view.width / NUM, 70);
                        [tasteView createSubviews];
                    }
                }else
                {
                    tasteView.frame = CGRectMake(((int)(self.helpView.right / self.view.width) ) * self.view.width, _helpView.bottom, self.view.width / NUM, 70);
                    [tasteView createSubviews];
                }
                
                
            }else
            {
                tasteView.frame = CGRectMake(_helpView.right, _helpView.top, self.view.width / NUM, 70);
                [tasteView createSubviews];
            }
            
            
            _helpView.frame = tasteView.frame;
            
            tasteView.attId = tasteModel.attId;
            
            [tasteView.nameButton setTitle:[NSString stringWithFormat:@"%@", tasteModel.attName] forState:UIControlStateNormal];
            [tasteView.nameButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [tasteView.nameButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];

            [tasteView.nameButton addTarget:self action:@selector(choceTasteAction:) forControlEvents:UIControlEventTouchUpInside];
            
            UILongPressGestureRecognizer * longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(deleteAction:)];
            
            [tasteView.nameButton addGestureRecognizer:longPress];
            
            [self.tasteScroll addSubview:tasteView];
            
            if (_helpView.bottom == 140 || _helpView.right > self.view.width) {
                self.tasteScroll.frame = CGRectMake(0, 31, _addTasteView.width, 140);
            }else
            {
                self.tasteScroll.frame = CGRectMake(0, 31, _addTasteView.width, 70);
            }
            
            if (((_helpView.right / self.view.width) - (int)(_helpView.right / self.view.width) == 0) ) {
                
                self.tasteScroll.contentSize = CGSizeMake(self.view.width * ((int)_helpView.right / self.view.width ), _tasteScroll.height);
                
                self.tastePageControl.numberOfPages = _helpView.right / self.view.width;
            }else
            {
                self.tasteScroll.contentSize = CGSizeMake(self.view.width * ((int)(_helpView.right / self.view.width) + 1), _tasteScroll.height);
                
                self.tastePageControl.numberOfPages = _helpView.right / self.view.width + 1;
            }
            
            self.tastePageControl.frame = CGRectMake(0, _tasteScroll.bottom, _addTasteView.width, 30);
            
            self.tipLabel.frame = CGRectMake(0, _tastePageControl.bottom, _addTasteView.width, 20);
            
            self.addTasteView.frame = CGRectMake(0, self.view.height - 40 - _tasteScroll.height - _tastePageControl.height - _tipLabel.height, self.view.width, 30 + _tastePageControl.height + _tasteScroll.height);
            
            self.tasteDetailTableView.frame = CGRectMake(0, 0, self.view.width, _addTasteView.top - 5 );
        }
        
        
    }
    
}

#pragma mark - 长按删除
- (void)deleteAction:(UILongPressGestureRecognizer *)sender
{
    
    UIButton * button = (UIButton *)sender.view;
    self.longPressView = (TasteView *)[button superview];
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确定删除?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
//        NSLog(@"开始长按");
    }else if (sender.state == UIGestureRecognizerStateChanged)
    {
//        NSLog(@"*******");
    }else if (sender.state == UIGestureRecognizerStateEnded)
    {
        NSLog(@"长按结束");
    }
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        int i = -1;
        for (int j = 0; j < self.allTasteDetailsArray.count; j++) {
            TasteDetailModel * model = [self.allTasteDetailsArray objectAtIndex:j];
            if (self.longPressView.attId == model.attId) {
                i = j;
                break;
            }
        }
        
        TasteDetailModel * tasteModel = [self.allTasteDetailsArray objectAtIndex:i];
        
        NSDictionary * jsonDic = @{
                                   @"UserId":[UserInfo shareUserInfo].userId,
                                   @"Command":@62,
                                   @"AttId":@(tasteModel.attId)
                                   };
        [self playPostWithDictionary:jsonDic];
        
        [SVProgressHUD showWithStatus:@"正在删除..." maskType:SVProgressHUDMaskTypeBlack];
    }
}

#pragma mark - TableViewDatesource And TableviewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tasteDetaileArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TasteDetailsCell * cell = [tableView dequeueReusableCellWithIdentifier:CELLIDENTIFIRE forIndexPath:indexPath];
    
    [cell creatSubviews:self.tasteDetailTableView.bounds];
    
    TasteDetailModel * tasteModel = [self.tasteDetaileArray objectAtIndex:indexPath.row];
    
    cell.tasteDetailsView.nameLabel.text = tasteModel.attName;
    cell.tasteDetailsView.integralLabel.text = [NSString stringWithFormat:@"%d", tasteModel.attIntegral];
    cell.tasteDetailsView.priceLabel.text = [NSString stringWithFormat:@"%.2f", tasteModel.attPrice];
    
    
//    cell.tasteDetailsView.nameLabel.text = @"好好吃";
//    cell.tasteDetailsView.integralLabel.text = @"100积分";
//    cell.tasteDetailsView.priceLabel.text = @"10.00元";
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
// 删除菜品附加属性
- (NSArray<UITableViewRowAction*>*)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction * rowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        TasteDetailModel * model = [self.tasteDetaileArray objectAtIndex:indexPath.row];
        
        if (self.detailMD) {
            NSDictionary * jsonDic = @{
                                       @"UserId":[UserInfo shareUserInfo].userId,
                                       @"Command":@61,
                                       @"AttId":@(model.attId),
                                       @"FoodId":self.detailMD.mealId
                                       };
            [self playPostWithDictionary:jsonDic];
        }else if (self.foodId)
        {
            NSDictionary * jsonDic = @{
                                       @"UserId":[UserInfo shareUserInfo].userId,
                                       @"Command":@61,
                                       @"AttId":@(model.attId),
                                       @"FoodId":@(self.foodId)
                                       };
            [self playPostWithDictionary:jsonDic];
        }
        
    }];
    rowAction.backgroundColor = [UIColor redColor];
    NSArray * arr = @[rowAction];
    return arr;
}

#pragma mark - 添加菜品属性
- (void)addTasteAction:(UIButton *)button
{
    
    [self.view addSubview:_tanchuView];
    
    [_tanchuView removeAllSubviews];
    
    UIView *addTasteView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width - 20, 200)];
    addTasteView.center = _tanchuView.center;
    addTasteView.backgroundColor = [UIColor whiteColor];
    [_tanchuView addSubview:addTasteView];
    
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, addTasteView.width - 40, 30)];
    titleLabel.text = @"添加属性";
    [addTasteView addSubview:titleLabel];
    
    self.tasteNameTF = [[UITextField alloc]initWithFrame:CGRectMake(20, titleLabel.bottom + 50, titleLabel.width, 30)];
    _tasteNameTF.placeholder = @"属性名称";
    _tasteNameTF.borderStyle = UITextBorderStyleNone;
    [addTasteView addSubview:_tasteNameTF];
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(20, _tasteNameTF.bottom, addTasteView.width - 40, 1)];
    lineView.backgroundColor = [UIColor orangeColor];
    [addTasteView addSubview:lineView];
    
    UIButton * cancleButton = [UIButton buttonWithType:UIButtonTypeSystem];
    cancleButton.frame = CGRectMake(40, lineView.bottom + 9, 80, 40);
    [cancleButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancleButton addTarget:self action:@selector(cancleADDTasteAction) forControlEvents:UIControlEventTouchUpInside];
    [addTasteView addSubview:cancleButton];
    
    UIButton * sureButton = [UIButton buttonWithType:UIButtonTypeSystem];
    sureButton.frame = CGRectMake(addTasteView.width - 40 - 80, cancleButton.top, cancleButton.width, cancleButton.height);
    [sureButton setTitle:@"确定" forState:UIControlStateNormal];
    [sureButton addTarget:self action:@selector(sureAddTaste:) forControlEvents:UIControlEventTouchUpInside];
    [addTasteView addSubview:sureButton];
    
    [self animateIn];
}

- (void)animateIn
{
    self.tanchuView.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.tanchuView.alpha = 0;
    [UIView animateWithDuration:0.35 animations:^{
        self.tanchuView.alpha = .9;
        self.tanchuView.transform = CGAffineTransformMakeScale(1, 1);
    }];
}

#pragma mark - 确定.取消添加菜品属性
- (void)cancleADDTasteAction
{
    [self.tanchuView removeFromSuperview];
}

- (void)sureAddTaste:(UIButton *)button
{
    if (self.tasteNameTF.text.length == 0) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"属性名称不能为空" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }else
    {
        UIView * view = [_addTasteView viewWithTag:10000];
        view.hidden = NO;
        
        
        NSDictionary * jsonDic = @{
                                   @"UserId":[UserInfo shareUserInfo].userId,
                                   @"Command":@57,
                                   @"AttrName":self.tasteNameTF.text
                                   };
        [self playPostWithDictionary:jsonDic];
        [SVProgressHUD showWithStatus:@"正在添加..." maskType:SVProgressHUDMaskTypeBlack];
//        
//        TasteView * tasteView = [[TasteView alloc]init];
//        
////        NSLog(@"******self.helpView.right / self.view.width = %f***", self.helpView.right / self.view.width);
////        NSLog(@"*****(self.view.width - (self.helpView.right - (self.helpView.right / self.view.width) * self.view.width) = %f", (self.view.width - (self.helpView.right - (self.helpView.right / self.view.width) * self.view.width)));
////        
////        NSLog(@"******self.view.width = %f*******self.helpView.right = %f",self.view.width, self.helpView.right );
//        
//        
//        if (((self.helpView.right - (int)(self.helpView.right / self.view.width) * self.view.width) == 0 ) && self.helpView.bottom == 140) {
//            tasteView.frame = CGRectMake((self.helpView.right / self.view.width ) * self.view.width , 0, self.view.width / 4, 70);
//            [tasteView createSubviews];
//        }else if ((self.helpView.right - (int)(self.helpView.right / self.view.width) * self.view.width) == 0 )
//        {
//            if ((int)(self.helpView.right / self.view.width) == 1 || self.helpView.right  == 0 ) {
//                tasteView.frame = CGRectMake(0, _helpView.bottom, self.view.width / 4, 70);
//                [tasteView createSubviews];
//            }else
//            {
//                tasteView.frame = CGRectMake(((int)(self.helpView.right / self.view.width) - 1) * self.view.width, _helpView.bottom, self.view.width / 2, 70);
//                [tasteView createSubviews];
//            }
//            
//        }else
//        {
//            tasteView.frame = CGRectMake(_helpView.right, _helpView.top, self.view.width / 4, 70);
//            [tasteView createSubviews];
//        }
//        
//        
//        
//        [self.allTasteDetailsArray addObject:tasteView];
//        
//        _helpView.frame = tasteView.frame;
//        
//        [tasteView.nameButton setTitle:[NSString stringWithFormat:@"%@", _tasteNameTF.text] forState:UIControlStateNormal];
//        [tasteView.nameButton addTarget:self action:@selector(choceTasteAction:) forControlEvents:UIControlEventTouchUpInside];
//        
//        [self.tasteScroll addSubview:tasteView];
//        
//        if (_helpView.bottom == 140 || _helpView.right > self.view.width) {
//            self.tasteScroll.frame = CGRectMake(0, 31, _addTasteView.width, 140);
//        }else
//        {
//            self.tasteScroll.frame = CGRectMake(0, 31, _addTasteView.width, 70);
//        }
//        
//        if (((_helpView.right / self.view.width) - (int)(_helpView.right / self.view.width) == 0) ) {
////            || (_helpView.bottom == 140 && ((_helpView.right / self.view.width) - (int)(_helpView.right / self.view.width) != 0))
//            self.tasteScroll.contentSize = CGSizeMake(self.view.width * ((int)_helpView.right / self.view.width ), _tasteScroll.height);
//            
//            self.tastePageControl.numberOfPages = _helpView.right / self.view.width;
//        }else
//        {
//        self.tasteScroll.contentSize = CGSizeMake(self.view.width * ((int)(_helpView.right / self.view.width) + 1), _tasteScroll.height);
//        
//        self.tastePageControl.numberOfPages = _helpView.right / self.view.width + 1;
//        }
//        
//        self.tastePageControl.frame = CGRectMake(0, _tasteScroll.bottom, _addTasteView.width, 30);
//        
//        self.tipLabel.frame = CGRectMake(0, _tastePageControl.bottom, _addTasteView.width, 20);
//        
//        self.addTasteView.frame = CGRectMake(0, self.view.height - 40 - _tasteScroll.height - _tastePageControl.height - _tipLabel.height, self.view.width, 30 + _tastePageControl.height + _tasteScroll.height);
        
    }
    
    [self.tanchuView removeFromSuperview];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.tastePageControl.currentPage = self.tasteScroll.contentOffset.x / self.view.width;
}

#pragma mark - 添加某菜品附加属性

- (void)choceTasteAction:(UIButton *)button
{
    button.tintColor = [UIColor whiteColor];
//    button.backgroundColor = [UIColor whiteColor];
    
    TasteView * view = (TasteView *)[button superview];
    
    button.selected = !button.selected;
    if (button.selected) {
        view.stateImageview.layer.borderColor = [UIColor orangeColor].CGColor;

    }else
    {
    view.stateImageview.layer.borderColor = [UIColor grayColor].CGColor;
    }
    
    [self.view addSubview:_tanchuView];
    
    [_tanchuView removeAllSubviews];
    
    self.attID = view.attId;
    
    UIView *tastePriceAndIntegralView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width - 20, 260)];
    tastePriceAndIntegralView.center = _tanchuView.center;
    tastePriceAndIntegralView.backgroundColor = [UIColor whiteColor];
    [_tanchuView addSubview:tastePriceAndIntegralView];
    
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, tastePriceAndIntegralView.width - 40 - 150, 30)];
    titleLabel.text = @"您选中了:";
    [tastePriceAndIntegralView addSubview:titleLabel];
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(titleLabel.right, 20, 150, 30)];
    label.text = [NSString stringWithFormat:@"%@", button.titleLabel.text];
    label.tag = 1000;
    label.textColor = [UIColor colorWithRed:249 / 255.0 green:72 / 255.0 blue:47 / 255.0 alpha:1];
    [tastePriceAndIntegralView addSubview:label];
    
    UILabel * priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, titleLabel.bottom + 50, 30, 30)];
    priceLabel.textColor = [UIColor colorWithRed:249 / 255.0 green:72 / 255.0 blue:47 / 255.0 alpha:1];
    priceLabel.textAlignment = NSTextAlignmentCenter;
    priceLabel.text = @"￥";
    [tastePriceAndIntegralView addSubview:priceLabel];
    
    self.priceTF = [[UITextField alloc]initWithFrame:CGRectMake(priceLabel.right, titleLabel.bottom + 50, tastePriceAndIntegralView.width - 70, 30)];
    _priceTF.placeholder = @"为您选中的菜品设置价格";
    _priceTF.borderStyle = UITextBorderStyleNone;
    _priceTF.keyboardType = UIKeyboardTypeNumberPad;
    [tastePriceAndIntegralView addSubview:_priceTF];
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(20, _priceTF.bottom, tastePriceAndIntegralView.width - 40, 1)];
    lineView.backgroundColor = [UIColor colorWithRed:249 / 255.0 green:72 / 255.0 blue:47 / 255.0 alpha:1];
    [tastePriceAndIntegralView addSubview:lineView];
    
    UILabel * integralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, lineView.bottom + 10, 30, 30)];
    integralLabel.textColor = [UIColor colorWithRed:249 / 255.0 green:72 / 255.0 blue:47 / 255.0 alpha:1];
    integralLabel.textAlignment = NSTextAlignmentCenter;
    integralLabel.text = @"积";
    [tastePriceAndIntegralView addSubview:integralLabel];
    
    self.integralTF = [[UITextField alloc]initWithFrame:CGRectMake(integralLabel.right, lineView.bottom + 10, tastePriceAndIntegralView.width - 70, 30)];
    _integralTF.placeholder = @"为您选中的菜品设置积分";
    _integralTF.borderStyle = UITextBorderStyleNone;
    _integralTF.keyboardType = UIKeyboardTypeNumberPad;
    [tastePriceAndIntegralView addSubview:_integralTF];
    
    UIView * lineView1 = [[UIView alloc]initWithFrame:CGRectMake(20, _integralTF.bottom, tastePriceAndIntegralView.width - 40, 1)];
    lineView1.backgroundColor = [UIColor colorWithRed:249 / 255.0 green:72 / 255.0 blue:47 / 255.0 alpha:1];
    [tastePriceAndIntegralView addSubview:lineView1];
    
    
    UIButton * cancleButton = [UIButton buttonWithType:UIButtonTypeSystem];
    cancleButton.frame = CGRectMake(40, lineView1.bottom + 9, 80, 40);
    [cancleButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancleButton addTarget:self action:@selector(cancleTastepriceAction) forControlEvents:UIControlEventTouchUpInside];
    [tastePriceAndIntegralView addSubview:cancleButton];
    
    UIButton * sureButton = [UIButton buttonWithType:UIButtonTypeSystem];
    sureButton.frame = CGRectMake(tastePriceAndIntegralView.width - 40 - 80, cancleButton.top, cancleButton.width, cancleButton.height);
    [sureButton setTitle:@"确定" forState:UIControlStateNormal];
    [sureButton addTarget:self action:@selector(sureTasteprice:) forControlEvents:UIControlEventTouchUpInside];
    [tastePriceAndIntegralView addSubview:sureButton];

    [self animateIn];
}

- (void)cancleTastepriceAction
{
    [self.tanchuView removeFromSuperview];
}

- (void)sureTasteprice:(UIButton *)button
{
//    UIView *view1 = [button superview];
//    UILabel * label = (UILabel *)[view1 viewWithTag:1000];
    
    [self.tanchuView removeFromSuperview];
    
    if (self.priceTF.text.length == 0) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"菜品价格不能为0" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }else
    {
        if (self.detailMD) {
            NSDictionary * jsonDic = @{
                                       @"UserId":[UserInfo shareUserInfo].userId,
                                       @"Command":@59,
                                       @"AttrId":@(self.attID),
                                       @"FoodId":self.detailMD.mealId,
                                       @"AttrPrice":@([self.priceTF.text doubleValue]),
                                       @"AttrIntegral":@([self.integralTF.text integerValue])
                                       };
            [self playPostWithDictionary:jsonDic];
        }else if (self.foodId)
        {
            NSDictionary * jsonDic = @{
                                       @"UserId":[UserInfo shareUserInfo].userId,
                                       @"Command":@59,
                                       @"AttrId":@(self.attID),
                                       @"FoodId":@(self.foodId),
                                       @"AttrPrice":@([self.priceTF.text doubleValue]),
                                       @"AttrIntegral":@([self.integralTF.text integerValue])
                                       };
            [self playPostWithDictionary:jsonDic];
        }
        
    }
    
    
}

- (void)returnPropertyValue:(ReturnValueBlock)valueBlock
{
    _returnValueBlock = valueBlock;
}

//- (void)viewWillDisappear:(BOOL)animated
//{
//    if (_returnValueBlock) {
//        _returnValueBlock();
//    }
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
