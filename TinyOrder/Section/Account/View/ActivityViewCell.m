//
//  ActivityViewCell.m
//  TinyOrder
//
//  Created by 仙林 on 15/7/21.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "ActivityViewCell.h"
#import "ActivityModel.h"

#define LEFT_SPACE 10
#define TOP_SPACE 15
#define LABEL_HEIGHT 20

@interface ActivityViewCell ()


@property (nonatomic, strong)UILabel * titleLabel;


@end



@implementation ActivityViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.separatorInset = UIEdgeInsetsZero;
        self.preservesSuperviewLayoutMargins = NO;
        self.layoutMargins = UIEdgeInsetsZero;
        [self createSubview];
    }
    return self;
}

- (void)createSubview
{
    if (!_titleLabel) {
        UIImageView * imageV = [[UIImageView alloc] initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE, 50, 16)];
        imageV.image = [UIImage imageNamed:@"activity.png"];
        [self.contentView addSubview:imageV];
        
        
        
        self.deleteBT = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteBT.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - LEFT_SPACE - 21, TOP_SPACE, 21, 18.5);
        
        [_deleteBT setBackgroundImage:[UIImage imageNamed:@"Deletebtn.png"] forState:UIControlStateNormal];
        [self.contentView addSubview:_deleteBT];
        
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(imageV.right + LEFT_SPACE, TOP_SPACE, _deleteBT.left - 2 * LEFT_SPACE - imageV.right, LABEL_HEIGHT)];
        _titleLabel.text = @"减免活动开始了";
        [self.contentView addSubview:_titleLabel];
        imageV.centerY = _titleLabel.centerY;
        _deleteBT.centerY = _titleLabel.centerY;
    }
}


- (void)setActivityMD:(ActivityModel *)activityMD
{
    _activityMD = activityMD;
    self.titleLabel.text = activityMD.actionName;
}

+ (CGFloat)cellHeight
{
    return TOP_SPACE * 2 + LABEL_HEIGHT;
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
