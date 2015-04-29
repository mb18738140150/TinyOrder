//
//  NewOrdersiewCell.h
//  TinyOrder
//
//  Created by 仙林 on 15/4/11.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NewOrderModel;
@interface NewOrdersiewCell : UITableViewCell


@property (nonatomic, strong)NewOrderModel * orderModel;

@property (nonatomic, strong)UIButton * nulliyButton;
@property (nonatomic, strong)UIButton * dealButton;

- (void)createSubView:(CGRect)frame mealCoutn:(int)mealCount;
+ (CGFloat)cellHeightWithMealCount:(int)mealCount;
- (NSString *)getPrintStringWithMealCount:(int)mealCount;

@end
