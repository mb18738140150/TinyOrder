//
//  WeekView.m
//  TinyOrder
//
//  Created by 仙林 on 15/7/22.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "WeekView.h"

@implementation WeekView


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
    self.changeBT = [UIButton buttonWithType:UIButtonTypeCustom];
    _changeBT.frame = CGRectMake(10, 20, 93, 18);
    [_changeBT setImage:[UIImage imageNamed:@"change_n.png"] forState:UIControlStateNormal];
    [_changeBT setImage:[UIImage imageNamed:@"change_s.png"] forState:UIControlStateSelected];
    [_changeBT setTitle:@"周一到周五" forState:UIControlStateNormal];
    [_changeBT setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _changeBT.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _changeBT.titleLabel.font = [UIFont systemFontOfSize:15];
//    _changeBT.imageView.contentMode = UIViewContentModeLeft;
//    _changeBT.titleLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:_changeBT];
    
//    self.titleLB = [[UILabel alloc] initWithFrame:CGRectMake(_changeBT.right + 5, _changeBT.top, 75, _changeBT.height)];
//    _titleLB.text = @"周一到周五";
//    _titleLB.textAlignment = NSTextAlignmentCenter;
//    _titleLB.font = [UIFont systemFontOfSize:15];
//    [self addSubview:_titleLB];
    
    self.timeBT = [UIButton buttonWithType:UIButtonTypeCustom];
    _timeBT.frame = CGRectMake(_changeBT.right + 5, _changeBT.top, 50, _changeBT.height);
    _timeBT.layer.cornerRadius = 3;
    _timeBT.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:0.5].CGColor;
    _timeBT.layer.borderWidth = 1;
    _timeBT.titleLabel.font = [UIFont systemFontOfSize:15];
    [_timeBT setTitleColor:[UIColor colorWithWhite:0.2 alpha:1] forState:UIControlStateNormal];
    [self addSubview:_timeBT];
    
    UILabel * aLabel = [[UILabel alloc] initWithFrame:CGRectMake(_timeBT.right + 3, _changeBT.top, 130, _changeBT.height)];
    aLabel.tag = 10001;
    aLabel.text = @"点前享受此活动。";
    aLabel.textAlignment = NSTextAlignmentCenter;
    aLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:aLabel];
    
}

- (void)hidenRightView:(BOOL)isHiden
{
    UILabel * alabel = (UILabel *)[self viewWithTag:10001];
    alabel.hidden = isHiden;
    self.timeBT.hidden = isHiden;
    if (isHiden) {
        [self.timeBT setTitle:@"" forState:UIControlStateNormal];
    }
    self.changeBT.selected = !isHiden;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
