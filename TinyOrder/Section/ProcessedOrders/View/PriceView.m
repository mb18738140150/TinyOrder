//
//  PriceView.m
//  TinyOrder
//
//  Created by 仙林 on 15/4/13.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "PriceView.h"
#import "UIViewAdditions.h"

#define RIGHTLABEL_WIDTH 50
#define LABEL_HEITH 30
#define LEFT_SPACE 10
#define TOP_SPACE 0
#define NUMLB_WIDTH 50
@implementation PriceView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createView];
    }
    return self;
}


- (void)createView
{
    /*
    self.menuLabel = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, 0, self.width - RIGHTLABEL_WIDTH - NUMLB_WIDTH - 2 * LEFT_SPACE, LABEL_HEITH)];
    _menuLabel.text = @"白菜炒肉丝+例汤+赠品";
    _menuLabel.font = [UIFont systemFontOfSize:20];
    [self addSubview:_menuLabel];
    self.numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(_menuLabel.right, 0, NUMLB_WIDTH, LABEL_HEITH)];
    _numberLabel.text = @"X2";
    _numberLabel.font = [UIFont systemFontOfSize:20];
    [self addSubview:_numberLabel];
    self.menuPriceLB = [[UILabel alloc] initWithFrame:CGRectMake(_numberLabel.right, 0, RIGHTLABEL_WIDTH, LABEL_HEITH)];
    _menuPriceLB.text = @"¥24";
    _menuPriceLB.font = [UIFont systemFontOfSize:20];
    [self addSubview:_menuPriceLB];
     */
    self.otherLael = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE, self.width - RIGHTLABEL_WIDTH - LEFT_SPACE * 2, LABEL_HEITH)];
    _otherLael.text = @"其他费用";
    _otherLael.font = [UIFont systemFontOfSize:20];
    [self addSubview:_otherLael];
    self.otherPriceLB = [[UILabel alloc] initWithFrame:CGRectMake(_otherLael.right, _otherLael.top, RIGHTLABEL_WIDTH, LABEL_HEITH)];
    _otherPriceLB.text = @"¥0";
    _otherPriceLB.font = [UIFont systemFontOfSize:20];
    [self addSubview:_otherPriceLB];
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, _otherPriceLB.bottom, self.width, 1.5)];
    lineView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.9];
    [self addSubview:lineView];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
