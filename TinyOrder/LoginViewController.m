//
//  LoginViewController.m
//  TinyOrder
//
//  Created by 仙林 on 15/4/14.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "LoginViewController.h"
#import "UIViewAdditions.h"
#import "MyTabBarController.h"
#import <APService.h>
#import "AppDelegate.h"

@interface LoginViewController ()<UITextFieldDelegate, HTTPPostDelegate>

@property (strong, nonatomic) IBOutlet UIView *nameVeiw;

@property (strong, nonatomic) IBOutlet UIView *passwordView;
@property (strong, nonatomic) IBOutlet UITextField *nameTF;
@property (strong, nonatomic) IBOutlet UITextField *passwordTF;

@property (nonatomic, strong)NSMutableData * data;

@property (assign, nonatomic)CGRect removeFrame;
@property (assign, nonatomic)CGFloat viewY;
- (IBAction)loginAction:(id)sender;
- (IBAction)registerUser:(id)sender;

@end

@implementation LoginViewController


- (NSMutableData *)data
{
    if (!_data) {
        self.data = [NSMutableData data];
    }
    return _data;
}



- (void)viewDidLoad {
    [super viewDidLoad];

//    self.myTabBarC = [[MyTabBarController alloc] init];
//    [self.navigationController presentViewController:_myTabBarC animated:YES completion:nil];
    self.navigationController.navigationBar.translucent = NO;
    self.nameTF.layer.borderColor = [UIColor whiteColor].CGColor;
    self.nameTF.layer.borderWidth = 1;
    self.passwordTF.layer.borderColor = [UIColor whiteColor].CGColor;
    self.passwordTF.layer.borderWidth = 1;
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor orangeColor];
    
    self.nameVeiw.layer.borderWidth = 1.5;
    self.nameVeiw.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:1.0].CGColor;
    self.passwordView.layer.borderWidth = 2;
    self.passwordView.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:1.0].CGColor;
    self.nameTF.delegate = self;
    self.passwordTF.delegate = self;

    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction)];
    [self.view addGestureRecognizer:tapGesture];
    [self automaticLogin];
    // Do any additional setup after loading the view from its nib.
}

- (void)tapGestureAction
{
    [self.nameTF resignFirstResponder];
    [self.passwordTF resignFirstResponder];
//    if (_viewY) {
//        [UIView animateWithDuration:0.5 animations:^{
//            self.view.frame = CGRectMake(self.view.left, _viewY, self.view.width, self.view.height);
//            _viewY = 0;
//        }];
//    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
//    [UIView animateWithDuration:1.0 animations:^{
//        NSLog(@"%g", self.view.top);
//        if (_viewY == 0) {
//            _viewY = self.navigationController.navigationBar.bottom;
//        }
//        self.view.frame = CGRectMake(self.view.left, -100, self.view.width, self.view.height);
//    }];
    return YES;
}

- (void)automaticLogin
{
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"haveLogin"] boolValue]) {
        self.passwordTF.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"Pwd"];
        self.nameTF.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserName"];
        NSLog(@"%@, user = %@", self.passwordTF.text, self.nameTF.text);
        [self loginFramPost];
    }
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
//    [UIView animateWithDuration:0.5 animations:^{
//        self.view.frame = CGRectMake(self.view.left, _viewY, self.view.width, self.view.height);
//        _viewY = 0;
//    }];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
//    [UIView animateWithDuration:0.5 animations:^{
//        self.view.frame = CGRectMake(self.view.left, _viewY, self.view.width, self.view.height);
//        _viewY = 0;
//    }];
    return YES;
}

- (IBAction)loginAction:(id)sender {
    if (self.nameTF.text.length == 0) {
        UIAlertView * NameAlerView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入账号" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [NameAlerView show];
    }else if (self.passwordTF.text.length == 0) {
        UIAlertView * alerView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入密码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alerView show];
    }else
    {
        [self loginFramPost];
    }
}

