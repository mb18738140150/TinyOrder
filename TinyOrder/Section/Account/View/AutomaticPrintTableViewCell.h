//
//  AutomaticPrintTableViewCell.h
//  TinyOrder
//
//  Created by 仙林 on 15/9/10.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AutomaticPrintTableViewCell : UITableViewCell

@property (nonatomic, strong)UILabel *label;
@property (nonatomic, strong)UISwitch *autoSwitch;

- (void)createSubviews:(CGRect)frame;

@end
