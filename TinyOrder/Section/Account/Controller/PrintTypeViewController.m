//
//  PrintTypeViewController.m
//  TinyOrder
//
//  Created by 仙林 on 15/9/9.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "PrintTypeViewController.h"
#import "PrintTestViewController.h"
#import "GPRSPrintViewController.h"
#import "NewOrderModel.h"

@interface PrintTypeViewController ()

@property (nonatomic, strong)PrintTestViewController *printVC;
@property (nonatomic, strong)GPRSPrintViewController *gprsVC;

@end

@implementation PrintTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"选择打印类型";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIScrollView * myscroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - self.navigationController.navigationBar.height)];
    myscroll.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:myscroll];
    
    UIButton * shoujianBT = [UIButton buttonWithType:UIButtonTypeCustom];
    [shoujianBT setTitle:@"蓝牙打印" forState:UIControlStateNormal];
    shoujianBT.titleLabel.font = [UIFont systemFontOfSize:30];
    shoujianBT.layer.cornerRadius = 15;
    shoujianBT.layer.backgroundColor = [UIColor colorWithRed:249 / 255.0 green:72 / 255.0 blue:47 / 255.0 alpha:1].CGColor;
    [shoujianBT addTarget:self action:@selector(bluetoothPrintAction:) forControlEvents:UIControlEventTouchUpInside];
    [myscroll addSubview:shoujianBT];
    
    UIButton * manjianBT = [UIButton buttonWithType:UIButtonTypeCustom];
    [manjianBT setTitle:@"GPRS打印" forState:UIControlStateNormal];
    manjianBT.titleLabel.font = [UIFont systemFontOfSize:30];
    manjianBT.layer.cornerRadius = 15;
    manjianBT.layer.backgroundColor = [UIColor colorWithRed:249 / 255.0 green:72 / 255.0 blue:47 / 255.0 alpha:1].CGColor;
    [manjianBT addTarget:self action:@selector(GPRSPrintAction:) forControlEvents:UIControlEventTouchUpInside];
    [myscroll addSubview:manjianBT];
    
    UIButton * gugujiBT = [UIButton buttonWithType:UIButtonTypeCustom];
    [gugujiBT setTitle:@"咕咕机打印" forState:UIControlStateNormal];
    gugujiBT.titleLabel.font = [UIFont systemFontOfSize:30];
    gugujiBT.layer.cornerRadius = 15;
    gugujiBT.layer.backgroundColor = [UIColor colorWithRed:249 / 255.0 green:72 / 255.0 blue:47 / 255.0 alpha:1].CGColor;
    [gugujiBT addTarget:self action:@selector(gugujiAction:) forControlEvents:UIControlEventTouchUpInside];
    [myscroll addSubview:gugujiBT];
    
    UIButton * mstchingBT = [UIButton buttonWithType:UIButtonTypeCustom];
    [mstchingBT setTitle:@"对对机打印" forState:UIControlStateNormal];
    mstchingBT.titleLabel.font = [UIFont systemFontOfSize:30];
    mstchingBT.layer.cornerRadius = 15;
    mstchingBT.layer.backgroundColor = [UIColor colorWithRed:249 / 255.0 green:72 / 255.0 blue:47 / 255.0 alpha:1].CGColor;
    [mstchingBT addTarget:self action:@selector(mstchingAction:) forControlEvents:UIControlEventTouchUpInside];
    [myscroll addSubview:mstchingBT];
    
//    if (self.fromWitchController == 1) {
        shoujianBT.frame = CGRectMake(0, 20, 180, 100);
        shoujianBT.centerX = myscroll.centerX;
        manjianBT.frame = CGRectMake(0, 20 + shoujianBT.bottom, 180, 100);
        manjianBT.centerX = myscroll.centerX;
    gugujiBT.frame = CGRectMake(0, 20 + manjianBT.bottom, 180, 100);
    gugujiBT.centerX = myscroll.centerX;
    mstchingBT.frame = CGRectMake(0, 20 + gugujiBT.bottom, 180, 100);
    mstchingBT.centerX = myscroll.centerX;
//    }else if (self.fromWitchController == 2)
//    {
//        shoujianBT.frame = CGRectMake(0, self.navigationController.navigationBar.bottom + 50, 180, 150);
//        shoujianBT.centerX = self.view.centerX;
//        manjianBT.frame = CGRectMake(0, 50 + shoujianBT.bottom, 180, 150);
//        manjianBT.centerX = self.view.centerX;
//    }
    
    self.printVC = [[PrintTestViewController alloc] init];
    
    
    UILabel * tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, mstchingBT.bottom + 10, self.view.frame.size.width - 40, 60)];
    tipLabel.text = @"温馨提示:如果您没有打印机,请到蓝牙打印机设置页面设定打印份数为0,并点击右上角启用,即可处理订单";
    tipLabel.textColor = [UIColor colorWithRed:249 / 255.0 green:72 / 255.0 blue:47 / 255.0 alpha:1];
    tipLabel.font = [UIFont systemFontOfSize:14];
    tipLabel.numberOfLines = 0;
    [myscroll addSubview:tipLabel];
    
    myscroll.contentSize = CGSizeMake(myscroll.width, tipLabel.bottom + 20);
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backLastVC:)];
    
//    self.printVC = [[PrintTestViewController alloc] init];
    
    // Do any additional setup after loading the view.
}

- (void)backLastVC:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)bluetoothPrintAction:(UIButton *)button
{
    _printVC.nOrderModel = self.nOrderModel;
    [self.navigationController pushViewController:_printVC animated:YES];
    NSLog(@"填写转到*******");
}


- (void)GPRSPrintAction:(UIButton *)button
{
    self.gprsVC = [[GPRSPrintViewController alloc] init];
    _gprsVC.nOrderModel = self.nOrderModel;
    _gprsVC.onlineprintType = GPRSPrint;
    [self.navigationController pushViewController:_gprsVC animated:YES];
}

- (void)gugujiAction:(UIButton *)button
{
    self.gprsVC = [[GPRSPrintViewController alloc] init];
    _gprsVC.nOrderModel = self.nOrderModel;
    _gprsVC.onlineprintType = GugujiPrint;
    [self.navigationController pushViewController:_gprsVC animated:YES];
}
- (void)mstchingAction:(UIButton *)button
{
    self.gprsVC = [[GPRSPrintViewController alloc] init];
    _gprsVC.nOrderModel = self.nOrderModel;
    _gprsVC.onlineprintType = MstchingPrint;
    [self.navigationController pushViewController:_gprsVC animated:YES];
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
