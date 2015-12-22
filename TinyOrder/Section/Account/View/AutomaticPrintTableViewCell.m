//
//  AutomaticPrintTableViewCell.m
//  TinyOrder
//
//  Created by 仙林 on 15/9/10.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "AutomaticPrintTableViewCell.h"

@implementation AutomaticPrintTableViewCell

- (void)createSubviews:(CGRect)frame
{
    if (!_label) {
        self.label = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 100, 50)];
        self.label.text = @"自动打印";
        [self addSubview:_label];
        self.autoSwitch = [GeneralSwitch shareGeneralSwitch].bluetoothSwitch;
        self.autoSwitch.frame = CGRectMake(self.right - 80, _label.top, 70, 10);
        _autoSwitch.on = NO;
        [self addSubview:_autoSwitch];
    }
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
