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
#define NUMLABEL_WIDTH 40
#define NUMLABEL_HEIGHT 30
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
    self.numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(-10, TOP_SPACE, NUMLABEL_WIDTH + 10, NUMLABEL_HEIGHT)];
    _numberLabel.textColor = [UIColor colorWithRed:249 / 255.0 green:72 / 255.0 blue:47 / 255.0 alpha:1];
    _numberLabel.backgroundColor = ROMDOM_COLOR;
    _numberLabel.text = @"10号";
    _numberLabel.font = [UIFont systemFontOfSize:19];
    [self addSubview:_numberLabel];
    
    
//    self.stateImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.width - IMAGE_WIDTH, 10, IMAGE_WIDTH, IMAGE_WIDTH)];
//    _stateImageView.center = CGPointMake(_stateImageView.centerX, self.height / 2);
//    _stateImageView.image = [UIImage imageNamed:@"proceState.png"];
//    [self addSubview:_stateImageView];
    
    UITextField * textField = [[UITextField alloc]initWithFrame:CGRectMake(_numberLabel.right, TOP_SPACE, self.width / 2 - LETF_SPACE - NUMLABEL_WIDTH, _numberLabel.height)];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.enabled = NO;
    textField.layer.cornerRadius = 5;
    textField.layer.masksToBounds = YES;
    textField.layer.borderColor = [UIColor grayColor].CGColor;
    [self addSubview:textField];
    
    UILabel * arriveLB = [[UILabel alloc]initWithFrame:CGRectMake(textField.left + 1, TOP_SPACE + 1, textField.width / 2 - 1, textField.height - 2)];
    arriveLB.text = @"送达时间";
//    arriveLB.font = [UIFont systemFontOfSize:13];
    arriveLB.adjustsFontSizeToFitWidth = YES;
    arriveLB.layer.cornerRadius = 5;
    arriveLB.layer.masksToBounds = YES;
    arriveLB.textAlignment = NSTextAlignmentCenter;
    [self addSubview:arriveLB];
    
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(arriveLB.right - 1, arriveLB.top + 4, 1, 20)];
    line.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    [self addSubview:line];
    
    self.arriveTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(line.right, arriveLB.top, textField.width / 2 - 1, arriveLB.height)];
    _arriveTimeLabel.text = @"00:00";
    _arriveTimeLabel.textAlignment = NSTextAlignmentCenter;
    _arriveTimeLabel.font = [UIFont systemFontOfSize:13];
    _arriveTimeLabel.layer.cornerRadius = 5;
    _arriveTimeLabel.layer.masksToBounds = YES;
    self.arriveTimeLabel.textColor = [UIColor colorWithRed:249 / 255.0 green:72 / 255.0 blue:47 / 255.0 alpha:1];
    [self addSubview:_arriveTimeLabel];
    
    
    self.stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.width / 2, TOP_SPACE, 60, _numberLabel.height)];
    _stateLabel.textColor = [UIColor grayColor];
    _stateLabel.backgroundColor = ROMDOM_COLOR;
    _stateLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_stateLabel];
    
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(_stateLabel.right, _stateLabel.top + 5, 1, _stateLabel.height - 10)];
    line2.backgroundColor = [UIColor grayColor];
    [self addSubview:line2];
    
    self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(line2.right, _stateLabel.top, self.width / 2 - _stateLabel.width - LETF_SPACE - 1, _stateLabel.height)];
    _dateLabel.textColor = [UIColor grayColor];
    _dateLabel.font = [UIFont systemFontOfSize:12];
    _dateLabel.backgroundColor = ROMDOM_COLOR;
    _dateLabel.numberOfLines = 0;
    _dateLabel.textAlignment = NSTextAlignmentCenter;
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
