//
//  OrderDetailsViewController.m
//  TinyOrder
//
//  Created by 仙林 on 16/3/1.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "OrderDetailsViewController.h"
#import "HeadView.h"
#import "OrderDetailsView.h"
#import "TotalPriceView.h"
#import "NewOrderModel.h"
#import "MealDetailsView.h"
#import "Meal.h"
#import "VerifyOrderViewController.h"
#import "PrintTypeViewController.h"
#import "GeneralBlueTooth.h"
#import "AppDelegate.h"
#define DETAILSLABEL_HEIGHT 30

#define TOP_SPACE 10
#define LEFT_SPACE 15


@interface OrderDetailsViewController ()<HTTPPostDelegate>

@property (nonatomic, strong)UIScrollView * scrollerView;

@property (nonatomic, strong)HeadView * headView;
@property (nonatomic, strong)OrderDetailsView * orderDetailsView;
// 赠品
@property (nonatomic, strong)DetailsView * giftView;
// 送达时间
@property (nonatomic, strong)DetailsView * arriveTime;
// 餐具费
@property (nonatomic, strong)DetailsView * tablewareFee;
// 配送费
@property (nonatomic, strong)DetailsView * delivery;
// 餐盒费
@property (nonatomic, strong)DetailsView * foodBox;
// 其他费用
@property (nonatomic, strong)DetailsView * otherMoney;
// 首单立减
@property (nonatomic, strong)DetailsView * firstRduce;
// 满减
@property (nonatomic, strong)DetailsView * fullRduce;
// 优惠券
@property (nonatomic, strong)DetailsView * reduceCardview;
// 打折
@property (nonatomic, strong)DetailsView * discountview;

// 积分
@property (nonatomic, strong)DetailsView * integralview;
// 订单号
@property (nonatomic, strong)DetailsView * orderIdView;
// 总计
@property (nonatomic, strong)DetailsView * totlePrice;

// 菜单
@property (nonatomic, strong)UIView * mealsView;
@property (nonatomic, strong)UILabel * payStateLabel;

// 总计
@property (nonatomic, strong)TotalPriceView * totlePriceView;
@property (nonatomic, strong)NewOrderModel * ordermodel;

@property (nonatomic, strong)PrintTypeViewController * printTypeVC;

@property (nonatomic, assign)int printIawaimaiOrtangshi;// 1、外卖  2、堂食
@property (nonatomic, assign)int printOrDealAndPrint;// 1、打印  2、打印并处理

@end

@implementation OrderDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"订单详情";
    self.view.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backLastVC:)];
    
    [self addSubViews];
    
    
    if (self.isWaimaiorTangshi == Waimai) {
        NSDictionary * jsonDic = @{
                                   @"UserId":[UserInfo shareUserInfo].userId,
                                   @"Command":@75,
                                   @"OrderId":self.orderID
                                   };
        [self playPostWithDictionary:jsonDic];

    }else
    {
        NSDictionary * jsonDic = @{
                                   @"UserId":[UserInfo shareUserInfo].userId,
                                   @"Command":@76,
                                   @"OrderId":self.orderID
                                   };
        [self playPostWithDictionary:jsonDic];
    }
    
    [SVProgressHUD showWithStatus:@"正在加载..." maskType:SVProgressHUDMaskTypeBlack];
    
    self.printIawaimaiOrtangshi = 1;
    self.printTypeVC = [[PrintTypeViewController alloc]init];
}

