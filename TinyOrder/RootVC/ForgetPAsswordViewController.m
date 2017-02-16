//
//  ForgetPAsswordViewController.m
//  TinyOrder
//
//  Created by 仙林 on 16/12/5.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "ForgetPAsswordViewController.h"
#import "ResetPasswordViewController.h"

@interface ForgetPAsswordViewController ()<HTTPPostDelegate>
{
    int _t;
}
@property (strong, nonatomic) IBOutlet UITextField *accountTF;
@property (strong, nonatomic) IBOutlet UITextField *phoneNymberTF;
@property (strong, nonatomic) IBOutlet UITextField *verifyCodeTF;
@property (strong, nonatomic) IBOutlet UIButton *verifuCodeBT;
@property (strong, nonatomic) IBOutlet UIButton *nextBT;

@property (nonatomic, strong)NSTimer * codeTimer;

/**
 *  服务器返回MD5加密的手机验证码
 */
@property (nonatomic, copy)NSString * md5Code;

@property (nonatomic, strong)NSDate * codeDate;

@end

@implementation ForgetPAsswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backLastVC:)];
    
    self.title = @"手机验证";
    
    // Do any additional setup after loading the view from its nib.
}
- (void)backLastVC:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)getVerifyCode:(id)sender {
    
    UIButton * button = (UIButton *)sender;
    
    if (self.accountTF.text.length != 0 && self.phoneNymberTF.text.length != 0) {
        
        _t = 60;
        
        self.codeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(codeTime) userInfo:nil repeats:YES];
        
        button.enabled = NO;
        [_verifuCodeBT setTitle:[NSString stringWithFormat:@"%ds后重发", _t] forState:UIControlStateDisabled];
        
        [self performSelector:@selector(passTime) withObject:nil afterDelay:60];
        
        NSDictionary * jsonDic = @{
                                   @"PhoneNumber":self.phoneNymberTF.text,
                                   @"Command":@42,
                                   @"Type":@2
                                   };
        [self playPostWithDictionary:jsonDic];
    }else
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"账号与手机号均不能为空" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }
}
- (void)codeTime
{
    _t--;
    [_verifuCodeBT setTitle:[NSString stringWithFormat:@"%ds后重发", _t] forState:UIControlStateDisabled];
}

- (void)passTime
{
    self.verifuCodeBT.enabled = YES;
    [_verifuCodeBT setTitle:@"重新获取" forState:UIControlStateNormal];
    [self.codeTimer invalidate];
    self.codeTimer = nil;
}
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


- (void)failWithError:(NSError *)error
{
    [SVProgressHUD dismiss];
    if ([[error.userInfo objectForKey:@"Reason"] isEqualToString:@"服务器处理失败"]) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"服务器处理失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil ];
        [alert show];
    }else
    {
        
        UIAlertView * alerV = [[UIAlertView alloc] initWithTitle:@"提示" message:@"连接服务器失败请重新连接" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alerV show];
    }
}

- (IBAction)nextStep:(id)sender {
    
    if (self.verifyCodeTF.text.length == 0) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入验证码" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:2];
    }else
    {
        if ([self.md5Code isEqualToString:[[[NSString stringWithFormat:@"%@231618", self.verifyCodeTF.text] md5] uppercaseString]]) {
            NSTimeInterval seconds = [[NSDate date]timeIntervalSinceDate:self.codeDate];
            if (seconds >120) {
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"时间超时,请重新获取验证码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }else
            {
                [self.codeTimer invalidate];
                self.codeTimer = nil;
                _t = 60;
                [_verifuCodeBT setTitle:[NSString stringWithFormat:@"验证码"] forState:UIControlStateDisabled];
                    ResetPasswordViewController * resetPVC = [[ResetPasswordViewController alloc]init];
                resetPVC.userName = self.accountTF.text;
                resetPVC.phoneNumber = self.phoneNymberTF.text;
                    [self.navigationController pushViewController:resetPVC animated:YES];
                
            }
        }else
        {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"验证码错误" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:2];
        }
    }
    
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
