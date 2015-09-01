//
//  BulletinView.m
//  TinyOrder
//
//  Created by 仙林 on 15/4/11.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "BulletinView.h"
#import "UIViewAdditions.h"


#define LEFT_SPACE 20
#define TOP_SPACE 15
#define BUTTON_HEIGHT 50
#define TEXTFILE_HEIGHT 150

@implementation BulletinView



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self createSubViw:frame];
    }
    return self;
}

- (void)createSubViw:(CGRect)frame
{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE, frame.size.width - 2 * LEFT_SPACE, TEXTFILE_HEIGHT)];
    view.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
    [self addSubview:view];
    self.bulletinTF = [[UITextView alloc] initWithFrame:CGRectMake(LEFT_SPACE + 1, TOP_SPACE + 1, frame.size.width - 2 * LEFT_SPACE - 2, TEXTFILE_HEIGHT - 2)];
//    _bulletinTF.text = @"商家公告";
    _bulletinTF.font = [UIFont systemFontOfSize:17];
//    _bulletinTF.backgroundColor = [UIColor grayColor];
    [self addSubview:_bulletinTF];
    
    self.submitButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _submitButton.frame = CGRectMake(LEFT_SPACE, _bulletinTF.bottom + TOP_SPACE, _bulletinTF.width, BUTTON_HEIGHT);
    _submitButton.backgroundColor = [UIColor orangeColor];
    [_submitButton setTitle:@"提交" forState:UIControlStateNormal];
    [self addSubview:_submitButton];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
