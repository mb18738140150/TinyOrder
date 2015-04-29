//
//  RevenueViewCell.m
//  TinyOrder
//
//  Created by 仙林 on 15/4/10.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "RevenueViewCell.h"
#import "UIViewAdditions.h"


#define SPACE 15
#define ICONVIEW_WIDTH 60
#define ICON_WIDTH 30
#define VIEW_COLOR [UIColor orangeColor]
#define VIEW_COLOR_2 [UIColor grayColor]
#define RIGHTLB_WIDTH 80
#define LABEL_HEIGHT 30


@interface RevenueViewCell ()

@property (nonatomic, strong)UIImageView * iconView;
@property (nonatomic, strong)UILabel * titleLabel;
@property (nonatomic, strong)UILabel * dataLabel;
@property (nonatomic, strong)UILabel * rmbLabel;
@property (nonatomic, strong)UILabel * stateLabel;

@end


@implementation RevenueViewCell


- (void)createSubView:(CGRect)frame
{
    if (!_iconView) {
        UIView * photoView = [[UIView alloc] initWithFrame:CGRectMake(SPACE, SPACE, ICONVIEW_WIDTH, ICONVIEW_WIDTH)];
        photoView.backgroundColor = [UIColor grayColor];
        [self addSubview:photoView];
        self.iconView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ICON_WIDTH, ICON_WIDTH)];
        _iconView.center = CGPointMake(ICONVIEW_WIDTH / 2, ICONVIEW_WIDTH / 2);
        _iconView.backgroundColor = VIEW_COLOR;
        [photoView addSubview:_iconView];
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(photoView.right + SPACE, SPACE, frame.size.width - ICONVIEW_WIDTH - 3 * SPACE - RIGHTLB_WIDTH, LABEL_HEIGHT)];
        _titleLabel.backgroundColor = VIEW_COLOR;
        [self addSubview:_titleLabel];
        
        self.dataLabel = [[UILabel alloc] initWithFrame:CGRectMake(photoView.right + SPACE, _titleLabel.bottom, frame.size.width - ICONVIEW_WIDTH - 3 * SPACE - RIGHTLB_WIDTH, LABEL_HEIGHT)];
        _dataLabel.backgroundColor = VIEW_COLOR_2;
        _dataLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:_dataLabel];
        
        self.rmbLabel = [[UILabel alloc] initWithFrame:CGRectMake(_titleLabel.right, SPACE, RIGHTLB_WIDTH, LABEL_HEIGHT)];
        _rmbLabel.backgroundColor = VIEW_COLOR_2;
        [self addSubview:_rmbLabel];
        
        self.stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(_titleLabel.right, _titleLabel.bottom, RIGHTLB_WIDTH, LABEL_HEIGHT)];
        _stateLabel.backgroundColor = VIEW_COLOR;
        _stateLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:_stateLabel];
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
