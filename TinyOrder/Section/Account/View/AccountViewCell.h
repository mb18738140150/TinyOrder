//
//  AccountViewCell.h
//  TinyOrder
//
//  Created by 仙林 on 15/4/9.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AccountModel;
@interface AccountViewCell : UITableViewCell


@property (nonatomic, strong)AccountModel * accountModel;
@property (nonatomic, strong)UISwitch * isBusinessSW;
- (void)createSubView:(CGRect)frame;
- (void)createSUbViewAndSwith:(CGRect)frame;
@end
