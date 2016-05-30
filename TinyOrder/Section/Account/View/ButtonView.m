//
//  ButtonView.m
//  TinyOrder
//
//  Created by 仙林 on 16/1/7.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "ButtonView.h"

@implementation ButtonView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatSubviews];
    }
    return self;
}

 -(void)creatSubviews
{
    self.image = [[UIImageView alloc]initWithFrame:CGRectMake(self.width / 3, self.width / 4, self.width / 3, self.width / 3 )];
    [self addSubview:_image];
    _image.userInteractionEnabled = YES;
    self.name = [[UILabel alloc]initWithFrame:CGRectMake(0, _image.bottom + self.width / 12 , self.width , 14)];
    _name.textColor = [UIColor colorWithWhite:.126 alpha:1];
//    _name.adjustsFontSizeToFitWidth = YES;
    _name.textAlignment = NSTextAlignmentCenter;
    _name.userInteractionEnabled = YES;
    _name.font = [UIFont systemFontOfSize:13];
    [self addSubview:_name];
    
    self.stateImagev = [[UIImageView alloc]initWithFrame:CGRectMake(_name.right, _name.top, 0, _name.height )];
    [self addSubview:_stateImagev];
    
    self.button = [UIButton buttonWithType:UIButtonTypeSystem];
    _button.frame = CGRectMake(0, 0, self.width, self.height);
    _button.backgroundColor = [UIColor clearColor];
    [self addSubview:_button];
    
    self.backgroundColor = [UIColor whiteColor];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
