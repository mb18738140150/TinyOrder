//
//  ActivityViewCell.h
//  TinyOrder
//
//  Created by 仙林 on 15/7/21.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ActivityModel;
@interface ActivityViewCell : UITableViewCell

@property (nonatomic, strong)UIButton * deleteBT;
@property (nonatomic, strong)ActivityModel * activityMD;

+ (CGFloat)cellHeight;
@end
