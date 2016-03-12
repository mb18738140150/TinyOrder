//
//  HeadView.m
//  TinyOrder
//
//  Created by 仙林 on 16/3/1.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "HeadView.h"

#import "UIViewAdditions.h"

#define LETF_SPACE 10
#define TOP_SPACE 10
#define NUMLABEL_WIDTH 40
#define NUMLABEL_HEIGHT 30
#define NUM_STATE_LB_SPACE 10
#define IMAGE_WIDTH 20

#define LABEL_TEXT_COLOR [UIColor colorWithRed:120 / 255.0 green:174 / 255.0 blue:38 / 255.0 alpha:1.0]

#define ROMDOM_COLOR [UIColor clearColor]

@implementation HeadView

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
    self.numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, TOP_SPACE, self.width / 5, NUMLABEL_HEIGHT)];
    _numberLabel.textColor = [UIColor blackColor];
    _numberLabel.backgroundColor = ROMDOM_COLOR;
    _numberLabel.text = @"10号";
    _numberLabel.textAlignment = NSTextAlignmentCenter;
//    _numberLabel.font = [UIFont systemFontOfSize:19];
    [self addSubview:_numberLabel];
    
    
    //    self.stateImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.width - IMAGE_WIDTH, 10, IMAGE_WIDTH, IMAGE_WIDTH)];
    //    _stateImageView.center = CGPointMake(_stateImageView.centerX, self.height / 2);
    //    _stateImageView.image = [UIImage imageNamed:@"proceState.png"];
    //    [self addSubview:_stateImageView];
    
//    UITextField * textField = [[UITextField alloc]initWithFrame:CGRectMake(_numberLabel.right, TOP_SPACE, self.width / 2 - LETF_SPACE - NUMLABEL_WIDTH, _numberLabel.height)];
//    textField.borderStyle = UITextBorderStyleRoundedRect;
//    textField.enabled = NO;
//    textField.layer.cornerRadius = 5;
//    textField.layer.masksToBounds = YES;
//    textField.layer.borderColor = [UIColor grayColor].CGColor;
//    [self addSubview:textField];
//    
//    UILabel * arriveLB = [[UILabel alloc]initWithFrame:CGRectMake(textField.left + 1, TOP_SPACE + 1, textField.width / 2 - 1, textField.height - 2)];
//    arriveLB.text = @"送达时间";
//    //    arriveLB.font = [UIFont systemFontOfSize:13];
//    arriveLB.adjustsFontSizeToFitWidth = YES;
//    arriveLB.layer.cornerRadius = 5;
//    arriveLB.layer.masksToBounds = YES;
//    arriveLB.textAlignment = NSTextAlignmentCenter;
//    [self addSubview:arriveLB];
//    
//    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(arriveLB.right - 1, arriveLB.top + 4, 1, 20)];
//    line.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
//    [self addSubview:line];
//    
//    self.arriveTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(line.right, arriveLB.top, textField.width / 2 - 1, arriveLB.height)];
//    _arriveTimeLabel.text = @"00:00";
//    _arriveTimeLabel.textAlignment = NSTextAlignmentCenter;
//    _arriveTimeLabel.font = [UIFont systemFontOfSize:13];
//    _arriveTimeLabel.layer.cornerRadius = 5;
//    _arriveTimeLabel.layer.masksToBounds = YES;
//    self.arriveTimeLabel.textColor = [UIColor colorWithRed:249 / 255.0 green:72 / 255.0 blue:47 / 255.0 alpha:1];
//    [self addSubview:_arriveTimeLabel];
    
    UIView * line1 = [[UIView alloc]initWithFrame:CGRectMake(_numberLabel.right, _numberLabel.top, 1, _numberLabel.height)];
    line1.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    [self addSubview:line1];
    
    self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(line1.right, _numberLabel.top, self.width / 5, _numberLabel.height)];
    _dateLabel.textColor = [UIColor blackColor];
//    _dateLabel.font = [UIFont systemFontOfSize:12];
    _dateLabel.backgroundColor = ROMDOM_COLOR;
    _dateLabel.numberOfLines = 0;
    _dateLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_dateLabel];
    
    UIView * line2 = [[UIView alloc]initWithFrame:CGRectMake(_dateLabel.right, _dateLabel.top, 1, _dateLabel.height)];
    line2.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    [self addSubview:line2];
    
    self.stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(line2.right, TOP_SPACE, self.width / 5 * 2, _numberLabel.height)];
    _stateLabel.textColor = [UIColor grayColor];
    _stateLabel.backgroundColor = ROMDOM_COLOR;
    _stateLabel.textAlignment = NSTextAlignmentCenter;
//    _stateLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:_stateLabel];
    
    UIView *line3 = [[UIView alloc]initWithFrame:CGRectMake(_stateLabel.right, _stateLabel.top, 1, _stateLabel.height)];
    line3.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    [self addSubview:line3];
    
    self.orderStyleLabel = [[UILabel alloc]initWithFrame:CGRectMake(line3.right, line3.top, self.width / 5, line3.height)];
    self.orderStyleLabel.textColor = BACKGROUNDCOLOR;
    self.orderStyleLabel.textAlignment = NSTextAlignmentCenter;
    _orderStyleLabel.backgroundColor = ROMDOM_COLOR;
    [self addSubview:_orderStyleLabel];
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
