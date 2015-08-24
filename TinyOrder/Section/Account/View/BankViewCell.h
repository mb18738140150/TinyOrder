//
//  BankViewCell.h
//  TinyOrder
//
//  Created by 仙林 on 15/7/29.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BankCarModel;
@interface BankViewCell : UITableViewCell

@property (nonatomic, strong)BankCarModel * bankCarMD;

+ (CGFloat)cellHeight;

@end
