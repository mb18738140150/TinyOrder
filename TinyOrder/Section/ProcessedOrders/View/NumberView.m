//
//  NumberView.m
//  TinyOrder
//
//  Created by 仙林 on 15/4/13.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "NumberView.h"
#import "UIViewAdditions.h"

#define LETF_SPACE 10
#define TOP_SPACE 10
#define NUMLABEL_WIDTH 70
#define NUMLABEL_HEIGHT 50
#define NUM_STATE_LB_SPACE 10
#define IMAGE_WIDTH 20

#define LABEL_TEXT_COLOR [UIColor colorWithRed:120 / 255.0 green:174 / 255.0 blue:38 / 255.0 alpha:1.0]

//#define ROMDOM_COLOR [UIColor colorWithRed:arc4random() % 256 / 255.0 green:arc4random() % 256 / 255.0 blue:arc4random() % 256 / 255.0 alpha:1.0]
#define ROMDOM_COLOR [UIColor clearColor]


@implementation NumberView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self createSubView];
    }
    return self;
}


- (void)createSubView
{
    self.numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(LETF_SPACE, TOP_SPACE, NUMLABEL_WIDTH, NUMLABEL_HEIGHT)];
    _numberLabel.textColor = LABEL_TEXT_COLOR;
    _numberLabel.backgroundColor = ROMDOM_COLOR;
    _numberLabel.text = @"10号";
    _numberLabel.font = [UIFont systemFontOfSize:32];
    [self addSubview:_numberLabel];
    self.stateImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.width - IMAGE_WIDTH, 10, IMAGE_WIDTH, IMAGE_WIDTH)];
    _stateImageView.center = CGPointMake(_stateImageView.centerX, self.height / 2);
    _stateImageView.image = [UIImage imageNamed:@"proceState.png"];
    [self addSubview:_stateImageView];
    self.stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(_numberLabel.right + NUM_STATE_LB_SPACE, TOP_SPACE, self.width - IMAGE_WIDTH - _numberLabel.right - NUM_STATE_LB_SPACE - LETF_SPACE, NUMLABEL_HEIGHT / 2)];
    _stateLabel.textColor = LABEL_TEXT_COLOR;
//    _stateLabel.text = @"订单已处理待配送";
    _stateLabel.backgroundColor = ROMDOM_COLOR;
    _stateLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:_stateLabel];
    self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(_stateLabel.left, _stateLabel.bottom, _stateLabel.width, _stateLabel.height)];
    _dateLabel.textColor = LABEL_TEXT_COLOR;
//    _dateLabel.text = @"下单时间:3/4 11:34:44";
    _dateLabel.font = [UIFont systemFontOfSize:14];
    _dateLabel.backgroundColor = ROMDOM_COLOR;
    _dateLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:_dateLabel];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
