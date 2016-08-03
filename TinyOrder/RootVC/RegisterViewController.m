//
//  RegisterViewController.m
//  TinyOrder
//
//  Created by 仙林 on 15/8/17.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "RegisterViewController.h"
#import "ProtocolViewController.h"
#import "ZNCitySelectView.h"
#import "StoreCreateViewController.h"
#import "AuthFillViewController.h"


#define LEFT_SPACE 10
#define TOP_SPACE 10
@interface RegisterViewController ()<UITextFieldDelegate, HTTPPostDelegate>

/**
 *  用户名输入框
 */
@property (nonatomic, strong)UITextField * nameTF;
/**
 *  密码输入框
 */
@property (nonatomic, strong)UITextField * passwordTF;
/**
 *  确认密码输入框
 */
@property (nonatomic, strong)UITextField * againPassTF;
/**
 *  地址输入框
 */
//@property (nonatomic, strong)UITextField * addressTF;
/**
 *  协议选中按钮
 */
@property (nonatomic, strong)UIButton * changeBT;
/**
 *  显示地址label
 */
//@property (nonatomic, strong)UILabel * addressLB;
/**
 *  地址
 */
@property (nonatomic, copy)NSString * address;
/**
 *  地址选择和显示按钮
 */
@property (nonatomic, strong)UIButton * addressBT;
/**
 *  注册账号成功后返回的用户id
 */
@property (nonatomic, strong)NSNumber * userId;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"基本信息";
    self.view.backgroundColor = [UIColor colorWithWhite:0.93 alpha:1];
    
    UILabel * nameLB = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE, 100, 30)];
    nameLB.text = @"用户名:";
    [self.view addSubview:nameLB];
    
    self.nameTF = [[UITextField alloc] initWithFrame:CGRectMake(nameLB.left, nameLB.bottom, self.view.width - nameLB.left * 2, 40)];
    _nameTF.borderStyle = UITextBorderStyleRoundedRect;
    _nameTF.placeholder = @"3~16位字符, 由数字/字母/汉字/下划线组成";
    _nameTF.keyboardType = UIKeyboardTypeASCIICapable;
    _nameTF.delegate = self;
    _nameTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:_nameTF];
    
    UILabel * passwordLB = [[UILabel alloc] initWithFrame:CGRectMake(_nameTF.left, TOP_SPACE + _nameTF.bottom, 100, 30)];
    passwordLB.text = @"密码:";
    [self.view addSubview:passwordLB];
    
    self.passwordTF = [[UITextField alloc] initWithFrame:CGRectMake(passwordLB.left, passwordLB.bottom, self.view.width - passwordLB.left * 2, 40)];
    _passwordTF.borderStyle = UITextBorderStyleRoundedRect;
    _passwordTF.placeholder = @"长度为6~16位字符";
    _passwordTF.secureTextEntry = YES;
    _passwordTF.delegate = self;
    _passwordTF.keyboardType = UIKeyboardTypeASCIICapable;
    _passwordTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:_passwordTF];
    
    UILabel * againLB = [[UILabel alloc] initWithFrame:CGRectMake(_passwordTF.left, TOP_SPACE + _passwordTF.bottom, 100, 30)];
    againLB.text = @"确认密码:";
    [self.view addSubview:againLB];
    
    self.againPassTF = [[UITextField alloc] initWithFrame:CGRectMake(againLB.left, againLB.bottom, self.view.width - againLB.left * 2, 40)];
    _againPassTF.borderStyle = UITextBorderStyleRoundedRect;
    _againPassTF.placeholder = @"长度为6~16位字符";
    _againPassTF.secureTextEntry = YES;
    _againPassTF.delegate = self;
    _againPassTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    _againPassTF.keyboardType = UIKeyboardTypeASCIICapable;
    [self.view addSubview:_againPassTF];
    
    UILabel * titleAddressLB = [[UILabel alloc] initWithFrame:CGRectMake(_againPassTF.left, TOP_SPACE + _againPassTF.bottom, 100, 30)];
    titleAddressLB.text = @"地址:";
    [self.view addSubview:titleAddressLB];
    /*
    self.addressLB = [[UILabel alloc] initWithFrame:CGRectMake(titleAddressLB.left, titleAddressLB.bottom, self.view.width - titleAddressLB.left * 2, 40)];
    _addressLB.text = @"请输入地址";
    _addressLB.textColor = [UIColor colorWithWhite:0.8 alpha:1];
    _addressLB.layer.borderColor = [UIColor colorWithWhite:0.7 alpha:1].CGColor;
    _addressLB.layer.borderWidth = 0.5;
    [self.view addSubview:_addressLB];
     */
    /*
    self.addressTF = [[UITextField alloc] initWithFrame:CGRectMake(titleAddressLB.left, titleAddressLB.bottom, self.view.width - titleAddressLB.left * 2, 40)];
    _addressTF.borderStyle = UITextBorderStyleRoundedRect;
    _addressTF.enabled = NO;
    _addressTF.placeholder = @"请选择地址";
    [self.view addSubview:_addressTF];
     */
    self.addressBT = [UIButton buttonWithType:UIButtonTypeCustom];
    _addressBT.frame = CGRectMake(titleAddressLB.left, titleAddressLB.bottom, self.view.width - titleAddressLB.left * 2, 40);
    _addressBT.backgroundColor = [UIColor whiteColor];
    _addressBT.layer.borderColor = [UIColor colorWithWhite:0.75 alpha:1].CGColor;
    _addressBT.layer.borderWidth = 0.6;
    _addressBT.layer.cornerRadius = 5;
    _addressBT.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _addressBT.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [_addressBT setTitle:@"请选择地址" forState:UIControlStateNormal];
    [_addressBT setTitleColor:[UIColor colorWithWhite:0.75 alpha:01] forState:UIControlStateNormal];
    [_addressBT addTarget:self action:@selector(changeAddress:) forControlEvents:UIControlEventTouchUpInside];
    _addressBT.titleLabel.numberOfLines = 0;
    _addressBT.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:_addressBT];
    
    
    self.changeBT = [UIButton buttonWithType:UIButtonTypeCustom];
    _changeBT.frame = CGRectMake(50, _addressBT.bottom + TOP_SPACE * 2, 135, 25);
