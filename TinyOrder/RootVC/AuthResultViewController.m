//
//  AuthResultViewController.m
//  TinyOrder
//
//  Created by 仙林 on 15/8/24.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "AuthResultViewController.h"
#import <UIImageView+WebCache.h>
#import "AuthFillViewController.h"
#import "LoginViewController.h"

#define LEFT_SPACE 10
#define TOP_SPACE 10

@interface AuthResultViewController ()<HTTPPostDelegate>


@property (nonatomic, strong)UILabel * nameLB;

@property (nonatomic, strong)UILabel * cardNumLB;

@property (nonatomic, strong)UIImageView * cardImageView;

@property (nonatomic, strong)UILabel * reasonLB;

@property (nonatomic, strong)UIButton * againBT;

@end

@implementation AuthResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    
    UIView * nameView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 50)];
    nameView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:nameView];
    
    UILabel * nameLeftLB = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE, 75, 30)];
    nameLeftLB.text = @"姓名:";
    nameLeftLB.textAlignment = NSTextAlignmentRight;
//    nameLeftLB.backgroundColor = [UIColor greenColor];
    [nameView addSubview:nameLeftLB];
    
    self.nameLB = [[UILabel alloc] initWithFrame:CGRectMake(nameLeftLB.right + 5, nameLeftLB.top, nameView.width - 2 * LEFT_SPACE - nameLeftLB.width - 5, nameLeftLB.height)];
    _nameLB.textColor = [UIColor colorWithWhite:0.2 alpha:1];
//    _nameLB.backgroundColor = [UIColor orangeColor];
    [nameView addSubview:_nameLB];
    
    
    UIView * cardNumView = [[UIView alloc] initWithFrame:CGRectMake(0, nameView.bottom + 1, self.view.width, 50)];
    cardNumView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:cardNumView];
    
    UILabel * cardNumLeftLB = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE, 75, 30)];
    cardNumLeftLB.text = @"身份证号:";
    cardNumLeftLB.textAlignment = NSTextAlignmentRight;
    [cardNumView addSubview:cardNumLeftLB];
    
    self.cardNumLB = [[UILabel alloc] initWithFrame:CGRectMake(cardNumLeftLB.right + 5, cardNumLeftLB.top, cardNumView.width - 2 * LEFT_SPACE - cardNumLeftLB.width - 5, cardNumLeftLB.height)];
    _cardNumLB.textColor = [UIColor colorWithWhite:0.2 alpha:1];
    [cardNumView addSubview:_cardNumLB];
    
    UIView * cardImageView = [[UIView alloc] initWithFrame:CGRectMake(0, cardNumView.bottom + 1, self.view.width, 50)];
    cardImageView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:cardImageView];
    
    UILabel * cardImageLB = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE, 75, 30)];
    cardImageLB.text = @"证件照:";
    cardImageLB.textAlignment = NSTextAlignmentRight;
    [cardImageView addSubview:cardImageLB];
    
    self.cardImageView = [[UIImageView alloc] initWithFrame:CGRectMake(cardImageLB.right + 5, cardImageLB.top, cardImageView.width - 2 * LEFT_SPACE - cardImageLB.width - 5, 100)];
    [cardImageView addSubview:_cardImageView];
    cardImageView.height = _cardImageView.bottom + TOP_SPACE;
    
    UIView * reasonView = [[UIView alloc] initWithFrame:CGRectMake(0, cardImageView.bottom + 1, self.view.width, 50)];
    reasonView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:reasonView];
    
    UILabel * reasonLeftLB = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE, 75, 30)];
    reasonLeftLB.text = @"认证状态:";
    reasonLeftLB.textAlignment = NSTextAlignmentRight;
    [reasonView addSubview:reasonLeftLB];
    
    self.reasonLB = [[UILabel alloc] initWithFrame:CGRectMake(reasonLeftLB.right + 5, reasonLeftLB.top, reasonView.width - 2 * LEFT_SPACE - reasonLeftLB.width - 5, 50)];
    _reasonLB.textColor = [UIColor redColor];
    _reasonLB.numberOfLines = 0;
    [reasonView addSubview:_reasonLB];
    
    reasonView.height = _reasonLB.bottom + TOP_SPACE;
    
    self.againBT = [UIButton buttonWithType:UIButtonTypeCustom];
    _againBT.frame = CGRectMake(LEFT_SPACE, reasonView.bottom + 20, self.view.width - 2 * LEFT_SPACE, 35);
    _againBT.backgroundColor = [UIColor colorWithRed:249 / 255.0 green:72 / 255.0 blue:47 / 255.0 alpha:1];
    _againBT.layer.cornerRadius = 4;
    [_againBT setTitle:@"重新认证" forState:UIControlStateNormal];
    [_againBT addTarget:self action:@selector(recertification:) forControlEvents:UIControlEventTouchUpInside];
    _againBT.hidden = YES;
    [self.view addSubview:_againBT];
    
    
    
    NSDictionary * jsonDic = @{
                               @"Command":@44,
                               @"UserId":[UserInfo shareUserInfo].userId
                               };
    [self playPostWithDictionary:jsonDic];
    
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backLastVC:)];
    
    
    // Do any additional setup after loading the view.
}

- (void)backLastVC:(id)sender
{
    LoginViewController * loginVC = (LoginViewController *)[self.navigationController.viewControllers firstObject];
    [loginVC pushTabBarVC];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)recertification:(UIButton *)button
{
    AuthFillViewController * authFillVC = [[AuthFillViewController alloc] init];
    authFillVC.userId = [UserInfo shareUserInfo].userId;
    [self.navigationController pushViewController:authFillVC animated:YES];
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
        if ([command isEqualToNumber:@10044]) {
            self.nameLB.text = [data objectForKey:@"AuthName"];
            self.cardNumLB.text = [data objectForKey:@"AuthIdCardNum"];
            [self.cardImageView sd_setImageWithURL:[NSURL URLWithString:[data objectForKey:@"AuthIdCard"]]];
            NSNumber * authState = [data objectForKey:@"HaveAuth"];
            _againBT.hidden = YES;
            switch (authState.intValue) {
                case 1:
                {
                    self.reasonLB.text = @"已通过";
                }
                    break;
                case 3:
                {
                    self.reasonLB.text = @"待审核";
                }
                    break;
                case 4:
                {
                    _againBT.hidden = NO;
                    self.reasonLB.text = [NSString stringWithFormat:@"未通过\n%@", [data objectForKey:@"ErrorMessage"]];
                    [_reasonLB sizeToFit];
                    UIView * view = _reasonLB.superview;
                    view.height = _reasonLB.bottom + TOP_SPACE;
                    _againBT.top = view.bottom + 20;
                }
                    break;
                    
                default:
                    break;
            }
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
    UIAlertView * alertV = [[UIAlertView alloc] initWithTitle:nil message:@"连接服务器失败" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [alertV show];
    [alertV performSelector:@selector(dismiss) withObject:nil afterDelay:1.5];
    NSLog(@"error = %@", error);
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
