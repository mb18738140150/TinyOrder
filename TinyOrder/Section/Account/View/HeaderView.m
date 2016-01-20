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
        _storeNameLable.textColor = [UIColor whiteColor];
        [self addSubview:_storeNameLable];
        
        self.storeStateLabel = [[UILabel alloc]initWithFrame:CGRectMake(_storeNameLable.right, _storeNameLable.top, _storeNameLable.width, _storeNameLable.height)];
        _storeStateLabel.backgroundColor = VIEW_COLOR;
        _storeStateLabel.textColor = [UIColor orangeColor];
        
        UIImageView * imageview = [[UIImageView alloc]init];
        imageview.frame = CGRectMake(_storeNameLable.right, _storeNameLable.top + 5, _storeNameLable.width, _storeNameLable.height - 10);
        imageview.image = [UIImage imageNamed:@"account_login_static-background.png"];
        [self addSubview:imageview];
        
        [self addSubview:_storeStateLabel];
        
        self.phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(_storeNameLable.left, _storeNameLable.bottom, _storeNameLable.width * 2, _storeNameLable.height)];
        _phoneLabel.textColor = [UIColor whiteColor];
//        _phoneLabel.text = [NSString stringWithFormat:@"%@", [UserInfo shareUserInfo].userId];
//        _phoneLabel.backgroundColor = [UIColor grayColor];
        [self addSubview:_phoneLabel];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(10, _icon.bottom + SPACE, self.width - 20, 0)];
        line.backgroundColor = [UIColor grayColor];
        line.alpha = .6;
        [self addSubview:line];
        
        self.todayOrderNum = [[UILabel alloc]initWithFrame:CGRectMake(SPACE, line.bottom + 10, (self.width - 4 * SPACE) / 3, 20)];
        _todayOrderNum.textAlignment = NSTextAlignmentCenter;
        _todayOrderNum.textColor = [UIColor whiteColor];
        
        self.todayMoney = [[UILabel alloc]initWithFrame:CGRectMake(_todayOrderNum.right + SPACE, _todayOrderNum.top, _todayOrderNum.width, _todayOrderNum.height)];
        _todayMoney.textColor = [UIColor whiteColor];
        _todayMoney.userInteractionEnabled = YES;
        _todayMoney.textAlignment = NSTextAlignmentCenter;
        
        self.bankCardNum = [[UILabel alloc]initWithFrame:CGRectMake(_todayMoney.right + SPACE, _todayMoney.top, _todayMoney.width, _todayMoney.height)];
        _bankCardNum.textColor = [UIColor whiteColor];
        _bankCardNum.userInteractionEnabled = YES;
        _bankCardNum.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_todayMoney];
        [self addSubview:_todayOrderNum];
        [self addSubview:_bankCardNum];
        
        UILabel *orderLB = [[UILabel alloc]initWithFrame:CGRectMake(SPACE, _todayOrderNum.bottom, (self.width - 4 * SPACE) / 3, 20)];
        orderLB.text = @"今日订单数";
        orderLB.textAlignment = NSTextAlignmentCenter;
        orderLB.textColor = [UIColor whiteColor];
        orderLB.alpha = .8;
        [self addSubview:orderLB];
        
        self.moneyLB = [[UILabel alloc]initWithFrame:CGRectMake(orderLB.right + SPACE, orderLB.top, orderLB.width, orderLB.height)];
        _moneyLB.text = @"今日销售额";
        _moneyLB.textAlignment = NSTextAlignmentCenter;
        _moneyLB.textColor = [UIColor whiteColor];
        _moneyLB.userInteractionEnabled = YES;
        _moneyLB.alpha = .8;
        [self addSubview:_moneyLB];
        
        self.bankLB = [[UILabel alloc]initWithFrame:CGRectMake(_moneyLB.right + SPACE, _moneyLB.top, _moneyLB.width, _moneyLB.height)];
        _bankLB.text = @"银行卡";
        _bankLB.textAlignment = NSTextAlignmentCenter;
        _bankLB.textColor = [UIColor whiteColor];
        _bankLB.userInteractionEnabled = YES;
        _bankLB.alpha = .8;
        [self addSubview:_bankLB];
        
        
        self.informationButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _informationButton.frame = CGRectMake(_storeStateLabel.right + SPACE, _icon.top + _icon.height / 4, BUTTON_WIDTH, _storeNameLable.height);
        [_informationButton setImage:[[UIImage imageNamed:@"account_right_icon.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
//        [_informationButton setBackgroundImage:[[UIImage imageNamed:@"account_right_icon.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        _informationButton.backgroundColor = [UIColor clearColor];
        _informationButton.titleLabel.font = [UIFont systemFontOfSize:25];
        [self addSubview:_informationButton];
        
        self.backgroundColor = [UIColor colorWithRed:247 /255.0 green:102 / 255.0 blue:69 / 255.0 alpha:1.0];
        
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