- (void)addSubViews
{
    self.scrollerView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 50 - 64)];
    _scrollerView.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    [self.view addSubview:_scrollerView];
    
    self.headView = [[HeadView alloc]initWithFrame:CGRectMake(0 , TOP_SPACE, self.view.width, 50)];
    [_scrollerView addSubview:_headView];
    
    UIView * separateLine = [[UIView alloc]initWithFrame:CGRectMake(0, _headView.bottom, self.view.width, 1)];
    separateLine.backgroundColor = [UIColor colorWithWhite:.9 alpha:1 ];
    [_scrollerView addSubview:separateLine];
    
    self.orderDetailsView = [[OrderDetailsView alloc]initWithFrame:CGRectMake(0, separateLine.bottom, self.view.width, 110)];
    self.orderDetailsView.phoneBT.hidden = NO;
    self.orderDetailsView.payTypeLabel.hidden = YES;
    [self.orderDetailsView.phoneBT addTarget:self action:@selector(telToOrderTelNumber:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollerView addSubview:_orderDetailsView];
    
    
    self.arriveTime = [[DetailsView alloc]initWithFrame:CGRectMake(0, _orderDetailsView.bottom, self.view.width, DETAILSLABEL_HEIGHT)];
    [_scrollerView addSubview:_arriveTime];
    
    self.tablewareFee = [[DetailsView alloc]initWithFrame:CGRectMake(0, _arriveTime.bottom, self.view.width, DETAILSLABEL_HEIGHT)];
    [_scrollerView addSubview:_tablewareFee];
    self.reduceCardview = [[DetailsView alloc]initWithFrame:CGRectMake(0, _tablewareFee.bottom, self.view.width, DETAILSLABEL_HEIGHT)];
    [_scrollerView addSubview:_reduceCardview];
    self.integralview = [[DetailsView alloc]initWithFrame:CGRectMake(0, _reduceCardview.bottom, self.view.width, DETAILSLABEL_HEIGHT)];
    [_scrollerView addSubview:_integralview];
    
    self.delivery = [[DetailsView alloc]initWithFrame:CGRectMake(0, _integralview.bottom, self.view.width, DETAILSLABEL_HEIGHT)];
    [_scrollerView addSubview:_delivery];
    
    self.foodBox = [[DetailsView alloc]initWithFrame:CGRectMake(0, _delivery.bottom, self.view.width, DETAILSLABEL_HEIGHT)];
    [_scrollerView addSubview:_foodBox];
    self.otherMoney = [[DetailsView alloc]initWithFrame:CGRectMake(0, _foodBox.bottom, self.view.width, DETAILSLABEL_HEIGHT)];
    [_scrollerView addSubview:_otherMoney];
    self.firstRduce = [[DetailsView alloc]initWithFrame:CGRectMake(0, _otherMoney.bottom, self.view.width, DETAILSLABEL_HEIGHT)];
    [_scrollerView addSubview:_firstRduce];
    self.fullRduce = [[DetailsView alloc]initWithFrame:CGRectMake(0, _firstRduce.bottom, self.view.width, DETAILSLABEL_HEIGHT)];
    [_scrollerView addSubview:_fullRduce];
    self.discountview = [[DetailsView alloc]initWithFrame:CGRectMake(0, _fullRduce.bottom, self.view.width, DETAILSLABEL_HEIGHT)];
    [_scrollerView addSubview:_discountview];
    self.orderIdView = [[DetailsView alloc]initWithFrame:CGRectMake(0, _discountview.bottom, self.view.width, DETAILSLABEL_HEIGHT)];
    [_scrollerView addSubview:_orderIdView];
    
    self.totlePrice = [[DetailsView alloc]initWithFrame:CGRectMake(0, _orderIdView.bottom, self.view.width, 0)];
    _totlePrice.hidden = YES;
    [_scrollerView addSubview:_totlePrice];
    
  
    
    // 菜单
    self.mealsView = [[UIView alloc]initWithFrame:CGRectMake(0, _totlePrice.bottom + TOP_SPACE, self.view.width, 100)];
    _mealsView.backgroundColor = [UIColor whiteColor];
    [_scrollerView addSubview:_mealsView];
    
    UILabel * mealLabel = [[UILabel alloc]initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE, _scrollerView.width / 2, 25)];
    mealLabel.text = @"菜单详情";
    mealLabel.backgroundColor = [UIColor whiteColor];
    [_mealsView addSubview:mealLabel];
    
    self.payStateLabel = [[UILabel alloc]initWithFrame:CGRectMake(mealLabel.right, TOP_SPACE, _scrollerView.width - 2 * LEFT_SPACE - mealLabel.width, 25)];
    self.payStateLabel.textColor = BACKGROUNDCOLOR;
    _payStateLabel.textAlignment = NSTextAlignmentRight;
    [self.mealsView addSubview:_payStateLabel];
    
    UIView * mealline = [[UIView alloc]initWithFrame:CGRectMake(0, mealLabel.bottom + TOP_SPACE - 1,_mealsView.width, 1)];
    mealline.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    [_mealsView addSubview:mealline];
    
    _scrollerView.contentSize = CGSizeMake(self.view.width, _mealsView.bottom + TOP_SPACE);
    
    self.totlePriceView = [[TotalPriceView alloc]initWithFrame:CGRectMake(0, _scrollerView.bottom, self.view.width, 50)];
    self.totlePriceView.detailsButton.hidden = YES;
    
    self.totlePriceView.totalPriceLabel.frame = CGRectMake(5, 15, self.totlePriceView.width - 2 * 100 - 5 + 10, 30);
    self.totlePriceView.dealButton.frame = CGRectMake(self.totlePriceView.totalPriceLabel.right + 90, 0, 100, self.totlePriceView.height);
     self.totlePriceView.printButton.frame = CGRectMake(self.totlePriceView.dealButton.left - 90, 0, 90, self.totlePriceView.height);
    self.totlePriceView.backgroundColor = [UIColor whiteColor];
    [self.totlePriceView.printButton addTarget:self action:@selector(leftAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.totlePriceView.dealButton addTarget:self action:@selector(rightAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_totlePriceView];
    
    
}

- (void)backLastVC:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -- 数据请求
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
    NSLog(@"%@", [data description]);
    if ([[data objectForKey:@"Result"] isEqualToNumber:@1]) {
        int command = [[data objectForKey:@"Command"] intValue];
        if ([[data objectForKey:@"Command"] isEqualToNumber:@10075] || [[data objectForKey:@"Command"] isEqualToNumber:@10076]) {
            NewOrderModel * orderModel = [[NewOrderModel alloc]initWithDictionary:[data objectForKey:@"OrderObject"]];
            self.ordermodel = orderModel;
        }
        
        if ([[data objectForKey:@"Command"] isEqualToNumber:@10075]) {
            
            [self refreshWithWaimaiOrder];
            
            
        }else if ([[data objectForKey:@"Command"] isEqualToNumber:@10076])
        {
            [self refreshWithTangshiOrder];
        }else if (command == 10023 || command == 10026 || command == 10027)
        {
            UIAlertView * alertV = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请求成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alertV show];
            [alertV performSelector:@selector(dismiss) withObject:nil afterDelay:1.5];
        }else if (command == 10069)
        {
            if ([PrintType sharePrintType].isGPRSenable) {
                
            }
            if ([PrintType sharePrintType].isBlutooth)
            {
                if (![GeneralBlueTooth shareGeneralBlueTooth].myPeripheral.state) {
                    ;
                }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"printNum"] integerValue] == 0){
                    
                }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"printNum"] integerValue] != 0){
                    
                    
                    NewOrderModel * order = self.ordermodel;
                    NSString * printStr = [self getPrintStringWithTangshiOrder:order];
                    NSMutableArray * printAry = [NSMutableArray array];
                    int num = [[[NSUserDefaults standardUserDefaults] objectForKey:@"printNum"] intValue];
                    for (int j = 0; j < num; j++) {
                        [printAry addObject:printStr];
                        
                        [[GeneralBlueTooth shareGeneralBlueTooth] printWithString:printStr];
                        
                        if (order.pays == 0) {
                            
                            NSString * str = [NSString stringWithFormat:@"http://wap.vlifee.com/eat/ScanCodeChangeMoney.aspx?ordersn=%@&busiid=%@&from=app", order.orderId, [UserInfo shareUserInfo].userId];
                            [[GeneralBlueTooth shareGeneralBlueTooth] printPng:str];
                            
                            
                        }
                        
                    }
                    
                    
                }
                
                
            }
            
            if (self.printOrDealAndPrint == 2) {
                UIAlertView * alertV = [[UIAlertView alloc] initWithTitle:@"提示" message:@"处理成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
                [alertV show];
                [alertV performSelector:@selector(dismiss) withObject:nil afterDelay:1.5];
            }else
            {
                ;
            }
            
        }else if (command == 10015)
        {
            
            if ([PrintType sharePrintType].isGPRSenable) {
                
            }
            if ([PrintType sharePrintType].isBlutooth)
            {
                // 蓝牙未连接，不作处理
                if (![GeneralBlueTooth shareGeneralBlueTooth].myPeripheral.state){
                    //                        NewOrderModel * order = [self.newsArray objectAtIndex:self.printRow];
                    //                        NSString * printStr = [self getPrintStringWithNewOrder:order];
                    //                        [[GeneralBlueTooth shareGeneralBlueTooth] printWithString:printStr];
                }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"printNum"] integerValue] == 0)
                {
                    // 打印份数为0，不作处理
                }
                else if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"printNum"] integerValue] != 0){
                    
                    
                    NewOrderModel * order = self.ordermodel;
                    NSString * printStr = [self getPrintStringWithNewOrder:order];
                    NSMutableArray * printAry = [NSMutableArray array];
                    int num = [[[NSUserDefaults standardUserDefaults] objectForKey:@"printNum"] intValue];
                    for (int j = 0; j < num; j++) {
                        [printAry addObject:printStr];
                        
                        [[GeneralBlueTooth shareGeneralBlueTooth] printWithString:printStr];
                        
                        if ([order.PayMath intValue] == 3) {
                            
                            
                            //                            UIImage * image = [[QRCode shareQRCode] createQRCodeForString:
                            //                                               [NSString stringWithFormat:@"http://wap.vlifee.com/eat/ScanCodeChangeMoney.aspx?ordersn=%@&busiid=%@&from=app", order.orderId, [UserInfo shareUserInfo].userId]];
                            //                            NSData * inageData = UIImageJPEGRepresentation(image, 1.0);
                            //                            UIImage * image1 = [UIImage imageWithData:inageData];
                            
                            
                            NSString * str = [NSString stringWithFormat:@"http://wap.vlifee.com/eat/ScanCodeChangeMoney.aspx?ordersn=%@&busiid=%@&from=app", order.orderId, [UserInfo shareUserInfo].userId];
                            [[GeneralBlueTooth shareGeneralBlueTooth] printPng:str];
                            
                        }
                        
                    }
                    
                    
                }
                
                
            }
            if (self.printOrDealAndPrint == 2) {
                UIAlertView * alertV = [[UIAlertView alloc] initWithTitle:@"提示" message:@"处理成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
                [alertV show];
                [alertV performSelector:@selector(dismiss) withObject:nil afterDelay:1.5];
            }else
            {
                ;
            }
        }else if (command == 10016)
        {
            //            if (self.dataArray.count == 1) {
            //                self.dataArray = nil;
            //            }
            UIAlertView * alertV = [[UIAlertView alloc] initWithTitle:@"提示" message:@"处理成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alertV show];
            [alertV performSelector:@selector(dismiss) withObject:nil afterDelay:1.5];
        }
    }else
    {
        [SVProgressHUD dismiss];
        int command = [[data objectForKey:@"Command"] intValue];
        if (command == 10015 || command == 10069) {
            
            if ([[data objectForKey:@"ErrorMsg"] isEqualToString:@"您没有可用的GPRS打印机"] && [PrintType sharePrintType].isBlutooth) {
                if (self.printOrDealAndPrint == 1) {
                    //仅打印
                    if (command == 10069) {
                        NSDictionary * jsonDic = @{
                                                   @"UserId":[UserInfo shareUserInfo].userId,
                                                   @"Command":@69,
                                                   @"OrderId":self.ordermodel.orderId,
                                                   @"PrintType":@2,
                                                   @"DealPrint":@1
                                                   };
                        [self playPostWithDictionary:jsonDic];
                    }else
                    {
                        NSDictionary * jsonDic = @{
                                                   @"UserId":[UserInfo shareUserInfo].userId,
                                                   @"Command":@15,
                                                   @"OrderId":self.ordermodel.orderId,
                                                   @"PrintType":@2,
                                                   @"DealPrint":@1
                                                   };
                        [self playPostWithDictionary:jsonDic];
                    }

                }else
                {
                    
                    if (command == 10069) {
                        NSDictionary * jsonDic = @{
                                                   @"UserId":[UserInfo shareUserInfo].userId,
                                                   @"Command":@69,
                                                   @"OrderId":self.ordermodel.orderId,
                                                   @"PrintType":@2,
                                                   @"DealPrint":@0
                                                   };
                        
                        [self playPostWithDictionary:jsonDic];
                    }else
                    {
                        NSDictionary * jsonDic = @{
                                                   @"UserId":[UserInfo shareUserInfo].userId,
                                                   @"Command":@15,
                                                   @"OrderId":self.ordermodel.orderId,
                                                   @"PrintType":@2
                                                   };
                        
                        [self playPostWithDictionary:jsonDic];
                    }
                }
            }
            
            //            NSDate * nowDate = [NSDate date];
            //            nowDate = [NSDate dateWithTimeIntervalSinceNow:0];
            //
            //            NSTimeInterval time = [nowDate timeIntervalSinceDate:self.date];
            //
            //            if (time < 1) {
            ////                NSLog(@"时间间隔太短");
            //            }else
            //            {
            //                if ([data objectForKey:@"ErrorMsg"]) {
            //                    UIAlertView * alertV = [[UIAlertView alloc] initWithTitle:@"提示" message:[data objectForKey:@"ErrorMsg"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            //                    [alertV show];
            //                }
            //            }
            //            self.date = nowDate;
        }else
        {
            
            if ([data objectForKey:@"ErrorMsg"]) {
                UIAlertView * alertV = [[UIAlertView alloc] initWithTitle:@"提示" message:[data objectForKey:@"ErrorMsg"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alertV show];
            }
        }
        
    }
}

- (void)failWithError:(NSError *)error
{
    [SVProgressHUD dismiss];
    //    AccountViewCell * cell = (AccountViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    //    cell.isBusinessSW.on = !cell.isBusinessSW.isOn;
    //    [self.tableView headerEndRefreshing];
//    if (error.code == -1009) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"友情提示" message:@"网络不给力,请检查网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alert show];
//    }else
//    {
        UIAlertView * alerV = [[UIAlertView alloc] initWithTitle:@"提示" message:@"连接服务器失败请重新连接" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alerV show];
//    }
}

#pragma mark - 点击事件
- (void)leftAction:(UIButton *)button
{
    // 拒绝接单。打印订单。拒绝退款
    
    if ([button.titleLabel.text isEqualToString:@"拒绝接单"]) {
        NSLog(@"拒绝接单");
        [self nulliyOrder];
    }else if ([button.titleLabel.text isEqualToString:@"打印订单"])
    {
        NSLog(@"打印订单");
        self.printIawaimaiOrtangshi = 1;
        self.printOrDealAndPrint = 1;
        [self printMeallist];
    }else if ([button.titleLabel.text isEqualToString:@"拒绝退款"])
    {
        NSLog(@"拒绝退款");
        [self refuseRefungAction];
    }
    
}

