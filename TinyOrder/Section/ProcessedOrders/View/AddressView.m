//
//  AddressView.m
//  TinyOrder
//
//  Created by 仙林 on 15/4/13.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "AddressView.h"
#import "UIViewAdditions.h"

#define LEFT_SPACE 10
#define PHONE_WIDTH 200
#define LABEL_HEIGHT 30

//#define ROMDOM_COLOR [UIColor colorWithRed:arc4random() % 256 / 255.0 green:arc4random() % 256 / 255.0 blue:arc4random() % 256 / 255.0 alpha:1.0]
#define ROMDOM_COLOR [UIColor clearColor]

@implementation AddressView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubView];
    }
    return self;
}

- (void)createSubView
{
    self.addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, 0, self.width - 2 * LEFT_SPACE, LABEL_HEIGHT)];
//    _addressLabel.text = @"地址:上海浦东新区陆家嘴东路12号1204";
    _addressLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:_addressLabel];
    self.contactLabel = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, _addressLabel.bottom, (self.width - 2 * LEFT_SPACE)/ 2 - LEFT_SPACE, LABEL_HEIGHT)];
//    _contactLabel.text = @"联系人: 王先生";
    _contactLabel.font = [UIFont systemFontOfSize:16];
    _contactLabel.backgroundColor = ROMDOM_COLOR;
//    [self addSubview:_contactLabel];
    self.phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, _contactLabel.top, (self.width - 2 * LEFT_SPACE) / 2 + LEFT_SPACE, LABEL_HEIGHT)];
//    _phoneLabel.text = @"电话: 13758409940";
    _phoneLabel.backgroundColor = ROMDOM_COLOR;
    _phoneLabel.font = [UIFont systemFontOfSize:16];
    _phoneLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:_phoneLabel];
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, _phoneLabel.bottom, self.width, 1)];
    lineView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.9];
    [self addSubview:lineView];
//    NSLog(@"%g", _phoneLabel.bottom);
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
