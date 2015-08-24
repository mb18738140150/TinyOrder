//
//  SwithAccountViewCell.h
//  TinyOrder
//
//  Created by 仙林 on 15/7/28.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AccountModel;
@interface SwithAccountViewCell : UITableViewCell


@property (nonatomic, strong)AccountModel * accountModel;
@property (nonatomic, strong)UISwitch * isBusinessSW;
- (void)createSUbViewAndSwith:(CGRect)frame;


@end
