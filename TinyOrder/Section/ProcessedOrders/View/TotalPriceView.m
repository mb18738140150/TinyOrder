//
//  TotalPriceView.m
//  TinyOrder
//
//  Created by 仙林 on 15/4/13.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "TotalPriceView.h"
#import "UIViewAdditions.h"

#define PRICELABEL_WIDTH 100
#define TOP_SPACE 5
#define LABEL_HEIGHT 30
#define LEFT_SPACE 10
@implementation TotalPriceView


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
    self.totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE, self.width - PRICELABEL_WIDTH - LEFT_SPACE * 2, LABEL_HEIGHT)];
    _totalLabel.text = @"总计";
    _totalLabel.font = [UIFont systemFontOfSize:24];
    [self addSubview:_totalLabel];
    self.totalPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(_totalLabel.right, TOP_SPACE, PRICELABEL_WIDTH, LABEL_HEIGHT)];
    _totalPriceLabel.text = @"¥24";
    _totalPriceLabel.font = [UIFont systemFontOfSize:24];
    _totalPriceLabel.textColor = [UIColor redColor];
    [self addSubview:_totalPriceLabel];
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, _totalPriceLabel.bottom, self.width, 1)];
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