- (IBAction)registerUser:(id)sender {
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请去官网http://www.vlifee.com进行商家注册" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

- (void)loginFramPost
{
//    if ([[UIApplication sharedApplication] currentUserNotificationSettings].types == UIUserNotificationTypeNone) {
//        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请打开远程推送,本应用需要远程推送协助" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alertView show];
//        return;
//    }
    [SVProgressHUD showWithStatus:@"正在登陆" maskType:SVProgressHUDMaskTypeGradient];
    NSDictionary * jsonDic = nil;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"RegistrationID"]) {
        jsonDic = @{
                    @"Pwd":self.passwordTF.text,
                    @"UserName":self.nameTF.text,
                    @"Command":@5,
                    @"RegistrationID":[[NSUserDefaults standardUserDefaults] objectForKey:@"RegistrationID"],
                    @"DeviceType":@1
                    };
    }else
    {
        jsonDic = @{
                    @"Pwd":self.passwordTF.text,
                    @"UserName":self.nameTF.text,
                    @"Command":@5,
                    @"RegistrationID":[NSNull null],
                    @"DeviceType":@1
                    };
    }
    NSString * jsonStr = [jsonDic JSONString];
    NSString * str = [NSString stringWithFormat:@"%@231618", jsonStr];
    NSString * md5Str = [str md5];
    //    NSLog(@"////%@", md5Str);
    NSString * urlString = [NSString stringWithFormat:@"http://p.vlifee.com/getdata.ashx?md5=%@",md5Str];
    
    HTTPPost * httpPost = [HTTPPost shareHTTPPost];
    [httpPost post:urlString HTTPBody:[jsonStr dataUsingEncoding:NSUTF8StringEncoding]];
    httpPost.delegate = self;
    [self.nameTF resignFirstResponder];
    [self.passwordTF resignFirstResponder];
}


- (void)login
{
    NSDictionary * jsonDic = @{
                               @"Pwd":self.passwordTF.text,
                               @"UserName":self.nameTF.text,
                               @"Command":@5,
                               @"RegistrationID":[[NSUserDefaults standardUserDefaults] objectForKey:@"RegistrationID"],
                               @"DeviceType":@1
                               };
    NSString * jsonStr = [jsonDic JSONString];
    NSString * str = [NSString stringWithFormat:@"%@231618", jsonStr];
    NSString * md5Str = [str md5];
    //    NSLog(@"////%@", md5Str);
    NSString * urlString = [NSString stringWithFormat:@"http://p.vlifee.com/getdata.ashx?md5=%@",md5Str];
    
    HTTPPost * httpPost = [HTTPPost shareHTTPPost];
    [httpPost post:urlString HTTPBody:[jsonStr dataUsingEncoding:NSUTF8StringEncoding]];
    httpPost.delegate = self;
    [self.nameTF resignFirstResponder];
    [self.passwordTF resignFirstResponder];
}


- (void)refresh:(id)data
{
    [SVProgressHUD dismiss];
    NSLog(@"++%@, %@", data, [data objectForKey:@"ErrorMsg"]);
    NSDictionary * dataDic = (NSDictionary *)data;
    if ([[dataDic objectForKey:@"Result"] isEqual:@1]) {
        [self registerRemoteNoti];
        [[NSUserDefaults standardUserDefaults] setValue:self.passwordTF.text forKey:@"Pwd"];//记录登录密码
        [[NSUserDefaults standardUserDefaults] setValue:self.nameTF.text forKey:@"UserName"];//记录用户名
        [[NSUserDefaults standardUserDefaults] setValue:@YES forKey:@"haveLogin"];//记录已经登录过
        [[UserInfo shareUserInfo] setUserInfoWithDictionary:[dataDic objectForKey:@"BusiInfo"]];
        
        [APService setAlias:[NSString stringWithFormat:@"%d", [[UserInfo shareUserInfo].userId intValue]] callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:[UIApplication sharedApplication].delegate];
        self.myTabBarC = [[MyTabBarController alloc] init];
        [self.navigationController presentViewController:_myTabBarC animated:YES completion:nil];
        self.passwordTF.text = nil;
//        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }else
    {
        if ([[dataDic objectForKey:@"ErrorMsg"] length]) {
            UIAlertView * alerView = [[UIAlertView alloc] initWithTitle:@"提示" message:[dataDic objectForKey:@"ErrorMsg"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alerView show];
            self.passwordTF.text = nil;
        }else
        {
            UIAlertView * alerView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"连接服务器失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alerView show];
        }
    }
}

- (void)failWithError:(NSError *)error
{
    [SVProgressHUD dismiss];
    UIAlertView * alerV = [[UIAlertView alloc] initWithTitle:@"提示" message:@"连接服务器失败请重新连接" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alerV show];
    NSLog(@"++++++=%@", error);
}


- (void)registerRemoteNoti
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //categories
        [APService
         registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                             UIUserNotificationTypeSound |
                                             UIUserNotificationTypeAlert)
         categories:nil];
    } else {
        //categories nil
        [APService
         registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                             UIRemoteNotificationTypeSound |
                                             UIRemoteNotificationTypeAlert)
#else
         //categories nil
         categories:nil];
        [APService
         registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                             UIRemoteNotificationTypeSound |
                                             UIRemoteNotificationTypeAlert)
#endif
         // Required
         categories:nil];
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
