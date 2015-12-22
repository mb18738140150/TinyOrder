//
//  GPRSprintViewCell.h
//  TinyOrder
//
//  Created by 仙林 on 15/9/9.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GPRSprintViewCell : UITableViewCell

@property (nonatomic, strong)UILabel *printNameLabel;
@property (nonatomic, strong)UILabel *printNumLabel;
@property (nonatomic, strong)UIButton *isEnableBT;
@property (nonatomic, strong)UIButton *deleteBT;

@property (nonatomic, strong)UILabel * printCountLabel;
@property (nonatomic, strong)UIButton * setUpCountBT;


@end
