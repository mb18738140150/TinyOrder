//
//  RealNameAuthenticationViewcontroller.h
//  TinyOrder
//
//  Created by 仙林 on 16/4/11.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AccountModel;
@interface RealNameAuthenticationViewcontroller : UIViewController
@property (nonatomic, strong)AccountModel * model;
@property (nonatomic, assign)int isfrom;

@end
