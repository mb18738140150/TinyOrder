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

@property (nonatomic, strong)UIImageView * icon;
@property (nonatomic, strong)UILabel * storeNameLable;
@property (nonatomic, strong)UILabel * phoneLabel;


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
        self.icon = [[UIImageView alloc] initWithFrame:CGRectMake(SPACE, SPACE, self.height - 2 * SPACE, self.height - 2 * SPACE)];
        _icon.backgroundColor = VIEW_COLOR;
        _icon.image = [UIImage imageNamed:@"userIcon.png"];
        [self addSubview:_icon];
        self.storeNameLable = [[UILabel alloc] initWithFrame:CGRectMake(_icon.right + SPACE, SPACE, self.width - 4 * SPACE - BUTTON_WIDTH - _icon.width, _icon.height / 2)];
        _storeNameLable.backgroundColor = VIEW_COLOR;
        _storeNameLable.text = [UserInfo shareUserInfo].userName;
        [self addSubview:_storeNameLable];
        self.phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(_storeNameLable.left, _storeNameLable.bottom, _storeNameLable.width, _storeNameLable.height)];
        _phoneLabel.text = [NSString stringWithFormat:@"%@", [UserInfo shareUserInfo].userId];
//        _phoneLabel.backgroundColor = [UIColor grayColor];
        [self addSubview:_phoneLabel];
        self.exitButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _exitButton.frame = CGRectMake(_storeNameLable.right + SPACE, SPACE, BUTTON_WIDTH, _storeNameLable.height);
        [_exitButton setTitle:@"退出" forState:UIControlStateNormal];
        _exitButton.backgroundColor = VIEW_COLOR;
        _exitButton.titleLabel.font = [UIFont systemFontOfSize:25];
        [self addSubview:_exitButton];
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
