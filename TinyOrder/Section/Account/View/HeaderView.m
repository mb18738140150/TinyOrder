//
//  HeaderView.m
//  TinyOrder
//
//  Created by 仙林 on 15/4/9.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "HeaderView.h"
#import "UIViewAdditions.h"

#define ICON_WITH 80
#define SPACE  15
//#define VIEW_COLOR [UIColor orangeColor]
#define VIEW_COLOR [UIColor clearColor]
#define BUTTON_WIDTH 60

@interface HeaderView ()




@end

@implementation HeaderView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubView];
    }
    return self;
}


- (void)createSubView
{
    if (!_icon) {
        self.icon = [[UIImageView alloc] initWithFrame:CGRectMake(SPACE, SPACE, ICON_WITH, ICON_WITH)];
        _icon.backgroundColor = VIEW_COLOR;
        _icon.image = [UIImage imageNamed:@"userIcon.png"];
        [self addSubview:_icon];
        self.storeNameLable = [[UILabel alloc] initWithFrame:CGRectMake(_icon.right + SPACE, SPACE, (self.width - 4 * SPACE - BUTTON_WIDTH - _icon.width) / 2, _icon.height / 2)];
        _storeNameLable.backgroundColor = VIEW_COLOR;
        _storeNameLable.text = [UserInfo shareUserInfo].userName;
        [self addSubview:_storeNameLable];
        
        self.storeStateLabel = [[UILabel alloc]initWithFrame:CGRectMake(_storeNameLable.right, _storeNameLable.top, _storeNameLable.width, _storeNameLable.height)];
        _storeStateLabel.backgroundColor = VIEW_COLOR;
        _storeStateLabel.textColor = [UIColor orangeColor];
        [self addSubview:_storeStateLabel];
        
        self.phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(_storeNameLable.left, _storeNameLable.bottom, _storeNameLable.width * 2, _storeNameLable.height)];
//        _phoneLabel.text = [NSString stringWithFormat:@"%@", [UserInfo shareUserInfo].userId];
//        _phoneLabel.backgroundColor = [UIColor grayColor];
        [self addSubview:_phoneLabel];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(10, _icon.bottom + SPACE, self.width - 20, 1)];
        line.backgroundColor = [UIColor grayColor];
        line.alpha = .6;
        [self addSubview:line];
        
        self.todayOrderNum = [[UILabel alloc]initWithFrame:CGRectMake(SPACE, line.bottom + 10, (self.width - 4 * SPACE) / 3, 20)];
        _todayOrderNum.textAlignment = NSTextAlignmentCenter;
        self.todayMoney = [[UILabel alloc]initWithFrame:CGRectMake(_todayOrderNum.right + SPACE, _todayOrderNum.top, _todayOrderNum.width, _todayOrderNum.height)];
        _todayMoney.textAlignment = NSTextAlignmentCenter;
        self.bankCardNum = [[UILabel alloc]initWithFrame:CGRectMake(_todayMoney.right + SPACE, _todayMoney.top, _todayMoney.width, _todayMoney.height)];
        _bankCardNum.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_todayMoney];
        [self addSubview:_todayOrderNum];
        [self addSubview:_bankCardNum];
        
        UILabel *orderLB = [[UILabel alloc]initWithFrame:CGRectMake(SPACE, _todayOrderNum.bottom, (self.width - 4 * SPACE) / 3, 20)];
        orderLB.text = @"今日订单数";
        orderLB.textAlignment = NSTextAlignmentCenter;
        orderLB.textColor = [UIColor grayColor];
        orderLB.alpha = .8;
        [self addSubview:orderLB];
        
        UILabel *moneyLB = [[UILabel alloc]initWithFrame:CGRectMake(orderLB.right + SPACE, orderLB.top, orderLB.width, orderLB.height)];
        moneyLB.text = @"今日销售额";
        moneyLB.textAlignment = NSTextAlignmentCenter;
        moneyLB.textColor = [UIColor grayColor];
        moneyLB.alpha = .8;
        [self addSubview:moneyLB];
        
        UILabel *bankLB = [[UILabel alloc]initWithFrame:CGRectMake(moneyLB.right + SPACE, moneyLB.top, moneyLB.width, moneyLB.height)];
        bankLB.text = @"银行卡";
        bankLB.textAlignment = NSTextAlignmentCenter;
        bankLB.textColor = [UIColor grayColor];
        bankLB.alpha = .8;
        [self addSubview:bankLB];
        
        
        self.informationButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _informationButton.frame = CGRectMake(_storeStateLabel.right + SPACE, _icon.top + _icon.height / 4, BUTTON_WIDTH, _storeNameLable.height);
        [_informationButton setImage:[[UIImage imageNamed:@"arrowright.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        _informationButton.backgroundColor = [UIColor whiteColor];
        _informationButton.titleLabel.font = [UIFont systemFontOfSize:25];
        [self addSubview:_informationButton];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
