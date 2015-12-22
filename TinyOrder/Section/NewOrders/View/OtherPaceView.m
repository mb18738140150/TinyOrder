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
#define TOP_SPACE 5
#define PACE_WIDTH 50
//#define ROMDOM_COLOR [UIColor colorWithRed:arc4random() % 256 / 255.0 green:arc4random() % 256 / 255.0 blue:arc4random() % 256 / 255.0 alpha:1.0]
#define ROMDOM_COLOR [UIColor clearColor]
#define LABEL_FONT [UIFont systemFontOfSize:15]

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
    _titleLable.textColor = [UIColor grayColor];
    [self addSubview:_titleLable];
    
    self.paceTitleLB = [[UILabel alloc] initWithFrame:CGRectMake(TOP_SPACE * 2, _titleLable.bottom + TOP_SPACE, self.width / 2, LABEL_HEIGHT)];
    _paceTitleLB.backgroundColor = ROMDOM_COLOR;
    _paceTitleLB.font = LABEL_FONT;
    _paceTitleLB.text = @"配送费";
    _paceTitleLB.textColor = [UIColor grayColor];
    [self addSubview:_paceTitleLB];
    self.paceLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.width - PACE_WIDTH, _paceTitleLB.top, PACE_WIDTH, LABEL_HEIGHT)];
//    _paceLabel.textAlignment = NSTextAlignmentRight;
    _paceLabel.backgroundColor = ROMDOM_COLOR;
    _paceLabel.textColor = [UIColor grayColor];
    _paceLabel.font = LABEL_FONT;
//    _paceLabel.text = @"¥108";
    [self addSubview:_paceLabel];
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, _paceLabel.bottom + TOP_SPACE, self.width, 1)];
    lineView.backgroundColor = [UIColor orangeColor];
    [self addSubview:lineView];
    
//    self.preferentialLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, lineView.bottom + TOP_SPACE, self.width, LABEL_HEIGHT)];
//    _preferentialLabel.backgroundColor = ROMDOM_COLOR;
//    //    _titleLable.font = [UIFont systemFontOfSize:20];
//    _preferentialLabel.text = @"其他优惠";
//    _preferentialLabel.textColor = [UIColor grayColor];
//    [self addSubview:_preferentialLabel];
//    
//    UILabel *firstReduceLB = [[UILabel alloc]initWithFrame:CGRectMake(TOP_SPACE * 2, _preferentialLabel.bottom + TOP_SPACE, self.width / 2, LABEL_HEIGHT)];
//    firstReduceLB.text = @"首单立减";
//    firstReduceLB.font = LABEL_FONT;
//    firstReduceLB.textColor = [UIColor grayColor];
//    [self addSubview:firstReduceLB];
//    
//    self.firstReduce = [[UILabel alloc]initWithFrame:CGRectMake(self.width - PACE_WIDTH, firstReduceLB.top , PACE_WIDTH, LABEL_HEIGHT)];
//    self.firstReduce.textColor = [UIColor grayColor];
//    _firstReduce.font = LABEL_FONT;
//    [self addSubview:_firstReduce];
//    
//    UILabel *fullReduceLB = [[UILabel alloc]initWithFrame:CGRectMake(TOP_SPACE * 2, firstReduceLB.bottom + TOP_SPACE, self.width / 2, LABEL_HEIGHT)];
//    fullReduceLB.text = @"满减优惠";
//    fullReduceLB.font = LABEL_FONT;
//    fullReduceLB.textColor = [UIColor grayColor];
//    [self addSubview:fullReduceLB];
//    
//    self.fullReduce = [[UILabel alloc]initWithFrame:CGRectMake(self.width - PACE_WIDTH, fullReduceLB.top , PACE_WIDTH, LABEL_HEIGHT)];
//    self.fullReduce.textColor = [UIColor grayColor];
//    _fullReduce.font = LABEL_FONT;
//    [self addSubview:_fullReduce];
//    
//    UILabel *reduceCardLB = [[UILabel alloc]initWithFrame:CGRectMake(TOP_SPACE * 2, fullReduceLB.bottom + TOP_SPACE, self.width / 2, LABEL_HEIGHT)];
//    reduceCardLB.text = @"优惠券";
//    reduceCardLB.font = LABEL_FONT;
//    reduceCardLB.textColor = [UIColor grayColor];
//    [self addSubview:reduceCardLB];
//    
//    self.reduceCard = [[UILabel alloc]initWithFrame:CGRectMake(self.width - PACE_WIDTH, reduceCardLB.top , PACE_WIDTH, LABEL_HEIGHT)];
//    self.reduceCard.textColor = [UIColor grayColor];
//    _reduceCard.font = LABEL_FONT;
//    [self addSubview:_reduceCard];
//    
//    UIView * line2View = [[UIView alloc] initWithFrame:CGRectMake(0, _reduceCard.bottom + TOP_SPACE, self.width, 1)];
//    line2View.backgroundColor = [UIColor orangeColor];
//    [self addSubview:line2View];
//    
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
