//
//  BulletinTypeViewController.m
//  TinyOrder
//
//  Created by 仙林 on 16/1/5.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "BulletinTypeViewController.h"
#import "BulletinViewController.h"

@interface BulletinTypeViewController ()<HTTPPostDelegate>

@property (nonatomic, strong)UIView * waimaiView;
@property (nonatomic, strong)UILabel * waimaiLabel;
@property (nonatomic, strong)UIButton * waimaiButton;
@property (nonatomic, strong)UIView *tangshiView;
@property (nonatomic, strong)UILabel * tangshiLabel;
@property (nonatomic, strong)UIButton * tangshiButton;

@end

@implementation BulletinTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"公告";
    self.view.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    
    self.waimaiView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, self.view.width, 101)];
    _waimaiView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_waimaiView];
    
    UILabel * waimaiLB = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 100, 30)];
    waimaiLB.text = @"外卖公告";
    [_waimaiView addSubview:waimaiLB];
    
    self.waimaiButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _waimaiButton.frame = CGRectMake(_waimaiView.width - 60, 5, 40, 40);
    [_waimaiButton setImage:[[UIImage imageNamed:@"arrowright.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    _waimaiButton.backgroundColor = [UIColor clearColor];
    [_waimaiButton addTarget:self action:@selector(bulletinAction:) forControlEvents:UIControlEventTouchUpInside];
    [_waimaiView addSubview:_waimaiButton];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 50, _waimaiView.width, 1)];
    line.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    [_waimaiView addSubview:line];
    
    self.waimaiLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, line.bottom, _waimaiView.width, 50)];
    _waimaiLabel.numberOfLines = 0;
    [_waimaiView addSubview:_waimaiLabel];
    
    
    self.tangshiView = [[UIView alloc]initWithFrame:CGRectMake(0, 20 + _waimaiView.bottom, self.view.width, 101)];
    _tangshiView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_tangshiView];
    
    UILabel * tangshiLB = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 100, 30)];
    tangshiLB.text = @"堂食公告";
    [_tangshiView addSubview:tangshiLB];
    
    self.tangshiButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _tangshiButton.frame = CGRectMake(_tangshiView.width - 60, 5, 40, 40);
    [_tangshiButton setImage:[[UIImage imageNamed:@"arrowright.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    _tangshiButton.backgroundColor = [UIColor clearColor];
    [_tangshiButton addTarget:self action:@selector(bulletinAction:) forControlEvents:UIControlEventTouchUpInside];
    [_tangshiView addSubview:_tangshiButton];
    
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 50, _tangshiView.width, 1)];
    line1.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    [_tangshiView addSubview:line1];
    
    self.tangshiLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, line1.bottom, _tangshiView.width, 50)];
    _tangshiLabel.numberOfLines = 0;
    [_tangshiView addSubview:_tangshiLabel];
    
    
    NSDictionary * jsonDic = @{
                               @"UserId":[UserInfo shareUserInfo].userId,
                               @"Command":@19,
                               };
    [self playPostWithDictionary:jsonDic];
    
    
    
    
    UIButton * waimaiBT = [UIButton buttonWithType:UIButtonTypeCustom];
    waimaiBT.frame = CGRectMake(0, 50, 180, 150);
    
    [waimaiBT setTitle:@"外卖" forState:UIControlStateNormal];
    waimaiBT.titleLabel.font = [UIFont systemFontOfSize:30];
    waimaiBT.layer.cornerRadius = 15;
    waimaiBT.layer.backgroundColor = [UIColor colorWithRed:249 / 255.0 green:72 / 255.0 blue:47 / 255.0 alpha:1].CGColor;
    waimaiBT.centerX = self.view.centerX;
    waimaiBT.tag = 1000;
    [waimaiBT addTarget:self action:@selector(typeAction:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:waimaiBT];
    
    
    UIButton * tangshiBT = [UIButton buttonWithType:UIButtonTypeCustom];
    tangshiBT.frame = CGRectMake(0, 50 + waimaiBT.bottom, 180, 150);
    [tangshiBT setTitle:@"堂食" forState:UIControlStateNormal];
    tangshiBT.titleLabel.font = [UIFont systemFontOfSize:30];
    tangshiBT.layer.cornerRadius = 15;
    tangshiBT.layer.backgroundColor = [UIColor colorWithRed:249 / 255.0 green:72 / 255.0 blue:47 / 255.0 alpha:1].CGColor;
    tangshiBT.centerX = self.view.centerX;
    tangshiBT.tag = 2000;
    [tangshiBT addTarget:self action:@selector(typeAction:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:tangshiBT];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backLastVC:)];
    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    NSDictionary * jsonDic = @{
                               @"UserId":[UserInfo shareUserInfo].userId,
                               @"Command":@19,
                               };
    [self playPostWithDictionary:jsonDic];
}

- (void)bulletinAction:(UIButton * )button
{
    BulletinViewController * typeVC = [[BulletinViewController alloc]init];
    if ([button isEqual:_waimaiButton]) {
        typeVC.isFromeWaimaiOrTangshi = 0;
    }else
    {
        typeVC.isFromeWaimaiOrTangshi = 1;
    }
    [self.navigationController pushViewController:typeVC animated:YES];

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
            self.waimaiLabel.text = [data objectForKey:@"StrNotice"];
            self.tangshiLabel.text = [data objectForKey:@"StrTangNotice"];
            
            [self creat];
            
            
            [SVProgressHUD dismiss];
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
- (void)creat
{
    NSString * waimaistr = self.waimaiLabel.text;
    
    NSString * tangshi  = self.tangshiLabel.text;
    
    CGSize maxSize = CGSizeMake(_waimaiView.width, 1000);
    CGRect waimaitextRect = [waimaistr boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil];
    
    int  height = waimaitextRect.size.height;
    _waimaiView.frame = CGRectMake(0, 20, self.view.width, 101 - 50 + height + 20);
    _waimaiLabel.frame = CGRectMake(10, _waimaiLabel.top, _waimaiView.width, height + 20);
    
    CGRect tangshitextRect = [tangshi boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil];
    
    int tangshiheight = tangshitextRect.size.height;
    _tangshiView.frame = CGRectMake(0, 20 + _waimaiView.bottom, self.view.width, 101 - 50 + tangshiheight + 20);
    _tangshiLabel.frame = CGRectMake(10, _tangshiLabel.top, _waimaiView.width, tangshiheight + 20);
    
    
}

- (void)backLastVC:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
