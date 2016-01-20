//
//  TodaySalesController.m
//  TinyOrder
//
//  Created by 仙林 on 16/1/18.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "TodaySalesController.h"

@implementation TodaySalesController
- (void)viewDidLoad
{
    self.navigationItem.title = @"今日销售额";
    
    self.view.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backLastVC:)];
}

- (void)backLastVC:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
