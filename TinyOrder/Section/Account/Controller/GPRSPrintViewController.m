//
//  GPRSPrintViewController.m
//  TinyOrder
//
//  Created by 仙林 on 15/9/9.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "GPRSPrintViewController.h"
#import "GPRSprintViewCell.h"
#import "GPRSPrintModel.h"
#import "CustomIOSAlertView.h"

#import "NewOrderModel.h"
#import "Meal.h"

#import "EquipmentInformationViewController.h"

#define CELL_INDENTIFIER @"cell"

#define TOP_SPACE 20
#define LEFT_SPACE 20
#define BUTTON_WIDTH 40
#define BUTTON_HEIGHT 40
#define VIEW_HEIGT TOP_SPACE + 2 * BUTTON_HEIGHT + 1
#define VIEW_WIDTH LEFT_SPACE * 2 + BUTTON_WIDTH * 6


@interface GPRSPrintViewController ()<UITableViewDataSource,UITableViewDelegate, HTTPPostDelegate, CustomIOSAlertViewDelegate>

@property (nonatomic, retain)NSMutableArray *gprsDataArray;
@property (nonatomic, strong)GPRSPrintModel *deleteModel;
@property (nonatomic, strong)GPRSPrintModel *startOrStopModel;
@property (nonatomic, strong)GPRSPrintModel *changeModel;
@property (nonatomic, assign)CGPoint currentTouchPoint;

@property (nonatomic, strong)UITextField *numberTF;

@end

@implementation GPRSPrintViewController


- (NSMutableArray *)gprsDataArray
{
    if (!_gprsDataArray) {
        self.gprsDataArray = [NSMutableArray array];
    }
    return _gprsDataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"GPRS打印";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"back.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backLastVC:)];
    
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 110)];
    UIButton * button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(20, 10, self.tableView.frame.size.width - 40, 40);
    [button setTitle:@"添加设备" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor colorWithRed:249 / 255.0 green:72 / 255.0 blue:47 / 255.0 alpha:1];
    button.titleLabel.font = [UIFont systemFontOfSize:20];
    button.layer.cornerRadius = 5;
    button.layer.masksToBounds = YES;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(addAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.tableView.tableFooterView addSubview:button];
    
    UILabel * tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, button.bottom + 10, self.tableView.frame.size.width - 40, 60)];
    tipLabel.text = @"温馨提示：如果您没有GPRS打印机，请到蓝牙打印机设置页面设定打印份数为0，即可处理订单";
    tipLabel.textColor = [UIColor colorWithRed:249 / 255.0 green:72 / 255.0 blue:47 / 255.0 alpha:1];
    tipLabel.font = [UIFont systemFontOfSize:14];
    tipLabel.numberOfLines = 0;
//    [self.tableView.tableFooterView addSubview:tipLabel];
    
    
//    UIButton * setUpbutton = [UIButton buttonWithType:UIButtonTypeSystem];
//    setUpbutton.frame = CGRectMake(20, button.bottom + 10, self.tableView.frame.size.width - 40, 40);
//    [setUpbutton setTitle:@"设置打印份数" forState:UIControlStateNormal];
//    setUpbutton.backgroundColor = [UIColor colorWithRed:249 / 255.0 green:72 / 255.0 blue:47 / 255.0 alpha:1];
//    setUpbutton.titleLabel.font = [UIFont systemFontOfSize:20];
//    setUpbutton.layer.cornerRadius = 5;
//    setUpbutton.layer.masksToBounds = YES;
//    [setUpbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [setUpbutton addTarget:self action:@selector(setUpPrintNum:) forControlEvents:UIControlEventTouchUpInside];
//    [self.tableView.tableFooterView addSubview:setUpbutton];
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"停止" style:UIBarButtonItemStylePlain target:self action:@selector(stopOrStart)];
    NSDictionary* selectedTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:16],
                                             NSForegroundColorAttributeName: [UIColor blackColor]};
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:selectedTextAttributes forState:UIControlStateNormal];
    if ([PrintType sharePrintType].printState == 1) {
        [self.navigationItem.rightBarButtonItem setTitle:@"停止"];
        [PrintType sharePrintType].isGPRSenable = YES;
//        [PrintType sharePrintType].printType = 2;
    }else
    {
       [self.navigationItem.rightBarButtonItem setTitle:@"启动"];
        [PrintType sharePrintType].isGPRSenable = NO;
    }
    
    [self.tableView registerClass:[GPRSprintViewCell class] forCellReuseIdentifier:CELL_INDENTIFIER];
    NSDictionary *jsondic = @{
                           @"Command":@50,
                           @"UserId":[UserInfo shareUserInfo].userId
                           };
    [self playPostWithDictionary:jsondic];
    [SVProgressHUD showWithStatus:@"加载数据" maskType:SVProgressHUDMaskTypeBlack];
}

