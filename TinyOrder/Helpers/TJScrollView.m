//
//  TJScrollView.m
//  TinyOrder
//
//  Created by 仙林 on 15/8/21.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "TJScrollView.h"
#import <BaiduMapAPI/BMapKit.h>
#import <BaiduMapAPI/BMKMapView.h>

@implementation TJScrollView


- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView * hitView = [super hitTest:point withEvent:event];
    if (hitView == self)
    {
//        NSLog(@"*****hitView == self");
        self.scrollEnabled = YES;
    }else
    {
//        NSLog(@"%@*****%@*****%@",hitView, hitView.superview, hitView.superview.superview);
        if ([hitView isKindOfClass:[BMKMapView class]]) {
            self.scrollEnabled = NO;
        }else if ([hitView.superview isKindOfClass:[BMKMapView class]])
        {
            self.scrollEnabled = NO;
        }else if ([hitView.superview.superview isKindOfClass:[BMKMapView class]])
        {
            self.scrollEnabled = NO;
        }else
        {
            self.scrollEnabled = YES;
        }
    }
    return hitView;
}

/*
- (BOOL)touchesShouldBegin:(NSSet *)touches withEvent:(UIEvent *)event inContentView:(UIView *)view
{
    NSLog(@"%@", view);
    if ([view isMemberOfClass:[BMKMapView class]]) {
        for (UITouch * touch in touches) {
            switch (touch.phase) {
                case UITouchPhaseBegan:
                {
                    NSLog(@"kiss");
                    self.scrollEnabled = NO;
                }
                    break;
                case UITouchPhaseMoved:
                {
                    NSLog(@"kiss");
                    self.scrollEnabled = NO;
                }
                    break;
                case UITouchPhaseEnded:
                {
                    NSLog(@"恩德");
                    self.scrollEnabled = YES;
                }
                    break;
                    
                default:
                    break;
            }
        }

    }
    return YES;
}

- (BOOL)touchesShouldCancelInContentView:(UIView *)view
{
    NSLog(@"1222");
    return YES;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"999");
}
*/
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
