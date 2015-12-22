//
//  SetTimeView.m
//  TinyOrder
//
//  Created by 仙林 on 15/10/12.
//  Copyright © 2015年 仙林. All rights reserved.
//

#import "SetTimeView.h"

@implementation SetTimeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubviewes];
    }
    return self;
}

- (void)addSubviewes
{
    self.backgroundColor = [UIColor whiteColor];
    
    self.modelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _modelButton.frame = CGRectMake(0, 0, 70, 60);
    [_modelButton setTitle:@"按区间" forState:UIControlStateNormal];
    [_modelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_modelButton setImage:[[UIImage imageNamed:@"flod.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [self addSubview:_modelButton];
    
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(_modelButton.right, _modelButton.top, 1, _modelButton.height)];
    line1.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    [self addSubview:line1];
    
    self.starButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _starButton.frame = CGRectMake(line1.right, _modelButton.top, (self.width - _modelButton.width - 2) / 2, _modelButton.height);
    [_starButton setTitle:@"选择活动开始时间" forState:UIControlStateNormal];
    [_starButton setTitleColor:[UIColor colorWithWhite:.9 alpha:1] forState:UIControlStateNormal];
    [self addSubview:_starButton];
    
    self.separateLine = [[UIView alloc]initWithFrame:CGRectMake(_starButton.right, _modelButton.top, 1, _modelButton.height)];
    _separateLine.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    [self addSubview:_separateLine];
    
    self.stopButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _stopButton.frame = CGRectMake(_separateLine.right, _modelButton.top, _starButton.width, _starButton.height);
    [_stopButton setTitle:@"选择活动结束时间" forState:UIControlStateNormal];
    [_stopButton setTitleColor:[UIColor colorWithWhite:.9 alpha:1] forState:UIControlStateNormal];
    [self addSubview:_stopButton];
    
    self.weekButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _weekButton.frame = CGRectMake(line1.right, _modelButton.top, self.width - _modelButton.width - 1, _modelButton.height);
    [_weekButton setTitle:@"周一到周五" forState:UIControlStateNormal];
    [_weekButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.weekButton.hidden = YES;
    [self addSubview:_weekButton];
    
    self.weekSeparateLine = [[UIView alloc]initWithFrame:CGRectMake(0, _modelButton.bottom, self.width, 1)];
    _weekSeparateLine.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    _weekSeparateLine.hidden = YES;
    [self addSubview:_weekSeparateLine];
    
    self.weekTimeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _weekTimeButton.frame = CGRectMake(0, _weekSeparateLine.bottom, self.width, _modelButton.height);
    [_weekTimeButton setTitle:@"设置活动时间" forState:UIControlStateNormal];
    [_weekTimeButton setTitleColor:[UIColor colorWithWhite:.9 alpha:1] forState:UIControlStateNormal];
    _weekTimeButton.hidden = YES;
    [self addSubview:_weekTimeButton];
    
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