//    _changeBT.backgroundColor = [UIColor redColor];
    [_changeBT setTitle:@"我已经阅读并同意" forState:UIControlStateNormal];
    [_changeBT setTitleColor:[UIColor colorWithWhite:0.7 alpha:1] forState:UIControlStateNormal];
    [_changeBT setImage:[UIImage imageNamed:@"change_n.png"] forState:UIControlStateNormal];
    [_changeBT setImage:[UIImage imageNamed:@"change_s.png"] forState:UIControlStateSelected];
    _changeBT.titleLabel.font = [UIFont systemFontOfSize:14];
    [_changeBT addTarget:self action:@selector(selectedProtocol:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_changeBT];
    
    
    UIButton * protocolBT = [UIButton buttonWithType:UIButtonTypeCustom];
    protocolBT.frame = CGRectMake(_changeBT.right, _changeBT.top, 155, _changeBT.height);
//    protocolBT.backgroundColor = [UIColor redColor];
    [protocolBT setTitleColor:[UIColor colorWithRed:249 / 255.0 green:72 / 255.0 blue:47 / 255.0 alpha:1] forState:UIControlStateNormal];
    [protocolBT setTitle:@"《微生活注册服务协议》" forState:UIControlStateNormal];
    protocolBT.titleLabel.font = [UIFont systemFontOfSize:14];
    [protocolBT addTarget:self action:@selector(readProtocol:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:protocolBT];
    
    _changeBT.left = (self.view.width - _changeBT.width - protocolBT.width) / 2;
    protocolBT.left = _changeBT.right;
    
    UIButton * confirmBT = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmBT.frame = CGRectMake(_addressBT.left, protocolBT.bottom + TOP_SPACE * 1.5, _addressBT.width, 40);
    confirmBT.backgroundColor = [UIColor colorWithRed:249 / 255.0 green:72 / 255.0 blue:47 / 255.0 alpha:1];
    [confirmBT setTitle:@"确定" forState:UIControlStateNormal];
    confirmBT.layer.cornerRadius = 5;
    [confirmBT addTarget:self action:@selector(confirmRegister:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confirmBT];
    
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backLastVC:)];
    // Do any additional setup after loading the view.
}
- (void)backLastVC:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)selectedProtocol:(UIButton *)button
{
    button.selected = !button.selected;
}

