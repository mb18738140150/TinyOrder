//
//  BulletinViewController.m
//  TinyOrder
//
//  Created by 仙林 on 15/4/11.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "BulletinViewController.h"
#import "BulletinView.h"


@interface BulletinViewController ()<HTTPPostDelegate>

@property (nonatomic, strong)BulletinView * bulletinView;

@end

@implementation BulletinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.bulletinView = [[BulletinView alloc] initWithFrame:self.view.bounds];
    _bulletinView.tag = 1000;
    self.view = _bulletinView;
    [_bulletinView.submitButton addTarget:self action:@selector(submitBulletin:) forControlEvents:UIControlEventTouchUpInside];
    [self getBulletin];
    [SVProgressHUD showWithStatus:@"正在获取公告..." maskType:SVProgressHUDMaskTypeBlack];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)submitBulletin:(UIButton *)button
{
    if (self.bulletinView.bulletinTF.text.length) {
        NSDictionary * jsonDic = @{
                                   @"UserId":[UserInfo shareUserInfo].userId,
                                   @"Command":@17,
                                   @"StrNotice":self.bulletinView.bulletinTF.text
                                   };
        [self playPostWithDictionary:jsonDic];
        [SVProgressHUD showWithStatus:@"正在修改公告..." maskType:SVProgressHUDMaskTypeBlack];
    }else
    {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"公告不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
   
}

- (void)getBulletin
{
    NSDictionary * jsonDic = @{
                               @"UserId":[UserInfo shareUserInfo].userId,
                               @"Command":@19
                               };
    [self playPostWithDictionary:jsonDic];
}

- (void)playPostWithDictionary:(NSDictionary *)jsonDic
{
    NSString * jsonStr = [jsonDic JSONString];
    NSString * str = [NSString stringWithFormat:@"%@231618", jsonStr];
    NSString * md5Str = [str md5];
    //    NSLog(@"////%@", md5Str);
    NSString * urlString = [NSString stringWithFormat:@"http://p.vlifee.com/getdata.ashx?md5=%@",md5Str];
    HTTPPost * httpPost = [HTTPPost shareHTTPPost];
    [httpPost post:urlString HTTPBody:[jsonStr dataUsingEncoding:NSUTF8StringEncoding]];
    httpPost.delegate = self;
}

- (void)refresh:(id)data
{
    NSLog(@"%@", data);
    int command = [[data objectForKey:@"Command"] intValue];
    if ([[data objectForKey:@"Result"] isEqual:@1]) {
        if (command == 10019) {
            self.bulletinView.bulletinTF.text = [data objectForKey:@"StrNotice"];
            [SVProgressHUD dismiss];
        }else if (command == 10017)
        {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"公告修改成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alertView show];
            [alertView performSelector:@selector(dismiss) withObject:nil afterDelay:1.5];
            [self getBulletin];
        }
    }else
    {
        [SVProgressHUD dismiss];
        if (command == 10017) {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"公告修改失败" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alertView show];
            [alertView performSelector:@selector(dismiss) withObject:nil afterDelay:1.5];
        }
    }

}

- (void)failWithError:(NSError *)error
{
    [SVProgressHUD dismiss];
    NSLog(@"%@", error);
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
