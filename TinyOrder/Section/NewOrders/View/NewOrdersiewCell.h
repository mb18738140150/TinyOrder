//
//  NewOrdersiewCell.h
//  TinyOrder
//
//  Created by 仙林 on 15/4/11.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TotalViw.h"

@class NewOrderModel;
@interface NewOrdersiewCell : UITableViewCell


@property (nonatomic, strong)NewOrderModel * orderModel;

@property (nonatomic, strong)UIButton * nulliyButton;
@property (nonatomic, strong)UIButton * dealButton;
@property (nonatomic, strong)TotalViw * totalView;
@property (nonatomic, assign)int b;
@property (nonatomic, assign)int a;

- (void)createSubView:(CGRect)frame mealCoutn:(int)mealCount;
+ (CGFloat)cellHeightWithMealCount:(int)mealCount;
- (NSString *)getPrintStringWithMealCount:(int)mealCount;
// 用来计算cell高度
- (void)calculateHeightwithcount:(int)count;
@end
