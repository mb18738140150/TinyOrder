//
//  Protocol ViewController.m
//  TinyOrder
//
//  Created by 仙林 on 15/8/17.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "ProtocolViewController.h"

@interface ProtocolViewController ()

@end

@implementation ProtocolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIScrollView * scrollV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - self.navigationController.navigationBar.bottom)];
//    scrollV.backgroundColor = [UIColor greenColor];
    [self.view addSubview:scrollV];
    
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 220, 30)];
    titleLabel.centerX = scrollV.width / 2;
    titleLabel.text = @"《微生活注册服务协议》";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:20];
    [scrollV addSubview:titleLabel];
    
    NSError * error = nil;
    NSString * filePath=[[NSBundle mainBundle] pathForResource:@"protocol"ofType:@"txt"];
    NSString * protocolStr = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
    if (protocolStr == nil) {
        NSLog(@"Error reading text file. %@", error);
    }
//    NSLog(@"%@", protocolStr);
    
    UILabel * protocolLB = [[UILabel alloc] initWithFrame:CGRectMake(10, titleLabel.bottom + 10, self.view.width - 20, 100)];
    protocolLB.numberOfLines = 0;
    protocolLB.text = protocolStr;
//    protocolLB.backgroundColor = [UIColor magentaColor];
    [scrollV addSubview:protocolLB];
    [protocolLB sizeToFit];
    scrollV.contentSize = CGSizeMake(scrollV.width, protocolLB.bottom + 20);
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
