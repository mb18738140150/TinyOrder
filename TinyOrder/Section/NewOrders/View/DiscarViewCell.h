//
//  DiscarViewCell.h
//  TinyOrder
//
//  Created by 仙林 on 15/7/14.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DealOrderModel;
@interface DiscarViewCell : UITableViewCell


@property (nonatomic, strong)DealOrderModel * dealOrder;
- (void)createSubView:(CGRect)frame mealCount:(int)mealCount;
+ (CGFloat)cellHeightWithMealCount:(int)mealCount;
+ (CGFloat)didDeliveryCellHeight;
- (void)hiddenSubView:(CGRect)frame mealCount:(int)mealCount;
- (void)disHiddenSubView:(CGRect)frame mealCount:(int)mealCount andHiddenImage:(BOOL)hidden;


@end
