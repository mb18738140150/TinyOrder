//
//  TasteDetailsCell.m
//  TinyOrder
//
//  Created by 仙林 on 15/10/31.
//  Copyright © 2015年 仙林. All rights reserved.
//

#import "TasteDetailsCell.h"

@implementation TasteDetailsCell

- (void)creatSubviews:(CGRect)frame
{
    self.frame = frame;
//    [self removeAllSubviews];
    self.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    self.tasteDetailsView = [[TasteDetailsView alloc]initWithFrame:CGRectMake(0, 0, self.width, 50)];
    [self addSubview:_tasteDetailsView];
    
//    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(5, _tasteDetailsView.bottom + 4, self.width - 10, 1)];
//    line.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
//    [self addSubview:line];
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
