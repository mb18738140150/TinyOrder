//
//  VerifyOrderViewController.m
//  TinyOrder
//
//  Created by 仙林 on 16/1/6.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "VerifyOrderViewController.h"
#import "QRCodeScanViewController.h"
@interface VerifyOrderViewController ()<HTTPPostDelegate>

@property (nonatomic, strong)UILabel * resultLabel;
@property (nonatomic, strong)UIButton * scanButton;

@property (nonatomic, strong)UITextField *verifyTF;


@end

@implementation VerifyOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"验证";
    
    self.view.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backLastVC:)];
    
    UIView * scanView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, self.view.width, 80)];
    scanView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:scanView];
    
    UIImageView *scanImage = [[UIImageView alloc]initWithFrame:CGRectMake(20, 10, 60, 60)];
    scanImage.image = [UIImage imageNamed:@"scan_code_icon.png"];
    scanImage.layer.cornerRadius = 30;
    scanImage.layer.masksToBounds = YES;
    scanImage.backgroundColor = [UIColor grayColor];
    [scanView addSubview:scanImage];
    
    UILabel * scanLabel = [[UILabel alloc]initWithFrame:CGRectMake(scanImage.right + 20, 20, self.view.width / 2, 25)];
    scanLabel.text = @"扫一扫";
    scanLabel.textColor = [UIColor blackColor];
    [scanView addSubview:scanLabel];
    
    UILabel * scaLB = [[UILabel alloc]initWithFrame:CGRectMake(scanLabel.left, scanLabel.bottom, scanLabel.width, 15)];
    scaLB.textColor = [UIColor grayColor];
    scaLB.text = @"使用扫一扫付款，方便，快捷";
//    scaLB.font = [UIFont systemFontOfSize:13];
    scaLB.adjustsFontSizeToFitWidth = YES;
    [scanView addSubview:scaLB];
    
    UIButton * buttoin = [UIButton buttonWithType:UIButtonTypeSystem];
    [buttoin setImage:[[UIImage imageNamed:@"arrowright.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    buttoin.frame = CGRectMake(scanView.right - 60, 20, 40, 40);
    [buttoin addTarget:self action:@selector(startScan:) forControlEvents:UIControlEventTouchUpInside];
    [scanView addSubview:buttoin];
    
    UIView * verificationView = [[UIView alloc]initWithFrame:CGRectMake(0, scanView.bottom + 20, self.view.width, 50)];
    verificationView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:verificationView];
    
    UILabel * verifyLAbel = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, 80, 30)];
    verifyLAbel.text = @"验证码:";
    verifyLAbel.textColor = [UIColor blackColor];
    [verificationView addSubview:verifyLAbel];
    
    self.verifyTF = [[UITextField alloc]initWithFrame:CGRectMake(verifyLAbel.right, verifyLAbel.top, self.view.width - 40 - verifyLAbel.width, 30)];
    _verifyTF.placeholder = @"请输入验证码";
    _verifyTF.borderStyle = UITextBorderStyleNone;
    _verifyTF.keyboardType = UIKeyboardTypeNumberPad;
    _verifyTF.adjustsFontSizeToFitWidth = YES;
    [verificationView addSubview:_verifyTF];
    
    
    UIButton * verifyBT = [UIButton buttonWithType:UIButtonTypeSystem];
    verifyBT.frame = CGRectMake(40, verificationView.bottom + 60, self.view.width - 80, 50) ;
    [verifyBT setTitleColor:[UIColor colorWithRed:247 /255.0 green:102 / 255.0 blue:69 / 255.0 alpha:1.0] forState:UIControlStateNormal];
    [verifyBT setTitle:@"验证" forState:UIControlStateNormal];
    verifyBT.backgroundColor = [UIColor whiteColor];
    verifyBT.layer.cornerRadius = 5;
    verifyBT.layer.masksToBounds = YES;
    verifyBT.layer.borderWidth = 1;
    verifyBT.layer.borderColor = [UIColor colorWithRed:247 /255.0 green:102 / 255.0 blue:69 / 255.0 alpha:1.0].CGColor;
    [verifyBT addTarget:self action:@selector(verifyAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:verifyBT];
    
    
   
    // Do any additional setup after loading the view.
}

- (void)backLastVC:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)startScan:(UIButton *)button
{
    QRCodeScanViewController * qrVC = [[QRCodeScanViewController alloc]init];
    __weak VerifyOrderViewController * verifyVC = self;
    [qrVC returnData:^(NSString *str) {
        
//        verifyVC.verifyTF.text = str;
        NSDictionary * jsonDic = @{
                                   @"UserId":[UserInfo shareUserInfo].userId,
                                   @"Command":@72,
                                   @"AutoCode":str
                                   };
        [verifyVC playPostWithDictionary:jsonDic];
        
        
    }];
    [self.navigationController pushViewController:qrVC animated:YES];
}

- (void)verifyAction:(UIButton *)button
{
    if (self.verifyTF.text.length != 0) {
        NSDictionary * jsonDic = @{
                                   @"UserId":[UserInfo shareUserInfo].userId,
                                   @"Command":@72,
                                   @"AutoCode":self.verifyTF.text
                                   };
        [self playPostWithDictionary:jsonDic];
    }else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"验证码不能为空" delegate:self cancelButtonTitle:nil
                                              otherButtonTitles:@"确定", nil];
        [alert show];
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
        NSNumber * command = [data objectForKey:@"Command"];
        if ([command isEqualToNumber:@10072]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"验证成功" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1.0];
            [self.navigationController popViewControllerAnimated:YES];
        }
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
