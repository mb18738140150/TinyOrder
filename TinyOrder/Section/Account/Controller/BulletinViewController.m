//
//  BulletinViewController.m
//  TinyOrder
//
//  Created by 仙林 on 15/4/11.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "BulletinViewController.h"
#import "BulletinView.h"


@interface BulletinViewController ()<HTTPPostDelegate, UITextViewDelegate>

@property (nonatomic, strong)BulletinView * bulletinView;

@end

@implementation BulletinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.bulletinView = [[BulletinView alloc] initWithFrame:self.view.bounds];
    _bulletinView.tag = 1000;
    _bulletinView.bulletinTF.delegate = self;
    self.view = _bulletinView;
    
//    [self addObserver:self forKeyPath:@"self.bulletinView.bulletinTF" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:NULL];
    
    [self getBulletin];
    [SVProgressHUD showWithStatus:@"正在获取公告..." maskType:SVProgressHUDMaskTypeBlack];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backLastVC:)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStyleDone target:self action:@selector(submitBulletin:)];
    NSDictionary* selectedTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:16],
                                             NSForegroundColorAttributeName: [UIColor blackColor]};
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:selectedTextAttributes forState:UIControlStateNormal];
}

- (void)backLastVC:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)submitBulletin:(UIBarButtonItem *)button
{
    if (self.bulletinView.bulletinTF.text.length) {
        NSDictionary * jsonDic = @{
                                   @"UserId":[UserInfo shareUserInfo].userId,
                                   @"Command":@17,
                                   @"StrNotice":self.bulletinView.bulletinTF.text,
                                   @"NoticeSort":@(self.isFromeWaimaiOrTangshi)
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
                               @"Command":@19,
                               @"NoticeSort":@(self.isFromeWaimaiOrTangshi)
                               };
    [self playPostWithDictionary:jsonDic];
}

- (void)playPostWithDictionary:(NSDictionary *)jsonDic
{
    NSString * jsonStr = [jsonDic JSONString];
    NSString * str = [NSString stringWithFormat:@"%@231618", jsonStr];
    NSLog(@"%@", jsonDic);
    NSString * md5Str = [str md5];
    //    NSLog(@"////%@", md5Str);
    NSString * urlString = [NSString stringWithFormat:@"%@%@", POST_URL, md5Str];
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
            if (self.isFromeWaimaiOrTangshi == 0) {
                self.bulletinView.bulletinTF.text = [data objectForKey:@"StrNotice"];
            }else
            {
                self.bulletinView.bulletinTF.text = [data objectForKey:@"StrTangNotice"];
            }
            UITextView *textView = self.bulletinView.bulletinTF;
            CGSize size = [textView sizeThatFits:CGSizeMake(CGRectGetWidth(textView.frame), MAXFLOAT)];
            CGRect frame = textView.frame;
            frame.size.height = size.height;
            textView.frame = frame;
            
            _bulletinView.line.frame = CGRectMake(20, textView.bottom + 15, _bulletinView.width - 2 * 20, 1);
            
            [SVProgressHUD dismiss];
        }else if (command == 10017)
        {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"公告修改成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alertView show];
            [alertView performSelector:@selector(dismiss) withObject:nil afterDelay:1.5];
//            [self getBulletin];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else
    {
        [SVProgressHUD dismiss];
        if (command == 10017) {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:[data objectForKey:@"ErrorMsg"] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
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

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    
    CGSize size = [textView sizeThatFits:CGSizeMake(CGRectGetWidth(textView.frame), MAXFLOAT)];
    CGRect frame = textView.frame;
    frame.size.height = size.height;
    textView.frame = frame;
    
    _bulletinView.line.frame = CGRectMake(20, textView.bottom + 15, _bulletinView.width - 2 * 20, 1);
    
    return YES;
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
