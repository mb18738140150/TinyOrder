//
//  VerifyOrderViewController.m
//  TinyOrder
//
//  Created by 仙林 on 16/1/6.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "VerifyOrderViewController.h"
#import "QRCodeScanViewController.h"
@interface VerifyOrderViewController ()

@property (nonatomic, strong)UILabel * resultLabel;
@property (nonatomic, strong)UIButton * scanButton;




@end

@implementation VerifyOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"验证订单";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backLastVC:)];
    
    self.resultLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 30, self.view.width - 40, 50)];
    _resultLabel.adjustsFontSizeToFitWidth = YES;
    _resultLabel.numberOfLines = 0;
    _resultLabel.textColor = [UIColor blackColor];
    _resultLabel.backgroundColor = [UIColor grayColor];
    [self.view addSubview:_resultLabel];
    
    self.scanButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _scanButton.frame = CGRectMake(100, 100, 100, 50);
    [_scanButton setTitle:@"开始扫描" forState:UIControlStateNormal];
    [_scanButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    _scanButton.backgroundColor = [UIColor cyanColor];
    [_scanButton addTarget:self action:@selector(startScan:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_scanButton];
    
   
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
        verifyVC.resultLabel.text = str;
    }];
    [self.navigationController pushViewController:qrVC animated:YES];
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
