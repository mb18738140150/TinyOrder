//
//  AddressView.m
//  TinyOrder
//
//  Created by 仙林 on 15/4/13.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "AddressView.h"
#import "UIViewAdditions.h"

#define Top_SPACE 10
#define LEFT_SPACE 10
#define PHONE_WIDTH 200
#define LABEL_HEIGHT 25
#define IMAGE_WIDTH 25

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
    UILabel * orderLB = [[UILabel alloc]initWithFrame:CGRectMake(0,  5, 60, LABEL_HEIGHT)];
    orderLB.text = @"订单号:";
    orderLB.font = [UIFont systemFontOfSize:15];
    [self addSubview:orderLB];
    
    self.orderLabel = [[UILabel alloc]initWithFrame:CGRectMake(orderLB.right, orderLB.top, self.width - 2 * LEFT_SPACE - 30, LABEL_HEIGHT)];
    _orderLabel.textColor = [UIColor orangeColor];
    _orderLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:_orderLabel];
    
    UIImageView *addressImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 5 * Top_SPACE , IMAGE_WIDTH, IMAGE_WIDTH)];
    addressImageView.image = [UIImage imageNamed:@"location_order.png"];
    [self addSubview:addressImageView];
    
    UIImageView *noteimageView = [[UIImageView alloc]initWithFrame:CGRectMake(addressImageView.left, addressImageView.bottom , addressImageView.width, addressImageView.height)];
    noteimageView.image = [UIImage imageNamed:@"remark_order.png"];
    [self addSubview:noteimageView];
    
        self.contactLabel = [[UILabel alloc] initWithFrame:CGRectMake(addressImageView.right + LEFT_SPACE, _orderLabel.bottom, 60, LABEL_HEIGHT)];
        _contactLabel.text = @"王先生哈";
        _contactLabel.font = [UIFont systemFontOfSize:15];
    _contactLabel.textAlignment = NSTextAlignmentLeft;
        _contactLabel.backgroundColor = ROMDOM_COLOR;
        [self addSubview:_contactLabel];
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(_contactLabel.right, _contactLabel.top + 5, 1, _contactLabel.height - 10)];
    line.backgroundColor = [UIColor grayColor];
    [self addSubview:line];
    
    self.phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(line.right, _contactLabel.top, 100, LABEL_HEIGHT)];
    _phoneLabel.backgroundColor = ROMDOM_COLOR;
    _phoneLabel.font = [UIFont systemFontOfSize:15];
    _phoneLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_phoneLabel];
    
    self.phoneBT = [UIButton buttonWithType:UIButtonTypeSystem];
    self.phoneBT.frame = _phoneLabel.frame;
    [self addSubview:_phoneBT];
    
    self.payTypeLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.width - 80, _contactLabel.top, 80, _contactLabel.height)];
    _payTypeLabel.layer.cornerRadius = 5;
    _payTypeLabel.layer.masksToBounds = YES;
    _payTypeLabel.layer.borderWidth = 1;
    _payTypeLabel.layer.borderColor = [UIColor grayColor].CGColor;
    _payTypeLabel.textAlignment = NSTextAlignmentCenter;
    _payTypeLabel.textColor = [UIColor colorWithRed:249 / 255.0 green:72 / 255.0 blue:47 / 255.0 alpha:1];
    [self addSubview:_payTypeLabel];
    
    
    self.addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(_contactLabel.left, _contactLabel.bottom, self.width - 3 * LEFT_SPACE - 40, LABEL_HEIGHT)];
    _addressLabel.font = [UIFont systemFontOfSize:15];
    _addressLabel.textColor = [UIColor grayColor];
    [self addSubview:_addressLabel];
    
    self.remarkLabel = [[UILabel alloc]initWithFrame:CGRectMake(_addressLabel.left, _addressLabel.bottom, self.width - 3 * LEFT_SPACE - 40, LABEL_HEIGHT)];
    _remarkLabel.font = [UIFont systemFontOfSize:15];
    _remarkLabel.numberOfLines = 0;
    _remarkLabel.textColor = [UIColor grayColor];
    [self addSubview:_remarkLabel];
    
    self.giftLabel = [[UILabel alloc]initWithFrame:CGRectMake(_addressLabel.left, _remarkLabel.bottom, self.width - 3 * LEFT_SPACE - 40, LABEL_HEIGHT)];
    _giftLabel.font = [UIFont systemFontOfSize:15];
    _giftLabel.textColor = [UIColor grayColor];
    [self addSubview:_giftLabel];
    
//    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, _phoneLabel.bottom, self.width, 1)];
//    lineView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.9];
//    [self addSubview:lineView];
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
