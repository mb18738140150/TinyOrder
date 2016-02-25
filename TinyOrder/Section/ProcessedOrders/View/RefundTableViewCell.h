//
//  RefundTableViewCell.h
//  TinyOrder
//
//  Created by 仙林 on 16/2/23.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TotalPriceView.h"

@class DealOrderModel;
@interface  RefundTableViewCell: UITableViewCell


@property (nonatomic, strong)DealOrderModel * dealOrder;
@property (nonatomic, strong)UIButton * nulliyButton;
@property (nonatomic, strong)UIButton * dealButton;
@property (nonatomic, strong)TotalPriceView * totalPriceView;

- (void)createSubView:(CGRect)frame mealCount:(int)mealCount;
+ (CGFloat)cellHeightWithMealCount:(int)mealCount;
+ (CGFloat)didDeliveryCellHeight;
- (void)hiddenSubView:(CGRect)frame mealCount:(int)mealCount;
- (void)disHiddenSubView:(CGRect)frame mealCount:(int)mealCount andHiddenImage:(BOOL)hidden;


@end
