//
//  TextCheckViewController.m
//  TinyOrder
//
//  Created by 仙林 on 15/10/9.
//  Copyright © 2015年 仙林. All rights reserved.
//

#import "ChangephoneViewController.h"
#import "ChangePasswordViewController.h"

#define SPACE  15
#define VIEW_COLOR [UIColor clearColor]
#define BUTTON_WIDTH 60

@interface ChangephoneViewController () <HTTPPostDelegate>
{
    int _t;
}
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

@property (nonatomic, strong)UITextField *phoneTF;

@end

@implementation ChangephoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"修改手机号码";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel * phineLB = [[UILabel alloc]initWithFrame:CGRectMake(SPACE, SPACE, 100, 30)];
    phineLB.text = @"新的手机号:";
    phineLB.backgroundColor = [UIColor clearColor];
    [self.view addSubview:phineLB];
    self.phoneTF = [[UITextField alloc]initWithFrame:CGRectMake(phineLB.right, SPACE, self.view.width - 2 * SPACE - phineLB.width, 30)];
    _phoneTF.borderStyle = UITextBorderStyleNone;
    _phoneTF.keyboardType = UIKeyboardTypeNumberPad;
    _phoneTF.placeholder = @"请输入新的手机号码";
    [self.view addSubview:_phoneTF];
    
    UILabel * codeLB = [[UILabel alloc]initWithFrame:CGRectMake(SPACE, phineLB.bottom + SPACE, self.view.width - 2 * SPACE, 30)];
    codeLB.text = @"请输入短信验证码";
    codeLB.backgroundColor = [UIColor clearColor];
    [self.view addSubview:codeLB];
    
    self.codeTF = [[UITextField alloc]initWithFrame:CGRectMake(SPACE, codeLB.bottom, self.view.width - 3 * SPACE - 100, 40)];
    _codeTF.borderStyle = UITextBorderStyleRoundedRect;
    _codeTF.placeholder = @"请输入验证码";
    _codeTF.keyboardType = UIKeyboardTypeNumberPad;
    _codeTF.enabled = NO;
    [self.view addSubview:_codeTF];
    
    self.getCodeBT = [UIButton buttonWithType:UIButtonTypeCustom];
    self.getCodeBT.backgroundColor = [UIColor colorWithRed:249 / 255.0 green:72 / 255.0 blue:47 / 255.0 alpha:1];;
    [_getCodeBT setTitle:@"获取验证码" forState:UIControlStateNormal];
    _getCodeBT.frame = CGRectMake(_codeTF.right + SPACE, _codeTF.top, 100, _codeTF.height);
    _getCodeBT.layer.cornerRadius = 3;
    [_getCodeBT addTarget:self action:@selector(getCodeFromeServer:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_getCodeBT];
    
    UIButton * nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.frame = CGRectMake(10, _codeTF.bottom + 20, self.view.width - 20, 40);
    nextButton.backgroundColor = [UIColor colorWithRed:249 / 255.0 green:72 / 255.0 blue:47 / 255.0 alpha:1];;
    nextButton.layer.cornerRadius = 5;
    [nextButton setTitle:@"验证" forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(NextAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextButton];
    
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backLastVC:)];
}

- (void)backLastVC:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)getCodeFromeServer:(UIButton *)sender
{
    [self.codeTF resignFirstResponder];
    _t = 60;
    _codeTF.enabled = YES;
    
    self.codeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(codeTime) userInfo:nil repeats:YES];
    
    sender.backgroundColor = [UIColor colorWithWhite:.7 alpha:1];
    sender.enabled = NO;
    [_getCodeBT setTitle:[NSString stringWithFormat:@"%ds后重发", _t] forState:UIControlStateDisabled];
    
    [self performSelector:@selector(passTime) withObject:nil afterDelay:60];
    
    NSDictionary * jsonDic = @{
                               @"PhoneNumber":self.phoneTF.text,
                               @"Command":@42,
                               @"Type":@1
                               };
    [self playPostWithDictionary:jsonDic];

}

- (void)codeTime
{
    //    NSLog(@"111");
    _t--;
    [_getCodeBT setTitle:[NSString stringWithFormat:@"%ds后重发", _t] forState:UIControlStateDisabled];
}

- (void)passTime
{
    self.getCodeBT.enabled = YES;
    _getCodeBT.backgroundColor = [UIColor colorWithRed:249 / 255.0 green:72 / 255.0 blue:47 / 255.0 alpha:1];
    [_getCodeBT setTitle:@"重新获取" forState:UIControlStateNormal];
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
    NSLog(@"%@", [data description]);
    if ([[data objectForKey:@"Result"] isEqualToNumber:@1]) {
        NSNumber * command = [data objectForKey:@"Command"];
        if ([command isEqualToNumber:@10042]) {
            self.md5Code = [data objectForKey:@"Verifynode"];
            self.codeDate = [NSDate date];
        }else if ([command isEqualToNumber:@10079])
        {
            [UserInfo shareUserInfo].phoneNumber = self.phoneTF.text;
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
- (void)NextAction:(UIButton *)button
{
    
    if (self.codeTF.text.length == 0) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入验证码" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:2];
    }else
    {
        if ([self.md5Code isEqualToString:[[[NSString stringWithFormat:@"%@231618", self.codeTF.text] md5] uppercaseString]]) {
            NSTimeInterval seconds = [[NSDate date]timeIntervalSinceDate:self.codeDate];
            if (seconds >120) {
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"时间超时,请重新获取验证码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }else
            {

                NSDictionary * jsonDic = @{
                                           @"PhoneNumber":self.phoneTF.text,
                                           @"Command":@79,
                                           @"UserId":[UserInfo shareUserInfo].userId
                                           };
                [self playPostWithDictionary:jsonDic];
            }
        }else
        {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"验证码错误" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:2];
        }
    }
    
}

- (void)viewDidAppear:(BOOL)animated
{
    if (self.codeTimer) {
        [self.codeTimer invalidate];
        self.codeTimer = nil;
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