- (void)viewWillAppear:(BOOL)animated
{
//    NSLog(@"*****%d", [PrintType sharePrintType].printType);
    
    if ([PrintType sharePrintType].printState == 1) {
        [self.navigationItem.rightBarButtonItem setTitle:@"停止"];
        [PrintType sharePrintType].isGPRSenable = YES;
//        [PrintType sharePrintType].printType = 2;
    }else
    {
        [self.navigationItem.rightBarButtonItem setTitle:@"启动"];
        [PrintType sharePrintType].isGPRSenable = NO;
    }
    
}

- (void)backLastVC:(UIBarButtonItem *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)stopOrStart
{

        if ([PrintType sharePrintType].printState == 1) {
            NSDictionary * jsondis = @{
                                       @"Command":@55,
                                       @"UserId":[UserInfo shareUserInfo].userId,
                                       @"PrintState":@2
                                       };
            [self playPostWithDictionary:jsondis];
        }else{
            NSDictionary * jsondis = @{
                                       @"Command":@55,
                                       @"UserId":[UserInfo shareUserInfo].userId,
                                       @"PrintState":@1
                                       };
            [self playPostWithDictionary:jsondis];
        }
}

#pragma mark - 数据请求


- (void)playPostWithDictionary:(NSDictionary *)dic
{
    NSString * jsonStr = [dic JSONString];
    NSLog(@"%@", jsonStr);
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
        NSNumber * command = [data objectForKey:@"Command"];
        if ([command isEqualToNumber:@10050]) {
            
            [PrintType sharePrintType].printState = (int)[data objectForKey:@"GprsState"];
            
            NSArray * array = [data objectForKey:@"PrintList"];
            self.gprsDataArray = nil;
            for (NSDictionary * dic in array) {
                GPRSPrintModel * activityMD = [[GPRSPrintModel alloc] initWithDictionary:dic];
                if (self.gprsDataArray.count == 0) {
                    [self.gprsDataArray addObject:activityMD];
                }else{
                    [self.gprsDataArray removeAllObjects];
                    [self.gprsDataArray addObject:activityMD];
                }
                
            }
            [self.tableView reloadData];
            [self tableViewEndRereshing];
            [SVProgressHUD dismiss];
        }else if ([command isEqualToNumber:@10053])
        {
            NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:self.currentTouchPoint];
            GPRSprintViewCell *cell = (GPRSprintViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
//            cell.isEnableBT.selected = !cell.isEnableBT.selected;
            
            
            
            if ([cell.isEnableBT.titleLabel.text isEqualToString:@"启用"]) {
                [cell.isEnableBT setTitle:@"禁止" forState:UIControlStateNormal];
                [cell.isEnableBT setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
                cell.isEnableBT.tintColor = [UIColor clearColor];
                [PrintType sharePrintType].isGPRS = YES;
            NSLog(@"*******以启用");
                
            }else
            {
                [cell.isEnableBT setTitle:@"启用" forState:UIControlStateNormal];
                [cell.isEnableBT setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
                [PrintType sharePrintType].isGPRS = NO;
                        NSLog(@"********已经禁止");
            }
        }else if ([command isEqualToNumber:@10052])
        {
            [self.gprsDataArray removeObject:self.deleteModel];
            [self.tableView reloadData];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"删除设备成功" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            [alert performSelector:@selector(dismiss) withObject:self afterDelay:1.0];
        }else if ([command isEqualToNumber:@10055])
        {
            if ([PrintType sharePrintType].printState == 1) {
                [PrintType sharePrintType].printState = 2;
                [self.navigationItem.rightBarButtonItem setTitle:@"启用"];
                [PrintType sharePrintType].isGPRSenable = NO;
//                [PrintType sharePrintType].printType = 0;
            }else{
                [PrintType sharePrintType].printState = 1;
                [self.navigationItem.rightBarButtonItem setTitle:@"停止"];
                [PrintType sharePrintType].isGPRSenable = YES;
//                [PrintType sharePrintType].printType = 2;
            }
            
        }else if ([command isEqualToNumber:@10056])
        {
            NSDictionary *jsondic = @{
                                      @"Command":@50,
                                      @"UserId":[UserInfo shareUserInfo].userId
                                      };
            [self playPostWithDictionary:jsondic];
            
            [self.tableView reloadData];
        }
    }else
    {
        if ([[data objectForKey:@"Command"] isEqualToNumber:@10052])
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"删除设备失败" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            [alert performSelector:@selector(dismiss) withObject:self afterDelay:1.0];
        }else if([[data objectForKey:@"Command"] isEqualToNumber:@10053])
        {
            NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:self.currentTouchPoint];
            GPRSprintViewCell *cell = (GPRSprintViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
            if ([cell.isEnableBT.titleLabel.text isEqualToString:@"启用"]) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"启动设备失败" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
                [alert show];
                [alert performSelector:@selector(dismiss) withObject:self afterDelay:1.0];
                
                
            }else
            {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"禁止设备失败" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
                [alert show];
                [alert performSelector:@selector(dismiss) withObject:self afterDelay:1.0];
                
            }

        }else{
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"失败" message:[data objectForKey:@"ErrorMsg"] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:2];
        [SVProgressHUD dismiss];
        }
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
#pragma mark - TableView Delegate & Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.gprsDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GPRSPrintModel *model = [self.gprsDataArray objectAtIndex:indexPath.row];
    
        GPRSprintViewCell * cell = [[GPRSprintViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_INDENTIFIER];

    cell.printNameLabel.text = model.printName;
    switch (model.printState) {
        case -1:
            cell.printNumLabel.text = [NSString stringWithFormat:@"%@(请求未响应)", model.printNum];
            break;
        case 0:
            cell.printNumLabel.text = [NSString stringWithFormat:@"%@(离线)", model.printNum];
            break;
        case 1:
            cell.printNumLabel.text = [NSString stringWithFormat:@"%@(在线)", model.printNum];
            break;
        case 2:
            cell.printNumLabel.text = [NSString stringWithFormat:@"%@(缺纸)", model.printNum];
            break;
        default:
            break;
    }
    [cell.isEnableBT addTarget:self action:@selector(isEnableAction:event:) forControlEvents:UIControlEventTouchUpInside];
    cell.isEnableBT.tag = 1000 + indexPath.row;
    [cell.deleteBT addTarget:self action:@selector(deleteBTAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.deleteBT.tag = 1000 + indexPath.row;
    
    [cell.setUpCountBT addTarget:self action:@selector(setUpPrintNum:event:) forControlEvents:UIControlEventTouchUpInside];
    cell.setUpCountBT.tag = 1000 + indexPath.row;
    cell.printCountLabel.text = [NSString stringWithFormat:@"当前打印份数:%d", model.printCount];
    
    if (model.isEnable == 1) {
        [cell.isEnableBT setTitle:@"禁止" forState:UIControlStateNormal];
        [cell.isEnableBT setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [PrintType sharePrintType].isGPRS = YES;
    }else if (model.isEnable == 2){
        [cell.isEnableBT setTitle:@"启用" forState:UIControlStateNormal];
        [cell.isEnableBT setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (void)isEnableAction:(UIButton *)button event:(id)event
{
    NSSet *touches = [event allTouches];
    UITouch * touch = [touches anyObject];
    CGPoint currentTouchPoint = [touch locationInView:self.tableView];
    self.currentTouchPoint = currentTouchPoint;
    
    GPRSPrintModel *model = [self.gprsDataArray objectAtIndex:button.tag - 1000];
    self.startOrStopModel = model;
    
    switch (model.printState) {
        case -1:
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"请求未响应" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
        }
            break;
        case 0:
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"设备离线" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
            button.enabled = NO;
        }
            break;
        case 1:
        {
            button.enabled = YES;
//            button.selected = !button.selected;
            if ([button.titleLabel.text isEqualToString:@"启用"]) {
                //         [button setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
                //        button.tintColor = [UIColor clearColor];
                NSDictionary *jsondic = @{
                                          @"Command":@53,
                                          @"UserId":[UserInfo shareUserInfo].userId,
                                          @"PrintId":@(model.printId),
                                          @"PrintState":@1
                                          };
                [self playPostWithDictionary:jsondic];
                        NSLog(@"******正在启用");
            }else if([button.titleLabel.text isEqualToString:@"禁止"])
            {
                //        [button setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
                NSDictionary *jsondic = @{
                                          @"Command":@53,
                                          @"UserId":[UserInfo shareUserInfo].userId,
                                          @"PrintId":@(model.printId),
                                          @"PrintState":@2
                                          };
                [self playPostWithDictionary:jsondic];
                        NSLog(@"^^^^^^正在禁止");
            }

        }
            break;
        case 2:
        {
            button.enabled = NO;
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"设备缺纸" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
        }
            break;
        default:
            break;
    }

    
  
}

- (void)deleteBTAction:(UIButton *)button
{
    NSLog(@"删除");
    GPRSPrintModel *model = [self.gprsDataArray objectAtIndex:button.tag - 1000];
    self.deleteModel = model;
    NSDictionary *jsondic = @{
                              @"Command":@52,
                              @"UserId":[UserInfo shareUserInfo].userId,
                              @"PrintId":@(model.printId)
                              };
    [self playPostWithDictionary:jsondic];
}

- (void)addAction:(UIButton *)button
{
    NSLog(@"添加");
    EquipmentInformationViewController *equipmentVC = [[EquipmentInformationViewController alloc]init];
    
    [self.navigationController pushViewController:equipmentVC animated:YES];
}

#pragma mark - 设置打印份数
- (void)setUpPrintNum:(UIButton *)sender event:(id)event
{
    NSSet *touches = [event allTouches];
    UITouch * touch = [touches anyObject];
    CGPoint currentTouchPoint = [touch locationInView:self.tableView];
    self.currentTouchPoint = currentTouchPoint;
    
    GPRSPrintModel *model = [self.gprsDataArray objectAtIndex:sender.tag - 1000];
    self.changeModel = model;
    
    [self createCustomAlertView];
}

- (void)createCustomAlertView
{
    CustomIOSAlertView * customAlert = [[CustomIOSAlertView alloc]init];
    customAlert.containerView = [self createAlertSubview];
    [customAlert setButtonTitles:@[@"取消", @"确定"]];
    customAlert.delegate = self;
    customAlert.useMotionEffects = YES;
    [customAlert show];
}

- (UIView *)createAlertSubview
{
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, VIEW_WIDTH, VIEW_HEIGT)];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.cornerRadius = 10;
    
//    UILabel *setUplabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, VIEW_WIDTH, BUTTON_HEIGHT)];
//    setUplabel.text = @"打印设置";
//    setUplabel.textAlignment = NSTextAlignmentCenter;
//    [view addSubview:setUplabel];
//
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 150, BUTTON_HEIGHT)];
    label1.text = @"请设置打印份数";
    [view addSubview:label1];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, label1.bottom, VIEW_WIDTH , 1)];
    line.backgroundColor = [UIColor grayColor];
    [view addSubview:line];
    
    
    UIButton * subtractButton = [UIButton buttonWithType:UIButtonTypeSystem];
    subtractButton.frame = CGRectMake(VIEW_WIDTH / 2 - 2 * BUTTON_WIDTH , line.bottom + TOP_SPACE / 2, BUTTON_WIDTH, BUTTON_HEIGHT);
    [subtractButton addTarget:self action:@selector(subtractPrintNumber:) forControlEvents:UIControlEventTouchUpInside];
    [subtractButton setBackgroundImage:[UIImage imageNamed:@"reduce_normal.png"] forState:UIControlStateNormal];
    [subtractButton setBackgroundImage:[UIImage imageNamed:@"reduce_press.png"] forState:UIControlStateHighlighted];
    //    subtractButton.backgroundColor = [UIColor orangeColor];
    [view addSubview:subtractButton];
    
    self.numberTF = [[UITextField alloc] initWithFrame:CGRectMake(subtractButton.right, subtractButton.top, subtractButton.width, subtractButton.height)];
    _numberTF.keyboardType = UIKeyboardTypeNumberPad;
    _numberTF.borderStyle = UITextBorderStyleLine;
    _numberTF.textAlignment = NSTextAlignmentCenter;
    _numberTF.text = [self getPrintNum];
    
    NSLog(@"***********%@", _numberTF.text);
    
    [view addSubview:_numberTF];
    
    UIButton * addButton = [UIButton buttonWithType:UIButtonTypeSystem];
    addButton.frame = CGRectMake(_numberTF.right, _numberTF.top, subtractButton.width, subtractButton.height);
    [addButton addTarget:self action:@selector(addPrintNumber:) forControlEvents:UIControlEventTouchUpInside];
    [addButton setBackgroundImage:[UIImage imageNamed:@"add_normal.png"] forState:UIControlStateNormal];
    [addButton setBackgroundImage:[UIImage imageNamed:@"add_press.png"] forState:UIControlStateHighlighted];
    //    addButton.backgroundColor = [UIColor orangeColor];
    [view addSubview:addButton];
    
    return view;
}

