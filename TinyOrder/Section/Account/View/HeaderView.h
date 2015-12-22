//
//  HeaderView.h
//  TinyOrder
//
//  Created by 仙林 on 15/4/9.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeaderView : UIView

@property (nonatomic, strong)UIButton * informationButton;

@property (nonatomic, strong)UIImageView * icon;
@property (nonatomic, strong)UILabel * storeNameLable;
@property (nonatomic, strong)UILabel *storeStateLabel;
@property (nonatomic, strong)UILabel * phoneLabel;
@property (nonatomic, strong)UILabel *todayOrderNum;
@property (nonatomic, strong)UILabel *todayMoney;
@property (nonatomic, strong)UILabel *bankCardNum;

@end
