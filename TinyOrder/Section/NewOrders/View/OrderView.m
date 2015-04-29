//
//  OrderView.m
//  TinyOrder
//
//  Created by 仙林 on 15/4/11.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "OrderView.h"
#import "UIViewAdditions.h"

#define NUMLABEL_WIDTH 80
#define NUMLABEL_HEIGHT 50
#define SPACE 20
#define TOP_SPACE 10
#define EXPECTLB_HEIGHT 30

#define NUMLB_TEXTCOLOR [UIColor orangeColor];

//#define ROMDOM_COLOR [UIColor colorWithRed:arc4random() % 256 / 255.0 green:arc4random() % 256 / 255.0 blue:arc4random() % 256 / 255.0 alpha:1.0]
#define ROMDOM_COLOR [UIColor clearColor]


@implementation OrderView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubView:frame];
    }
    return self;
}

- (void)createSubView:(CGRect)frame
{
    self.numLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, NUMLABEL_WIDTH, NUMLABEL_HEIGHT)];
    _numLabel.text = @"12号";
    _numLabel.textColor = NUMLB_TEXTCOLOR;
    _numLabel.font = [UIFont systemFontOfSize:38];
    _numLabel.backgroundColor = ROMDOM_COLOR;
    [self addSubview:_numLabel];
    UIView * numLineView = [[UIView alloc] initWithFrame:CGRectMake(0, _numLabel.bottom, self.width, 3)];
    numLineView.backgroundColor = [UIColor orangeColor];
    [self addSubview:numLineView];
    self.stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(_numLabel.right + SPACE, 0, self.width - SPACE - _numLabel.right, NUMLABEL_HEIGHT / 2)];
    _stateLabel.text = @"等待处理";
    _stateLabel.textColor = NUMLB_TEXTCOLOR;
    _stateLabel.textAlignment = NSTextAlignmentCenter;
    _stateLabel.font = [UIFont systemFontOfSize:14];
    _stateLabel.backgroundColor = ROMDOM_COLOR;
    [self addSubview:_stateLabel];
    self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(_stateLabel.left, _stateLabel.bottom, _stateLabel.width, _stateLabel.height)];
    _dateLabel.font = [UIFont systemFontOfSize:14];
    _dateLabel.textAlignment = NSTextAlignmentCenter;
    _dateLabel.text = @"下单时间:3月4号 19:10:14";
    _dateLabel.textColor = NUMLB_TEXTCOLOR;
    _dateLabel.backgroundColor = ROMDOM_COLOR;
    [self addSubview:_dateLabel];
    self.expectLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _numLabel.bottom + TOP_SPACE, self.width, EXPECTLB_HEIGHT)];
    _expectLabel.textColor = [UIColor whiteColor];
    _expectLabel.layer.cornerRadius = 15.0;
//    _expectLabel.layer.borderWidth = 1;
//    _expectLabel.layer.borderColor = [UIColor grayColor].CGColor;
    _expectLabel.layer.backgroundColor = [UIColor orangeColor].CGColor;
//    _expectLabel.backgroundColor = [UIColor orangeColor];
    _expectLabel.font = [UIFont systemFontOfSize:20];
    _expectLabel.text = @"  预订单: 期望送达时间11:10";
    [self addSubview:_expectLabel];
    self.addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _expectLabel.bottom + TOP_SPACE, self.width, NUMLABEL_HEIGHT / 2)];
    _addressLabel.backgroundColor = ROMDOM_COLOR;
    _addressLabel.font = [UIFont systemFontOfSize:15];
    _addressLabel.text = @"地址: 上海浦东新区陆家嘴东路12号1204";
    [self addSubview:_addressLabel];
    self.contactsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _addressLabel.bottom + TOP_SPACE, self.width / 2 - SPACE, NUMLABEL_HEIGHT / 2)];
    _contactsLabel.backgroundColor = ROMDOM_COLOR;
    _contactsLabel.text = @"联系人: 王先生";
    _contactsLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:_contactsLabel];
    self.telLabel = [[UILabel alloc] initWithFrame:CGRectMake(_contactsLabel.right + SPACE, _contactsLabel.top, self.width / 2, NUMLABEL_HEIGHT / 2)];
    _telLabel.font = [UIFont systemFontOfSize:15];
    _telLabel.backgroundColor = ROMDOM_COLOR;
    _telLabel.text = @"电话: 13884034473";
    [self addSubview:_telLabel];
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, _telLabel.bottom + TOP_SPACE, self.width, 1.5)];
    lineView.backgroundColor = [UIColor orangeColor];
    [self addSubview:lineView];
//    NSLog(@"%g", lineView.bottom);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
