//
//  CarInfoViewController.m
//  TinyOrder
//
//  Created by 仙林 on 15/7/29.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "CarInfoViewController.h"

@interface CarInfoViewController ()<HTTPPostDelegate>


@property (nonatomic, strong)UITextField * carNumTF;
@property (nonatomic, strong)UITextField * telNumTF;

@property (nonatomic, strong)UITextField * bankNameTF;

@property (nonatomic, copy)NSString * bankCarName;

@end

@implementation CarInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    
    UILabel * alertLB = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, self.view.width - 50, 20)];
    alertLB.text = @"请填写银行预留信息";
    alertLB.textColor = [UIColor colorWithWhite:0.6 alpha:1];
    [self.view addSubview:alertLB];
    
    UIView * aView = [[UIView alloc] initWithFrame:CGRectMake(0, alertLB.bottom, self.view.width, 140)];
    aView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:aView];
    
    UILabel * bankCarNumLB = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, aView.width - 20, 40)];
//    bankCarNumLB.text = @"证件类型";
    bankCarNumLB.numberOfLines = 0;
    [aView addSubview:bankCarNumLB];
    
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(bankCarNumLB.left, bankCarNumLB.bottom + 5, aView.width - bankCarNumLB.left * 2, 1)];
    line.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    [aView addSubview:line];
    
    
    UILabel * carTypyLB = [[UILabel alloc] initWithFrame:CGRectMake(10, 10 + line.bottom, 70, 20)];
    carTypyLB.text = @"证件类型";
    [aView addSubview:carTypyLB];
    
    UILabel * typeLB = [[UILabel alloc] initWithFrame:CGRectMake(carTypyLB.right, carTypyLB.top, 60, carTypyLB.height)];
    typeLB.text = @"身份证";
    typeLB.textColor = [UIColor orangeColor];
    [aView addSubview:typeLB];
    
    UIView * line1 = [[UIView alloc] initWithFrame:CGRectMake(carTypyLB.left, carTypyLB.bottom + 10, aView.width - carTypyLB.left * 2, 1)];
    line1.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    [aView addSubview:line1];
    
    UILabel * carNumLB = [[UILabel alloc] initWithFrame:CGRectMake(line1.left, line1.bottom + 10, 55, 20)];
    carNumLB.text = @"证件号";
    [aView addSubview:carNumLB];
    
    self.carNumTF = [[UITextField alloc] initWithFrame:CGRectMake(carNumLB.right + 5, carNumLB.top, aView.width - carNumLB.left - carNumLB.right - 5, carNumLB.height)];
    _carNumTF.placeholder = @"请输入证件号";
//    _carNumTF.keyboardType = UIKeyboardTypeEmailAddress;
    _carNumTF.clearButtonMode = UITextFieldViewModeWhileEditing;
//    _carNumTF.clearsOnBeginEditing = YES;
    [aView addSubview:_carNumTF];
    
    UIView * line2 = [[UIView alloc] initWithFrame:CGRectMake(carNumLB.left, carNumLB.bottom + 10, aView.width - carNumLB.left * 2, 1)];
    line2.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    [aView addSubview:line2];
    
    UILabel * telNumLB = [[UILabel alloc] initWithFrame:CGRectMake(line2.left, line2.bottom + 10, 55, 20)];
    telNumLB.text = @"手机号";
    [aView addSubview:telNumLB];
    
    self.telNumTF = [[UITextField alloc] initWithFrame:CGRectMake(telNumLB.right + 5, telNumLB.top, aView.width - telNumLB.left - telNumLB.right - 5, telNumLB.height)];
    _telNumTF.placeholder = @"请输入银行预留手机号";
    _telNumTF.keyboardType = UIKeyboardTypeNumberPad;
    _telNumTF.clearButtonMode = UITextFieldViewModeWhileEditing;
//    _telNumTF.clearsOnBeginEditing = YES;
    [aView addSubview:_telNumTF];
    
    
    UIView * line3 = [[UIView alloc] initWithFrame:CGRectMake(telNumLB.left, telNumLB.bottom + 10, aView.width - telNumLB.left * 2, 1)];
    line3.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    [aView addSubview:line3];
    
    UILabel * bankLB = [[UILabel alloc] initWithFrame:CGRectMake(line3.left, line3.bottom + 10, 55, 20)];
    bankLB.text = @"开户行";
    [aView addSubview:bankLB];
    
    self.bankNameTF = [[UITextField alloc] initWithFrame:CGRectMake(bankLB.right + 5, bankLB.top, aView.width - bankLB.left - bankLB.right - 5, bankLB.height)];
    _bankNameTF.placeholder = @"请输入开户行";
    _bankNameTF.clearButtonMode = UITextFieldViewModeWhileEditing;
