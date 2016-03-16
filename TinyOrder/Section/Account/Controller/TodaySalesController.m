//
//  TodaySalesController.m
//  TinyOrder
//
//  Created by 仙林 on 16/1/18.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "TodaySalesController.h"
#import "BankCarController.h"

#define TOP_SPACE 10
#define LEFT_SPACE 15

#define MAIN_COLOR [UIColor grayColor]
#define MAIN_FONT [UIFont systemFontOfSize:30]

@interface TodaySalesController ()<HTTPPostDelegate>
@property (nonatomic, strong)UILabel * yueLabel;
@property (nonatomic, strong)UILabel * yuetotlelebel;
@property (nonatomic, strong)UILabel * yueTixianLabel;

@property (nonatomic, strong)UILabel * zaixianLabel;

@property (nonatomic, strong)UILabel * xianjinLabel;

@property (nonatomic, strong)UILabel * tangshiOnlineLabel;
@property (nonatomic, strong)UILabel * tangshiCashLabel;

@end

@implementation TodaySalesController
- (void)viewDidLoad
{
    self.navigationItem.title = @"今日销售额";
    
    self.view.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backLastVC:)];
    
    NSDictionary * attributes = @{NSForegroundColorAttributeName:[UIColor blackColor]};
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"提现" style:UIBarButtonItemStylePlain target:self action:@selector(tixian:)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:attributes forState:UIControlStateNormal];
    
    UIScrollView * scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64)];
    scrollView.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    [self.view addSubview:scrollView];
    
    UIView * yuerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, scrollView.width, 270)];
    yuerView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:yuerView];
    
    UIView * yueline1 = [[UIView alloc]initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE , 2, 20)];
    yueline1.backgroundColor = [UIColor redColor];
    [yuerView addSubview:yueline1];
    
    UILabel * uieLB = [[UILabel alloc]initWithFrame:CGRectMake(yueline1.right + LEFT_SPACE, TOP_SPACE / 2, 100, 30)];
    uieLB.text = @"账户余额";
    uieLB.textColor = MAIN_COLOR;
    [yuerView addSubview:uieLB];
    
    UIView * yueLine = [[UIView alloc]initWithFrame:CGRectMake(0, uieLB.bottom + TOP_SPACE, yuerView.width, 1)];
    yueLine.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    [yuerView addSubview:yueLine];
    
    
    UILabel * yueLB1 = [[UILabel alloc]initWithFrame:CGRectMake(yuerView.width / 2 - 50, yueLine.bottom + 60, 100, 20)];
    yueLB1.text = @"账户余额";
    yueLB1.textColor = MAIN_COLOR;
    yueLB1.textAlignment = NSTextAlignmentCenter;
    [yuerView addSubview:yueLB1];
    
    self.yueLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, yueLB1.bottom + 20, yuerView.width, 30)];
    _yueLabel.text = @"¥30.00";
    _yueLabel.font = MAIN_FONT;
    _yueLabel.textAlignment = NSTextAlignmentCenter;
    [yuerView addSubview:_yueLabel];
    
    UIView * yueline2 = [[UIView alloc]initWithFrame:CGRectMake(0, _yueLabel.bottom + 30, yuerView.width, 1)];
    yueline2.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    [yuerView addSubview:yueline2];
    
    UILabel * yuetotleLB = [[UILabel alloc]initWithFrame:CGRectMake(0, yueline2.bottom + 15, yuerView.width / 2 - 0.5, 20)];
    yuetotleLB.text = @"总余额(元)";
    yuetotleLB.textColor = MAIN_COLOR;
    yuetotleLB.textAlignment = NSTextAlignmentCenter;
    [yuerView addSubview:yuetotleLB];
    
    self.yuetotlelebel = [[UILabel alloc]initWithFrame:CGRectMake(0, yuetotleLB.bottom, yuetotleLB.width, yuetotleLB.height)];
    _yuetotlelebel.text = @"¥0.00";
    _yuetotlelebel.textAlignment = NSTextAlignmentCenter;
    [yuerView addSubview:_yuetotlelebel];
    
    UIView * yueline3 = [[UIView alloc]initWithFrame:CGRectMake( _yuetotlelebel.right, yueline2.bottom + 20, 1, 30)];
    yueline3.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    [yuerView addSubview:yueline3];
    
    UILabel * yueTixianLB = [[UILabel alloc]initWithFrame:CGRectMake(yueline3.right, yueline2.bottom + 15, yuerView.width / 2 - 0.5, 20)];
    yueTixianLB.text = @"提现中的余额(元)";
    yueTixianLB.textColor = MAIN_COLOR;
    yueTixianLB.textAlignment = NSTextAlignmentCenter;
    [yuerView addSubview:yueTixianLB];
    
    self.yueTixianLabel = [[UILabel alloc]initWithFrame:CGRectMake(yueTixianLB.left, yueTixianLB.bottom, yueTixianLB.width, yueTixianLB.height)];
    _yueTixianLabel.text = @"¥0.00";
    _yueTixianLabel.textAlignment = NSTextAlignmentCenter;
    [yuerView addSubview:_yueTixianLabel];
    
    
    UIView * zaixianView = [[UIView alloc]initWithFrame:CGRectMake(0, yuerView.bottom + TOP_SPACE, self.view.width, 200)];
    zaixianView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:zaixianView];
    
    UIView * zaixianline1 = [[UIView alloc]initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE , 2, 20)];
    zaixianline1.backgroundColor = [UIColor redColor];
    [zaixianView addSubview:zaixianline1];
    
    UILabel * zaixianLB = [[UILabel alloc]initWithFrame:CGRectMake(zaixianline1.right + LEFT_SPACE, TOP_SPACE / 2, 150, 30)];
    zaixianLB.text = @"外卖在线支付金额";
    zaixianLB.textColor = MAIN_COLOR;
    [zaixianView addSubview:zaixianLB];
    
    UIView * zaixianLine = [[UIView alloc]initWithFrame:CGRectMake(0, zaixianLB.bottom + TOP_SPACE, zaixianView.width, 1)];
    zaixianLine.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    [zaixianView addSubview:zaixianLine];
    
    
    UILabel * zaixianLB1 = [[UILabel alloc]initWithFrame:CGRectMake(zaixianView.width / 2 - 80, zaixianLine.bottom + 60, 160, 20)];
    zaixianLB1.text = @"外卖在线支付金额";
    zaixianLB1.textColor = MAIN_COLOR;
    zaixianLB1.textAlignment = NSTextAlignmentCenter;
    [zaixianView addSubview:zaixianLB1];
    
    self.zaixianLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, zaixianLB1.bottom + 20, zaixianView.width, 30)];
    _zaixianLabel.text = @"¥30.00";
    _zaixianLabel.font = MAIN_FONT;
    _zaixianLabel.textAlignment = NSTextAlignmentCenter;
    [zaixianView addSubview:_zaixianLabel];
    
    
    UIView * xianjinView = [[UIView alloc]initWithFrame:CGRectMake(0, zaixianView.bottom + TOP_SPACE, scrollView.width, 200)];
    xianjinView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:xianjinView];
    
    UIView * xianjinline1 = [[UIView alloc]initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE , 2, 20)];
    xianjinline1.backgroundColor = [UIColor redColor];
    [xianjinView addSubview:xianjinline1];
    
    UILabel * xianjinLB = [[UILabel alloc]initWithFrame:CGRectMake(xianjinline1.right + LEFT_SPACE, TOP_SPACE / 2, 150, 30)];
    xianjinLB.text = @"外卖现金支付金额";
    xianjinLB.textColor = MAIN_COLOR;
    [xianjinView addSubview:xianjinLB];
    
    UIView * xianjinLine = [[UIView alloc]initWithFrame:CGRectMake(0, xianjinLB.bottom + TOP_SPACE, xianjinView.width, 1)];
    xianjinLine.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    [xianjinView addSubview:xianjinLine];
    
    
    UILabel * xianjinLB1 = [[UILabel alloc]initWithFrame:CGRectMake(xianjinView.width / 2 - 80, xianjinLine.bottom + 60, 160, 20)];
    xianjinLB1.text = @"外卖现金支付金额";
    xianjinLB1.textColor = MAIN_COLOR;
    xianjinLB1.textAlignment = NSTextAlignmentCenter;
    [xianjinView addSubview:xianjinLB1];
    
    self.xianjinLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, xianjinLB1.bottom + 20, xianjinView.width, 30)];
    _xianjinLabel.text = @"¥30.00";
    _xianjinLabel.font = MAIN_FONT;
    _xianjinLabel.textAlignment = NSTextAlignmentCenter;
    [xianjinView addSubview:_xianjinLabel];

    UIView * tangshiOnlineView = [[UIView alloc]initWithFrame:CGRectMake(0, xianjinView.bottom + TOP_SPACE, scrollView.width, 200)];
    tangshiOnlineView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:tangshiOnlineView];
    
    UIView * tangshiOnlineline1 = [[UIView alloc]initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE , 2, 20)];
    tangshiOnlineline1.backgroundColor = [UIColor redColor];
    [tangshiOnlineView addSubview:tangshiOnlineline1];
    
    UILabel * tangshiOnlineLB = [[UILabel alloc]initWithFrame:CGRectMake(tangshiOnlineline1.right + LEFT_SPACE, TOP_SPACE / 2, 150, 30)];
    tangshiOnlineLB.text = @"堂食在线支付金额";
    tangshiOnlineLB.textColor = MAIN_COLOR;
    [tangshiOnlineView addSubview:tangshiOnlineLB];
    
    UIView * tangshiOnlineLine = [[UIView alloc]initWithFrame:CGRectMake(0, tangshiOnlineLB.bottom + TOP_SPACE, tangshiOnlineView.width, 1)];
    tangshiOnlineLine.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    [tangshiOnlineView addSubview:tangshiOnlineLine];
    
    
    UILabel * tangshiOnlineLB1 = [[UILabel alloc]initWithFrame:CGRectMake(tangshiOnlineView.width / 2 - 80, tangshiOnlineLine.bottom + 60, 160, 20)];
    tangshiOnlineLB1.text = @"堂食在线支付金额";
    tangshiOnlineLB1.textColor = MAIN_COLOR;
    tangshiOnlineLB1.textAlignment = NSTextAlignmentCenter;
    [tangshiOnlineView addSubview:tangshiOnlineLB1];
    
    self.tangshiOnlineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, tangshiOnlineLB1.bottom + 20, tangshiOnlineView.width, 30)];
    _tangshiOnlineLabel.text = @"¥30.00";
    _tangshiOnlineLabel.font = MAIN_FONT;
    _tangshiOnlineLabel.textAlignment = NSTextAlignmentCenter;
    [tangshiOnlineView addSubview:_tangshiOnlineLabel];

    UIView * tangshiCashView = [[UIView alloc]initWithFrame:CGRectMake(0, tangshiOnlineView.bottom + TOP_SPACE, scrollView.width, 200)];
    tangshiCashView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:tangshiCashView];
    
    UIView * tangshiCashline1 = [[UIView alloc]initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE , 2, 20)];
    tangshiCashline1.backgroundColor = [UIColor redColor];
    [tangshiCashView addSubview:tangshiCashline1];
    
    UILabel * tangshiCashLB = [[UILabel alloc]initWithFrame:CGRectMake(tangshiCashline1.right + LEFT_SPACE, TOP_SPACE / 2, 150, 30)];
    tangshiCashLB.text = @"堂食现金支付金额";
    tangshiCashLB.textColor = MAIN_COLOR;
    [tangshiCashView addSubview:tangshiCashLB];
    
    UIView * tangshiCashLine = [[UIView alloc]initWithFrame:CGRectMake(0, tangshiCashLB.bottom + TOP_SPACE, tangshiCashView.width, 1)];
    tangshiCashLine.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    [tangshiCashView addSubview:tangshiCashLine];
    
    
    UILabel * tangshiCashLB1 = [[UILabel alloc]initWithFrame:CGRectMake(tangshiCashView.width / 2 - 80, tangshiCashLine.bottom + 60, 160, 20)];
    tangshiCashLB1.text = @"堂食现金支付金额";
    tangshiCashLB1.textColor = MAIN_COLOR;
    tangshiCashLB1.textAlignment = NSTextAlignmentCenter;
    [tangshiCashView addSubview:tangshiCashLB1];
    
    self.tangshiCashLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, tangshiCashLB1.bottom + 20, tangshiCashView.width, 30)];
    _tangshiCashLabel.text = @"¥30.00";
    _tangshiCashLabel.font = MAIN_FONT;
    _tangshiCashLabel.textAlignment = NSTextAlignmentCenter;
    [tangshiCashView addSubview:_tangshiCashLabel];

    
    
    
    scrollView.contentSize = CGSizeMake(self.view.width, tangshiCashView.bottom + 10);
    
    NSDictionary * jsonDic = @{
                               @"Command":@74,
                               @"UserId":[UserInfo shareUserInfo].userId
                               };
    [self playPostWithDictionary:jsonDic];
    
    
}

