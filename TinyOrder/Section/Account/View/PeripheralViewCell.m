//
//  PeripheralViewCell.m
//  TinyOrder
//
//  Created by 仙林 on 15/4/16.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "PeripheralViewCell.h"
#import "UIViewAdditions.h"

#define LETF_SPACE 20
#define TOP_SPACE 10
#define IMAGEVIEW_WIDTH 50


@implementation PeripheralViewCell



- (void)createSubView:(CGRect)frame
{
    if (!_periheralName) {
        UIImageView * bluetoothImageView = [[UIImageView alloc] initWithFrame:CGRectMake(LETF_SPACE, TOP_SPACE, IMAGEVIEW_WIDTH, IMAGEVIEW_WIDTH)];
        bluetoothImageView.image = [UIImage imageNamed:@"bluetooth.png"];
        [self addSubview:bluetoothImageView];
        self.periheralName = [[UILabel alloc] initWithFrame:CGRectMake(bluetoothImageView.right, TOP_SPACE, frame.size.width - bluetoothImageView.right - LETF_SPACE, IMAGEVIEW_WIDTH / 2)];
        _periheralName.text = @"蓝牙未连接";
        _periheralName.font = [UIFont systemFontOfSize:14];
        [self addSubview:_periheralName];
        self.periheralID = [[UILabel alloc] initWithFrame:CGRectMake(_periheralName.left, _periheralName.bottom, _periheralName.width, _periheralName.height)];
        _periheralID.text = @"未连接";
        _periheralID.font = [UIFont systemFontOfSize:14];
        [self addSubview:_periheralID];
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
