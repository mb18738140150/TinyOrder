//
//  WithdrawalViewController.m
//  TinyOrder
//
//  Created by 仙林 on 15/7/29.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "WithdrawalViewController.h"
#import "BankCarModel.h"

@interface WithdrawalViewController ()<HTTPPostDelegate>

@property (nonatomic, strong)UITextField * priceTF;
@property (nonatomic, strong)UILabel * drawalPriceLB;
@property (nonatomic, strong)NSNumber * balance;

@end

@implementation WithdrawalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    UIView * aView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, self.view.width, 150)];
    aView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:aView];
    
    UILabel * bankNameLB = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 200, 20)];
    bankNameLB.text = self.bankCarMD.bankCardName;
    [aView addSubview:bankNameLB];
    
    UILabel * tailNumLB = [[UILabel alloc] initWithFrame:CGRectMake(bankNameLB.left, bankNameLB.bottom, 120, bankNameLB.height)];
    tailNumLB.text = [NSString stringWithFormat:@"尾号%@", [self.bankCarMD.bankCardNumber substringFromIndex:self.bankCarMD.bankCardNumber.length - 4]];
    tailNumLB.textColor = [UIColor colorWithWhite:0.7 alpha:1];
    tailNumLB.font = [UIFont systemFontOfSize:14];
    [aView addSubview:tailNumLB];
    
//    UILabel * typeLB = [[UILabel alloc] initWithFrame:CGRectMake(tailNumLB.right + 20, tailNumLB.top, 51, tailNumLB.height)];
//    typeLB.textColor = [UIColor colorWithWhite:0.7 alpha:1];
//    typeLB.text = @"储蓄卡";
//    typeLB.font = [UIFont systemFontOfSize:14];
//    [aView addSubview:typeLB];
    
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(tailNumLB.left, tailNumLB.bottom + 5, aView.width - 2 * tailNumLB.left, 1)];
    line.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    [aView addSubview:line];
    
    
    UILabel * timeTitleLB = [[UILabel alloc] initWithFrame:CGRectMake(line.left, line.bottom + 10, 100, tailNumLB.height)];
    timeTitleLB.text = @"到账时间";
    [aView addSubview:timeTitleLB];
    
    UILabel * timeLB = [[UILabel alloc] initWithFrame:CGRectMake(line.right - 110, timeTitleLB.top, 110, timeTitleLB.height)];
    timeLB.text = @"24小时内到账";
    timeLB.textAlignment = NSTextAlignmentRight;
    timeLB.textColor = [UIColor colorWithWhite:0.7 alpha:1];
    [aView addSubview:timeLB];
    
    UIView * line2 = [[UIView alloc] initWithFrame:CGRectMake(line.left, timeLB.bottom + 10, line.width, 1)];
    line2.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    [aView addSubview:line2];
    
    
    UILabel * drawalLB = [[UILabel alloc] initWithFrame:CGRectMake(line2.left, line2.bottom + 10, 100, timeLB.height)];
    drawalLB.text = @"可提现余额";
    [aView addSubview:drawalLB];
    
    NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:@"0元"];
    [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, string.length)];
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(0, string.length - 1)];
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithWhite:0.7 alpha:1] range:NSMakeRange(string.length - 1, 1)];
    
    self.drawalPriceLB = [[UILabel alloc] initWithFrame:CGRectMake(line2.right - 120, drawalLB.top, 120, drawalLB.height)];
    _drawalPriceLB.attributedText = string;
    _drawalPriceLB.textAlignment = NSTextAlignmentRight;
//    drawalPriceLB.backgroundColor = [UIColor grayColor];
    [aView addSubview:_drawalPriceLB];
    
    
    UIView * line3 = [[UIView alloc] initWithFrame:CGRectMake(line.left, _drawalPriceLB.bottom + 10, line.width, 1)];
    line3.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    [aView addSubview:line3];
    
    
    UILabel * aLabel = [[UILabel alloc] initWithFrame:CGRectMake(line.left, line3.bottom + 10, 40, _drawalPriceLB.height)];
    aLabel.text = @"金额";
    [aView addSubview:aLabel];
    
    
    self.priceTF = [[UITextField alloc] initWithFrame:CGRectMake(aLabel.right + 20, aLabel.top, 100, aLabel.height)];
    _priceTF.centerX = aView.width / 2;
    _priceTF.placeholder = @"转出金额";
    _priceTF.keyboardType = UIKeyboardTypeNumberPad;
    [aView addSubview:_priceTF];
    
    UILabel * priceLB = [[UILabel alloc] initWithFrame:CGRectMake(_priceTF.right + 2, _priceTF.top, 20, _priceTF.height)];
    priceLB.text = @"元";
    [aView addSubview:priceLB];
    aView.height = priceLB.bottom + 10;
    
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(20, aView.bottom + 25, self.view.width - 40, 40);
    button.backgroundColor = [UIColor orangeColor];
    button.layer.cornerRadius = 5;
    [button setTitle:@"确定转出" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(withdrawAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    
    NSDictionary * jsonDic = @{
                               @"Command":@37,
                               @"UserId":[UserInfo shareUserInfo].userId
                               };
    [self playPostWithDictionary:jsonDic];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backLastVC:)];
    // Do any additional setup after loading the view.
}



- (void)backLastVC:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)withdrawAction:(UIButton *)button
{
    if (self.priceTF.text.length != 0 && self.priceTF.text.doubleValue <= self.balance.doubleValue) {
        NSDictionary * jsonDic = @{
                                   @"Command":@38,
                                   @"UserId":[UserInfo shareUserInfo].userId,
                                   @"BankCardId":self.bankCarMD.bankCardId,
                                   @"Money":self.priceTF.text
                                   };
        [self playPostWithDictionary:jsonDic];
    }else if(self.priceTF.text.length == 0)
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"请输入转出金额" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:2];
    }else if (self.priceTF.text.doubleValue > self.balance.doubleValue)
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"转出金额不能超过余额" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:2];
    }
    
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
        if ([[data objectForKey:@"Command"] isEqualToNumber:@10037]) {
            self.balance = [data objectForKey:@"Balance"];
            NSString * priceStr = [NSString stringWithFormat:@"%@元", [data objectForKey:@"Balance"]];
            NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:priceStr];
            [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, string.length)];
            [string addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(0, string.length - 1)];
            [string addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithWhite:0.7 alpha:1] range:NSMakeRange(string.length - 1, 1)];
            self.drawalPriceLB.attributedText = [string copy];
        }else if ([[data objectForKey:@"Command"] isEqualToNumber:@10038])
        {
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
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
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
