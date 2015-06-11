//
//  LoginViewController.h
//  TinyOrder
//
//  Created by 仙林 on 15/4/14.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyTabBarController;
@interface LoginViewController : UIViewController

@property (nonatomic, strong)MyTabBarController * myTabBarC;
- (void)login;

@end
