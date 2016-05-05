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
#import "RealNameAuthenticationViewcontroller.h"

#define SCX_OBJECT_STRING(str) ([[NSString stringWithFormat:@"%@", (str) ? (str) : @""] isEqualToString:@"<null>"] ? @"" : [NSString stringWithFormat:@"%@", (str) ? (str) : @""])
#define LEFT_SPACE 10
#define TOP_SPACE 10

@interface AuthResultViewController ()<HTTPPostDelegate>


@property (nonatomic, strong)UILabel * nameLB;

@property (nonatomic, strong)UILabel * cardNumLB;

@property (nonatomic, strong)UIImageView * cardImageView;
@property (nonatomic, strong)UIImageView * businessImageView;
@property (nonatomic, strong)UIImageView * diningImageView;

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
    
    UILabel * cardImageLB = [[UILabel alloc] initWithFrame:CGRectMake(0, TOP_SPACE, self.view.width / 3, 30)];
    cardImageLB.text = @"证件照";
    cardImageLB.textAlignment = NSTextAlignmentCenter;
    [cardImageView addSubview:cardImageLB];
    
    self.cardImageView = [[UIImageView alloc] initWithFrame:CGRectMake(cardImageLB.left + 10, cardImageLB.bottom + TOP_SPACE, cardImageLB.width - 20, 80)];
    [cardImageView addSubview:_cardImageView];
    cardImageView.height = _cardImageView.bottom + TOP_SPACE;
    
    UILabel * businessImageLB = [[UILabel alloc] initWithFrame:CGRectMake(cardImageLB.right, TOP_SPACE, self.view.width / 3, 30)];
    businessImageLB.text = @"营业执照";
    businessImageLB.textAlignment = NSTextAlignmentCenter;
    [cardImageView addSubview:businessImageLB];
    
    self.businessImageView = [[UIImageView alloc] initWithFrame:CGRectMake(businessImageLB.left + 10, businessImageLB.bottom + TOP_SPACE, businessImageLB.width - 20, 80)];
    [cardImageView addSubview:_businessImageView];
    
    UILabel * diningImageLB = [[UILabel alloc] initWithFrame:CGRectMake(businessImageLB.right, TOP_SPACE, self.view.width / 3, 30)];
    diningImageLB.text = @"餐饮服务许可证";
    diningImageLB.textAlignment = NSTextAlignmentCenter;
    [cardImageView addSubview:diningImageLB];
    
    self.diningImageView = [[UIImageView alloc] initWithFrame:CGRectMake(diningImageLB.left + 10, diningImageLB.bottom + TOP_SPACE, diningImageLB.width - 20, 80)];
    [cardImageView addSubview:_diningImageView];
    
    
    UIView * reasonView = [[UIView alloc] initWithFrame:CGRectMake(0, cardImageView.bottom + 1, self.view.width, 50)];
    reasonView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:reasonView];
    
    UILabel * reasonLeftLB = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE, 75, 30)];
    reasonLeftLB.text = @"认证状态:";
    reasonLeftLB.textAlignment = NSTextAlignmentRight;
    [reasonView addSubview:reasonLeftLB];
    
    self.reasonLB = [[UILabel alloc] initWithFrame:CGRectMake(reasonLeftLB.right + 5, reasonLeftLB.top, reasonView.width - 2 * LEFT_SPACE - reasonLeftLB.width - 5, 30)];
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
                               @"Command":@82,
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
    RealNameAuthenticationViewcontroller * authFillVC = [[RealNameAuthenticationViewcontroller alloc] init];
    authFillVC.isfrom = 2;
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
        if ([command isEqualToNumber:@10082]) {
            self.nameLB.text = [data objectForKey:@"RealName"];
            self.cardNumLB.text = [data objectForKey:@"Idcardnumber"];
            NSString * idiconstr = [data objectForKey:@"IdIcon"];
            idiconstr = [idiconstr stringByAppendingString:@".220220.png"];
            
            NSString * businessiconstr = [data objectForKey:@"BusinessLicenseIcon"];
            businessiconstr = [businessiconstr stringByAppendingString:@".220220.png"];
            
            NSString * diningiconstr = [data objectForKey:@"DiningLicenseIcon"];
            diningiconstr = [diningiconstr stringByAppendingString:@".220220.png"];
            
            __weak AuthResultViewController * realVC = self;
            [self.cardImageView sd_setImageWithURL:[NSURL URLWithString:idiconstr] placeholderImage:[UIImage imageNamed:@"icon_ren_zheng.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if (image) {
                    realVC.cardImageView.image = image;
                }
            }];
            [self.businessImageView sd_setImageWithURL:[NSURL URLWithString:businessiconstr] placeholderImage:[UIImage imageNamed:@"icon_ren_zheng.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if (image) {
                    realVC.businessImageView.image = image;
                }
            }];
            [self.diningImageView sd_setImageWithURL:[NSURL URLWithString:diningiconstr] placeholderImage:[UIImage imageNamed:@"icon_ren_zheng.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if (image) {
                    realVC.diningImageView.image = image;
                }
            }];
           
            
            NSString * str = SCX_OBJECT_STRING([data objectForKey:@"Reason"]);
            
            //    str = @"水库方便的是放假吧是放假吧司法局欧版我覅你我；二佛吧是；欧in俄方我；新服务；偶记；偶尔玩我人家闺女弗兰克历史上的回复你绿豆沙都是看你发来；按分尸快递了的可能给福利卡控件的不舒服看了收入可能看世界杯年付款了如何呢";
            self.reasonLB.text = str;
            switch (((NSNumber *)[data objectForKey:@"RealNameCertificationState"]).intValue) {
                case 0:
                    self.reasonLB.text = @"未认证";
                    break;
                case 1:
                    self.reasonLB.text = @"认证中";
                    break;
                case 2:
                    self.reasonLB.text = @"已认证";
                    break;
                case 3:
                    if (str.length == 0) {
                        self.reasonLB.text = @"认证失败";
                    }else
                    {
                        self.reasonLB.text = [NSString stringWithFormat:@"认证失败:%@", str];
                    }
                    self.againBT.hidden = NO;
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
//    if (error.code == -1009) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"友情提示" message:@"网络不给力,请检查网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alert show];
//    }else
//    {
        UIAlertView * alerV = [[UIAlertView alloc] initWithTitle:@"提示" message:@"连接服务器失败请重新连接" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alerV show];
//    }
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
