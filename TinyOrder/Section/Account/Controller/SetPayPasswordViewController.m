//
//  SetPayPasswordViewController.m
//  TinyOrder
//
//  Created by 仙林 on 15/12/7.
//  Copyright © 2015年 仙林. All rights reserved.
//

#import "SetPayPasswordViewController.h"
#import "PasswordVIewHelpView.h"

#define TOP_SPACE 10
#define PASS_HEIGHT 50

@interface SetPayPasswordViewController ()<UITextFieldDelegate, HTTPPostDelegate>

@property (nonatomic, strong)PasswordVIewHelpView * oldPasswordTF;
@property (nonatomic, strong)PasswordVIewHelpView * nPasswordTF;
@property (nonatomic, strong)PasswordVIewHelpView * sPasswordTF;

@end

@implementation SetPayPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    
    self.oldPasswordTF = [[PasswordVIewHelpView alloc]initWithFrame:CGRectMake(0,TOP_SPACE , self.view.width, PASS_HEIGHT)];
    self.oldPasswordTF.nameLabel.text = @"密码";
    self.oldPasswordTF.passwordTF.placeholder = @"6-16字符,区分大小写";
    _oldPasswordTF.passwordTF.delegate = self;
    _oldPasswordTF.passwordTF.secureTextEntry = YES;
    [self.view addSubview:_oldPasswordTF];
    
    self.nPasswordTF = [[PasswordVIewHelpView alloc]initWithFrame:CGRectMake(0, _oldPasswordTF.bottom+ TOP_SPACE , self.view.width, PASS_HEIGHT)];
    _nPasswordTF.nameLabel.text = @"新密码";
    _nPasswordTF.passwordTF.placeholder = @"6-16字符,区分大小写";
    _nPasswordTF.passwordTF.secureTextEntry = YES;
    [self.view addSubview:_nPasswordTF];
    
    UILabel * tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, _nPasswordTF.bottom + 10, self.view.width - 20, 40)];
    tipLabel.backgroundColor = [UIColor clearColor];
    tipLabel.textColor = [UIColor grayColor];
    tipLabel.font = [UIFont systemFontOfSize:14];
    tipLabel.text = @"温馨提示，初始支付密码为账户登录密码";
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.numberOfLines = 0;
    [self.view addSubview:tipLabel];
    
    self.navigationItem.title = @"设置支付密码";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(complateAction:)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back@2x.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction:)];

    
    // Do any additional setup after loading the view.
}
- (void)backAction:(UIBarButtonItem * )sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)complateAction:(UIBarButtonItem *)sender
{

        NSDictionary * jsonDic = @{
                                   @"Command":@67,
                                   @"UserId":[UserInfo shareUserInfo].userId,
                                   @"PeyPassword":self.oldPasswordTF.passwordTF.text
                                   };
        [self playPostWithDictionary:jsonDic];
    
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
    int command = [[data objectForKey:@"Command"] intValue];
    if ([[data objectForKey:@"Result"] isEqual:@1]) {
        if (command == 10067) {
            
            NSDictionary * jsonDic = @{
                                       @"Command":@66,
                                       @"UserId":[UserInfo shareUserInfo].userId,
                                       @"NewPassword":self.nPasswordTF.passwordTF.text
                                       };
            [self playPostWithDictionary:jsonDic];
        }else if (command == 10066)
        {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"支付密码修改成功" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1.5];
            [self.navigationController popViewControllerAnimated:YES];
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
//    if (error.code == -1009) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"友情提示" message:@"网络不给力,请检查网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alert show];
//    }else
//    {
        UIAlertView * alerV = [[UIAlertView alloc] initWithTitle:@"提示" message:@"连接服务器失败请重新连接" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alerV show];
//    }
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString * str = textField.text;
    if (str.length >= 16 ) {
        return NO;
    }
    
    NSCharacterSet * characterSet = [[NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_\b"]invertedSet];
    NSString * filtered = [[string componentsSeparatedByCharactersInSet:characterSet]componentsJoinedByString:@""];
    BOOL a = [string isEqualToString:filtered];
    
    return a;
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
