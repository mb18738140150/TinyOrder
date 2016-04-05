//
//  TangshiCell.h
//  TinyOrder
//
//  Created by 仙林 on 15/12/10.
//  Copyright © 2015年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TotalPriceView.h"
#import "NewOrderModel.h"

@interface TangshiCell : UITableViewCell

@property (nonatomic, strong)NewOrderModel * orderModel;
@property (nonatomic, strong)UIButton * dealButton;

@property (nonatomic, strong)TotalPriceView * totalPriceView;
- (void)createSubView:(CGRect)frame mealCoutn:(NewOrderModel *)mealModel;
+ (CGFloat)cellHeightWithMealCount:(NewOrderModel *)mealModel;
@end
