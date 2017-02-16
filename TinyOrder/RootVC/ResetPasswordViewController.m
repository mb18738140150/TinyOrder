//
//  ResetPasswordViewController.m
//  TinyOrder
//
//  Created by 仙林 on 16/12/6.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "ResetPasswordViewController.h"

@interface ResetPasswordViewController ()<HTTPPostDelegate, UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *resetPassword;

@property (strong, nonatomic) IBOutlet UITextField *surePassword;

@property (strong, nonatomic) IBOutlet UIButton *complateBT;

@end

@implementation ResetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backLastVC:)];
    self.title = @"输入密码";
    
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
- (IBAction)conpleteAction:(id)sender {
    
    if (self.resetPassword.text.length != 0 && self.surePassword.text.length != 0) {
        if ([self.resetPassword.text isEqualToString:self.surePassword.text]) {
            NSDictionary * jsonDic = @{
                                       @"PhoneNumber":self.phoneNumber,
                                       @"UserName":self.userName,
                                       @"Command":@90,
                                       @"Pwd":self.resetPassword.text
                                       };
            [self playPostWithDictionary:jsonDic];
        }else
        {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"两次输入的密码不一致请从新输入" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
        }
    }else
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"密不能为空" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }else
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:[data objectForKey:@"ErrorMsg"] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:2];
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
