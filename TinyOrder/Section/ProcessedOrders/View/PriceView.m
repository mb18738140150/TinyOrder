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
#define LABEL_HEIGHT 20
#define LEFT_SPACE 10
#define TOP_SPACE 5
#define NUMLB_WIDTH 50
#define LABEL_FONT [UIFont systemFontOfSize:15]
#define ROMDOM_COLOR [UIColor clearColor]

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
    self.otherLael = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, 0, self.width - RIGHTLABEL_WIDTH - LEFT_SPACE * 2, LABEL_HEITH)];
    _otherLael.text = @"其他费用";
    _otherLael.textColor = [UIColor grayColor];
    _otherLael.font = [UIFont systemFontOfSize:15];
    [self addSubview:_otherLael];
    self.otherPriceLB = [[UILabel alloc] initWithFrame:CGRectMake(_otherLael.right, _otherLael.top, RIGHTLABEL_WIDTH, LABEL_HEITH)];
    _otherPriceLB.text = @"¥0";
    _otherPriceLB.textColor = [UIColor grayColor];
    _otherPriceLB.font = [UIFont systemFontOfSize:15];
    [self addSubview:_otherPriceLB];
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, _otherPriceLB.bottom, self.width, 1)];
    lineView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.9];
    [self addSubview:lineView];
    
//    self.preferentialLabel = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, lineView.bottom + TOP_SPACE, self.width, LABEL_HEIGHT)];
//    _preferentialLabel.backgroundColor = ROMDOM_COLOR;
////        _titleLable.font = [UIFont systemFontOfSize:15];
//    _preferentialLabel.text = @"其他优惠";
//    _preferentialLabel.font = LABEL_FONT;
//    _preferentialLabel.textColor = [UIColor grayColor];
//    [self addSubview:_preferentialLabel];
//    
//    UILabel *firstReduceLB = [[UILabel alloc]initWithFrame:CGRectMake(TOP_SPACE * 2, _preferentialLabel.bottom + TOP_SPACE, self.width - RIGHTLABEL_WIDTH - LEFT_SPACE * 2, LABEL_HEIGHT)];
//    firstReduceLB.text = @"首单立减";
//    firstReduceLB.font = LABEL_FONT;
//    firstReduceLB.textColor = [UIColor grayColor];
//    [self addSubview:firstReduceLB];
//    
//    self.firstReduce = [[UILabel alloc]initWithFrame:CGRectMake(firstReduceLB.right, firstReduceLB.top , RIGHTLABEL_WIDTH, LABEL_HEIGHT)];
//    self.firstReduce.textColor = [UIColor grayColor];
//    _firstReduce.font = LABEL_FONT;
//    [self addSubview:_firstReduce];
//    
//    UILabel *fullReduceLB = [[UILabel alloc]initWithFrame:CGRectMake(TOP_SPACE * 2, firstReduceLB.bottom + TOP_SPACE, self.width - RIGHTLABEL_WIDTH - LEFT_SPACE * 2, LABEL_HEIGHT)];
//    fullReduceLB.text = @"满减优惠";
//    fullReduceLB.font = LABEL_FONT;
//    fullReduceLB.textColor = [UIColor grayColor];
//    [self addSubview:fullReduceLB];
//    
//    self.fullReduce = [[UILabel alloc]initWithFrame:CGRectMake(fullReduceLB.right, fullReduceLB.top , RIGHTLABEL_WIDTH, LABEL_HEIGHT)];
//    self.fullReduce.textColor = [UIColor grayColor];
//    _fullReduce.font = LABEL_FONT;
//    [self addSubview:_fullReduce];
//    
//    UILabel *reduceCardLB = [[UILabel alloc]initWithFrame:CGRectMake(TOP_SPACE * 2, fullReduceLB.bottom + TOP_SPACE, self.width - RIGHTLABEL_WIDTH - LEFT_SPACE * 2, LABEL_HEIGHT)];
//    reduceCardLB.text = @"优惠券";
//    reduceCardLB.font = LABEL_FONT;
//    reduceCardLB.textColor = [UIColor grayColor];
//    [self addSubview:reduceCardLB];
//    
//    self.reduceCard = [[UILabel alloc]initWithFrame:CGRectMake(reduceCardLB.right, reduceCardLB.top , RIGHTLABEL_WIDTH, LABEL_HEIGHT)];
//    self.reduceCard.textColor = [UIColor grayColor];
//    _reduceCard.font = LABEL_FONT;
//    [self addSubview:_reduceCard];
//    
//    UIView * line2View = [[UIView alloc] initWithFrame:CGRectMake(0, _reduceCard.bottom + TOP_SPACE, self.width, 1)];
//    line2View.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.9];
//    [self addSubview:line2View];

    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