- (void)addPrintNumber:(UIButton *)button
{
    self.numberTF.text = [NSString stringWithFormat:@"%d", [self.numberTF.text intValue] + 1];
}

- (void)subtractPrintNumber:(UIButton *)button
{
    if ([self.numberTF.text intValue] != 0) {
        self.numberTF.text = [NSString stringWithFormat:@"%d", [self.numberTF.text intValue] - 1];
    }
}

- (void)customIOS7dialogButtonTouchUpInside:(id)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        if ([_numberTF.text intValue] < 0) {
            _numberTF.text = @"0";
        }
        
        [PrintType sharePrintType].gprsPrintNum = [_numberTF.text intValue];
        
        NSDictionary * jsondic = @{
                                   @"Command":@56,
                                   @"PrintId":@(self.changeModel.printId),
                                   @"PrintCount":@([_numberTF.text intValue])
                                   };
        [self playPostWithDictionary:jsondic];
        
//        [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithInt:[_numberTF.text intValue]] forKey:@"gprsPrintNum"];
    }
//    NSLog(@"**gprs打印份数%d", [PrintType sharePrintType].gprsPrintNum);
    [alertView close];
}

- (NSString *)getPrintNum
{
    
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:self.currentTouchPoint];
    GPRSprintViewCell *cell = (GPRSprintViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    NSString * str = [cell.printCountLabel.text substringFromIndex:7];
    
    return str;

    
}

#pragma mark - 下拉刷新
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
    NSDictionary *jsondic = @{
                              @"Command":@50,
                              @"UserId":[UserInfo shareUserInfo].userId
                              };
    [self playPostWithDictionary:jsondic];
}

- (void)footerRereshing
{

            self.tableView.footerRefreshingText = @"数据已经加载完";
            [self.tableView performSelector:@selector(footerEndRefreshing) withObject:nil afterDelay:1];

}

- (void)downloadData
{
    NSDictionary *jsondic = @{
                              @"Command":@50,
                              @"UserId":[UserInfo shareUserInfo].userId
                              };
    [self playPostWithDictionary:jsondic];
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
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
