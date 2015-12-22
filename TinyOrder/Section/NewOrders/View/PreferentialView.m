//
//  PreferentialView.m
//  TinyOrder
//
//  Created by 仙林 on 15/9/28.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "PreferentialView.h"

#define LABEL_FONT [UIFont systemFontOfSize:15]
#define TOP_SPACE 10
#define LEFT_SPACE 10
#define LABEL_HEIGHT 20
#define LABEL_WIDTH 100

@implementation PreferentialView
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
    self.title = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE, self.width - 200 - 2 * LEFT_SPACE, LABEL_HEIGHT)];
    _title.backgroundColor = [UIColor clearColor];
//    _title.textColor = [UIColor grayColor];
    _title.font = LABEL_FONT;
    [self addSubview:_title];
    
    UIView * line1 = [[UIView alloc]initWithFrame:CGRectMake(_title.right, 0, 1, 40)];
    line1.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    [self addSubview:line1];
    
    self.detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(line1.right, TOP_SPACE, 99, LABEL_HEIGHT)];
    _detailLabel.font = LABEL_FONT;
    _detailLabel.textAlignment = NSTextAlignmentCenter;
    _detailLabel.text = @"-";
    [self addSubview:_detailLabel];
    
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(_detailLabel.right, 0, 1, 40)];
    line2.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    [self addSubview:line2];
    
    self.titleLable = [[UILabel alloc] initWithFrame:CGRectMake(line2.right,  TOP_SPACE, 99, LABEL_HEIGHT)];
    _titleLable.backgroundColor = [UIColor clearColor];
    _titleLable.textAlignment = NSTextAlignmentRight;
    _titleLable.font = LABEL_FONT;
    [self addSubview:_titleLable];
    
    UIView *line3 = [[UIView alloc]initWithFrame:CGRectMake(0, _title.bottom + TOP_SPACE - 1, self.width, 1)];
    line3.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    [self addSubview:line3];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