- (void)rightAction:(UIButton *)button
{
    // 外卖：处理并打印。标记餐已送出。同意退款
    // 堂食：打印并处理。去验证。打印
    
    // 外卖订单按钮处理事件
    if ([button.titleLabel.text isEqualToString:@"处理并打印"]) {
        NSLog(@"处理并打印");
        self.printIawaimaiOrtangshi = 1;
        self.printOrDealAndPrint = 2;
        [self dealAndPrint];
    }else if ([button.titleLabel.text isEqualToString:@"标记餐已送出"])
    {
        NSLog(@"标记餐已送出");
        [self markMealSentOut];
    }else if ([button.titleLabel.text isEqualToString:@"同意退款"])
    {
        NSLog(@"同意退款");
        [self agreeRefundAction];
    }else if ([button.titleLabel.text isEqualToString:@"打印并处理"])
    {
        // 以下为堂食订单按钮处理事件
        NSLog(@"打印并处理");
        self.printIawaimaiOrtangshi = 2;
        self.printOrDealAndPrint = 2;
        [self dealAndPrint];
    }else if ([button.titleLabel.text isEqualToString:@"去验证"])
    {
        NSLog(@"去验证");
        VerifyOrderViewController * verifyVC = [[VerifyOrderViewController alloc]init];
        verifyVC.isfrome = 1;
        [self.navigationController pushViewController:verifyVC animated:YES];
    }else if ([button.titleLabel.text isEqualToString:@"打印"])
    {
        NSLog(@"打印");
        self.printIawaimaiOrtangshi = 2;
        self.printOrDealAndPrint = 1;
        [self printMeallist];
    }
    
}

#pragma mark - 拨电话
- (void)telToOrderTelNumber:(UIButton *)button
{
    if (self.ordermodel.tel.length != 0) {
        UIWebView *callWebView = [[UIWebView alloc] init];
        
        NSURL *telURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", self.ordermodel.tel]];
        //    [[UIApplication sharedApplication] openURL:telURL];
        [callWebView loadRequest:[NSURLRequest requestWithURL:telURL]];
        
        AppDelegate * appdelegate = [UIApplication sharedApplication].delegate;
        [appdelegate.window addSubview:callWebView];
    }else if(self.ordermodel.reservePhoneNo.length != 0)
    {
        UIWebView *callWebView = [[UIWebView alloc] init];
        
        NSURL *telURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", self.ordermodel.reservePhoneNo]];
        //    [[UIApplication sharedApplication] openURL:telURL];
        [callWebView loadRequest:[NSURLRequest requestWithURL:telURL]];
        
        AppDelegate * appdelegate = [UIApplication sharedApplication].delegate;
        [appdelegate.window addSubview:callWebView];
    }else
    {
        NSLog(@"电话号码为空");
    }
}

