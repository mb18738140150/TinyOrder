//
//  OtherPaceView.m
//  TinyOrder
//
//  Created by 仙林 on 15/4/11.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "OtherPaceView.h"
#import "UIViewAdditions.h"
#define TITLELB_HEIGHT 30
#define LABEL_HEIGHT 20
#define TOP_SPACE 10
#define PACE_WIDTH 50
//#define ROMDOM_COLOR [UIColor colorWithRed:arc4random() % 256 / 255.0 green:arc4random() % 256 / 255.0 blue:arc4random() % 256 / 255.0 alpha:1.0]
#define ROMDOM_COLOR [UIColor clearColor]

@implementation OtherPaceView


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
    self.titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, LABEL_HEIGHT)];
    _titleLable.backgroundColor = ROMDOM_COLOR;
//    _titleLable.font = [UIFont systemFontOfSize:20];
    _titleLable.text = @"其他费用";
    [self addSubview:_titleLable];
//    self.paceTitleLB = [[UILabel alloc] initWithFrame:CGRectMake(0, _titleLable.bottom + TOP_SPACE, self.width / 2, LABEL_HEIGHT)];
//    _paceTitleLB.backgroundColor = ROMDOM_COLOR;
////    _paceTitleLB.font = [UIFont systemFontOfSize:20];
//    _paceTitleLB.text = @"配送费";
//    [self addSubview:_paceTitleLB];
    self.paceLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.width - PACE_WIDTH, _titleLable.top, PACE_WIDTH, LABEL_HEIGHT)];
    _paceLabel.textAlignment = NSTextAlignmentRight;
    _paceLabel.backgroundColor = ROMDOM_COLOR;
//    _paceLabel.font = [UIFont systemFontOfSize:20];
//    _paceLabel.text = @"¥108";
    [self addSubview:_paceLabel];
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, _paceLabel.bottom + TOP_SPACE, self.width, 1.5)];
    lineView.backgroundColor = [UIColor orangeColor];
    [self addSubview:lineView];
    NSLog(@"%g", lineView.bottom);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
