//
//  MenuView.m
//  TinyOrder
//
//  Created by 仙林 on 15/4/11.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "MenuView.h"
#import "UIViewAdditions.h"

#define LEFT_SPACE 10
#define TOP_SPACE 0
#define NUMLABEL_WIDTH 50
#define LABEL_HEIGHT 25
#define NUMMENULB_HEIGHT 30
//#define ROMDOM_COLOR [UIColor colorWithRed:arc4random() % 256 / 255.0 green:arc4random() % 256 / 255.0 blue:arc4random() % 256 / 255.0 alpha:1.0]
#define ROMDOM_COLOR [UIColor clearColor]
#define LABEL_FONT [UIFont systemFontOfSize:20]

@implementation MenuView


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
//    self.numMenuLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, NUMMENULB_HEIGHT)];
//    _numMenuLabel.backgroundColor = ROMDOM_COLOR;
//    _numMenuLabel.text = @"1号套餐";
//    _numMenuLabel.font = [UIFont systemFontOfSize:20];
//    [self addSubview:_numMenuLabel];
    self.comboLabel = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE, self.width - 2 * NUMLABEL_WIDTH - 3 * LEFT_SPACE, LABEL_HEIGHT)];
    _comboLabel.backgroundColor = ROMDOM_COLOR;
    _comboLabel.text = @"白菜炒肉丝+例汤+赠品";
    _comboLabel.font = LABEL_FONT;
    [self addSubview:_comboLabel];
    self.numLabel = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE + _comboLabel.right, _comboLabel.top, NUMLABEL_WIDTH, LABEL_HEIGHT)];
    _numLabel.backgroundColor = ROMDOM_COLOR;
    _numLabel.text = @"X4";
    _numLabel.font = LABEL_FONT;
    [self addSubview:_numLabel];
    self.paceLabel = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE + _numLabel.right, _comboLabel.top, NUMLABEL_WIDTH, LABEL_HEIGHT)];
    _paceLabel.backgroundColor = ROMDOM_COLOR;
    _paceLabel.text = @"¥24";
    _paceLabel.font = LABEL_FONT;
    [self addSubview:_paceLabel];
    
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
