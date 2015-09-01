//
//  PhoneViewController.m
//  TinyOrder
//
//  Created by 仙林 on 15/8/17.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "PhoneViewController.h"
#import "RegisterViewController.h"

#define LEFT_SPACE 10


@interface PhoneViewController ()<HTTPPostDelegate>

{
    int _t;
}

/**
 *  手机号输入框
 */
@property (nonatomic, strong)UITextField * phoneTF;
/**
 *  验证码输入框
 */
@property (nonatomic, strong)UITextField * codeTF;
/**
 *  获取验证码按钮
 */
@property (nonatomic, strong)UIButton * getCodeBT;

@property (nonatomic, strong)NSTimer * codeTimer;
/**
 *  服务器返回MD5加密的手机验证码
 */
@property (nonatomic, copy)NSString * md5Code;

@property (nonatomic, strong)NSDate * codeDate;

@end

@implementation PhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"手机验证";
    self.view.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    
    
    self.phoneTF = [[UITextField alloc] initWithFrame:CGRectMake(LEFT_SPACE, 20, self.view.width - LEFT_SPACE * 2, 40)];
    _phoneTF.borderStyle = UITextBorderStyleRoundedRect;
    _phoneTF.placeholder = @"请输入手机号";
    _phoneTF.keyboardType = UIKeyboardTypePhonePad;
    [self.view addSubview:_phoneTF];
    
    
    self.codeTF = [[UITextField alloc] initWithFrame:CGRectMake(LEFT_SPACE, 20 + _phoneTF.bottom, self.view.width - LEFT_SPACE * 3 - 100, 40)];
    _codeTF.borderStyle = UITextBorderStyleRoundedRect;
    _codeTF.placeholder = @"验证码";
    _codeTF.keyboardType = UIKeyboardTypeNumberPad;
    _codeTF.enabled = NO;
    [self.view addSubview:_codeTF];
    
    self.getCodeBT = [UIButton buttonWithType:UIButtonTypeCustom];
    self.getCodeBT.backgroundColor = [UIColor orangeColor];
    [_getCodeBT setTitle:@"获取验证码" forState:UIControlStateNormal];
    _getCodeBT.frame = CGRectMake(_codeTF.right + LEFT_SPACE, _codeTF.top, 100, _codeTF.height);
    _getCodeBT.layer.cornerRadius = 3;
    [_getCodeBT addTarget:self action:@selector(getCodeFromeServer:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_getCodeBT];
    
    
    UIButton * confirmBT = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmBT.frame = CGRectMake(_codeTF.left, _codeTF.bottom + 20, self.view.width - _codeTF.left * 2, 40);
    confirmBT.backgroundColor = [UIColor orangeColor];
    [confirmBT setTitle:@"确定" forState:UIControlStateNormal];
    confirmBT.layer.cornerRadius = 5;
    [confirmBT addTarget:self action:@selector(confirmVerificationPhone:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confirmBT];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backLastVC:)];
    // Do any additional setup after loading the view.
}
- (void)backLastVC:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)getCodeFromeServer:(UIButton *)button
{
    [self.phoneTF resignFirstResponder];
    [self.codeTF resignFirstResponder];
    if ([NSString isTelPhoneNub:self.phoneTF.text]) {
        _t = 60;
        _codeTF.enabled = YES;
        self.codeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(codeTime) userInfo:nil repeats:YES];
        button.backgroundColor = [UIColor colorWithWhite:0.7 alpha:1];
        button.enabled = NO;
        [_getCodeBT setTitle:[NSString stringWithFormat:@"%ds后重发", _t] forState:UIControlStateDisabled];
        [self performSelector:@selector(passTime) withObject:nil afterDelay:60];
        
        NSDictionary * jsonDic = @{
                                   @"PhoneNumber":self.phoneTF.text,
                                   @"Command":@42,
                                   @"Type":@2
                                   };
        [self playPostWithDictionary:jsonDic];
    }
}

- (void)codeTime
{
//    NSLog(@"111");
    [_getCodeBT setTitle:[NSString stringWithFormat:@"%ds后重发", --_t] forState:UIControlStateDisabled];
}

- (void)passTime
{
    self.getCodeBT.enabled = YES;
    _getCodeBT.backgroundColor = [UIColor orangeColor];
    [_getCodeBT setTitle:@"重新获取" forState:UIControlStateNormal];
    [self.codeTimer invalidate];
    self.codeTimer = nil;
}

- (void)confirmVerificationPhone:(UIButton *)button
{
    [self.phoneTF resignFirstResponder];
    [self.codeTF resignFirstResponder];
    if (self.phoneTF.text.length == 0) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入手机号码" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:2];
    }else if (self.codeTF.text.length == 0)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入验证码" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:2];
    }else
    {
        if ([NSString isTelPhoneNub:self.phoneTF.text]) {
//            NSLog(@"\n%@\n%@", self.md5Code, [[[NSString stringWithFormat:@"%@231618", self.codeTF.text] md5] uppercaseString]);
//            RegisterViewController * registerVC = [[RegisterViewController alloc] init];
//            registerVC.phoneNumber = self.phoneTF.text;
//            [self.navigationController pushViewController:registerVC animated:YES];
            
            if ([self.md5Code isEqualToString:[[[NSString stringWithFormat:@"%@231618", self.codeTF.text] md5] uppercaseString]]) {
                
                NSTimeInterval seconds = [[NSDate date] timeIntervalSinceDate:self.codeDate];
                if (seconds > 120) {
                    
                }else
                {
                    RegisterViewController * registerVC = [[RegisterViewController alloc] init];
                    registerVC.phoneNumber = self.phoneTF.text;
                    [self.navigationController pushViewController:registerVC animated:YES];
                }
            }else
            {
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"验证码错误" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
                [alert show];
                [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:2];
            }
        }
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
        if ([command isEqualToNumber:@10042]) {
            self.md5Code = [data objectForKey:@"Verifynode"];
            self.codeDate = [NSDate date];
        }
    }else
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:[data objectForKey:@"ErrorMsg"] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:2];
    }
}

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