#pragma mark - 根据数据刷新界面
- (void)refreshWithWaimaiOrder
{
    NewOrderModel * orderModel = self.ordermodel;
    
    self.headView.numberLabel.text = [NSString stringWithFormat:@"%d号", orderModel.orderNum];
    switch (orderModel.dealState.intValue) {
        case 1:
        {
            self.headView.stateLabel.text = @"等待处理";
            self.totlePrice.hidden = YES;
            [self.totlePriceView.printButton setTitle:@"拒绝接单" forState:UIControlStateNormal];
            [self.totlePriceView.dealButton setTitle:@"处理并打印" forState:UIControlStateNormal];
        }
            break;
        case 2:
        {
            self.headView.stateLabel.text = @"待配送";
            self.totlePrice.hidden = YES;
            [self.totlePriceView.printButton setTitle:@"打印订单" forState:UIControlStateNormal];
            [self.totlePriceView.dealButton setTitle:@"标记餐已送出" forState:UIControlStateNormal];
        }
            break;
        case 3:
        {
            self.headView.stateLabel.text = @"已配送";
            self.totlePrice.hidden = NO;
        }
            break;
        case 4:
        {
            self.headView.stateLabel.text = @"已作废";
            self.totlePrice.hidden = NO;
        }
            break;
        case 5:
        {
            self.headView.stateLabel.text = @"申请退款";
            [self.totlePriceView.printButton setTitle:@"拒绝退款" forState:UIControlStateNormal];
            [self.totlePriceView.dealButton setTitle:@"同意退款" forState:UIControlStateNormal];
            self.totlePrice.hidden = YES;
        }
            break;
        case 6:
        {
            self.headView.stateLabel.text = @"退款成功";
            self.totlePrice.hidden = NO;
        }
            break;
        case 7:
        {
            self.headView.stateLabel.text = @"已完成";
            self.totlePrice.hidden = NO;
        }
            break;
            
        default:
            break;
    }
    
    // 拿到时间
    NSDateFormatter * fomatter = [[NSDateFormatter alloc]init];
    fomatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate * date = [fomatter dateFromString:orderModel.orderTime];
    //            NSLog(@"%@", date);
    
    // 转换成日期
    NSDateFormatter * dayDateFM = [[NSDateFormatter alloc]init];
    dayDateFM.dateFormat = @"MM-dd";
    NSString *dayStr = [dayDateFM stringFromDate:date];
    
    NSDate *nowDate = [NSDate date];
    nowDate = [NSDate dateWithTimeIntervalSinceNow:0];
    
    NSString * nowStr = [dayDateFM stringFromDate:nowDate];
    
    //    NSLog(@"***%@**%@", nowStr, dayStr);
    
    // 比较看是否是今天的订单
    if (![nowStr isEqualToString:dayStr]) {
        self.headView.dateLabel.text = dayStr;
    }else
    {
        NSDateFormatter * houreDateFM = [[NSDateFormatter alloc]init];
        houreDateFM.dateFormat = @"HH:mm";
        NSString *houreStr = [houreDateFM stringFromDate:date];
        self.headView.dateLabel.text = houreStr;
    }
    
    
    NSString *string = [orderModel.orderId substringToIndex:1];
    string = [string lowercaseString];
    
    if ([string isEqualToString:@"z"]) {
        self.headView.orderStyleLabel.text = @"外卖";
    }else
    {
        self.headView.orderStyleLabel.text = @"堂食";
    }
    
//    self.orderDetailsView.nameAndPhoneview.detailesLabel.text = [NSString stringWithFormat:@"%@ | %@", orderModel.name, orderModel.tel];
    self.orderDetailsView.nameAndPhoneview.name = [NSString stringWithFormat:@"%@", orderModel.name];
    self.orderDetailsView.nameAndPhoneview.phonenumber = [NSString stringWithFormat:@"%@", orderModel.tel];
    
    self.orderDetailsView.addressView.detailesLabel.text = [NSString stringWithFormat:@"%@", orderModel.address];
    NSDictionary * attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:17]};
    CGRect addRect = [self.orderDetailsView.addressView.detailesLabel.text boundingRectWithSize:CGSizeMake(self.orderDetailsView.addressView.detailesLabel.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    float addressHeight = 0;
    if (addRect.size.height>30) {
        self.orderDetailsView.addressView.detailesLabel.numberOfLines = 0;
        self.orderDetailsView.addressView.height = addRect.size.height;
        addressHeight = addRect.size.height - 30;
        self.orderDetailsView.addressView.detailesLabel.height = addRect.size.height;
        self.orderDetailsView.height = self.orderDetailsView.height + addRect.size.height - 30;
        NSLog(@"%f, %f", self.orderDetailsView.addressView.height, self.orderDetailsView.height);
        [self refreshSubViews];
        
    }else
    {
        ;
    }
    
    self.orderDetailsView.remarkView.detailesLabel.text = [NSString stringWithFormat:@"备注:%@", orderModel.remark];
    CGRect remarkRect = [self.orderDetailsView.remarkView.detailesLabel.text boundingRectWithSize:CGSizeMake(self.orderDetailsView.remarkView.detailesLabel.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    float remarkHeight = 0;
    if (remarkRect.size.height>30) {
        self.orderDetailsView.remarkView.detailesLabel.numberOfLines = 0;
        self.orderDetailsView.remarkView.height = remarkRect.size.height;
        remarkHeight = remarkRect.size.height - 30;
        self.orderDetailsView.remarkView.detailesLabel.height = remarkRect.size.height;
        self.orderDetailsView.height = self.orderDetailsView.height + remarkRect.size.height - 30;
        [self refreshSubViews];
        
    }else
    {
        ;
    }
    
    
    if (orderModel.gift.length != 0) {
        self.orderDetailsView.giftView.hidden = NO;
        self.orderDetailsView.giftView.detailesLabel.text = [NSString stringWithFormat:@"赠品:%@", orderModel.gift];
        self.orderDetailsView.frame = CGRectMake(0, _orderDetailsView.top, self.view.width, 140+ addressHeight + remarkHeight);
    }else
    {
        self.orderDetailsView.giftView.hidden = YES;
        self.orderDetailsView.frame = CGRectMake(0, _orderDetailsView.top, self.view.width, 110+ addressHeight + remarkHeight);
    }
    
    
    
    //            NSLog(@"送达时间%@", orderModel.hopeTime);
    if (orderModel.hopeTime.length != 0) {
        self.arriveTime.frame = CGRectMake(0, _orderDetailsView.bottom, self.view.width, DETAILSLABEL_HEIGHT);
        self.arriveTime.detailesLabel.text = [NSString stringWithFormat:@"送达时间: %@", orderModel.hopeTime];
    }else
    {
        self.arriveTime.frame = CGRectMake(0, _orderDetailsView.bottom, self.view.width, 0);
        self.arriveTime.hidden = YES;
    }
    
    if (orderModel.tablewareFee  != 0) {
        self.tablewareFee.frame = CGRectMake(0, _arriveTime.bottom, self.view.width, DETAILSLABEL_HEIGHT);
        self.tablewareFee.detailesLabel.text = [NSString stringWithFormat:@"餐具费: %.2f", orderModel.tablewareFee];
    }else
    {
        self.tablewareFee.hidden = YES;
        self.tablewareFee.frame = CGRectMake(0, _arriveTime.bottom , self.view.width, 0);
    }
    
    
    if ([orderModel.reduceCard doubleValue] != 0) {
        self.reduceCardview.frame = CGRectMake(0, _tablewareFee.bottom, self.view.width, DETAILSLABEL_HEIGHT);
        self.reduceCardview.detailesLabel.text = [NSString stringWithFormat:@"优惠券: -%.2f元", [orderModel.reduceCard doubleValue]];
    }else
    {
        self.reduceCardview.hidden = YES;
        self.reduceCardview.frame = CGRectMake(0, _tablewareFee.bottom , self.view.width, 0);
    }
    
    if ([orderModel.internal intValue] != 0) {
        self.integralview.frame = CGRectMake(0, _reduceCardview.bottom , self.view.width, DETAILSLABEL_HEIGHT);
        double integral = orderModel.internal.doubleValue / 100;
        self.integralview.detailesLabel.text = [NSString stringWithFormat:@"积分: -%.2f元", integral];
    }else
    {
        self.integralview.hidden = YES;
        self.integralview.frame = CGRectMake(0, _reduceCardview.bottom , self.view.width, 0);
    }
    
    if ([orderModel.delivery doubleValue] != 0) {
        self.delivery.frame = CGRectMake(0, _integralview.bottom , self.view.width, DETAILSLABEL_HEIGHT);
        self.delivery.detailesLabel.text = [NSString stringWithFormat:@"配送费: +%.2f元", [orderModel.delivery doubleValue]];
    }else
    {
        self.delivery.hidden = YES;
        self.delivery.frame = CGRectMake(0, _integralview.bottom , self.view.width, 0);
        self.foodBox.frame = CGRectMake(0, _delivery.bottom , self.view.width, DETAILSLABEL_HEIGHT);
    }
    
    if ([orderModel.foodBox doubleValue] != 0) {
        self.foodBox.frame =CGRectMake(0, _delivery.bottom , self.view.width, DETAILSLABEL_HEIGHT);
        self.foodBox.detailesLabel.text = [NSString stringWithFormat:@"餐盒费: +%.2f元", [orderModel.foodBox doubleValue]];
    }else
    {
        self.foodBox.hidden = YES;
        self.foodBox.frame =CGRectMake(0, _delivery.bottom , self.view.width, 0);
    }
    
    if ([orderModel.otherMoney doubleValue] != 0) {
        self.otherMoney.frame = CGRectMake(0, _foodBox.bottom, self.view.width, DETAILSLABEL_HEIGHT);
        self.otherMoney.detailesLabel.text = [NSString stringWithFormat:@"其他费用: +%.2f元", [orderModel.otherMoney doubleValue]];
    }else
    {
        self.otherMoney.hidden = YES;
        self.otherMoney.frame = CGRectMake(0, _foodBox.bottom, self.view.width, 0);
    }
    
    if ([orderModel.firstReduce doubleValue] != 0) {
        self.firstRduce.frame = CGRectMake(0, _otherMoney.bottom, self.view.width, DETAILSLABEL_HEIGHT);
        self.firstRduce.detailesLabel.text = [NSString stringWithFormat:@"首单立减: -%.2f元", [orderModel.firstReduce doubleValue]];
    }else
    {
        self.firstRduce.hidden = YES;
        self.firstRduce.frame = CGRectMake(0, _otherMoney.bottom, self.view.width, 0);
        self.fullRduce.frame = CGRectMake(0, _firstRduce.bottom, self.view.width, DETAILSLABEL_HEIGHT);
    }
    
    if ([orderModel.fullReduce doubleValue] != 0) {
        self.fullRduce.frame = CGRectMake(0, _firstRduce.bottom, self.view.width, DETAILSLABEL_HEIGHT);
        self.fullRduce.detailesLabel.text =[NSString stringWithFormat:@"满减优惠: -%.2f元", [orderModel.fullReduce doubleValue]];;
    }else
    {
        self.fullRduce.hidden = YES;
        self.fullRduce.frame = CGRectMake(0, _firstRduce.bottom, self.view.width, 0);
    }
    if (orderModel.discount != 0) {
        self.discountview.frame = CGRectMake(0, _fullRduce.bottom, self.view.width, DETAILSLABEL_HEIGHT);
        self.discountview.detailesLabel.text = [NSString stringWithFormat:@"打折优惠: %.1f折", orderModel.discount];
    }else
    {
        self.discountview.hidden = YES;
        self.discountview.frame = CGRectMake(0, _fullRduce.bottom, self.view.width, 0);
    }
    
    self.orderIdView.frame = CGRectMake(0, _discountview.bottom, self.view.width, DETAILSLABEL_HEIGHT);
    self.orderIdView.detailesLabel.text = [NSString stringWithFormat:@"订单号: %@", orderModel.orderId];
    
    if (self.totlePrice.hidden) {
//        NSLog(@"总价隐藏");
        self.totlePrice.frame = CGRectMake(0, _orderIdView.bottom, self.view.width, 0);
        self.totlePriceView.hidden = NO;
    }else
    {
        self.totlePrice.frame = CGRectMake(0, _orderIdView.bottom, self.view.width, DETAILSLABEL_HEIGHT);
        self.totlePrice.detailesLabel.frame = CGRectMake(self.totlePrice.detailesLabel.left, self.totlePrice.detailesLabel.top, self.view.width - 30, self.totlePrice.height);
        self.totlePrice.detailesLabel.text = [NSString stringWithFormat:@"总计: %@", orderModel.allMoney];
        _totlePrice.detailesLabel.textColor = [UIColor redColor];
        self.totlePriceView.hidden = YES;
    }
    
    
    self.mealsView.frame = CGRectMake(0, _totlePrice.bottom + TOP_SPACE, self.view.width, 100);
    
    if ([orderModel.PayMath intValue] == 3) {
        self.payStateLabel.text = @"现金支付";
    }else
    {
        self.payStateLabel.text = @"已支付";
    }
    
    for (int i = 0; i < orderModel.mealArray.count; i++) {
        MealDetailsView * mealDetailsView = [[MealDetailsView alloc]initWithFrame:CGRectMake(0, 45 + 30 * i, self.mealsView.width, 30)];
        Meal * meal = [orderModel.mealArray objectAtIndex:i];
        
        mealDetailsView.nametext = meal.name;
        mealDetailsView.nameLabel.text = meal.name;
        mealDetailsView.countLabel.text = [NSString stringWithFormat:@"x %@", meal.count];
        mealDetailsView.priceLabel.text = [NSString stringWithFormat:@"%@元", meal.money];
        [self.mealsView addSubview:mealDetailsView];
        self.mealsView.height = mealDetailsView.bottom + 10;
    }
    
    self.totlePriceView.moneyStr = [NSString stringWithFormat:@"%@", orderModel.allMoney];
    _scrollerView.contentSize = CGSizeMake(self.view.width, _mealsView.bottom + TOP_SPACE);
    
}

- (void)refreshWithTangshiOrder
{
    NewOrderModel * orderModel = self.ordermodel;
    
    self.headView.numberLabel.text = [NSString stringWithFormat:@"%d号", orderModel.orderNum];
    switch (orderModel.dealState.intValue) {
        case 1:
        {
            self.headView.stateLabel.text = @"未处理";
        }
            break;
        case 2:
        {
            self.headView.stateLabel.text = @"已处理";
        }
            break;
        case 3:
        {
            self.headView.stateLabel.text = @"已配送";
        }
            break;
        case 4:
        {
            self.headView.stateLabel.text = @"已作废";
        }
            break;
        case 5:
        {
            self.headView.stateLabel.text = @"申请退款";
        }
            break;
        case 6:
        {
            self.headView.stateLabel.text = @"退款成功";
        }
            break;
        case 7:
        {
            self.headView.stateLabel.text = @"已完成";
        }
            break;
            
        default:
            break;
    }
    
    // 拿到时间
    NSDateFormatter * fomatter = [[NSDateFormatter alloc]init];
    fomatter.dateFormat = @"yyyy/MM/dd HH:mm:ss";
    NSDate * date = [fomatter dateFromString:orderModel.orderTime];
    //            NSLog(@"%@", date);
    
    // 转换成日期
    NSDateFormatter * dayDateFM = [[NSDateFormatter alloc]init];
    dayDateFM.dateFormat = @"MM-dd";
    NSString *dayStr = [dayDateFM stringFromDate:date];
    
    NSDate *nowDate = [NSDate date];
    nowDate = [NSDate dateWithTimeIntervalSinceNow:0];
    
    NSString * nowStr = [dayDateFM stringFromDate:nowDate];
    
    //    NSLog(@"***%@**%@", nowStr, dayStr);
    
    // 比较看是否是今天的订单
    if (![nowStr isEqualToString:dayStr]) {
        self.headView.dateLabel.text = dayStr;
    }else
    {
        NSDateFormatter * houreDateFM = [[NSDateFormatter alloc]init];
        houreDateFM.dateFormat = @"HH:mm";
        NSString *houreStr = [houreDateFM stringFromDate:date];
        self.headView.dateLabel.text = houreStr;
    }
    
    
    NSString *string = [orderModel.orderId substringToIndex:1];
    string = [string lowercaseString];
    
    if ([string isEqualToString:@"z"]) {
        self.headView.orderStyleLabel.text = @"外卖";
    }else
    {
        self.headView.orderStyleLabel.text = @"堂食";
    }
    
    if (orderModel.isReserve.intValue == 0) {
        self.orderDetailsView.nameAndPhoneview.detailesLabel.text = [NSString stringWithFormat:@"用餐位置: %@", orderModel.eatLocation];
        self.orderDetailsView.addressView.detailesLabel.text = [NSString stringWithFormat:@"用餐人数: %d", orderModel.customerCount];
        self.orderDetailsView.remarkView.detailesLabel.text = [NSString stringWithFormat:@"备注:%@", orderModel.remark];
        CGSize remakesize = [self.orderDetailsView.remarkView.detailesLabel.text boundingRectWithSize:CGSizeMake(self.orderDetailsView.remarkView.detailesLabel.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size;
        if (remakesize.height > 30) {
            self.orderDetailsView.remarkView.detailesLabel.height = remakesize.height;
            self.orderDetailsView.remarkView.height = remakesize.height;
            self.orderDetailsView.giftView.top = self.orderDetailsView.remarkView.bottom;
        }
        
        if (orderModel.gift.length != 0) {
            self.orderDetailsView.giftView.hidden = NO;
            self.orderDetailsView.giftView.detailesLabel.text = [NSString stringWithFormat:@"赠品:%@", orderModel.gift];
            if (remakesize.height > 30) {
                self.orderDetailsView.frame = CGRectMake(0, _orderDetailsView.top, self.view.width, 140 + remakesize.height - 30);
            }else
            {
                self.orderDetailsView.frame = CGRectMake(0, _orderDetailsView.top, self.view.width, 140);
            }
        }else
        {
            self.orderDetailsView.giftView.hidden = YES;
            if (remakesize.height > 30) {
                self.orderDetailsView.frame = CGRectMake(0, _orderDetailsView.top, self.view.width, 110 + remakesize.height - 30);
            }else
            {
                self.orderDetailsView.frame = CGRectMake(0, _orderDetailsView.top, self.view.width, 110);
            }
        }
        
        self.orderDetailsView.phoneBT.hidden = YES;
    }else
    {
        self.orderDetailsView.nameAndPhoneview.name = [NSString stringWithFormat:@"%@", orderModel.reserveName];
        self.orderDetailsView.nameAndPhoneview.phonenumber = [NSString stringWithFormat:@"%@", orderModel.reservePhoneNo];
        self.orderDetailsView.addressView.detailesLabel.text = [NSString stringWithFormat:@"预定时间:%@", orderModel.reserveTime];
        self.orderDetailsView.openTimeview.detailesLabel.text = [NSString stringWithFormat:@"开餐时间:%@", orderModel.openMealTime];
        self.orderDetailsView.openTimeview.hidden = NO;
        self.orderDetailsView.remarkView.detailesLabel.text = [NSString stringWithFormat:@"备注:%@", orderModel.remark];
        self.orderDetailsView.remarkView.top = self.orderDetailsView.openTimeview.bottom;
        CGSize remakesize = [self.orderDetailsView.remarkView.detailesLabel.text boundingRectWithSize:CGSizeMake(self.orderDetailsView.remarkView.detailesLabel.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size;
        if (remakesize.height > 30) {
            self.orderDetailsView.remarkView.detailesLabel.height = remakesize.height;
            self.orderDetailsView.remarkView.height = remakesize.height;
        }
        
        self.orderDetailsView.giftView.top = self.orderDetailsView.remarkView.bottom;
        if (orderModel.gift.length != 0) {
            self.orderDetailsView.giftView.hidden = NO;
            self.orderDetailsView.giftView.detailesLabel.text = [NSString stringWithFormat:@"赠品:%@", orderModel.gift];
            if (remakesize.height > 30) {
                self.orderDetailsView.frame = CGRectMake(0, _orderDetailsView.top, self.view.width, 170 + remakesize.height - 30);
            }else
            {
                self.orderDetailsView.frame = CGRectMake(0, _orderDetailsView.top, self.view.width, 170);
            }
        }else
        {
            self.orderDetailsView.giftView.hidden = YES;
            if (remakesize.height > 30) {
                self.orderDetailsView.frame = CGRectMake(0, _orderDetailsView.top, self.view.width, 140 + remakesize.height - 30);
            }else
            {
                self.orderDetailsView.frame = CGRectMake(0, _orderDetailsView.top, self.view.width, 140);
            }
        }
        
        self.orderDetailsView.phoneBT.hidden = NO;
    }
    
    
    //            NSLog(@"送达时间%@", orderModel.hopeTime);
    if (orderModel.hopeTime.length != 0) {
        self.arriveTime.frame = CGRectMake(0, _orderDetailsView.bottom, self.view.width, DETAILSLABEL_HEIGHT);
        self.arriveTime.detailesLabel.text = [NSString stringWithFormat:@"送达时间: %@", orderModel.hopeTime];
    }else
    {
        self.arriveTime.frame = CGRectMake(0, _orderDetailsView.bottom, self.view.width, 0);
        self.arriveTime.hidden = YES;
    }
    
    if (orderModel.tablewareFee  != 0) {
        self.tablewareFee.frame = CGRectMake(0, _arriveTime.bottom, self.view.width, DETAILSLABEL_HEIGHT);
        self.tablewareFee.detailesLabel.text = [NSString stringWithFormat:@"餐具费: %.2f", orderModel.tablewareFee];
    }else
    {
        self.tablewareFee.hidden = YES;
        self.tablewareFee.frame = CGRectMake(0, _arriveTime.bottom , self.view.width, 0);
    }
    
    if ([orderModel.reduceCard doubleValue] != 0) {
        self.reduceCardview.frame = CGRectMake(0, _tablewareFee.bottom, self.view.width, DETAILSLABEL_HEIGHT);
        self.reduceCardview.detailesLabel.text = [NSString stringWithFormat:@"优惠券: -%.2f元", [orderModel.reduceCard doubleValue]];
    }else
    {
        self.reduceCardview.hidden = YES;
        self.reduceCardview.frame = CGRectMake(0, _tablewareFee.bottom , self.view.width, 0);
    }
    
    if ([orderModel.internal intValue] != 0) {
        self.integralview.frame = CGRectMake(0, _reduceCardview.bottom , self.view.width, DETAILSLABEL_HEIGHT);
        double integral = orderModel.internal.doubleValue / 100;
        self.integralview.detailesLabel.text = [NSString stringWithFormat:@"积分: -%.2f元", integral];
    }else
    {
        self.integralview.hidden = YES;
        self.integralview.frame = CGRectMake(0, _reduceCardview.bottom , self.view.width, 0);
    }
    
    if ([orderModel.delivery doubleValue] != 0) {
        self.delivery.frame = CGRectMake(0, _integralview.bottom , self.view.width, DETAILSLABEL_HEIGHT);
        self.delivery.detailesLabel.text = [NSString stringWithFormat:@"配送费: +%.2f元", [orderModel.delivery doubleValue]];
    }else
    {
        self.delivery.hidden = YES;
        self.delivery.frame = CGRectMake(0, _integralview.bottom , self.view.width, 0);
        self.foodBox.frame = CGRectMake(0, _delivery.bottom , self.view.width, DETAILSLABEL_HEIGHT);
    }
    
    if ([orderModel.foodBox doubleValue] != 0) {
        self.foodBox.frame =CGRectMake(0, _delivery.bottom , self.view.width, DETAILSLABEL_HEIGHT);
        self.foodBox.detailesLabel.text = [NSString stringWithFormat:@"餐盒费: +%.2f元", [orderModel.foodBox doubleValue]];
    }else
    {
        self.foodBox.hidden = YES;
        self.foodBox.frame =CGRectMake(0, _delivery.bottom , self.view.width, 0);
    }
    
    if ([orderModel.otherMoney doubleValue] != 0) {
        self.otherMoney.frame = CGRectMake(0, _foodBox.bottom, self.view.width, DETAILSLABEL_HEIGHT);
        self.otherMoney.detailesLabel.text = [NSString stringWithFormat:@"其他费用: +%.2f元", [orderModel.otherMoney doubleValue]];
    }else
    {
        self.otherMoney.hidden = YES;
        self.otherMoney.frame = CGRectMake(0, _foodBox.bottom, self.view.width, 0);
    }
    
    if ([orderModel.firstReduce doubleValue] != 0) {
        self.firstRduce.frame = CGRectMake(0, _otherMoney.bottom, self.view.width, DETAILSLABEL_HEIGHT);
        self.firstRduce.detailesLabel.text = [NSString stringWithFormat:@"首单立减: -%.2f元", [orderModel.firstReduce doubleValue]];
    }else
    {
        self.firstRduce.hidden = YES;
        self.firstRduce.frame = CGRectMake(0, _otherMoney.bottom, self.view.width, 0);
        self.fullRduce.frame = CGRectMake(0, _firstRduce.bottom, self.view.width, DETAILSLABEL_HEIGHT);
    }
    
    if ([orderModel.fullReduce doubleValue] != 0) {
        self.fullRduce.frame = CGRectMake(0, _firstRduce.bottom, self.view.width, DETAILSLABEL_HEIGHT);
        self.fullRduce.detailesLabel.text =[NSString stringWithFormat:@"满减优惠: -%.2f元", [orderModel.fullReduce doubleValue]];;
    }else
    {
        self.fullRduce.hidden = YES;
        self.fullRduce.frame = CGRectMake(0, _firstRduce.bottom, self.view.width, 0);
    }
    if (orderModel.discount != 0) {
        self.discountview.frame = CGRectMake(0, _fullRduce.bottom, self.view.width, DETAILSLABEL_HEIGHT);
        self.discountview.detailesLabel.text = [NSString stringWithFormat:@"打折优惠: %.1f折", orderModel.discount];
    }else
    {
        self.discountview.hidden = YES;
        self.discountview.frame = CGRectMake(0, _fullRduce.bottom, self.view.width, 0);
    }
    
    self.orderIdView.frame = CGRectMake(0, _discountview.bottom, self.view.width, DETAILSLABEL_HEIGHT);
    self.orderIdView.detailesLabel.text = [NSString stringWithFormat:@"订单号: %@", orderModel.orderId];
    
    if (self.totlePrice.hidden) {
//        NSLog(@"总价隐藏");
        self.totlePrice.frame = CGRectMake(0, _orderIdView.bottom, self.view.width, 0);
        self.totlePriceView.hidden = NO;
    }else
    {
        self.totlePrice.frame = CGRectMake(0, _orderIdView.bottom, self.view.width, DETAILSLABEL_HEIGHT);
        self.totlePrice.detailesLabel.frame = CGRectMake(self.totlePrice.detailesLabel.left, self.totlePrice.detailesLabel.top, self.view.width - 30, self.totlePrice.height);
        self.totlePrice.detailesLabel.text = [NSString stringWithFormat:@"总计: %@", orderModel.allMoney];
        _totlePrice.detailesLabel.textColor = [UIColor redColor];
        self.totlePriceView.hidden = YES;
    }
    
    
    self.mealsView.frame = CGRectMake(0, _totlePrice.bottom + TOP_SPACE, self.view.width, 100);
    
    
    self.totlePriceView.printButton.hidden = YES;
    
//    if (orderModel.pays == 0) {
//        
//        if (orderModel.isVerifyOrder == 0) {
//            // 未付款，验证状态0，不变
//            //            [self.totalPriceView.printButton setTitle:@"未付款" forState:UIControlStateNormal];
//            _payStateLabel.text = @"未付款";
//            [self.totlePriceView.dealButton setTitle:@"打印并处理" forState:UIControlStateNormal];
//            if (orderModel.dealState.intValue == 2) {
//                [self.totlePriceView.dealButton setTitle:@"打印" forState:UIControlStateNormal];
//            }
//            ;
//        }else if (orderModel.isVerifyOrder == 1)
//        {
//            // 未付款，验证状态1，未验证-验证
//            //            [self.totalPriceView.printButton setTitle:@"未付款" forState:UIControlStateNormal];
//            _payStateLabel.text = @"未付款";
//            [self.totlePriceView.dealButton setTitle:@"去验证" forState:UIControlStateNormal];
//            
//        }else if (orderModel.isVerifyOrder == 2)
//        {
//            // 相当于已处理订单
//            //            [self.totalPriceView.printButton setTitle:@"未付款" forState:UIControlStateNormal];
//            _payStateLabel.text = @"未付款";
//            [self.totlePriceView.dealButton setTitle:@"已验证" forState:UIControlStateNormal];
//        }
//        
//        
//    }else
//    {
//        if (orderModel.isVerifyOrder == 0) {
//            //            [self.totalPriceView.printButton setTitle:@"已付款" forState:UIControlStateNormal];
//            _payStateLabel.text = @"已付款";
//            [self.totlePriceView.dealButton setTitle:@"打印并处理" forState:UIControlStateNormal];
//            if (orderModel.dealState.intValue == 2) {
//                [self.totlePriceView.dealButton setTitle:@"打印" forState:UIControlStateNormal];
//            }
//        }else if (orderModel.isVerifyOrder == 1)
//        {
//            //            [self.totalPriceView.printButton setTitle:@"未验证" forState:UIControlStateNormal];
//            _payStateLabel.text = @"未验证";
//            [self.totlePriceView.dealButton setTitle:@"去验证" forState:UIControlStateNormal];
//        }else if (orderModel.isVerifyOrder == 2)
//        {
//            // 相当于已处理订单
//            //            [self.totalPriceView.printButton setTitle:@"已验证" forState:UIControlStateNormal];
//            _payStateLabel.text = @"已验证";
//            [self.totlePriceView.dealButton setTitle:@"打印" forState:UIControlStateNormal];
//        }
//    }
    if (orderModel.dealState.intValue == 1) {
        if (orderModel.pays == 0) {
            
            if (orderModel.isVerifyOrder == 0) {
                // 未付款，验证状态0，不变
                _payStateLabel.text = @"未付款";
                [self.totlePriceView.dealButton setTitle:@"打印并处理" forState:UIControlStateNormal];
                ;
            }else if (orderModel.isVerifyOrder == 1)
            {
                // 未付款，验证状态1，未验证-验证
                _payStateLabel.text = @"未付款-未验证";
                
                if (orderModel.dealState.intValue == 4 || orderModel.dealState.intValue == 6) {
                    self.totlePriceView.dealButton.hidden = YES;
                }else
                {
                    [self.totlePriceView.dealButton setTitle:@"去验证" forState:UIControlStateNormal];
                }
                
                
            }else if (orderModel.isVerifyOrder == 2)
            {
                // 相当于已处理订单
                _payStateLabel.text = @"已验证";
                [self.totlePriceView.dealButton setTitle:@"打印并处理" forState:UIControlStateNormal];
            }
            
            
        }else
        {
            if (orderModel.isVerifyOrder == 0) {
                _payStateLabel.text = @"已付款";
                [self.totlePriceView.dealButton setTitle:@"打印并处理" forState:UIControlStateNormal];
            }else if (orderModel.isVerifyOrder == 1)
            {
                _payStateLabel.text = @"未验证";
                if (orderModel.dealState.intValue == 4 || orderModel.dealState.intValue == 6) {
                    self.totlePriceView.dealButton.hidden = YES;
                }else
                {
                    [self.totlePriceView.dealButton setTitle:@"去验证" forState:UIControlStateNormal];
                }
            }else if (orderModel.isVerifyOrder == 2)
            {
                // 相当于已处理订单
                _payStateLabel.text = @"已验证";
                [self.totlePriceView.dealButton setTitle:@"打印并处理" forState:UIControlStateNormal];
                
            }
        }
    }else
    {
        if (orderModel.pays == 0) {
            
            if (orderModel.isVerifyOrder == 0) {
                // 未付款，验证状态0，不变
                _payStateLabel.text = @"未付款";
                [self.totlePriceView.dealButton setTitle:@"打印" forState:UIControlStateNormal];
                ;
            }else if (orderModel.isVerifyOrder == 1)
            {
                // 未付款，验证状态1，未验证-验证
                _payStateLabel.text = @"未付款-未验证";
                
                if (orderModel.dealState.intValue == 4 || orderModel.dealState.intValue == 6) {
                    self.totlePriceView.dealButton.hidden = YES;
                }else
                {
                    [self.totlePriceView.dealButton setTitle:@"去验证" forState:UIControlStateNormal];
                }
                
                
            }else if (orderModel.isVerifyOrder == 2)
            {
                // 相当于已处理订单
                _payStateLabel.text = @"已验证";
                [self.totlePriceView.dealButton setTitle:@"打印" forState:UIControlStateNormal];
            }
            
            
        }else
        {
            if (orderModel.isVerifyOrder == 0) {
                _payStateLabel.text = @"已付款";
                [self.totlePriceView.dealButton setTitle:@"打印" forState:UIControlStateNormal];
            }else if (orderModel.isVerifyOrder == 1)
            {
                _payStateLabel.text = @"未验证";
                if (orderModel.dealState.intValue == 4 || orderModel.dealState.intValue == 6) {
                    self.totlePriceView.dealButton.hidden = YES;
                }else
                {
                    [self.totlePriceView.dealButton setTitle:@"去验证" forState:UIControlStateNormal];
                }
            }else if (orderModel.isVerifyOrder == 2)
            {
                // 相当于已处理订单
                _payStateLabel.text = @"已验证";
                [self.totlePriceView.dealButton setTitle:@"打印" forState:UIControlStateNormal];
                
            }
        }
    }
    
    for (int i = 0; i < orderModel.mealArray.count; i++) {
        MealDetailsView * mealDetailsView = [[MealDetailsView alloc]initWithFrame:CGRectMake(0, 45 + 30 * i, self.mealsView.width, 30)];
        Meal * meal = [orderModel.mealArray objectAtIndex:i];
        
        mealDetailsView.nametext = meal.name;
        mealDetailsView.nameLabel.text = meal.name;
        mealDetailsView.countLabel.text = [NSString stringWithFormat:@"x %@", meal.count];
        mealDetailsView.priceLabel.text = [NSString stringWithFormat:@"%@元", meal.money];
        [self.mealsView addSubview:mealDetailsView];
        self.mealsView.height = mealDetailsView.bottom + 10;
    }
    
    self.totlePriceView.moneyStr = [NSString stringWithFormat:@"%@", orderModel.allMoney];
    _scrollerView.contentSize = CGSizeMake(self.view.width, _mealsView.bottom + TOP_SPACE);

}

#pragma mark - 拒绝接单
- (void)nulliyOrder
{
    //     NewOrderModel * order = [self.newsArray objectAtIndex:button.tag - NULLIYBUTTON_TAG];
    //    NSDictionary * jsonDic = @{
    //                               @"UserId":[UserInfo shareUserInfo].userId,
    //                               @"Command":@75,
    //                               @"OrderId":order.orderId
    //                               };
    //    [self playPostWithDictionary:jsonDic];
    NSDictionary * jsonDic = nil;
    NSString * string = nil;
    NewOrderModel * order = self.ordermodel;
    if (order.dealState.integerValue == 1) {
        //拒绝接单
        jsonDic = @{
                    @"UserId":[UserInfo shareUserInfo].userId,
                    @"Command":@26,
                    @"OrderId":order.orderId
                    };
        string = @"正在拒绝...";
    }else if (order.dealState.integerValue == 4) {
        //无效
        jsonDic = @{
                    @"UserId":[UserInfo shareUserInfo].userId,
                    @"Command":@23,
                    @"OrderId":order.orderId
                    };
        string = @"正在设置无效...";
    }else if (order.dealState.integerValue == 5) {
        //退款
        jsonDic = @{
                    @"UserId":[UserInfo shareUserInfo].userId,
                    @"Command":@27,
                    @"OrderId":order.orderId
                    };
        string = @"正在退款...";
    }
    [self playPostWithDictionary:jsonDic];
    [SVProgressHUD showWithStatus:string maskType:SVProgressHUDMaskTypeBlack];
}
#pragma mark - 处理退款
- (void)refuseRefungAction
{
    
    NSDictionary * jsonDic = nil;
    NSString * string = nil;
    jsonDic = @{
                @"UserId":[UserInfo shareUserInfo].userId,
                @"Command":@27,
                @"OrderId":self.ordermodel.orderId,
                @"Type":@1
                };
    string = @"正在处理...";
    [self playPostWithDictionary:jsonDic];
    [SVProgressHUD showWithStatus:string maskType:SVProgressHUDMaskTypeBlack];
    
    
}

- (void)agreeRefundAction
{
    
    NSDictionary * jsonDic = nil;
    NSString * string = nil;
    jsonDic = @{
                @"UserId":[UserInfo shareUserInfo].userId,
                @"Command":@27,
                @"OrderId":self.ordermodel.orderId,
                @"Type":@0
                };
    string = @"正在退款...";
    [self playPostWithDictionary:jsonDic];
    [SVProgressHUD showWithStatus:string maskType:SVProgressHUDMaskTypeBlack];
}
#pragma mark - 标记餐已送出
- (void)markMealSentOut
{
    NSDictionary * jsonDic = @{
                               @"UserId":[UserInfo shareUserInfo].userId,
                               @"Command":@16,
                               @"OrderId":self.ordermodel.orderId
                               };
    [self playPostWithDictionary:jsonDic];
    [SVProgressHUD showWithStatus:@"正在标记成已处理..." maskType:SVProgressHUDMaskTypeBlack];
}


#pragma mark - 打印
- (void)printMeallist
{
    NSLog(@"打印订单");
    
        if (self.printIawaimaiOrtangshi == 2) {
            NewOrderModel * order = self.ordermodel;
            
            if ([PrintType sharePrintType].isGPRSenable && [PrintType sharePrintType].isBlutooth) {
                NSDictionary * jsonDic = @{
                                           @"UserId":[UserInfo shareUserInfo].userId,
                                           @"Command":@69,
                                           @"OrderId":order.orderId,
                                           @"PrintType":@3,
                                           @"DealPrint":@1
                                           };
                
                [self playPostWithDictionary:jsonDic];
            }else if ([PrintType sharePrintType].isGPRSenable ) {
                
                NSDictionary * jsonDic = @{
                                           @"UserId":[UserInfo shareUserInfo].userId,
                                           @"Command":@69,
                                           @"OrderId":order.orderId,
                                           @"PrintType":@3,
                                           @"DealPrint":@1
                                           };
                
                [self playPostWithDictionary:jsonDic];
                
            }else if ( [PrintType sharePrintType].isBlutooth )
            {

                NSDictionary * jsonDic = @{
                                           @"UserId":[UserInfo shareUserInfo].userId,
                                           @"Command":@69,
                                           @"OrderId":order.orderId,
                                           @"PrintType":@2,
                                           @"DealPrint":@1
                                           };
                [self playPostWithDictionary:jsonDic];
                [SVProgressHUD showWithStatus:@"正在请求处理..." maskType:SVProgressHUDMaskTypeBlack];
            }
            if  (![PrintType sharePrintType].isGPRSenable && ![PrintType sharePrintType].isBlutooth)
            {

                _printTypeVC.fromWitchController = 2;
                _printTypeVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:_printTypeVC animated:YES];
                //            }
            }
        }else
        {
            NewOrderModel * order = self.ordermodel;
            
            if ([PrintType sharePrintType].isGPRSenable && [PrintType sharePrintType].isBlutooth) {
                NSDictionary * jsonDic = @{
                                           @"UserId":[UserInfo shareUserInfo].userId,
                                           @"Command":@15,
                                           @"OrderId":order.orderId,
                                           @"PrintType":@3,
                                           @"DealPrint":@1
                                           };
                
                [self playPostWithDictionary:jsonDic];
            }else if ([PrintType sharePrintType].isGPRSenable ) {
                
                NSDictionary * jsonDic = @{
                                           @"UserId":[UserInfo shareUserInfo].userId,
                                           @"Command":@15,
                                           @"OrderId":order.orderId,
                                           @"PrintType":@3,
                                           @"DealPrint":@1
                                           };
                
                [self playPostWithDictionary:jsonDic];
                
            }
            else if ( [PrintType sharePrintType].isBlutooth )
            {
                NSDictionary * jsonDic = @{
                                           @"UserId":[UserInfo shareUserInfo].userId,
                                           @"Command":@15,
                                           @"OrderId":order.orderId,
                                           @"PrintType":@2,
                                           @"DealPrint":@1
                                           };
                [self playPostWithDictionary:jsonDic];
                [SVProgressHUD showWithStatus:@"正在请求处理..." maskType:SVProgressHUDMaskTypeBlack];
            }
            
            if  (![PrintType sharePrintType].isGPRSenable && ![PrintType sharePrintType].isBlutooth)
            {
      
                _printTypeVC.fromWitchController = 2;
                _printTypeVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:_printTypeVC animated:YES];
            }
            
            
        }
    
    
}

#pragma mark - 处理并打印
- (void)dealAndPrint
{
   
        
        if (self.printIawaimaiOrtangshi == 1) {
            ;
            NewOrderModel * order = self.ordermodel;
            
            if ([PrintType sharePrintType].isGPRSenable && [PrintType sharePrintType].isBlutooth) {
                NSDictionary * jsonDic = @{
                                           @"UserId":[UserInfo shareUserInfo].userId,
                                           @"Command":@15,
                                           @"OrderId":order.orderId,
                                           @"PrintType":@3
                                           };
                
                [self playPostWithDictionary:jsonDic];
            }else if ([PrintType sharePrintType].isGPRSenable) {
                
                NSNumber *num = nil;
                NSDictionary * jsonDic = @{
                                           @"UserId":[UserInfo shareUserInfo].userId,
                                           @"Command":@15,
                                           @"OrderId":order.orderId,
                                           @"PrintType":@3
                                           };
                
                [self playPostWithDictionary:jsonDic];
                
                
            }else if ( [PrintType sharePrintType].isBlutooth)
            {
             
                NSDictionary * jsonDic = @{
                                           @"UserId":[UserInfo shareUserInfo].userId,
                                           @"Command":@15,
                                           @"OrderId":order.orderId,
                                           @"PrintType":@2
                                           };
                
                [self playPostWithDictionary:jsonDic];
                
            }
            if (![PrintType sharePrintType].isGPRSenable && ![PrintType sharePrintType].isBlutooth)
            {
               
                NSDictionary * jsonDic = @{
                                           @"UserId":[UserInfo shareUserInfo].userId,
                                           @"Command":@15,
                                           @"OrderId":order.orderId,
                                           @"PrintType":@1
                                           };
                
                [self playPostWithDictionary:jsonDic];
                
                [SVProgressHUD showWithStatus:@"正在请求处理..." maskType:SVProgressHUDMaskTypeBlack];
                
            }
            
            NSLog(@"订单号%d", order.orderNum);
        }else if (self.printIawaimaiOrtangshi == 2)
        {
            ;
            NewOrderModel * order = self.ordermodel;
            
            if ([PrintType sharePrintType].isGPRSenable && [PrintType sharePrintType].isBlutooth) {
                NSDictionary * jsonDic = @{
                                           @"UserId":[UserInfo shareUserInfo].userId,
                                           @"Command":@69,
                                           @"OrderId":order.orderId,
                                           @"PrintType":@3,
                                           @"DealPrint":@0
                                           };
                
                [self playPostWithDictionary:jsonDic];
            }else if ([PrintType sharePrintType].isGPRSenable) {
                
                NSNumber *num = nil;
                
                NSDictionary * jsonDic = @{
                                           @"UserId":[UserInfo shareUserInfo].userId,
                                           @"Command":@69,
                                           @"OrderId":order.orderId,
                                           @"PrintType":@3,
                                           @"DealPrint":@0
                                           };
                
                [self playPostWithDictionary:jsonDic];
                
            }else if ( [PrintType sharePrintType].isBlutooth)
            {
           
                NSDictionary * jsonDic = @{
                                           @"UserId":[UserInfo shareUserInfo].userId,
                                           @"Command":@69,
                                           @"OrderId":order.orderId,
                                           @"PrintType":@2,
                                           @"DealPrint":@0
                                           };
                
                [self playPostWithDictionary:jsonDic];
                
            }
            if (![PrintType sharePrintType].isGPRSenable && ![PrintType sharePrintType].isBlutooth)
            {
                
                NSDictionary * jsonDic = @{
                                           @"UserId":[UserInfo shareUserInfo].userId,
                                           @"Command":@69,
                                           @"OrderId":order.orderId,
                                           @"PrintType":@1,
                                           @"DealPrint":@0
                                           };
                
                [self playPostWithDictionary:jsonDic];
                [SVProgressHUD showWithStatus:@"正在请求处理..." maskType:SVProgressHUDMaskTypeBlack];
            }
            
            NSLog(@"订单号%d", order.orderNum);
        }
    
    
}

#pragma mark - 获取打印信息
- (NSString *)dataString
{
    Byte caPrintFmt[5];
    
    /*初始化命令：ESC @ 即0x1b,0x40*/
    caPrintFmt[0] = 0x1b;
    caPrintFmt[1] = 0x40;
    
    /*字符设置命令：ESC ! n即0x1b,0x21,n*/
    caPrintFmt[2] = 0x1b;
    caPrintFmt[3] = 0x21;
    
    caPrintFmt[4] = 0x16;
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString * str = [[NSString alloc] initWithBytes:caPrintFmt length:5 encoding:enc];
    return  str;
}

- (NSString *)normalString
{
    Byte caPrintFmt[5];
    
    /*初始化命令：ESC @ 即0x1b,0x40*/
    caPrintFmt[0] = 0x1b;
    caPrintFmt[1] = 0x40;
    
    /*字符设置命令：ESC ! n即0x1b,0x21,n*/
    caPrintFmt[2] = 0x1b;
    caPrintFmt[3] = 0x21;
    
    caPrintFmt[4] = 0x00;
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString * str = [[NSString alloc] initWithBytes:caPrintFmt length:5 encoding:enc];
    return  str;
}


- (NSString *)getPrintStringWithNewOrder:(NewOrderModel *)order
{
    NSString * spaceString = @"                           ";
    NSString * lineStr = @"--------------------------------\r";
    NSMutableString * str = [NSMutableString string];
    [str appendFormat:@"%d号    %@\r", order.orderNum, [UserInfo shareUserInfo].StroeName];
    [str appendFormat:@"店铺:%@\r%@", [UserInfo shareUserInfo].userName, lineStr];
    [str appendFormat:@"下单时间:%@\r", order.orderTime];
    [str appendFormat:@"送达时间:%@\r%@", order.hopeTime, lineStr];
    [str appendFormat:@"订单号:%@\r", order.orderId];
    [str appendFormat:@"地址:%@\r", order.address];
    [str appendFormat:@"联系人:%@\r", order.name];
    [str appendString:[self dataString]];
    [str appendFormat:@"电话:%@\r%@", order.tel, lineStr];
    [str appendString:[self normalString]];
    if (order.remark.length != 0) {
        [str appendFormat:@"备注:%@\r%@", order.remark, lineStr];
    }
    
    if (order.gift.length != 0) {
        [str appendFormat:@"奖品:%@\r%@", order.remark, lineStr];
    }
    
    for (Meal * meal in order.mealArray) {
        NSInteger length = 16 - meal.name.length;
        NSString * space = [spaceString substringWithRange:NSMakeRange(0, length)];
        [str appendFormat:@"%@%@%@%@  %@元\r", meal.name, space, meal.count, meal.units, meal.money];
    }
    [str appendString:lineStr];
    if ([order.delivery doubleValue] != 0) {
        [str appendFormat:@"配送费           +%@元\r", order.delivery];
    }
    if ([order.foodBox doubleValue] != 0) {
        [str appendFormat:@"餐盒费           +%@元\r", order.foodBox];
    }
    
    if ([order.firstReduce doubleValue] != 0) {
        [str appendFormat:@"首单立减           -%@元\r", order.firstReduce];
    }
    if ([order.fullReduce doubleValue] != 0) {
        [str appendFormat:@"满减优惠           -%@元\r", order.fullReduce];
    }
    if ([order.reduceCard doubleValue] != 0) {
        [str appendFormat:@"优惠券           -%@元\r%@", order.reduceCard, lineStr];
    }
    if ([order.internal intValue] != 0) {
        double integral = order.internal.doubleValue / 100;
        [str appendFormat:@"积分           -%.2f元\r%@", integral, lineStr];
    }
    if (order.discount != 0) {
        
        [str appendFormat:@"打折           %.1f折\r%@", order.discount, lineStr];
    }
    if (order.tablewareFee != 0) {
        [str appendFormat:@"餐具费           +%f元\r%@", order.tablewareFee, lineStr];
    }
    if ([order.otherMoney doubleValue] != 0) {
        [str appendFormat:@"其他费用           +%@元\r%@", order.otherMoney, lineStr];
    }
    if ([order.PayMath isEqualToNumber:@3]) {
        [str appendFormat:@"总计     %@元      现金支付\r%@", order.allMoney, lineStr];
    }else
    {
        [str appendFormat:@"总计     %@元          已付款\r%@", order.allMoney, lineStr];
    }
    if ([order.PayMath intValue] == 3) {
        //        NSString * string = @"扫描下方二维码完成订单支付";
        NSLog(@"********%@", order.PayMath);
        [str appendFormat:@"扫描下方二维码完成订单支付"];
    }
    [str appendFormat:@"\n"];
    return [str copy];
}

- (NSString *)getPrintStringWithTangshiOrder:(NewOrderModel *)order
{
    NSString * spaceString = @"                           ";
    NSString * lineStr = @"--------------------------------\r";
    NSMutableString * str = [NSMutableString string];
    [str appendFormat:@"%d号    %@\r%@", order.orderNum, [UserInfo shareUserInfo].StroeName, lineStr];
    [str appendFormat:@"下单时间:%@\r%@", order.orderTime, lineStr];
    [str appendFormat:@"订单号:%@\r", order.orderId];
    [str appendFormat:@"用餐位置:%@\r", order.eatLocation];
    [str appendFormat:@"用餐人数:%d\r%@", order.customerCount, lineStr];
    if (order.remark.length != 0) {
        [str appendFormat:@"备注:%@\r%@", order.remark, lineStr];
    }
    
    if (order.gift.length != 0) {
        [str appendFormat:@"奖品:%@\r%@", order.remark, lineStr];
    }
    
    for (Meal * meal in order.mealArray) {
        NSInteger length = 16 - meal.name.length;
        NSString * space = [spaceString substringWithRange:NSMakeRange(0, length)];
        [str appendFormat:@"%@%@%@%@  %@元\r", meal.name, space, meal.count, meal.units, meal.money];
    }
    [str appendString:lineStr];
    if ([order.delivery doubleValue] != 0) {
        [str appendFormat:@"配送费           +%@元\r", order.delivery];
    }
    if ([order.foodBox doubleValue] != 0) {
        [str appendFormat:@"餐盒费           +%@元\r", order.foodBox];
    }
    
    if ([order.firstReduce doubleValue] != 0) {
        [str appendFormat:@"首单立减           -%@元\r", order.firstReduce];
    }
    if ([order.fullReduce doubleValue] != 0) {
        [str appendFormat:@"满减优惠           -%@元\r", order.fullReduce];
    }
    if ([order.reduceCard doubleValue] != 0) {
        [str appendFormat:@"优惠券           -%@元\r%@", order.reduceCard, lineStr];
    }
    if ([order.internal intValue] != 0) {
        double integral = order.internal.doubleValue / 100;
        [str appendFormat:@"积分           -%.2f元\r%@", integral, lineStr];
    }
    if (order.discount != 0) {
        
        [str appendFormat:@"打折           %.1f折\r%@", order.discount, lineStr];
    }
    if (order.tablewareFee != 0) {
        [str appendFormat:@"餐具费           +%f元\r%@", order.tablewareFee, lineStr];
    }
    if ([order.otherMoney doubleValue] != 0) {
        [str appendFormat:@"其他费用           +%@元\r%@", order.otherMoney, lineStr];
    }
    if (order.pays == 0) {
        [str appendFormat:@"总计     %@元      未付款\r%@", order.allMoney, lineStr];
    }else
    {
        [str appendFormat:@"总计     %@元          已付款\r%@", order.allMoney, lineStr];
    }
    if (order.pays == 0) {
        //        NSString * string = @"扫描下方二维码完成订单支付";
        //        NSLog(@"********%d", order.pay);
        [str appendFormat:@"扫描下方二维码完成订单支付"];
    }
    [str appendFormat:@"\n"];
    return [str copy];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 刷新布局
- (void)refreshSubViews
{
    
    
    self.orderDetailsView.remarkView.frame = CGRectMake(0, self.orderDetailsView.addressView.bottom, self.orderDetailsView.remarkView.width, self.orderDetailsView.remarkView.height);
    self.orderDetailsView.giftView.frame = CGRectMake(0, self.orderDetailsView.remarkView.bottom, self.orderDetailsView.giftView.width, self.orderDetailsView.giftView.height);
//    CGRect giftframe = self.orderDetailsView.giftView.frame;
//    giftframe.origin.y = self.orderDetailsView.remarkView.bottom;
    
    CGRect arriveframe = self.arriveTime.frame;
    arriveframe.origin.y = self.orderDetailsView.bottom;
    
    CGRect tablewarefeeframe = self.tablewareFee.frame;
    tablewarefeeframe.origin.y = self.arriveTime.bottom;
    
    CGRect reducecardframe = self.reduceCardview.frame;
    reducecardframe.origin.y = self.tablewareFee.bottom;
    
    CGRect integralframe = self.integralview.frame;
    integralframe.origin.y = self.reduceCardview.bottom;
    
    CGRect deliveryframe = self.delivery.frame;
    deliveryframe.origin.y = self.integralview.bottom;
    
    CGRect foodBoxframe = self.foodBox.frame;
    foodBoxframe.origin.y = self.delivery.bottom;
    
    CGRect othermoneyframe = self.otherMoney.frame;
    othermoneyframe.origin.y = self.foodBox.bottom;
    
    CGRect fullreduceframe = self.fullRduce.frame;
    fullreduceframe.origin.y = self.otherMoney.bottom;
    
    CGRect firstreduceframe = self.firstRduce.frame;
    firstreduceframe.origin.y = self.fullRduce.bottom;
    
    CGRect discountframe = self.discountview.frame;
    discountframe.origin.y = self.firstRduce.bottom;
    
    CGRect orderIDframe = self.orderIdView.frame;
    self.orderIdView.top = self.discountview.bottom;
    self.totlePrice.top = self.discountview.bottom;
    self.mealsView.top = self.totlePrice.bottom + TOP_SPACE;
    _scrollerView.contentSize = CGSizeMake(self.view.width, _mealsView.bottom + TOP_SPACE);
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
