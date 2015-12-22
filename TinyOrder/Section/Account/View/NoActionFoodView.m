//
//  NoActionFoodView.m
//  TinyOrder
//
//  Created by 仙林 on 15/10/10.
//  Copyright © 2015年 仙林. All rights reserved.
//

#import "NoActionFoodView.h"

@implementation NoActionFoodView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self removeAllSubviews];
        self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width - 30, frame.size.height)];
        _imageView.image = [UIImage imageNamed:@"action_food_left.png"];
        [self addSubview:_imageView];
        
        self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, frame.size.width - 30, frame.size.height)];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_nameLabel];
        
        self.deleteButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_deleteButton setImage:[[UIImage imageNamed:@"action_food_right.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        _deleteButton.frame = CGRectMake(_imageView.right, _imageView.top, 30, _imageView.height);
        [self addSubview:_deleteButton];
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
