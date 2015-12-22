//
//  TasteView.m
//  TinyOrder
//
//  Created by 仙林 on 15/10/30.
//  Copyright © 2015年 仙林. All rights reserved.
//

#import "TasteView.h"

#define SPACE 10
#define TOP_SPACE 20

@implementation TasteView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        [self createSubviews];
    }
    return self;
}

- (void)createSubviews
{
    self.backgroundColor = [UIColor whiteColor];
    
    UIView * topline = [[UIView alloc]initWithFrame:CGRectMake(0, self.height - 1, self.width, 1)];
    topline.backgroundColor = [UIColor grayColor];
    [self addSubview:topline];
    
    self.stateImageview = [[UIImageView alloc]initWithFrame:CGRectMake(self.width - 20, TOP_SPACE - 10, 10, 10)];
    self.stateImageview.backgroundColor = [UIColor whiteColor];
    _stateImageview.layer.cornerRadius = 5;
    _stateImageview.layer.masksToBounds = YES;
    _stateImageview.layer.borderWidth = 1;
    _stateImageview.layer.borderColor = [UIColor grayColor].CGColor;
    [self addSubview:_stateImageview];
    
    UIView * rightLine = [[UIView alloc]initWithFrame:CGRectMake(self.width - 1, 0, 1, self.height - 1)];
    rightLine.backgroundColor = [UIColor grayColor];
    [self addSubview:rightLine];
    
    self.nameButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _nameButton.frame = CGRectMake(5, TOP_SPACE, self.width - SPACE, 40) ;
//    _nameButton.highlighted = NO;
//    [_nameButton setHighlighted:NO];
//    [_nameButton setTintColor:[UIColor whiteColor]];
    [_nameButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _nameButton.titleLabel.numberOfLines = 0;
    [self addSubview:_nameButton];
    
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
