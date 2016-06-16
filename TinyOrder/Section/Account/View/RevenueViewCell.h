//
//  RevenueViewCell.h
//  TinyOrder
//
//  Created by 仙林 on 15/4/10.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RevewnueModel;

typedef void(^DetailesBlock)(NSString * ordertype);

@interface RevenueViewCell : UITableViewCell

@property (nonatomic, strong)RevewnueModel * revewnueMD;

- (void)createSubView:(CGRect)frame;

- (void)orderdetailes:(DetailesBlock)detailesBlock;

@end
