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
    self.image = [[UIImageView alloc]initWithFrame:CGRectMake(20, 10, (self.width - 40), (self.width - 40) )];
    [self addSubview:_image];
    _image.userInteractionEnabled = YES;
    self.name = [[UILabel alloc]initWithFrame:CGRectMake(0, _image.bottom , self.width , self.height  - _image.bottom)];
    _name.textColor = [UIColor blackColor];
//    _name.adjustsFontSizeToFitWidth = YES;
    _name.textAlignment = NSTextAlignmentCenter;
    _name.userInteractionEnabled = YES;
    _name.font = [UIFont systemFontOfSize:15];
    [self addSubview:_name];
    
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
