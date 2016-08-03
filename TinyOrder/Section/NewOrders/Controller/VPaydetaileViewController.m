//
//  VPaydetaileViewController.m
//  TinyOrder
//
//  Created by 仙林 on 16/6/12.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "VPaydetaileViewController.h"

@interface VPaydetaileViewController ()<HTTPPostDelegate>
@property (strong, nonatomic) IBOutlet UILabel *orderIDLB;
@property (strong, nonatomic) IBOutlet UILabel *payTypeLB;
@property (strong, nonatomic) IBOutlet UILabel *monryLB;
@property (strong, nonatomic) IBOutlet UILabel *orderTimeLB;
@property (strong, nonatomic) IBOutlet UILabel *remarkLB;

@end

@implementation VPaydetaileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"订单详情";
    self.view.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backLastVC:)];
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSLog(@"%@", self.orderID);
    
    NSDictionary * jsonDic = @{
                               @"UserId":[UserInfo shareUserInfo].userId,
                               @"Command":@87,
                               @"OrderId":self.orderID
                               };
    [self playPostWithDictionary:jsonDic];
    
    [SVProgressHUD showWithStatus:@"正在加载..." maskType:SVProgressHUDMaskTypeBlack];
}
- (void)backLastVC:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- 数据请求
- (void)playPostWithDictionary:(NSDictionary *)dic
{
    NSString * jsonStr = [dic JSONString];
    NSLog(@"--%@", jsonStr);
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
        int command = [[data objectForKey:@"Command"] intValue];
        [self getDataWithDic:[data objectForKey:@"OrderDetail"]];
    }else
    {
        [SVProgressHUD dismiss];
        int command = [[data objectForKey:@"Command"] intValue];
        
    }
}

- (void)failWithError:(NSError *)error
{
    [SVProgressHUD dismiss];
    if ([[error.userInfo objectForKey:@"Reason"] isEqualToString:@"服务器处理失败"]) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"服务器处理失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil ];
        [alert show];
    }else
    {
        
        UIAlertView * alerV = [[UIAlertView alloc] initWithTitle:@"提示" message:@"连接服务器失败请重新连接" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alerV show];
    }
}
- (void)getDataWithDic:(NSDictionary *)dic
{
    self.orderIDLB.text = [NSString stringWithFormat:@"订单号：%@", [dic objectForKey:@"OrderSn"]];
    self.payTypeLB.text = [NSString stringWithFormat:@"支付方式：%@", [dic objectForKey:@"PayMethod"]];
    self.monryLB.text = [NSString stringWithFormat:@"支付金额：%@", [dic objectForKey:@"Money"]];
    self.orderTimeLB.text = [NSString stringWithFormat:@"支付时间：%@", [dic objectForKey:@"PayTime"]];
    
    NSString * str = [NSString stringWithFormat:@"备注：\n%@",[dic objectForKey:@"Remark"]];
    CGSize size = [str boundingRectWithSize:CGSizeMake(self.remarkLB.width,CGFLOAT_MAX ) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
    
    self.remarkLB.height = size.height;
    self.remarkLB.text = str;
    
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
