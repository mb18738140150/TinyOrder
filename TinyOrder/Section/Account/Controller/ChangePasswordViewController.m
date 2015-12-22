//
//  ChangePasswordViewController.m
//  TinyOrder
//
//  Created by 仙林 on 15/10/9.
//  Copyright © 2015年 仙林. All rights reserved.
//

#import "ChangePasswordViewController.h"

@interface ChangePasswordViewController ()<HTTPPostDelegate>

@property (nonatomic, strong)UITextField *nPWTF;
@property (nonatomic, strong)UITextField *sureNewPWTF;

@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = @"修改密码";
    
    UIView * bigView = [[UIView alloc]init];
    bigView.backgroundColor = [UIColor colorWithWhite:.9 alpha:.7];
    bigView.frame = self.view.frame;
    [self.view addSubview:bigView];
    
    self.nPWTF = [[UITextField alloc]initWithFrame:CGRectMake(0, 20, self.view.width, 40)];
    _nPWTF.placeholder = @"请输入新密码";
    _nPWTF.backgroundColor = [UIColor whiteColor];
    _nPWTF.secureTextEntry = YES;
    [bigView addSubview:_nPWTF];
    
    self.sureNewPWTF = [[UITextField alloc]initWithFrame:CGRectMake(0, _nPWTF.bottom + 20, self.view.width, 40)];
    _sureNewPWTF.placeholder = @"请确认新密码";
    _sureNewPWTF.backgroundColor = [UIColor whiteColor];
    _sureNewPWTF.secureTextEntry = YES;
    [bigView addSubview:_sureNewPWTF];
    
    UIButton * nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.frame = CGRectMake(0, _sureNewPWTF.bottom + 20, self.view.width , 40);
    nextButton.backgroundColor = [UIColor colorWithRed:249 / 255.0 green:72 / 255.0 blue:47 / 255.0 alpha:1];;
    nextButton.layer.cornerRadius = 5;
    [nextButton setTitle:@"确认" forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(sureAction:) forControlEvents:UIControlEventTouchUpInside];
    [bigView addSubview:nextButton];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backLastVC:)];
}

- (void)backLastVC:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)sureAction:(UIButton *)button
{
    
    if (self.nPWTF.text.length == 0) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入新密码" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:2];
    }else if (self.sureNewPWTF.text.length == 0)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入确认密码" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:2];
    }else
    {
            if ([self.nPWTF.text isEqualToString:self.sureNewPWTF.text]) {
                
                NSDictionary * jsonDic = @{
                                           @"Command":@54,
                                           @"UserId":[UserInfo shareUserInfo].userId,
                                           @"Password":_nPWTF.text
                                           };
                [self playPostWithDictionary:jsonDic];
            }else
            {
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"两次密码输入不一致,请从新输入" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
                [alert show];
                [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:2];
            }
        
    }

    
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
        UIViewController * vc = [self.navigationController.viewControllers objectAtIndex:1];
        [self.navigationController popToViewController:vc animated:YES];  
        
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
