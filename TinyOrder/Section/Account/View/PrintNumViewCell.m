//
//  PrintNumViewCell.m
//  TinyOrder
//
//  Created by 仙林 on 15/4/16.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "PrintNumViewCell.h"
#import "UIViewAdditions.h"
#define LEFT_SPACE 20
#define TOP_SPACE 10
#define LABEL_HEIGHT 40
#define NUMLABEL_WIDTH 50

@implementation PrintNumViewCell



- (void)createSubView:(CGRect)frame
{
    if (!_numberLabel) {
        UILabel * printLabel = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE, frame.size.width - 2 * LEFT_SPACE - NUMLABEL_WIDTH, LABEL_HEIGHT)];
        printLabel.text = @"打印份数";
        [self addSubview:printLabel];
        self.numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(printLabel.right, TOP_SPACE, NUMLABEL_WIDTH, LABEL_HEIGHT)];
        _numberLabel.text = @"1份";
        [self addSubview:_numberLabel];
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