- (void)backLastVC:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
    NSLog(@"data = %@", [data description]);
    if ([[data objectForKey:@"Result"] intValue] == 1 ) {
        self.yueLabel.text = [NSString stringWithFormat:@"¥ %.2f", [[data objectForKey:@"Balance"] doubleValue]];
        self.yuetotlelebel.text = [NSString stringWithFormat:@"¥ %.2f", [[data objectForKey:@"TotleBalance"] doubleValue]];
        self.yueTixianLabel.text = [NSString stringWithFormat:@"¥ %.2f", [[data objectForKey:@"DepositMoney"] doubleValue]];
        self.zaixianLabel.text = [NSString stringWithFormat:@"¥ %.2f", [[data objectForKey:@"OnLineMoney"] doubleValue]];
        self.xianjinLabel.text = [NSString stringWithFormat:@"¥ %.2f", [[data objectForKey:@"CashMoney"] doubleValue]];
        self.tangshiOnlineLabel.text = [NSString stringWithFormat:@"%.2f", [[data objectForKey:@"TangOnLineMoney"] doubleValue]];
        self.tangshiCashLabel.text = [NSString stringWithFormat:@"%.2f", [[data objectForKey:@"TangCashMoney"] doubleValue]];
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
//    if (error.code == -1009) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"友情提示" message:@"网络不给力,请检查网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alert show];
//    }else
//    {
        UIAlertView * alerV = [[UIAlertView alloc] initWithTitle:@"提示" message:@"连接服务器失败请重新连接" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alerV show];
//    }
}
- (void)tixian:(UIBarButtonItem *)bar
{
//    NSLog(@"提现");
    BankCarController * bankCardVC = [[BankCarController alloc]init];
    [self.navigationController pushViewController:bankCardVC animated:YES];
}

@end
