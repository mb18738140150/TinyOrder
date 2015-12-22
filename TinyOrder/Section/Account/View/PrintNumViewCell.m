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
#define NUMLABEL_WIDTH 80

@implementation PrintNumViewCell



- (void)createSubView:(CGRect)frame
{
    if (!_nameLabel) {
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE, frame.size.width - 2 * LEFT_SPACE - NUMLABEL_WIDTH - 1, LABEL_HEIGHT)];
        _nameLabel.text = @"您还未连接到蓝牙设备";
        _nameLabel.textColor = [UIColor grayColor];
        [self addSubview:_nameLabel];
        self.line = [[UIView alloc]initWithFrame:CGRectMake(_nameLabel.right, _nameLabel.top, 1, LABEL_HEIGHT)];
        _line.backgroundColor = [UIColor cyanColor];
        [self addSubview:_line];
        
        self.searchBT = [UIButton buttonWithType:UIButtonTypeSystem];
        [_searchBT setTitle:@"开始搜索" forState:UIControlStateNormal];
        [_searchBT setTitle:@"开始搜索" forState:UIControlStateSelected];
        _searchBT.frame = CGRectMake(_line.right, _line.top, NUMLABEL_WIDTH, LABEL_HEIGHT);
        _searchBT.tintColor = [UIColor cyanColor];
        [self addSubview:_searchBT];
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