//    _bankNameTF.clearsOnBeginEditing = YES;
    [aView addSubview:_bankNameTF];
    
    
    aView.height = _bankNameTF.bottom + 10;
    
    UIButton * confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmButton.frame = CGRectMake(10, aView.bottom + 20, self.view.width - 20, 40);
    confirmButton.backgroundColor = [UIColor orangeColor];
    confirmButton.layer.cornerRadius = 5;
    [confirmButton setTitle:@"确定绑定" forState:UIControlStateNormal];
    [confirmButton addTarget:self action:@selector(confirmBinding:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confirmButton];
    
    
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"http://apis.haoservice.com/lifeservice/bankcard/query?card=%@&key=b860adf50ca24f8d89ce53b2d31b6d6b", self.carNum]];
    NSString * string = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    NSLog(@"%@", string);
    
    NSRange range = [string rangeOfString:@"银行卡种"];
    if (range.length > 0) {
        NSString * str = [string substringFromIndex:range.location];
        NSRange range1 = [str rangeOfString:@"</ul>"];
        NSString * string1 = [str substringToIndex:range1.location];
        BOOL i = YES;
        while (i) {
            NSRange range2 = [string1 rangeOfString:@"<"];
            NSRange range3 = [string1 rangeOfString:@">"];
            if (range2.location != NSNotFound) {
                string1 = [string1 stringByReplacingCharactersInRange:NSMakeRange(range2.location, range3.location - range2.location + 1) withString:@""];
            }else
            {
                i = NO;
            }
        }
        string1 = [string1 stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        string1 = [string1 stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        string1 = [string1 stringByReplacingOccurrencesOfString:@" " withString:@""];
        string1 = [string1 stringByReplacingOccurrencesOfString:@"银行卡种：" withString:@""];
        //    NSLog(@"%@", string1);
        self.bankCarName = string1;
        NSString * bankStr = [NSString stringWithFormat:@"%@\n%@", string1, self.carNum];
        NSMutableAttributedString * attriStr = [[NSMutableAttributedString alloc] initWithString:bankStr];
        NSRange strRange = [bankStr rangeOfString:self.carNum];
        [attriStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:strRange];
        [attriStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithWhite:0.7 alpha:1] range:strRange];
        bankCarNumLB.attributedText = attriStr;
    }
    // Do any additional setup after loading the view.
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)confirmBinding:(UIButton *)button
{
    
    if (self.carNumTF.text.length != 0 && self.telNumTF.text.length != 0 && self.bankNameTF.text.length != 0) {
        if ([NSString validateIDCardNumber:self.carNumTF.text] && [NSString isTelPhoneNub:self.telNumTF.text]) {
            NSLog(@"%@", self.carNumTF.text);
            NSDictionary * jsonDic = @{
                                       @"Command":@36,
                                       @"UserId":[UserInfo shareUserInfo].userId,
                                       @"BankCardName":self.bankCarName,
                                       @"OpenBankPlace":self.bankNameTF.text,
                                       @"CardName":self.personName,
                                       @"CardNumber":self.carNum,
                                       @"Paper":@"身份证",
                                       @"PaperNumber":self.carNumTF.text,
                                       @"PhoneNumber":self.telNumTF.text
                                       };
            [self playPostWithDictionary:jsonDic];
        }else if (![NSString validateIDCardNumber:self.carNumTF.text])
        {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"请输入正确的身份证号" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:2];
        }else if (![NSString isTelPhoneNub:self.telNumTF.text])
        {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"请输入正确的手机号" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:2];
        }
    }else if (self.carNumTF.text.length == 0)
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"请输入身份证号" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:2];
    }else if (self.telNumTF.text.length == 0)
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"请输入手机号" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:2];
    }else if (self.bankNameTF.text.length == 0)
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"请输入开户行" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:2];
    }
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
    NSLog(@"%@", data);
    if ([[data objectForKey:@"Result"] isEqualToNumber:@1]) {
        if ([[data objectForKey:@"Command"] isEqualToNumber:@10036]) {
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
