//
//  DetailsViewCell.h
//  TinyOrder
//
//  Created by 仙林 on 15/4/10.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailModel;
typedef void(^ExchangeSelectTypeBlock)(int selectType);

@interface DetailsViewCell : UITableViewCell


@property (nonatomic, strong)DetailModel * detailModel;


- (void)createSubView:(CGRect)frame;
- (void)exchangeSelectTypeAction:(ExchangeSelectTypeBlock)block;

@end
