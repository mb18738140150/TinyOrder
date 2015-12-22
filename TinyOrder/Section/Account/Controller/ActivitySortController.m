//
//  ActivitySortController.m
//  TinyOrder
//
//  Created by 仙林 on 15/12/11.
//  Copyright © 2015年 仙林. All rights reserved.
//

#import "ActivitySortController.h"
#import "TypeViewController.h"
@interface ActivitySortController ()

@end

@implementation ActivitySortController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"选择活动类型";
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    
    UIButton * waimaiBT = [UIButton buttonWithType:UIButtonTypeCustom];
    waimaiBT.frame = CGRectMake(0, 50, 180, 150);
    
    [waimaiBT setTitle:@"外卖" forState:UIControlStateNormal];
    waimaiBT.titleLabel.font = [UIFont systemFontOfSize:30];
    waimaiBT.layer.cornerRadius = 15;
    waimaiBT.layer.backgroundColor = [UIColor colorWithRed:249 / 255.0 green:72 / 255.0 blue:47 / 255.0 alpha:1].CGColor;
    waimaiBT.centerX = self.view.centerX;
    waimaiBT.tag = 1000;
    [waimaiBT addTarget:self action:@selector(typeAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:waimaiBT];
    
    
    UIButton * tangshiBT = [UIButton buttonWithType:UIButtonTypeCustom];
    tangshiBT.frame = CGRectMake(0, 50 + waimaiBT.bottom, 180, 150);
    [tangshiBT setTitle:@"堂食" forState:UIControlStateNormal];
    tangshiBT.titleLabel.font = [UIFont systemFontOfSize:30];
    tangshiBT.layer.cornerRadius = 15;
    tangshiBT.layer.backgroundColor = [UIColor colorWithRed:249 / 255.0 green:72 / 255.0 blue:47 / 255.0 alpha:1].CGColor;
    tangshiBT.centerX = self.view.centerX;
    tangshiBT.tag = 2000;
    [tangshiBT addTarget:self action:@selector(typeAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:tangshiBT];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backLastVC:)];
    
    // Do any additional setup after loading the view.
}

- (void)typeAction:(UIButton *)button
{
    TypeViewController * typeVC = [[TypeViewController alloc]init];
    if (button.tag == 1000) {
        typeVC.fromeWaimaiOrTangshi = 1;
        typeVC.isHaveFirst = self.isWaimaiFirstCut;
    }else
    {
        typeVC.fromeWaimaiOrTangshi = 2;
        typeVC.isHaveFirst = self.isTangshiFirstCut;
    }
    [self.navigationController pushViewController:typeVC animated:YES];
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
