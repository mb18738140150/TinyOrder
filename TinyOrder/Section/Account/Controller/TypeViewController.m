//
//  TypeViewController.m
//  TinyOrder
//
//  Created by 仙林 on 15/7/20.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "TypeViewController.h"
#import "FirstCutViewController.h"
#import "FullCutViewController.h"

@interface TypeViewController ()

@end

@implementation TypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"选择活动类型";
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    
    UIButton * shoujianBT = [UIButton buttonWithType:UIButtonTypeCustom];
    shoujianBT.frame = CGRectMake(0, 50, 180, 150);
    [shoujianBT setTitle:@"首单立减" forState:UIControlStateNormal];
    shoujianBT.titleLabel.font = [UIFont systemFontOfSize:30];
    shoujianBT.layer.cornerRadius = 15;
    shoujianBT.layer.backgroundColor = [UIColor orangeColor].CGColor;
    shoujianBT.centerX = self.view.centerX;
    [shoujianBT addTarget:self action:@selector(firstCutAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shoujianBT];
    
    
    UIButton * manjianBT = [UIButton buttonWithType:UIButtonTypeCustom];
    manjianBT.frame = CGRectMake(0, 50 + shoujianBT.bottom, 180, 150);
    [manjianBT setTitle:@"满减" forState:UIControlStateNormal];
    manjianBT.titleLabel.font = [UIFont systemFontOfSize:30];
    manjianBT.layer.cornerRadius = 15;
    manjianBT.layer.backgroundColor = [UIColor orangeColor].CGColor;
    manjianBT.centerX = self.view.centerX;
    [manjianBT addTarget:self action:@selector(fullCutAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:manjianBT];
    
    
    if (_isHaveFirst) {
        shoujianBT.hidden = YES;
        manjianBT.centerY = (self.view.height - self.navigationController.navigationBar.bottom) / 2;
    }
    
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backLastVC:)];
    
    
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


- (void)firstCutAction:(UIButton *)button
{
    FirstCutViewController * firstCutVC = [[FirstCutViewController alloc] init];
    [self.navigationController pushViewController:firstCutVC animated:YES];
}


- (void)fullCutAction:(UIButton *)button
{
    FullCutViewController * fullCutVC = [[FullCutViewController alloc] init];
    [self.navigationController pushViewController:fullCutVC animated:YES];
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
