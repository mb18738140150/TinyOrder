//
//  WeekView.h
//  TinyOrder
//
//  Created by 仙林 on 15/7/22.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeekView : UIView


@property (nonatomic, strong)UIButton * changeBT;
//@property (nonatomic, strong)UILabel * titleLB;
@property (nonatomic, strong)UIButton * timeBT;

- (void)hidenRightView:(BOOL)isHiden;



@end
