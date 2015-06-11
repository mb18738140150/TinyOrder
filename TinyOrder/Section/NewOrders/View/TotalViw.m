//
//  TotalViw.m
//  TinyOrder
//
//  Created by 仙林 on 15/4/11.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "TotalViw.h"
#import "UIViewAdditions.h"

//#define ROMDOM_COLOR [UIColor colorWithRed:arc4random() % 256 / 255.0 green:arc4random() % 256 / 255.0 blue:arc4random() % 256 / 255.0 alpha:1.0]
#define ROMDOM_COLOR [UIColor clearColor]



#define LABEL_WIDTH 80
#define LABEL_HEIGHT 30
#define SPACE 0


@implementation TotalViw


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
    self.totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, LABEL_WIDTH, LABEL_HEIGHT)];
    _totalLabel.text = @"总计";
    _totalLabel.textColor = [UIColor grayColor];
//    _totalLabel.font = [UIFont systemFontOfSize:20];
    [self addSubview:_totalLabel];
    self.paceLabel = [[UILabel alloc] initWithFrame:CGRectMake(_totalLabel.right + SPACE, 0, LABEL_WIDTH, LABEL_HEIGHT)];
    _paceLabel.text = @"¥24";
    _paceLabel.textColor = [UIColor redColor];
//    _paceLabel.font = [UIFont systemFontOfSize:20];
    [self addSubview:_paceLabel];
    self.stateImageV = [[UIImageView alloc] initWithFrame:CGRectMake(self.width - LABEL_WIDTH - LABEL_HEIGHT, 0, LABEL_HEIGHT, LABEL_HEIGHT)];
//    _stateImageV.backgroundColor = ROMDOM_COLOR;
    _stateImageV.image = [UIImage imageNamed:@"state.png"];
    [self addSubview:_stateImageV];
    self.stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.width - LABEL_WIDTH, 0, LABEL_WIDTH, LABEL_HEIGHT)];
    _stateLabel.text = @"已付款";
    _stateLabel.textColor = [UIColor grayColor];
//    _stateLabel.font = [UIFont systemFontOfSize:20];
    [self addSubview:_stateLabel];
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, _paceLabel.bottom, self.width, 1)];
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
