//
//  MealPriceView.m
//  TinyOrder
//
//  Created by 仙林 on 15/4/27.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "MealPriceView.h"

#define RIGHTLABEL_WIDTH 50
#define LABEL_HEITH 30
#define LEFT_SPACE 10
#define NUMLB_WIDTH 50


@implementation MealPriceView



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubview];
    }
    return self;
}


- (void)createSubview
{
    self.menuLabel = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, 0, self.width - RIGHTLABEL_WIDTH - NUMLB_WIDTH - 2 * LEFT_SPACE, LABEL_HEITH)];
//    _menuLabel.text = @"白菜炒肉丝+例汤+赠品";
    _menuLabel.textColor = [UIColor grayColor];
    _menuLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:_menuLabel];
    self.numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(_menuLabel.right, 0, NUMLB_WIDTH, LABEL_HEITH)];
//    _numberLabel.text = @"X2";
    _numberLabel.textColor = [UIColor grayColor];
    _numberLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:_numberLabel];
    self.menuPriceLB = [[UILabel alloc] initWithFrame:CGRectMake(_numberLabel.right, 0, RIGHTLABEL_WIDTH, LABEL_HEITH)];
//    _menuPriceLB.text = @"¥24";
    _menuPriceLB.textColor = [UIColor grayColor];
    _menuPriceLB.font = [UIFont systemFontOfSize:15];
    [self addSubview:_menuPriceLB];

}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