- (void)confirmRegister:(UIButton *)button
{
    if (self.nameTF.text.length < 3) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:@"用户名最少3个字符" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:2];
    }else if (self.passwordTF.text.length < 6)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:@"密码最少6位" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:2];
    }else if (self.againPassTF.text.length == 0)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:@"请再一次输入密码" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:2];
    }else if (self.address.length == 0)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:@"请选择地址" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:2];
    }else if (![self.passwordTF.text isEqualToString:self.againPassTF.text])
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:@"输入的两次密码不一致" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:2];
    }else if (!self.changeBT.selected)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:@"须同意《微生活注册服务协议》" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:2];
    }else
    {
        [SVProgressHUD showWithStatus:@"正在提交..." maskType:SVProgressHUDMaskTypeBlack];
        NSDictionary * jsonDic = @{
                                   @"Command":@39,
                                   @"Password":self.passwordTF.text,
                                   @"Account":self.nameTF.text,
                                   @"Phone":self.phoneNumber,
                                   @"Address":self.address,
                                   @"Type":@2,
                                   @"RegFromType":@4
                                   };
        [self playPostWithDictionary:jsonDic];
    }
}

- (void)readProtocol:(UIButton *)button
{
    ProtocolViewController * protocolVC = [[ProtocolViewController alloc] init];
    [self.navigationController pushViewController:protocolVC animated:YES];
}

- (void)changeAddress:(UIButton *)button
{
    __weak RegisterViewController * registerVC = self;
    ZNCitySelectView * citySelectView = [[ZNCitySelectView alloc] init];
    citySelectView.m_selectComplete = ^(NSDictionary *provinceDic, NSDictionary *cityDic, NSDictionary *areaDic){
        registerVC.address = [NSString stringWithFormat:@"%@,%@,%@", provinceDic[@"name"], cityDic[@"name"], areaDic[@"name"]];
        [registerVC.addressBT setTitleColor:[UIColor colorWithWhite:0.3 alpha:1] forState:UIControlStateNormal];
        [registerVC.addressBT setTitle:registerVC.address forState:UIControlStateNormal];
        CGSize size = [registerVC.addressBT.titleLabel sizeThatFits:CGSizeMake(_addressBT.width - 20, CGFLOAT_MAX)];
        if (registerVC.addressBT.height < size.height) {
            registerVC.addressBT.height = size.height;
        }
    };
    [citySelectView show];
}


#pragma mark - textField Delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString * text = textField.text;
    if (text.length >= 16) {
        return NO;
    }
    
    // 只允许字母数字下划线
//    if ([textField isEqual:self.nameTF]) {
//        NSCharacterSet * characterSet = [[NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_\b"] invertedSet];
//        NSString * filtered = [[string componentsSeparatedByCharactersInSet:characterSet] componentsJoinedByString:@""];
//        BOOL a = [string isEqualToString:filtered];
//        return a;
//    }
    
    return YES;
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
        if ([command isEqualToNumber:@10039]) {
            self.userId = [data objectForKey:@"UserId"];
            [UserInfo shareUserInfo].userId = [data objectForKey:@"UserId"];
            [UserInfo shareUserInfo].userName = self.nameTF.text;
            [[NSUserDefaults standardUserDefaults] setValue:self.passwordTF.text forKey:@"Pwd"];//记录登录密码
            [[NSUserDefaults standardUserDefaults] setValue:self.nameTF.text forKey:@"UserName"];//记录用户名
            StoreCreateViewController * storeCreateVC = [[StoreCreateViewController alloc] init];
            storeCreateVC.userId = [data objectForKey:@"UserId"];
            [self.navigationController pushViewController:storeCreateVC animated:YES];
            
//            AuthFillViewController * authFillVC = [[AuthFillViewController alloc] init];
//            authFillVC.userId = [data objectForKey:@"UserId"];
//            [self.navigationController pushViewController:authFillVC animated:YES];
            
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
//    if (error.code == -1009) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"友情提示" message:@"网络不给力,请检查网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alert show];
//    }else
//    {
    if ([[error.userInfo objectForKey:@"Reason"] isEqualToString:@"服务器处理失败"]) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"服务器处理失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil ];
        [alert show];
    }else
    {
        
        UIAlertView * alerV = [[UIAlertView alloc] initWithTitle:@"提示" message:@"连接服务器失败请重新连接" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alerV show];
    }
//    }
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
